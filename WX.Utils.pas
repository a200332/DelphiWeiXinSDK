unit WX.Utils;

interface

uses
  SysUtils, Classes, Variants, System.Generics.Collections, System.Hash,
  Datasnap.DBClient, DB, WX.Common, Vcl.ExtCtrls, JsonDataObjects,
  System.Net.HttpClient, Xml.XMLIntf, Xml.XMLDoc, Xml.xmldom, Xml.omnixmldom;

type
  TWxHelper = record
    class function CheckSignatrue(const Signature, Timestamp, Nonce, Token: string): Boolean; static;
    class function DateTimeToWxTime(DataTime: TDateTime): TwxDateTime; static;
    class function WxTimeToDateTime(DataTime: TwxDateTime): TDateTime; static;
    class function GenNonceStr(ALength: Integer = 16): string; static;
    class function GetSign(XMLDocument: IXMLDocument; const Key: string;
      SignType: TwxSignType): string; static;
    class function ValidSign(XMLDocument: IXMLDocument; const Key: string;
      SignType: TwxSignType): Boolean; overload; static;
    class function ValidSign(const XML, Key: string; SignType: TwxSignType): Boolean; overload; static;
    class function WxDateTimeStrToDateTime(const WxDateTimeStr: string): TDateTime; static;
    class function DateTimeToWxDateTimeStr(const DateTime: TDateTime): string; static; inline;
    class procedure ParseBillText(const BillContent: string; out DetailData, SumData: Variant); static;
    class function ParseCommentText(const CommentContent: string; out CommentData: Variant): Integer; static;
    class function GetLocalIP: string; static; inline;
    class function VarToInt(Value: Variant): Int64; static;
    class function VarToFloat(Value: Variant): Extended; static;
  end;

  TJDOJsonObjectHelper = class helper for TJDOJsonObject
  public type
    IStream = interface
      function GetValue: TStream;
      property Value: TStream read GetValue;
    end;
    TStreamImpl = class(TInterfacedObject, IStream)
    private
      FStringStream: TStringStream;
      function GetValue: TStream;
      property Value: TStream read GetValue;
    public
      constructor Create(Value: string; Encoding: TEncoding);
      destructor Destroy; override;
    end;
  public
    function ToStream(Encoding: TEncoding = nil): IStream;
  end;

  IHTTPClient = reference to function: THTTPClient;
  HTTPClient = record
  private type
    THTTPClientImpl = class(TInterfacedObject, IHTTPClient)
    private
      FHTTPClient: THTTPClient;
      function Invoke: THTTPClient;
    public
      constructor Create;
      destructor Destroy; override;
    end;
  private
    class function GetMake: IHTTPClient; static;
  public
    class property Make: IHTTPClient read GetMake;
  end;

  TwxMsgTypeHelper = record helper for TwxMsgType
  private const
    MSG_TYPE_STR: array[TwxMsgType] of string =
      ('text', 'image', 'voice', 'video', 'shortvideo', 'location', 'link',
       'music', 'news', 'Event');
  public
    function ToString: string; inline;
    class function ParseStr(const Value: string): TwxMsgType; static;
  end;

  TwxEventTypeHelper = record helper for TwxEventType
  private const
    EVENT_TYPE_STR: array[TwxEventType] of string =
      ('subscribe', 'unsubscribe', 'SCAN', 'LOCATION', 'CLICK', 'VIEW',
       'view_miniprogram', 'scancode_push', 'scancode_waitmsg', 'pic_sysphoto',
       'pic_photo_or_album', 'pic_weixin', 'location_select', 'TemplateSendJobFinish');
  public
    function ToString: string; inline;
    class function ParseStr(const Value: string): TwxEventType; static;
  end;

  TwxMediaTypeHelper = record helper for TwxMediaType
  private const
    MEDIA_TYPE_STR: array[TwxMediaType] of string =
      ('image', 'voice', 'video', 'thumb', 'news');
  public
    function ToString: string; inline;
    class function ParseStr(const Value: string): TwxMediaType; static;
  end;

  TwxTradeTypeHelper = record helper for TwxTradeType
  private const
    TRADE_TYPE_STR: array[TwxTradeType] of string =
      ('JSAPI', 'NATIVE', 'APP', 'MICROPAY', 'MWEB');
  public
    function ToString: string; inline;
    class function ParseStr(const Value: string): TwxTradeType; static;
  end;

  TwxTradeStateHelper = record helper for TwxTradeState
  private const
    TRADE_STATE_STR: array[TwxTradeState] of string =
      ('SUCCESS', 'REFUND', 'NOTPAY', 'CLOSED', 'REVOKED', 'USERPAYING', 'PAYERROR');
  public
    function ToString: string; inline;
    class function ParseStr(const Value: string): TwxTradeState; static;
  end;

  TwxPayResultCodeHelper = record helper for TwxPayResultCode
  private const
    PAY_RESULT_CODE_STR: array[TwxPayResultCode] of string = ('SUCCESS', 'FAIL');
  public
    function ToString: string; inline;
    class function ParseStr(const Value: string): TwxPayResultCode; static;
  end;

  TwxSignTypeHelper = record helper for TwxSignType
  private const
    SIGN_TYPE_STR: array[TwxSignType] of string = ('MD5', 'HMAC-SHA256');
  public
    function ToString: string; inline;
    class function ParseStr(const Value: string): TwxSignType; static;
  end;

