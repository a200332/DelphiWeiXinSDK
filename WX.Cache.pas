unit WX.Cache;

interface

uses
  SysUtils, Classes, Variants, Datasnap.DBClient, DB, WX.Common, Vcl.ExtCtrls,
  JsonDataObjects, System.Net.HttpClient, Redis.Commons;

type
  TClientDataSetTokenCacher = class(TInterfacedObject, ITokenCacher)
  private
    FLock: TObject;
    FFileName: string;
    FClientDataSet: TClientDataSet;
    procedure InitClientDataSetFieldDef;
    function DoGetAccessToken(const AppId, Secret: string): string;
    function DoGetJsApiTicket(const AppId, Secret: string): string;
  protected
    {ITokenCacher}
    function GetAccessToken(const AppId, Secret: string): string;
    function GetJsApiTicket(const AppId, Secret: string): string;
  public
    constructor Create;
    destructor Destroy; override;
  end;

//  TDBTokenCacher = class(TInterfacedObject, ITokenCacher)
//  end;

  TRadisTokenCacher = class(TInterfacedObject, ITokenCacher)
  private
    FLock: TObject;
    FRedisClient: IRedisClient;
    function DoGetAccessToken(const AppId, Secret: string): string;
    function DoGetJsApiTicket(const AppId, Secret: string): string;
  protected
    {ITokenCacher}
    function GetAccessToken(const AppId, Secret: string): string;
    function GetJsApiTicket(const AppId, Secret: string): string;
  public
    constructor Create(const Host: string; Port: Integer);
    destructor Destroy; override;
  end;

function TokenCacher: ITokenCacher;
procedure SetDefaultTokenCacher(const Cacher: ITokenCacher);

implementation

uses
  System.DateUtils, System.Net.URLClient, REST.Types, WX.Utils, Redis.Client,
  Redis.NetLib.INDY;

var
  DefaultTokenCacher: ITokenCacher;

function TokenCacher: ITokenCacher;
var
  Temp: ITokenCacher;
begin
  if DefaultTokenCacher = nil then begin
    Temp := TClientDataSetTokenCacher.Create;
    if AtomicCmpExchange(Pointer(DefaultTokenCacher), Pointer(Temp), nil) = nil then
      Temp._AddRef;
  end;
  Result := DefaultTokenCacher;
end;

procedure SetDefaultTokenCacher(const Cacher: ITokenCacher);
var
  Old: Pointer;
begin
  Old := AtomicExchange(Pointer(DefaultTokenCacher), Pointer(Cacher));
  if Old <> Pointer(Cacher) then begin
    if Old <> nil then
      ITokenCacher(Old)._Release;
    if Cacher <> nil then
      Cacher._AddRef;
  end;
end;

{ TClientDataSetTokenCacher }

constructor TClientDataSetTokenCacher.Create;
var
  Version: Variant;
begin
  FLock := TObject.Create;
  FFileName := IncludeTrailingPathDelimiter(ExtractFilePath(GetModuleName(HInstance)))+'TokenCacher';
  FClientDataSet := TClientDataSet.Create(nil);
  if FileExists(FFileName) then begin
    FClientDataSet.LoadFromFile(FFileName);
    Version := FClientDataSet.GetOptionalParam('version');
    if VarIsClear(Version) or (Integer(Version) < 2) then
      InitClientDataSetFieldDef;
  end
  else InitClientDataSetFieldDef;
end;

destructor TClientDataSetTokenCacher.Destroy;
begin
  FClientDataSet.SaveToFile(FFileName);
  FClientDataSet.Free;
  FLock.Free;
  inherited;
end;

procedure TClientDataSetTokenCacher.InitClientDataSetFieldDef;
begin
  FClientDataSet.Close;
  FClientDataSet.FieldDefs.Clear;
  FClientDataSet.FieldDefs.Add('AppId', ftString, 100, True);
  with FClientDataSet.FieldDefs.AddFieldDef do begin
    DataType := ftDataSet;
    Name := 'AccessToken';
    ChildDefs.Add('AccessToken', ftString, 500, True);
    ChildDefs.Add('ExpiresTime', ftDateTime, 0, True);
  end;
  with FClientDataSet.FieldDefs.AddFieldDef do begin
    DataType := ftDataSet;
    Name := 'JsApiTicket';
    ChildDefs.Add('JsApiTicket', ftString, 500, True);
    ChildDefs.Add('ExpiresTime', ftDateTime, 0, True);
  end;
  FClientDataSet.CreateDataSet;
  FClientDataSet.SetOptionalParam('version', 2);
  FClientDataSet.SaveToFile(FFileName);
end;

function TClientDataSetTokenCacher.GetAccessToken(const AppId,
  Secret: string): string;
begin
  System.TMonitor.Enter(FLock);
  try
    Result := DoGetAccessToken(AppId, Secret);
  finally
    System.TMonitor.Exit(FLock);
  end;