implementation

uses
  System.DateUtils, IdStack;

const
  WX_BASE_DATE: TDateTime = UnixDateDelta;

{ TWxUtil }

class function TWxHelper.VarToInt(Value: Variant): Int64;
var
  s: string;
begin
  s := VarToStr(Value);
  if not TryStrToInt64(s, Result) then
    Result := 0;
end;

class function TWxHelper.VarToFloat(Value: Variant): Extended;
var
  s: string;
begin
  s := VarToStr(Value);
  if not TryStrToFloat(s, Result) then
    Result := 0;
end;

class function TWxHelper.DateTimeToWxTime(DataTime: TDateTime): TwxDateTime;
begin
  Result := SecondsBetween(WX_BASE_DATE, TTimeZone.Local.ToUniversalTime(DataTime));
end;

class function TWxHelper.WxTimeToDateTime(DataTime: TwxDateTime): TDateTime;
begin
  Result := TTimeZone.Local.ToLocalTime(IncSecond(WX_BASE_DATE, DataTime));
end;

class function TWxHelper.CheckSignatrue(const Signature, Timestamp, Nonce, Token: string): Boolean;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.CaseSensitive := True;
    sl.Add(Timestamp);
    sl.Add(Nonce);
    sl.Add(Token);
    sl.Sorted:= True;
    Result := THashSHA1.GetHashString(sl[0]+sl[1]+sl[2]) = Signature;
  finally
    sl.Free;
  end;
end;

const
  __S_LENGTH = 26*2+10;
  __S: array[0..__S_LENGTH-1] of Char = (
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
    '0','1','2','3','4','5','6','7','8','9');

class function TWxHelper.GenNonceStr(ALength: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to ALength - 1 do
    Result := Result + __S[Random(__S_LENGTH)];
end;

class function TWxHelper.GetSign(XMLDocument: IXMLDocument; const Key: string;
  SignType: TwxSignType): string;
var
  Dic: TDictionary<string, string>;
  List: TList<string>;
  RootNode: IXMLNode;
  I: Integer;
  k, v: string;
  SignTemp: string;
begin
  Dic := TDictionary<string, string>.Create;
  List := TList<string>.Create;
  try
    RootNode := XMLDocument.DocumentElement;
    for I := 0 to RootNode.ChildNodes.Count - 1 do begin
      k := RootNode.ChildNodes[I].NodeName;
      if SameText(k, 'sign') then
        Continue;
      v := RootNode.ChildNodes[I].Text.Trim;
      if not v.IsEmpty then begin
        Dic.Add(k, v);
        List.Add(k);
      end;
    end;
    List.Sort;
    SignTemp := '';
    for I := 0 to List.Count - 1 do begin
      k := List[I];
      SignTemp := SignTemp + Format('&%s=%s', [k, Dic[k]]);
    end;
    SignTemp := SignTemp.Substring(1) + Format('&key=%s', [Key]);
    case SignType of
      stMD5: Result := THashMD5.GetHashString(SignTemp).ToUpper;
      stHMAC_SHA256: Result := THashSHA2.GetHMAC(SignTemp, Key, THashSHA2.TSHA2Version.SHA256).ToUpper;
    end;
  finally
    Dic.Free;
    List.Free;
  end;
end;

class function TWxHelper.ValidSign(XMLDocument: IXMLDocument; const Key: string;
  SignType: TwxSignType): Boolean;
var
  Sign: string;
  XMLNode: IXMLNode;
begin
  XMLNode := XMLDocument.DocumentElement.ChildNodes.FindNode('sign');
  if Assigned(XMLNode) then
    Result := XMLNode.Text.ToUpper = GetSign(XMLDocument, Key, SignType)
  else
    Result := False;
end;

class function TWxHelper.ValidSign(const XML, Key: string;
  SignType: TwxSignType): Boolean;
var
  XMLDocument: IXMLDocument;
begin
  XMLDocument := TXMLDocument.Create(nil);
  TXMLDocument(XMLDocument).DOMVendor := GetDOMVendor(sOmniXmlVendor);
  XMLDocument.LoadFromXML(XML);
  Result := ValidSign(XMLDocument, Key, SignType);
end;

class function TWxHelper.WxDateTimeStrToDateTime(
  const WxDateTimeStr: string): TDateTime;
var
  AYear, AMonth, ADay, AHour, AMinute, ASecond: Word;
  L: Integer;
  s: string;
begin
  s := WxDateTimeStr.Replace(' ', '', [rfReplaceAll]).Replace('-', '', [rfReplaceAll]).Replace(':', '', [rfReplaceAll]);
  AYear   := s.Substring(0, 4).ToInteger;
  AMonth  := s.Substring(4, 2).ToInteger;
  ADay    := s.Substring(6, 2).ToInteger;
  L := s.Length;
  if L > 8 then
    AHour := s.Substring(8, 2).ToInteger
  else
    AHour := 0;
  if L > 10 then
    AMinute := s.Substring(10, 2).ToInteger
  else
    AMinute := 0;
  if L > 12 then
    ASecond := s.Substring(12, 2).ToInteger
  else
    ASecond := 0;
  Result  := EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, 0);
end;

class function TWxHelper.DateTimeToWxDateTimeStr(
  const DateTime: TDateTime): string;
begin
  Result := FormatDateTime('yyyyMMddHHmmss', DateTime);
end;

class procedure TWxHelper.ParseBillText(const BillContent: string;
  out DetailData, SumData: Variant);

  procedure AddFieldDef(ClientDataSet: TClientDataSet; const FieldName: string);
  var
    fn: string;
  begin
    fn := FieldName.Replace('（元）', '', [rfReplaceAll]);
    if fn.EndsWith('金额') or fn.EndsWith('额') or fn.EndsWith('费') or
       fn.EndsWith('费率') or fn.EndsWith('结余')
    then
      ClientDataSet.FieldDefs.Add(FieldName, ftCurrency) else
    if fn.EndsWith('单数') or fn.EndsWith('笔数') then
      ClientDataSet.FieldDefs.Add(FieldName, ftInteger) else
    if fn.EndsWith('时间') or fn.EndsWith('日期') then
      ClientDataSet.FieldDefs.Add(FieldName, ftDateTime)
    else
      ClientDataSet.FieldDefs.Add(FieldName, ftstring, 255);
  end;

  procedure SetFieldValue(Field: TField; const Value: string);
  begin
    if Field.DataType in [ftDateTime, ftTimeStamp, ftDate, ftTime] then
      Field.AsDateTime := WxDateTimeStrToDateTime(Value) else
    if Field.DataType in [ftCurrency, ftFloat, ftBCD] then
      Field.Value := Value.ToDouble else
    if Field.DataType in [ftInteger, ftSmallint, ftWord] then
      Field.Value := Value.ToInteger
    else
      Field.Value := Value;
  end;

var
  cdsDetailData: TClientDataSet;
  cdsSumData: TClientDataSet;
  sl: TStringList;
  s: string;
  sa: TArray<string>;
  I: Integer;
  K: Integer;