end;

function TClientDataSetTokenCacher.DoGetAccessToken(const AppId, Secret: string): string;
var
  ExpiresTime: TDateTime;
  AccessTokenDataSet: TDataSet;

  function GetFromWX: string;
  var
    Url: string;
    Response: IHTTPResponse;
    jo: TJSONObject;
    AccessToken: string;
    ExpiresIn: Integer;
  begin
    jo := nil;
    try
      Url := Format('https://%s/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s',
        [WX_DOMAIN, AppId, Secret]);
      Response := WX.Utils.HTTPClient.Make.Get(Url);
      jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
      AccessToken := jo.S['access_token'];
      if AccessToken.IsEmpty  then
        raise Exception.CreateFmt('get access token error [%d]: %s',
          [jo.I['errcode'], jo.S['errmsg']]);
      ExpiresIn := jo.I['expires_in'];
      if not FClientDataSet.Locate('AppId', AppId, []) then begin
        FClientDataSet.Append;
        FClientDataSet['AppId'] := AppId;
      end
      else FClientDataSet.Edit;
      AccessTokenDataSet := (FClientDataSet.FieldByName('AccessToken') as TDataSetField).NestedDataSet;
      if AccessTokenDataSet.RecordCount = 0 then
        AccessTokenDataSet.Append
      else
        AccessTokenDataSet.Edit;
      AccessTokenDataSet.FieldByName('AccessToken').AsString := AccessToken;
      AccessTokenDataSet.FieldByName('ExpiresTime').AsDateTime := IncSecond(Now, ExpiresIn);
      AccessTokenDataSet.Post;
      FClientDataSet.Post;
      FClientDataSet.SaveToFile(FFileName);
      Result := AccessToken;
    finally
      jo.Free;
    end;
  end;

begin
  if not FClientDataSet.Locate('AppId', AppId, []) then
    Exit(GetFromWX);
  AccessTokenDataSet := (FClientDataSet.FieldByName('AccessToken') as TDataSetField).NestedDataSet;
  if AccessTokenDataSet.RecordCount = 0 then
    Exit(GetFromWX);
  ExpiresTime := AccessTokenDataSet.FieldByName('ExpiresTime').AsDateTime;
  if IncSecond(ExpiresTime, -10) < Now then
    Exit(GetFromWX)
  else
    Result := AccessTokenDataSet.FieldByName('AccessToken').AsString;
end;

function TClientDataSetTokenCacher.GetJsApiTicket(const AppId,
  Secret: string): string;
begin
  System.TMonitor.Enter(FLock);
  try
    Result := DoGetJsApiTicket(AppId, Secret);
  finally
    System.TMonitor.Exit(FLock);
  end;
end;

function TClientDataSetTokenCacher.DoGetJsApiTicket(const AppId, Secret: string): string;
var
  ExpiresTime: TDateTime;
  JsApiTicketDataSet: TDataSet;

  function GetFromWX: string;
  var
    HTTPClient: THTTPClient;
    Url: string;
    Response: IHTTPResponse;
    jo: TJSONObject;
    JsApiTicket: string;
    ExpiresIn: Integer;
  begin
    jo := nil;
    HTTPClient := THTTPClient.Create;
    try
      HTTPClient.UserAgent := WX_SDK_VERSION;
      Url := Format('https://%s/cgi-bin/ticket/getticket?access_token=%s&type=jsapi',
        [WX_DOMAIN, DoGetAccessToken(AppId, Secret)]);
      Response := HTTPClient.Get(Url);
      jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
      JsApiTicket := jo.S['ticket'];
      if JsApiTicket.IsEmpty  then
        raise Exception.CreateFmt('get jsapi ticket error [%d]: %s',
          [jo.I['errcode'], jo.S['errmsg']]);
      ExpiresIn := jo.I['expires_in'];
      if not FClientDataSet.Locate('AppId', AppId, []) then begin
        FClientDataSet.Append;
        FClientDataSet['AppId'] := AppId;
      end
      else FClientDataSet.Edit;
      JsApiTicketDataSet := (FClientDataSet.FieldByName('JsApiTicket') as TDataSetField).NestedDataSet;
      if JsApiTicketDataSet.RecordCount = 0 then
        JsApiTicketDataSet.Append
      else
        JsApiTicketDataSet.Edit;
      JsApiTicketDataSet.FieldByName('JsApiTicket').AsString := JsApiTicket;
      JsApiTicketDataSet.FieldByName('ExpiresTime').AsDateTime := IncSecond(Now, ExpiresIn);
      JsApiTicketDataSet.Post;
      FClientDataSet.Post;
      FClientDataSet.SaveToFile(FFileName);
      Result := JsApiTicket;
    finally
      HTTPClient.Free;
      jo.Free;
    end;
  end;