begin
  sl := TStringList.Create;
  cdsDetailData := TClientDataSet.Create(nil);
  cdsSumData := TClientDataSet.Create(nil);
  try
    sl.Text := BillContent;
    sa := sl[0].Split([',']);
    for s in sa do
      AddFieldDef(cdsDetailData, s.Trim);
    cdsDetailData.CreateDataSet;
    for I := 1 to sl.Count-3 do begin
      sa := sl[I].Substring(1).Split([',`']);
      cdsDetailData.Append;
      for K := Low(sa) to High(sa) do
        SetFieldValue(cdsDetailData.Fields[K], sa[K]);
      cdsDetailData.Post;
    end;
    DetailData := cdsDetailData.Data;
    sa := sl[sl.Count-2].Split([',']);
    for s in sa do
      AddFieldDef(cdsSumData, s.Trim);
    cdsSumData.CreateDataSet;
    sa := sl[sl.Count-1].Substring(1).Split([',`']);
    cdsSumData.Append;
    for K := Low(sa) to High(sa) do
      SetFieldValue(cdsSumData.Fields[K], sa[K]);
    cdsSumData.Post;
    SumData := cdsSumData.Data;
  finally
    sl.Free;
    cdsDetailData.Free;
    cdsSumData.Free;
  end;
end;

class function TWxHelper.ParseCommentText(const CommentContent: string;
  out CommentData: Variant): Integer;
var
  cdsCommentData: TClientDataSet;
  sl: TStringList;
  sa: TArray<string>;
  I: Integer;
begin
  sl := TStringList.Create;
  cdsCommentData := TClientDataSet.Create(nil);
  try
    sl.Text := CommentContent;
    cdsCommentData.FieldDefs.Add('CommentTime', ftDateTime);
    cdsCommentData.FieldDefs.Add('TransactionId', ftString, 50);
    cdsCommentData.FieldDefs.Add('Start', ftInteger);
    cdsCommentData.FieldDefs.Add('Comment', ftMemo);
    cdsCommentData.CreateDataSet;
    for I := 1 to sl.Count-1 do begin
      sa := sl[I].Substring(1).Split([',`']);
      cdsCommentData.Append;
      cdsCommentData['CommentTime'] := TWxHelper.WxDateTimeStrToDateTime(sa[0]);
      cdsCommentData['TransactionId'] := sa[1];
      cdsCommentData['Start'] := sa[2];
      cdsCommentData['Comment'] := sa[3];
      cdsCommentData.Post;
    end;
    Result := sl[0].ToInteger;
    CommentData := cdsCommentData.Data;
  finally
    sl.Free;
    cdsCommentData.Free;
  end;
end;

class function TWxHelper.GetLocalIP: string;
begin
  Result := IdStack.GStack.LocalAddress;
end;

{ TJDOJsonObjectHelper.TStreamImpl }

constructor TJDOJsonObjectHelper.TStreamImpl.Create(Value: string; Encoding: TEncoding);
begin
  if Encoding = nil then
    FStringStream := TStringStream.Create(Value, TEncoding.UTF8)
  else
    FStringStream := TStringStream.Create(Value, Encoding);
end;

destructor TJDOJsonObjectHelper.TStreamImpl.Destroy;
begin
  FStringStream.Free;
  inherited;
end;

function TJDOJsonObjectHelper.TStreamImpl.GetValue: TStream;
begin
  Result := FStringStream;
end;

{ TJDOJsonObjectHelper }

function TJDOJsonObjectHelper.ToStream(Encoding: TEncoding): IStream;
begin
  Result := TStreamImpl.Create(Self.ToString, Encoding);//微信api不支持中文转义的json结构
end;

{ HTTPClient.THTTPClientImpl }

constructor HTTPClient.THTTPClientImpl.Create;
begin
  FHTTPClient := THTTPClient.Create;
  FHTTPClient.UserAgent := WX_SDK_VERSION;
end;

destructor HTTPClient.THTTPClientImpl.Destroy;
begin
  FHTTPClient.Free;
  inherited;
end;

function HTTPClient.THTTPClientImpl.Invoke: THTTPClient;
begin
  Result := FHTTPClient;
end;

{ HTTPClient }

class function HTTPClient.GetMake: IHTTPClient;
begin
  Result := THTTPClientImpl.Create();
end;

{ TwxMsgTypeHelper }

class function TwxMsgTypeHelper.ParseStr(const Value: string): TwxMsgType;
var
  mt: TwxMsgType;
begin
  for mt := Low(TwxMsgType) to High(TwxMsgType) do
    if SameText(MSG_TYPE_STR[mt], Value) then begin
      Result := mt;
      Exit;
    end;
  raise Exception.CreateFmt('%s is invalid MsgType string', [Value]);
end;

function TwxMsgTypeHelper.ToString: string;
begin
  Result := MSG_TYPE_STR[Self];
end;

{ TwxEventTypeHelper }

class function TwxEventTypeHelper.ParseStr(const Value: string): TwxEventType;
var
  et: TwxEventType;
begin
  for et := Low(TwxEventType) to High(TwxEventType) do
    if SameText(EVENT_TYPE_STR[et], Value) then
      Exit(et);
  raise Exception.CreateFmt('%s is invalid EventType string', [Value]);
end;

function TwxEventTypeHelper.ToString: string;
begin
  Result := EVENT_TYPE_STR[Self]
end;

{ TwxMediaTypeHelper }

class function TwxMediaTypeHelper.ParseStr(const Value: string): TwxMediaType;
var
  mt: TwxMediaType;
begin
  for mt := Low(TwxMediaType) to High(TwxMediaType) do
    if SameText(MEDIA_TYPE_STR[mt], Value) then
      Exit(mt);
  raise Exception.CreateFmt('%s is invalid MediaType string', [Value]);
end;

function TwxMediaTypeHelper.ToString: string;
begin
  Result := MEDIA_TYPE_STR[Self]
end;

{ TwxTradeTypeHelper }

class function TwxTradeTypeHelper.ParseStr(const Value: string): TwxTradeType;
var
  tt: TwxTradeType;
begin
  for tt := Low(TwxTradeType) to High(TwxTradeType) do
    if SameText(TRADE_TYPE_STR[tt], Value) then
      Exit(tt);
  raise Exception.CreateFmt('%s is invalid TradeType string', [Value]);
end;

function TwxTradeTypeHelper.ToString: string;
begin
  Result := TRADE_TYPE_STR[Self]
end;

{ TwxTradeStateHelper }

class function TwxTradeStateHelper.ParseStr(const Value: string): TwxTradeState;
var
  ts: TwxTradeState;
begin
  for ts := Low(TwxTradeState) to High(TwxTradeState) do
    if SameText(TRADE_STATE_STR[ts], Value) then
      Exit(ts);
  raise Exception.CreateFmt('%s is invalid TradeState string', [Value]);
end;

function TwxTradeStateHelper.ToString: string;
begin
  Result := TRADE_STATE_STR[Self]
end;

{ TwxPayResultCodeHelper }

class function TwxPayResultCodeHelper.ParseStr(
  const Value: string): TwxPayResultCode;
var
  prc: TwxPayResultCode;
begin
  for prc := Low(TwxPayResultCode) to High(TwxPayResultCode) do
    if SameText(PAY_RESULT_CODE_STR[prc], Value) then
      Exit(prc);
  raise Exception.CreateFmt('%s is invalid PayResultCode string', [Value]);
end;

function TwxPayResultCodeHelper.ToString: string;
begin
  Result := PAY_RESULT_CODE_STR[Self]
end;

{ TwxSignTypeHelper }

class function TwxSignTypeHelper.ParseStr(
  const Value: string): TwxSignType;
var
  st: TwxSignType;
begin
  for st := Low(TwxSignType) to High(TwxSignType) do
    if SameText(SIGN_TYPE_STR[st], Value) then
      Exit(st);
  raise Exception.CreateFmt('%s is invalid SignType string', [Value]);
end;

function TwxSignTypeHelper.ToString: string;
begin
  Result := SIGN_TYPE_STR[Self]
end;

end.