begin
  if not FClientDataSet.Locate('AppId', AppId, []) then
    Exit(GetFromWX);
  JsApiTicketDataSet := (FClientDataSet.FieldByName('JsApiTicket') as TDataSetField).NestedDataSet;
  if JsApiTicketDataSet.RecordCount = 0 then
    Exit(GetFromWX);
  ExpiresTime := JsApiTicketDataSet.FieldByName('ExpiresTime').AsDateTime;
  if IncMinute(ExpiresTime, -10) < Now then
    Exit(GetFromWX)
  else
    Result := JsApiTicketDataSet.FieldByName('JsApiTicket').AsString;
end;

{ TRadisTokenCacher }

constructor TRadisTokenCacher.Create(const Host: string; Port: Integer);
begin
  FLock := TObject.Create;
  FRedisClient := TRedisClient.Create(Host, Port);
  FRedisClient.Connect;
end;

destructor TRadisTokenCacher.Destroy;
begin
  FLock.Free;
  inherited;
end;

function TRadisTokenCacher.GetAccessToken(const AppId, Secret: string): string;
begin
  System.TMonitor.Enter(FLock);
  try
    Result := DoGetAccessToken(AppId, Secret);
  finally
    System.TMonitor.Exit(FLock);
  end;
end;

function TRadisTokenCacher.DoGetAccessToken(const AppId, Secret: string): string;
var
  Key: string;
  Value: string;
  Index: Integer;
  ExpiresTime: TDateTime;

  function GetFromWX: string;
  var
    Url: string;
    Response: IHTTPResponse;
    jo: TJSONObject;
    AccessToken: string;
    ExpiresIn: Integer;
  begin
    jo := nil;
    try
      Url := Format('https://%s/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s',
        [WX_DOMAIN, AppId, Secret]);
      Response := WX.Utils.HTTPClient.Make.Get(Url);
      jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
      AccessToken := jo.S['access_token'];
      if AccessToken.IsEmpty  then
        raise Exception.CreateFmt('get access token error [%d]: %s',
          [jo.I['errcode'], jo.S['errmsg']]);
      ExpiresIn := jo.I['expires_in'];
      Value := Double(IncSecond(Now, ExpiresIn)).ToString + ';' + AccessToken;
      FRedisClient.&SET(Key, Value);
      Result := AccessToken;
    finally
      jo.Free;
    end;
  end;

begin
  Key := 'wx.AccessToken.' + AppId;
  if not FRedisClient.GET(Key, Value) or Value.IsEmpty then
    Exit(GetFromWX);
  Index := Value.IndexOf(';');
  if Index < 0 then
    Exit(GetFromWX);
  ExpiresTime := Value.Substring(0, Index).ToDouble;
  if IncMinute(ExpiresTime, -10) < Now then
    Exit(GetFromWX)
  else
    Result := Value.Substring(Index+1);
end;

function TRadisTokenCacher.GetJsApiTicket(const AppId, Secret: string): string;
begin
  System.TMonitor.Enter(FLock);
  try
    Result := DoGetJsApiTicket(AppId, Secret);
  finally
    System.TMonitor.Exit(FLock);
  end;
end;

function TRadisTokenCacher.DoGetJsApiTicket(const AppId, Secret: string): string;
var
  Key: string;
  Value: string;
  Index: Integer;
  ExpiresTime: TDateTime;

  function GetFromWX: string;
  var
    HTTPClient: THTTPClient;
    Url: string;
    Response: IHTTPResponse;
    jo: TJSONObject;
    JsApiTicket: string;
    ExpiresIn: Integer;
  begin
    jo := nil;
    HTTPClient := THTTPClient.Create;
    try
      HTTPClient.UserAgent := WX_SDK_VERSION;
      Url := Format('https://%s/cgi-bin/ticket/getticket?access_token=%s&type=jsapi',
        [WX_DOMAIN, DoGetAccessToken(AppId, Secret)]);
      Response := HTTPClient.Get(Url);
      jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
      JsApiTicket := jo.S['ticket'];
      if JsApiTicket.IsEmpty  then
        raise Exception.CreateFmt('get jsapi ticket error [%d]: %s',
          [jo.I['errcode'], jo.S['errmsg']]);
      ExpiresIn := jo.I['expires_in'];
      Value := Double(IncSecond(Now, ExpiresIn)).ToString + ';' + JsApiTicket;
      FRedisClient.&SET(Key, Value);
      Result := JsApiTicket;
    finally
      HTTPClient.Free;
      jo.Free;
    end;
  end;

begin
  Key := 'wx.JsApiTicket.' + AppId;
  if not FRedisClient.GET(Key, Value) or Value.IsEmpty then
    Exit(GetFromWX);
  Index := Value.IndexOf(';');
  if Index < 0 then
    Exit(GetFromWX);
  ExpiresTime := Value.Substring(0, Index).ToDouble;
  if IncMinute(ExpiresTime, -10) < Now then
    Exit(GetFromWX)
  else
    Result := Value.Substring(Index+1);
end;

end.
