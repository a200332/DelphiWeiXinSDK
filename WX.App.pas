unit WX.App;

interface

uses
  System.SysUtils, System.Variants, System.Classes, WX.Common;

type
  IwxAppBuilder = interface
  ['{729EDCC4-1CDC-4126-9137-0B5774C0D914}']
    function AppId(const AppId: string): IwxAppBuilder;
    function Secret(const Secret: string): IwxAppBuilder;
    function TokenCacher(const Cacher: ITokenCacher): IwxAppBuilder;
    function Build: IwxApp;
  end;

  TwxAppBuilder = class(TInterfacedObject, IwxAppBuilder)
  private
    FAppId: string;
    FSecret: string;
    FTokenCacher: ITokenCacher;
  public
    class function New: IwxAppBuilder;
    function AppId(const AppId: string): IwxAppBuilder;
    function Secret(const Secret: string): IwxAppBuilder;
    function TokenCacher(const TokenCacher: ITokenCacher): IwxAppBuilder;
    function Build: IwxApp;
  end;

implementation

uses
  System.Hash, DB, JsonDataObjects, System.Net.HttpClient, System.Net.Mime,
  System.NetEncoding, WX.Utils, WX.Cache, WX.Error, DateUtils, Vcl.ExtCtrls;

type
  //线程安全
  TWxApp = class(TInterfacedObject, IWxApp)
  private
    FAppId: string;
    FSecret: string;
    FTokenCacher: ITokenCacher;
	  procedure AddCustomServicePair(JsonObject: TJSONObject; const KFAccount: string);
    function MessageCustomSendUrl: string;

    {security}
    function GetAccessToken: string;
    property AccessToken: string read GetAccessToken;
    function GetJsApiTicket: string;
    property JsApiTicket: string read GetJsApiTicket;
    function GetJsApiSignature(const Url: string): IWxJsApiSignature;
    function WebAuthorize(const Code: string): IWxWebAuthorize;
    function WebAuthorizeFromBase64(const Base64: string): IWxWebAuthorize;

    {IP}
    function GetCallBackIP: TArray<string>;
    function GetApiDomainIP: TArray<string>;
    function CallbackCheck: TJSONObject;

    {IWxApp Menu}
    procedure CreateMenu(MenuJson: TJSONObject);
    procedure DeleteMenu;
	  function GetMenuInfo: TJSONObject;

    {IWxApp KFAccount}
    procedure AddKFAccount(const KFAccount, NickName, Password: string);
    procedure UpdateKFAccount(const KFAccount, NickName, Password: string);
    procedure DelKFAccount(const KFAccount, NickName, Password: string);
    procedure UploadKFAccountHeadImg(const KFAccount, ImgFile: string);
    procedure InviteWorker(const KFAccount, InviteWx: string);
    function GetKFAccountList: TJSONObject;

    {IWxApp Custom Message}
    procedure SendCustomTextMsg(const ToUser, Text: string; const KFAccount: string = '');
    procedure SendCustomImageMsg(const ToUser, MediaId: string; const KFAccount: string = '');
    procedure SendCustomVoiceMsg(const ToUser, MediaId: string; const KFAccount: string = '');
    procedure SendCustomVideoMsg(const ToUser, MediaId, ThumbMediaId, Title, Description: string; const KFAccount: string = '');
    procedure SendCustomMusicMsg(const ToUser, Title, Description, MusicUrl, HQMusicUrl, ThumbMediaId: string; const KFAccount: string = '');
    procedure SendCustomNewsMsg(const ToUser, Title, Description, Url, PicUrl: string; const KFAccount: string = '');
    procedure SendCustomMpnewsMsg(const ToUser, MediaId: string; const KFAccount: string = '');
    procedure SendCustomWxcardMsg(const ToUser, CardId: string; const KFAccount: string = '');
    procedure SendCustomMiniProgramPageMsg(const ToUser, Title, AppId, PagePath, ThumbMediaId: string; const KFAccount: string = '');
	  procedure SendCustomTypingMsg(const ToUser: string);

    {Media And Material}
    procedure UploadMedia(const MediaFile: string; AType: TwxMediaType; out MediaId: string; out CreatedAt: TDateTime);
    procedure DownloadMedia(const MediaId: string; Stream: TStream);
    procedure UploadMaterialNews(Articles: array of TMediaArticle; out MediaId: string);
    procedure UpdateMaterialNews(const MediaId: string; Article: TMediaArticle; Index: Integer);
    procedure UploadMaterialVideo(const MaterialFile: string; const Title, Introduction: string; out MediaId: string);
    procedure UploadMaterialOther(const MaterialFile: string; const AType: TwxMediaType;
      out MediaId, Url: string);
    procedure DownloadMaterialOther(const MediaId: string; Stream: TStream);
    function GetMaterialNews(const MediaId: string): TJSONObject;
    function GetMaterialVideo(const MediaId: string): TJSONObject;
    procedure DeleteMaterial(const MediaId: string);
    procedure UploadImg(const ImgFile: string; out Url: string);
    procedure UploadNews(Articles: array of TMediaArticle; out MediaId: string; out CreatedAt: TDateTime);
    procedure GetMaterialCount(out VoiceCount, VideoCount, ImageCount, NewsCount: Integer);
    function BatchGetMaterialList(AType: TwxMediaType; const Offset, Count: Integer): TJSONObject;

    {tags}
    function AddTag(const Name: string): TJSONObject;
    function GetTags: TJSONObject;
    procedure UpdateTag(const Id: Integer; Name: string);
    procedure DeleteTag(const Id: Integer);
    function GetTagFans(const TagId: Integer; const NextOpenId: string = ''): TJSONObject;
    procedure BatchTagging(TagId: Integer; const OpenIds: array of string);
    procedure BatchUntagging(TagId: Integer; const OpenIds: array of string);
    function GetUserTags(const OpenId: string): TJSONObject;

    {User}
    function GetUserList(const NextOpenId: string = ''): TJSONObject;
    function GetUserInfo(const OpenId: string; const Lang: string = 'zh_CN'): TJSONObject;
    function BatchGetUserInfo(const OpenIds: array of string; const Lang: string = 'zh_CN'): TJSONObject;
    procedure UpdateUserRemark(const OpenId, Remark: string);
    function GetUserBlackList(const BeginOpenId: string = ''): TJSONObject;
    procedure BatchBlackUsers(const OpenIds: array of string);
    procedure BatchUnblackUsers(const OpenIds: array of string);

    {qrcode}
    function CreateSceneQRCode(const SceneId: Integer; const ExpireSeconds: Integer = 2592000): TwxCreateSceneQRCodeResult; overload;
    function CreateSceneQRCode(const SceneStr: string; const ExpireSeconds: Integer = 2592000): TwxCreateSceneQRCodeResult; overload;
    function CreateSceneLimitQRCode(const SceneId: Integer): TwxCreateSceneQRCodeResult; overload;
    function CreateSceneLimitQRCode(const SceneStr: string): TwxCreateSceneQRCodeResult; overload;
    procedure DownloadSceneQRCode(const Ticket: string; Stream: TStream);
    function Long2Short(const LongUrl: string): string;

    {Template}
    procedure SetIndustry(IndustryId1, IndustryId2: Integer);
    function GetIndustry: TJSONObject;
    function AddTemplate(const TemplateIdShort: string): string;
    procedure DeleteTemplate(const TemplateId: string);
    function GetAllTemplate: TJSONObject;
    function SendTemplateMsg(const ToUser, TemplateId: string; Data: TJSONObject;
      const Url: string = ''; const MiniProgramAppId: string = '';
      const MiniProgramPagePath: string = ''): Int64;

    {user data cube}
    function GetUserSummary(BeginDate, EndDate: TDate): TArray<TUserSummary>;
    function GetUserCumulate(BeginDate, EndDate: TDate): TArray<TUserCumulate>;

    {article data cube}
    function GetArticleSummary(ADate: TDate): TArray<TArticleSummary>;
    function GetArticleTotal(ADate: TDate): TArray<TArticleTotal>;
    function GetUserRead(BeginDate, EndDate: TDate): TArray<TUserRead>;
    function GetUserReadHour(ADate: TDate): TArray<TUserReadHour>;
    function GetUserShare(BeginDate, EndDate: TDate): TArray<TUserShare>;
    function GetUserShareHour(ADate: TDate): TArray<TUserShareHour>;

    {Msg data cube}
    function GetUpStreamMsg(BeginDate, EndDate: TDate): TArray<TUpStreamMsg>;
    function GetUpStreamMsgHour(ADate: TDate): TArray<TUpStreamMsgHour>;
    function GetUpStreamMsgWeek(ADate: TDate): TArray<TUpStreamMsgWeek>;
    function GetUpStreamMsgMonth(AYear, AMonth: Word): TArray<TUpStreamMsgMonth>;
    function GetUpStreamMsgDist(BeginDate, EndDate: TDate): TArray<TUpStreamMsgDist>;
    function GetUpStreamMsgDistWeek(ADate: TDate): TArray<TUpStreamMsgDistWeek>;
    function GetUpStreamMsgDistMonth(AYear, AMonth: Word): TArray<TUpStreamMsgDistMonth>;

    {Interface data cube}
    function GetInterfaceSummary(BeginDate, EndDate: TDate): TArray<TInterfaceSummary>;
    function GetInterfaceSummaryHour(ADate: TDate): TArray<TInterfaceSummaryHour>;
  public
    constructor Create(const AppId, Secret: string; TokenCacher: ITokenCacher);
  end;

  TwxUserInfo = class(TInterfacedObject, IwxUserInfo)
  private
    FJsonObject: TJDOJsonObject;
    function GetOpenId: string;
    function GetNickName: string;
    function GetSex: string;
    function GetProvince: string;
    function GetCity: string;
    function GetCountry: string;
    function GetHeadImgUrl: string;
    function GetPrivilege: TArray<string>;
    function GetUnionId: string;
    function ToJSON: string;
    function GetAccessToken: string;
    function GetRefreshToken: string;
    property OpenId: string read GetOpenId;
    property NickName: string read GetNickName;
    property Sex: string read GetSex;
    property Province: string read GetProvince;
    property City: string read GetCity;
    property Country: string read GetCountry;
    property HeadImgUrl: string read GetHeadImgUrl;
    property Privilege: TArray<string> read GetPrivilege;
    property UnionId: string read GetUnionId;
    property AccessToken: string read GetAccessToken;
    property RefreshToken: string read GetRefreshToken;
  public
    destructor Destroy; override;
  end;

  TWxWebAuthorize = class(TInterfacedObject, IWxWebAuthorize)
  private
    FLockObject: TObject;
    FAppId: string;
    FAccessToken: string;
    FRefreshToken: string;
    FExpiresTime: TDateTime;
    FOpenId: string;
    procedure DoHttp(const url, Description: string; Proc: TProc<IHTTPResponse>);
    procedure Lock;
    procedure Unlock;
  protected
    { IWxWebAuthorize }
    function GetUserInfo: IWxUserInfo;
    function GetAppId: string;
    function GetAccessToken: string;
    function GetRefreshToken: string;
    function GetExpiresTime: TDateTime;
    procedure Refresh;
    function GetBase64: string;
    property UserInfo: IWxUserInfo read GetUserInfo;
    property AppId: string read GetAppId;
    property AccessToken: string read GetAccessToken;
    property RefreshToken: string read GetRefreshToken;
    property ExpiresTime: TDateTime read GetExpiresTime;
  public
    constructor Create; overload;
    constructor Create(const AppId, Secret, Code: string); overload;
    destructor Destroy; override;
  end;

  TWxJsApiSignature = class(TInterfacedObject, IWxJsApiSignature)
  private
    FNonceStr: string;
    FTimestamp: TwxDateTime;
    FSignature: string;
    FAppId: string;
    function GetNonceStr: string;
    function GetTimestamp: TwxDateTime;
    function GetSignature: string;
    function GetAppId: string;
    property NonceStr: string read GetNonceStr;
    property Timestamp: TwxDateTime read GetTimestamp;
    property Signature: string read GetSignature;
    property AppId: string read GetAppId;
    function ToString: string;
  public
    constructor Create(const NonceStr: string; Timestamp: TwxDateTime;
      const Signature, AppId: string);
  end;

{ TwxAppBuilder }

function TwxAppBuilder.Build: IwxApp;
begin
  Result := TWxApp.Create(FAppId, FSecret, FTokenCacher);
end;

class function TwxAppBuilder.New: IwxAppBuilder;
begin
  Result := TwxAppBuilder.Create;
end;

function TwxAppBuilder.AppId(const AppId: String): IwxAppBuilder;
begin
  FAppId := AppId;
  Result := Self;
end;

function TwxAppBuilder.Secret(const Secret: string): IwxAppBuilder;
begin
  FSecret := Secret;
  Result := Self;
end;

function TwxAppBuilder.TokenCacher(const TokenCacher: ITokenCacher): IwxAppBuilder;
begin
  FTokenCacher := TokenCacher;
  Result := Self;
end;

{ TWxApp }

constructor TWxApp.Create(const AppId, Secret: string; TokenCacher: ITokenCacher);
begin
  FAppId := AppId;
  FSecret := Secret;
  if TokenCacher = nil then
    FTokenCacher := WX.Cache.TokenCacher
  else
    FTokenCacher := TokenCacher;
end;

function TWxApp.GetAccessToken: string;
begin
  Result := FTokenCacher.GetAccessToken(FAppId, FSecret);
end;

function TWxApp.GetJsApiTicket: string;
begin
  Result := FTokenCacher.GetJsApiTicket(FAppId, FSecret);
end;

function TWxApp.GetJsApiSignature(const Url: string): IWxJsApiSignature;
var
  NonceStr: string;
  Timestamp: TwxDateTime;
  s: string;
  Signature: string;
begin
  NonceStr := TWxHelper.GenNonceStr;
  Timestamp := TWxHelper.DateTimeToWxTime(Now);
  s := Format('jsapi_ticket=%s&noncestr=%s&timestamp=%d&url=%s',
    [GetJsApiTicket, NonceStr, Timestamp, Url]);
  Signature := THashSHA1.GetHashString(s);
  Result := TWxJsApiSignature.Create(NonceStr, Timestamp, Signature, FAppId);
end;

function TWxApp.GetCallBackIP: TArray<string>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  I: Integer;
begin
  Url := Format('https://%s/cgi-bin/getcallbackip?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取微信callback IP地址');
  jo := nil;
  try
    jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result , jo.A['ip_list'].Count);
    for I := Low(Result) to High(Result) do
      Result[I] := jo.A['ip_list'].S[I];
  finally
    jo.Free;
  end;
end;

function TWxApp.CallbackCheck: TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/callback/check?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['action'] := 'all';
    jo.S['check_operator'] := 'DEFAULT';
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, 'Callback网络检测');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

function TWxApp.GetApiDomainIP: TArray<string>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  I: Integer;
begin
  Url := Format('https://%s/cgi-bin/get_api_domain_ip?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取微信API接口 IP地址');
  jo := nil;
  try
    jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result , jo.A['ip_list'].Count);
    for I := Low(Result) to High(Result) do
      Result[I] := jo.A['ip_list'].S[I];
  finally
    jo.Free;
  end;
end;

procedure TWxApp.AddCustomServicePair(JsonObject: TJSONObject; const KFAccount: string);
begin
  if not KFAccount.Trim.IsEmpty then
    JsonObject.O['customservice'].S['kf_account'] := KFAccount;
end;

function TWxApp.MessageCustomSendUrl: string;
begin
  Result := Format('https://%s/cgi-bin/message/custom/send?access_token=%s', [WX_DOMAIN, AccessToken]);
end;

procedure TWxApp.CreateMenu(MenuJson: TJSONObject);
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/menu/create?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Post(Url, MenuJson.ToStream.Value);
  ParseResponseJsonError(Response, '创建菜单');
end;

procedure TWxApp.DeleteMenu;
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/menu/delete?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '删除菜单');
end;

function TWxApp.GetMenuInfo: TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/menu/get?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取菜单信息');
  Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
end;

procedure TWxApp.AddKFAccount(const KFAccount, NickName, Password: string);
var
  Url: string;
  Response: IHTTPResponse;
  KFAccountObject: TJSONObject;
begin
  KFAccountObject := TJSONObject.Create;
  try
    Url := Format('https://%s/customservice/kfaccount/add?access_token=%s', [WX_DOMAIN, AccessToken]);
    KFAccountObject.S['kf_account'] := KFAccount;
    KFAccountObject.S['nickname'] := NickName;
	  KFAccountObject.S['password'] := Password;
    Response := HTTPClient.Make.Post(Url, KFAccountObject.ToStream.Value);
    ParseResponseJsonError(Response, '添加客服帐号');
  finally
    KFAccountObject.Free;
  end;
end;

procedure TWxApp.UpdateKFAccount(const KFAccount, NickName, Password: string);
var
  Url: string;
  Response: IHTTPResponse;
  KFAccountObject: TJSONObject;
begin
  KFAccountObject := TJSONObject.Create;
  try
    Url := Format('https://%s/customservice/kfaccount/update?access_token=%s', [WX_DOMAIN, AccessToken]);
    KFAccountObject.S['kf_account'] := KFAccount;
    KFAccountObject.S['nickname'] := NickName;
	  KFAccountObject.S['password'] := Password;
    Response := HTTPClient.Make.Post(Url, KFAccountObject.ToStream.Value);
    ParseResponseJsonError(Response, '修改客服帐号');
  finally
    KFAccountObject.Free;
  end;
end;

procedure TWxApp.DelKFAccount(const KFAccount, NickName, Password: string);
var
  Url: string;
  Response: IHTTPResponse;
  KFAccountObject: TJSONObject;
begin
  KFAccountObject := TJSONObject.Create;
  try
    Url := Format('https://%s/customservice/kfaccount/del?access_token=%s', [WX_DOMAIN, AccessToken]);
    KFAccountObject.S['kf_account'] :=  KFAccount;
    KFAccountObject.S['nickname'] := NickName;
	  KFAccountObject.S['password'] := Password;
    Response := HTTPClient.Make.Post(Url, KFAccountObject.ToStream.Value);
    ParseResponseJsonError(Response, '删除客服帐号');
  finally
    KFAccountObject.Free;
  end;
end;

procedure TWxApp.UploadKFAccountHeadImg(const KFAccount, ImgFile: string);
var
  Url: string;
  Response: IHTTPResponse;
  MultipartFormData: TMultipartFormData;
begin
  MultipartFormData := TMultipartFormData.Create;
  try
    Url := Format('http://%s/customservice/kfaccount/uploadheadimg?access_token=%s&kf_account=%s',
      [WX_DOMAIN, AccessToken, KFAccount]);
    MultipartFormData.AddFile('HeadImg', ImgFile);
    Response := HTTPClient.Make.Post(Url, MultipartFormData);
    ParseResponseJsonError(Response, '设置客服帐号的头像');
  finally
    MultipartFormData.Free;
  end;
end;

procedure TWxApp.InviteWorker(const KFAccount, InviteWx: string);
var
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    jo.S['kf_account'] := KFAccount;
    jo.S['invite_wx'] := InviteWx;
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, jo.ToStream.Value);
    ParseResponseJsonError(Response, '邀请绑定客服帐号');
  finally
    jo.Free;
  end;
end;

function TWxApp.GetKFAccountList: TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/customservice/getkflist?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取所有客服账号');
  Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
end;

procedure TWxApp.SendCustomTextMsg(const ToUser, Text: string; const KFAccount: string);
var
  Response: IHTTPResponse;
  TextObject: TJSONObject;
begin
  TextObject := TJSONObject.Create;
  try
    TextObject.S['touser'] := ToUser;
    TextObject.S['msgtype'] := 'text';
    TextObject.o['text'].S['content'] := Text;
    AddCustomServicePair(TextObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, TextObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送文本消息');
  finally
    TextObject.Free;
  end;
end;

procedure TWxApp.SendCustomImageMsg(const ToUser, MediaId: string; const KFAccount: string);
var
  Url: string;
  Response: IHTTPResponse;
  ImageObject: TJSONObject;
begin
  ImageObject := TJSONObject.Create;
  try
    ImageObject.S['touser'] := ToUser;
    ImageObject.S['msgtype'] := 'image';
    ImageObject.O['image'].S['media_id'] := MediaId;
    AddCustomServicePair(ImageObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, ImageObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送图片消息');
  finally
    ImageObject.Free;
  end;
end;

procedure TWxApp.SendCustomVoiceMsg(const ToUser, MediaId: string; const KFAccount: string);
var
  Response: IHTTPResponse;
  VoiceObject: TJSONObject;
begin
  VoiceObject := TJSONObject.Create;
  try
    VoiceObject.S['touser'] := ToUser;
    VoiceObject.S['msgtype'] := 'voice';
    VoiceObject.O['voice'].S['media_id'] := MediaId;
    AddCustomServicePair(VoiceObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, VoiceObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送语音消息');
  finally
    VoiceObject.Free;
  end;
end;

procedure TWxApp.SendCustomVideoMsg(const ToUser, MediaId, ThumbMediaId, Title, Description: string; const KFAccount: string);
var
  Response: IHTTPResponse;
  VideoObject: TJSONObject;
  jo: TJSONObject;
begin
  VideoObject := TJSONObject.Create;
  try
    VideoObject.S['touser'] := ToUser;
    VideoObject.S['msgtype'] := 'video';
    jo := TJSONObject.Create;
    jo.S['media_id'] := MediaId;
    jo.S['thumb_media_id'] := ThumbMediaId;
    jo.S['title'] := Title;
    jo.S['description'] := Description;
    VideoObject.O['video'] := jo;
    AddCustomServicePair(VideoObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, VideoObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送视频消息');
  finally
    VideoObject.Free;
  end;
end;

procedure TWxApp.SendCustomMusicMsg(const ToUser, Title, Description, MusicUrl, HQMusicUrl, ThumbMediaId: string; const KFAccount: string);
var
  Response: IHTTPResponse;
  MusicObject: TJSONObject;
  jo: TJSONObject;
begin
  MusicObject := TJSONObject.Create;
  try
    MusicObject.S['touser'] := ToUser;
    MusicObject.S['msgtype'] := 'music';
    jo := TJSONObject.Create;
    jo.S['musicurl'] := MusicUrl;
    jo.S['hqmusicurl'] := HQMusicUrl;
    jo.S['thumb_media_id'] := ThumbMediaId;
    jo.S['title'] := Title;
    jo.S['description'] := Description;
    MusicObject.O['music'] := jo;
    AddCustomServicePair(MusicObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, MusicObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送音乐消息');
  finally
    MusicObject.Free;
  end;
end;

procedure TWxApp.SendCustomNewsMsg(const ToUser, Title, Description, Url, PicUrl: string; const KFAccount: string);
var
  Response: IHTTPResponse;
  NewsObject: TJSONObject;
  Articles: TJSONArray;
  jo: TJSONObject;
begin
  NewsObject := TJSONObject.Create;
  try
    NewsObject.S['touser'] := ToUser;
    NewsObject.S['msgtype'] := 'news';
    Articles := TJSONArray.Create;
    NewsObject.O['news'].A['articles'] := Articles;
    jo := Articles.AddObject;
    jo.S['url'] := Url;
    jo.S['picurl'] := PicUrl;
    jo.S['title'] := Title;
    jo.S['description'] := Description;
    AddCustomServicePair(NewsObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, NewsObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送图文消息');
  finally
    NewsObject.Free;
  end;
end;

procedure TWxApp.SendCustomMpnewsMsg(const ToUser, MediaId: string; const KFAccount: string);
var
  Response: IHTTPResponse;
  MpnewsObject: TJSONObject;
begin
  MpnewsObject := TJSONObject.Create;
  try
    MpnewsObject.S['touser'] := ToUser;
    MpnewsObject.S['msgtype'] := 'mpnews';
    MpnewsObject.O['mpnews'].S['media_id'] := MediaId;
    AddCustomServicePair(MpnewsObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, MpnewsObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送图文消息');
  finally
    MpnewsObject.Free;
  end;
end;

procedure TWxApp.SendCustomWxcardMsg(const ToUser, CardId: string; const KFAccount: string);
var
  Response: IHTTPResponse;
  WxcardObject: TJSONObject;
begin
  WxcardObject := TJSONObject.Create;
  try
    WxcardObject.S['touser'] := ToUser;
    WxcardObject.S['msgtype'] := 'wxcard';
    WxcardObject.O['wxcard'].S['card_id'] := CardId;
    AddCustomServicePair(WxcardObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, WxcardObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送卡券');
  finally
    WxcardObject.Free;
  end;
end;

procedure TWxApp.SendCustomMiniProgramPageMsg(const ToUser, Title, AppId, PagePath, ThumbMediaId: string; const KFAccount: string);
var
  Response: IHTTPResponse;
  MiniProgramPageObject: TJSONObject;
  jo: TJSONObject;
begin
  MiniProgramPageObject := TJSONObject.Create;
  try
    MiniProgramPageObject.S['touser'] := ToUser;
    MiniProgramPageObject.S['msgtype'] := 'miniprogrampage';
    jo := TJSONObject.Create;
    jo.S['appid'] := AppId;
    jo.S['pagepath'] := PagePath;
    jo.S['thumb_media_id'] := ThumbMediaId;
    jo.S['title'] := Title;
    MiniProgramPageObject.O['miniprogrampage'] := jo;
    AddCustomServicePair(MiniProgramPageObject, KFAccount);
    Response := HTTPClient.Make.Post(MessageCustomSendUrl, MiniProgramPageObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送小程序卡片');
  finally
    MiniProgramPageObject.Free;
  end;
end;

procedure TWxApp.SendCustomTypingMsg(const ToUser: string);
var
  Url: string;
  Response: IHTTPResponse;
  TypingObject: TJSONObject;
begin
  TypingObject := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/message/custom/typing?access_token=%s', [WX_DOMAIN, AccessToken]);
    TypingObject.S['touser'] := ToUser;
    TypingObject.S['command'] := 'Typing';
    Response := HTTPClient.Make.Post(Url, TypingObject.ToStream.Value);
    ParseResponseJsonError(Response, '发送客服输入状态');
  finally
    TypingObject.Free;
  end;
end;

procedure TWxApp.UploadMedia(const MediaFile: string; AType: TwxMediaType; out MediaId: string; out CreatedAt: TDateTime);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  MultipartFormData: TMultipartFormData;
begin
  jo := nil;
  MultipartFormData := TMultipartFormData.Create;
  try
    Url := Format('https://%s/cgi-bin/media/upload?access_token=%s&type=%s', [WX_DOMAIN, AccessToken, AType.ToString]);
    MultipartFormData.AddFile('media', MediaFile);
    Response := HTTPClient.Make.Post(Url, MultipartFormData);
    ParseResponseJsonError(Response, '新增临时素材');
    jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    MediaId := jo.S['media_id'];
    CreatedAt := TWxHelper.WxTimeToDateTime(jo.L['created_at']);
  finally
    jo.Free;
    MultipartFormData.Free;
  end;
end;

procedure TWxApp.DownloadMedia(const MediaId: string; Stream: TStream);
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/media/get?access_token=%s&media_id=%s',
    [WX_DOMAIN, AccessToken, MediaId]);
  Response := HTTPClient.Make.Get(Url);
  if Response.StatusCode = 200 then begin
    ParseResponseJsonError(Response, '获取临时素材');
    Stream.Size := 0;
    Stream.Position := 0;
    Stream.CopyFrom(Response.ContentStream, 0);
    Stream.Position := 0;
  end
  else
    raise Exception.Create(Response.StatusText);
end;

procedure TWxApp.UploadMaterialNews(Articles: array of TMediaArticle; out MediaId: string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  ArticleArray: TJSONArray;
  Article: TMediaArticle;
  ArticleObject: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
begin
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/material/add_news?access_token=%s', [WX_DOMAIN, AccessToken]);
    ArticleArray := TJSONArray.Create;
    for Article in Articles do begin
      ArticleObject := ArticleArray.AddObject;
      ArticleObject.S['thumb_media_id'] := Article.Thumb_media_id;
      ArticleObject.S['author'] := Article.Author;
      ArticleObject.S['title'] := Article.Title;
      ArticleObject.S['content_source_url'] := Article.ContentSourceUrl;
      ArticleObject.S['content'] := Article.Content;
      ArticleObject.S['digest'] := Article.Digest;
      ArticleObject.I['show_cover_pic'] := BOOL_INT[Article.ShowCoverPic];
      ArticleObject.I['need_open_comment'] := BOOL_INT[Article.NeedOpenComment];
      ArticleObject.I['only_fans_can_comment'] := BOOL_INT[Article.OnlyFansCanComment];
    end;
    jo.A['articles'] := ArticleArray;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '新增永久图文素材');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    MediaId := jo2.S['media_id'];
  finally
    jo.Free;
    jo2.Free;
  end;
end;

procedure TWxApp.UpdateMaterialNews(const MediaId: string; Article: TMediaArticle; Index: Integer);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  Articles: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/material/add_news?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['media_id'] := MediaId;
    jo.I['index'] := Index;
    Articles := TJSONObject.Create;
    Articles.S['thumb_media_id'] := Article.Thumb_media_id;
    Articles.S['author'] := Article.Author;
    Articles.S['title'] := Article.Title;
    Articles.S['content_source_url'] := Article.ContentSourceUrl;
    Articles.S['content'] := Article.Content;
    Articles.S['digest'] := Article.Digest;
    Articles.I['show_cover_pic'] := BOOL_INT[Article.ShowCoverPic];
    Articles.I['need_open_comment'] := BOOL_INT[Article.NeedOpenComment];
    Articles.I['only_fans_can_comment'] := BOOL_INT[Article.OnlyFansCanComment];
    jo.O['articles'] := Articles;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '修改永久图文素材');
  finally
    jo.Free;
  end;
end;

procedure TWxApp.UploadMaterialVideo(const MaterialFile: string;
  const Title, Introduction: string; out MediaId: string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  MultipartFormData: TMultipartFormData;
begin
  jo := nil;
  MultipartFormData := TMultipartFormData.Create;
  try
    Url := Format('https://%s/cgi-bin/material/add_material?access_token=%s&type=%s',
      [WX_DOMAIN, AccessToken, TwxMediaType.Video.ToString]);
    MultipartFormData.AddFile('media', MaterialFile);
    MultipartFormData.AddField('description',
      Format('{"title":"%s","introduction":"%s"}', [Title, Introduction]));
    Response := HTTPClient.Make.Post(Url, MultipartFormData);
    ParseResponseJsonError(Response, Format('新增[%s]类型永久素材材', [TwxMediaType.Video.ToString]));
    jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    MediaId := jo.S['media_id'];
  finally
    jo.Free;
    MultipartFormData.Free;
  end;
end;

procedure TWxApp.UploadMaterialOther(const MaterialFile: string; const AType: TwxMediaType;
  out MediaId, Url: string);
var
  aUrl: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  MultipartFormData: TMultipartFormData;
begin
  jo := nil;
  MultipartFormData := TMultipartFormData.Create;
  try
    aUrl := Format('https://%s/cgi-bin/material/add_material?access_token=%s&type=%s',
      [WX_DOMAIN, AccessToken, AType.ToString]);
    MultipartFormData.AddFile('media', MaterialFile);
    Response := HTTPClient.Make.Post(aUrl, MultipartFormData);
    ParseResponseJsonError(Response, Format('新增[%s]类型永久素材材', [AType.ToString]));
    jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    MediaId := jo.S['media_id'];
    Url := jo.S['url'];
  finally
    jo.Free;
    MultipartFormData.Free;
  end;
end;

function TWxApp.GetMaterialNews(const MediaId: string): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/material/get_material?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['media_id'] := MediaId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取永久图文素材');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

function TWxApp.GetMaterialVideo(const MediaId: string): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/material/get_material?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['media_id'] := MediaId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取永久视频素材');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

procedure TWxApp.DeleteMaterial(const MediaId: string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/material/del_material?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['media_id'] := MediaId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '删除永久素材');
  finally
    jo.Free;
  end;
end;

procedure TWxApp.DownloadMaterialOther(const MediaId: string; Stream: TStream);
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/material/get_material?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  if Response.StatusCode = 200 then begin
    ParseResponseJsonError(Response, '获取永久素材');
    Stream.Size := 0;
    Stream.Position := 0;
    Stream.CopyFrom(Response.ContentStream, 0);
    Stream.Position := 0;
  end
  else
    raise Exception.Create(Response.StatusText);
end;

procedure TWxApp.UploadImg(const ImgFile: string; out Url: string);
var
  aUrl: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  MultipartFormData: TMultipartFormData;
begin
  jo := nil;
  MultipartFormData := TMultipartFormData.Create;
  try
    aUrl := Format('https://%s/cgi-bin/media/uploadimg?access_token=%s', [WX_DOMAIN, AccessToken]);
    MultipartFormData.AddFile('media', ImgFile);
    Response := HTTPClient.Make.Post(aUrl, MultipartFormData);
    ParseResponseJsonError(Response, '上传图片');
    jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    Url := jo.S['url'];
  finally
    jo.Free;
    MultipartFormData.Free;
  end;
end;

procedure TWxApp.UploadNews(Articles: array of TMediaArticle; out MediaId: string; out CreatedAt: TDateTime);
const
  BOOL_INT: array[Boolean] of Integer = (0, 1);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  ArticleArray: TJSONArray;
  Article: TMediaArticle;
  ArticleObject: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
begin
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/media/uploadnews?access_token=%s', [WX_DOMAIN, AccessToken]);
    ArticleArray := TJSONArray.Create;
    for Article in Articles do begin
      ArticleObject := ArticleArray.AddObject;
      ArticleObject.S['thumb_media_id'] := Article.Thumb_media_id;
      ArticleObject.S['author'] := Article.Author;
      ArticleObject.S['title'] := Article.Title;
      ArticleObject.S['content_source_url'] := Article.ContentSourceUrl;
      ArticleObject.S['content'] := Article.Content;
      ArticleObject.S['digest'] := Article.Digest;
      ArticleObject.I['show_cover_pic'] := BOOL_INT[Article.ShowCoverPic];
      ArticleObject.I['need_open_comment'] := BOOL_INT[Article.NeedOpenComment];
      ArticleObject.I['only_fans_can_comment'] := BOOL_INT[Article.OnlyFansCanComment];
    end;
    jo.A['articles'] := ArticleArray;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '上传图文消息素材');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    MediaId := jo2.S['media_id'];
    CreatedAt := TWxHelper.WxTimeToDateTime(jo2.L['created_at']);
  finally
    jo.Free;
    jo2.Free;
  end;
end;

procedure TWxApp.GetMaterialCount(out VoiceCount, VideoCount, ImageCount, NewsCount: Integer);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := nil;
  try
    Url := Format('https://%s/cgi-bin/material/get_materialcount?access_token=%s', [WX_DOMAIN, AccessToken]);
    Response := HTTPClient.Make.Get(Url);
    ParseResponseJsonError(Response, '获取素材总数');
    jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    VoiceCount := jo.I['voice_count'];
    VideoCount := jo.I['video_count'];
    ImageCount := jo.I['image_count'];
    NewsCount  := jo.I['news_count'];
  finally
    jo.Free;
  end;
end;

function TWxApp.BatchGetMaterialList(AType: TwxMediaType; const Offset, Count: Integer): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/material/batchget_material?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['type'] := AType.ToString;
    jo.I['offset'] := Offset;
    jo.I['count'] := Count;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取素材列表');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

function TWxApp.AddTag(const Name: string): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/create?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.O['tag'].S['name'] := Name;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '创建标签');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

procedure TWxApp.UpdateTag(const Id: Integer; Name: string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/update?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo2 := TJSONObject.Create;
    jo2.I['id'] := Id;
    jo2.S['name'] := Name;
    jo.O['tag'] := jo2;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '删除标签');
  finally
    jo.Free;
  end;
end;

procedure TWxApp.DeleteTag(const Id: Integer);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/delete?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.O['tag'].I['id'] := Id;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '删除标签');
  finally
    jo.Free;
  end;
end;

function TWxApp.GetTags: TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/tags/update?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取标签详情');
  Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
end;

function TWxApp.GetTagFans(const TagId: Integer; const NextOpenId: string): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/delete?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.I['tagid'] := TagId;
    jo.S['next_openid'] := NextOpenId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取标签下粉丝列表');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

procedure TWxApp.BatchTagging(TagId: Integer; const OpenIds: array of string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  OpenIdList: TJSONArray;
  S: string;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/members/batchtagging?access_token=%s', [WX_DOMAIN, AccessToken]);
    OpenIdList := TJSONArray.Create;
    for s in OpenIds do
      OpenIdList.Add(s);
    jo.A['openid_list'] := OpenIdList;
    jo.I['tagid'] := TagId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '批量为用户打标签');
  finally
    jo.Free;
  end;
end;

procedure TWxApp.BatchUntagging(TagId: Integer; const OpenIds: array of string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  OpenIdList: TJSONArray;
  S: string;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/members/batchuntagging?access_token=%s', [WX_DOMAIN, AccessToken]);
    OpenIdList := TJSONArray.Create;
    for s in OpenIds do
      OpenIdList.Add(s);
    jo.A['openid_list'] := OpenIdList;
    jo.I['tagid'] := TagId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '批量为用户取消标签');
  finally
    jo.Free;
  end;
end;

function TWxApp.GetUserTags(const OpenId: string): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/getidlist?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['openid'] := OpenId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取用户身上的标签列表');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

function TWxApp.GetUserList(const NextOpenId: string): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
begin
  if NextOpenId.Trim.IsEmpty then
    Url := Format('https://%s/cgi-bin/user/get?access_token=%s', [WX_DOMAIN, AccessToken])
  else
    Url := Format('https://%s/cgi-bin/user/get?access_token=%s&next_openid=%s', [WX_DOMAIN, AccessToken, NextOpenId]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取关注者列表');
  Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
end;

function TWxApp.GetUserInfo(const OpenId: string; const Lang: string): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/user/info?access_token=%s&openid=%s&lang=%s',
    [WX_DOMAIN, AccessToken, OpenId, Lang]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取用户基本信息');
  Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
end;

function TWxApp.BatchGetUserInfo(const OpenIds: array of string; const Lang: string = 'zh_CN'): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  UserList: TJSONArray;
  s: string;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/user/info/batchget?access_token=%s', [WX_DOMAIN, AccessToken]);
    UserList := TJSONArray.Create;
    for s in OpenIds do begin
      jo2 := TJSONObject.Create;
      jo2.S['openid'] := s;
      jo2.S['lang'] := Lang;
      UserList.Add(jo2);
    end;
    jo.A['user_list'] := UserList;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '批量获取用户基本信息');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

procedure TWxApp.UpdateUserRemark(const OpenId, Remark: string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/user/info/updateremark?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['openid'] := OpenId;
    jo.S['remark'] := Remark;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '设置用户备注名');
  finally
    jo.Free;
  end;
end;

function TWxApp.GetUserBlackList(const BeginOpenId: string = ''): TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/members/getblacklist?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_openid'] := BeginOpenId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取公众号的黑名单列表');
    Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
  finally
    jo.Free;
  end;
end;

procedure TWxApp.BatchBlackUsers(const OpenIds: array of string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  List: TJSONArray;
  S: string;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/members/batchblacklist?access_token=%s', [WX_DOMAIN, AccessToken]);
    List := TJSONArray.Create;
    for s in OpenIds do
      List.Add(s);
    jo.A['openid_list'] := List;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '拉黑用户');
  finally
    jo.Free;
  end;
end;

procedure TWxApp.BatchUnblackUsers(const OpenIds: array of string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  List: TJSONArray;
  S: string;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/tags/members/batchunblacklist?access_token=%s', [WX_DOMAIN, AccessToken]);
    List := TJSONArray.Create;
    for s in OpenIds do
      List.Add(s);
    jo.A['openid_list'] := List;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '取消拉黑用户');
  finally
    jo.Free;
  end;
end;

function TWxApp.CreateSceneQRCode(const SceneId: Integer; const ExpireSeconds: Integer): TwxCreateSceneQRCodeResult;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jr: TJSONObject;
begin
  jr := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/qrcode/create?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.I['expire_seconds'] := ExpireSeconds;
    jo.S['action_name'] := 'QR_SCENE';
    jo.O['action_info'].O['scene'].I['scene_id'] := SceneId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '创建临时二维码');
    jr := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    Result.Ticket := jr.S['ticket'];
    Result.ExpireSeconds := jr.I['expire_seconds'];
    Result.Url := jr.S['url'];
  finally
    jo.Free;
    jr.Free;
  end;
end;

function TWxApp.CreateSceneQRCode(const SceneStr: string; const ExpireSeconds: Integer): TwxCreateSceneQRCodeResult;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jr: TJSONObject;
begin
  if SceneStr.IsEmpty then
    raise Exception.Create('scene string is empty');
  if 64 < SceneStr.Length then
    raise Exception.Create('scene string length can not large than 64');
  jr := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/qrcode/create?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.I['expire_seconds'] := ExpireSeconds;
    jo.S['action_name'] := 'QR_STR_SCENE';
    jo.O['action_info'].O['scene'].S['scene_str'] := SceneStr;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '创建临时二维码');
    jr := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    Result.Ticket := jr.S['ticket'];
    Result.ExpireSeconds := jr.I['expire_seconds'];
    Result.Url := jr.S['url'];
  finally
    jo.Free;
    jr.Free;
  end;
end;

function TWxApp.CreateSceneLimitQRCode(const SceneId: Integer): TwxCreateSceneQRCodeResult;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jr: TJSONObject;
begin
  jr := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/qrcode/create?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['action_name'] := 'QR_LIMIT_SCENE';
    jo.O['action_info'].O['scene'].I['scene_id'] := SceneId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '创建永久二维码');
    jr := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    Result.Ticket := jr.S['ticket'];
    Result.ExpireSeconds := jr.I['expire_seconds'];
    Result.Url := jr.S['url'];
  finally
    jo.Free;
    jr.Free;
  end;
end;

function TWxApp.CreateSceneLimitQRCode(const SceneStr: string): TwxCreateSceneQRCodeResult;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jr: TJSONObject;
begin
  if SceneStr.IsEmpty then
    raise Exception.Create('scene string is empty');
  if 64 < SceneStr.Length then
    raise Exception.Create('scene string length can not large than 64');
  jr := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/qrcode/create?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['action_name'] := 'QR_LIMIT_STR_SCENE';
    jo.O['action_info'].O['scene'].S['scene_str'] := SceneStr;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '创建永久二维码');
    jr := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    Result.Ticket := jr.S['ticket'];
    Result.ExpireSeconds := jr.I['expire_seconds'];
    Result.Url := jr.S['url'];
  finally
    jo.Free;
    jr.Free;
  end;
end;

procedure TWxApp.DownloadSceneQRCode(const Ticket: string; Stream: TStream);
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=%s', [TNetEncoding.URL.EncodeQuery(Ticket)]);
  Response := HTTPClient.Make.Get(Url);
  if Response.StatusCode = 200 then begin
    ParseResponseJsonError(Response, '通过ticket换取二维码');
    Stream.Size := 0;
    Stream.Position := 0;
    Stream.CopyFrom(Response.ContentStream, 0);
    Stream.Position := 0;
  end
  else
    raise Exception.Create(Response.StatusText);
end;

function TWxApp.Long2Short(const LongUrl: string): string;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
begin
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/shorturl?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['action'] := 'long2short';
    jo.S['long_url'] := LongUrl;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '长链接转成短链接');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    Result := jo2.S['short_url'];
  finally
    jo.Free;
    jo2.Free;
  end;
end;

procedure TWxApp.SetIndustry(IndustryId1, IndustryId2: Integer);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/template/api_set_industry?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['industry_id1'] := IndustryId1.ToString;
    jo.S['industry_id2'] := IndustryId2.ToString;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '设置所属行业');
  finally
    jo.Free;
  end;
end;

function TWxApp.GetIndustry: TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/template/get_industry?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取设置的行业信息');
  Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
end;

function TWxApp.AddTemplate(const TemplateIdShort: string): string;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
begin
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/template/api_add_template?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['template_id_short'] := 'TemplateIdShort';
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获得模板ID');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    Result := jo2.S['template_id'];
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetAllTemplate: TJSONObject;
var
  Url: string;
  Response: IHTTPResponse;
begin
  Url := Format('https://%s/cgi-bin/template/get_all_private_template?access_token=%s', [WX_DOMAIN, AccessToken]);
  Response := HTTPClient.Make.Get(Url);
  ParseResponseJsonError(Response, '获取模板列表');
  Result := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
end;

procedure TWxApp.DeleteTemplate(const TemplateId: string);
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
begin
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/cgi-bin/template/del_private_template?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['template_id'] := TemplateId;
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '删除模板');
  finally
    jo.Free;
  end;
end;

function TWxApp.SendTemplateMsg(const ToUser, TemplateId: string; Data: TJSONObject;
  const Url, MiniProgramAppId, MiniProgramPagePath: string): Int64;
var
  aUrl: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  MiniProgram: TJSONObject;
begin
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    aUrl := Format('https://%s/cgi-bin/message/template/send?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['touser'] := ToUser;
    jo.S['template_id'] := TemplateId;
    jo.S['url'] := Url;
    if not MiniProgramAppId.Trim.IsEmpty and not MiniProgramPagePath.Trim.IsEmpty then begin
      MiniProgram := TJSONObject.Create;
      MiniProgram.S['appid'] := MiniProgramAppId;
      MiniProgram.S['pagepath'] := MiniProgramPagePath;
      jo.O['miniprogram'] := MiniProgram;
    end;
    jo.O['data'] := Data.Clone as TJSONObject;
    Response := HTTPClient.Make.Post(aUrl, jo.ToStream.Value);
    ParseResponseJsonError(Response, '发送模板消息');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    Result := jo2.L['msgid'];
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.WebAuthorize(const Code: string): IWxWebAuthorize;
begin
  Result := TWxWebAuthorize.Create(FAppId, FSecret, Code);
end;

function TWxApp.WebAuthorizeFromBase64(const Base64: string): IWxWebAuthorize;
var
  jo: TJsonObject;
begin
  jo := TJsonObject.Parse(TNetEncoding.Base64.Decode(Base64)) as TJsonObject;
  try
    Result := TWxWebAuthorize.Create;
    TWxWebAuthorize(Result).FAppId := FAppId;
    TWxWebAuthorize(Result).FOpenId := jo.S['open_id'];
    TWxWebAuthorize(Result).FAccessToken := jo.S['access_token'];
    TWxWebAuthorize(Result).FRefreshToken := jo.S['refresh_token'];
    TWxWebAuthorize(Result).FExpiresTime := jo.F['expires_time'];
  finally
    jo.Free;
  end;
end;

function TWxApp.GetUserSummary(BeginDate, EndDate: TDate): TArray<TUserSummary>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if 7-1 < DaysBetween(BeginDate, EndDate) then
    TWXException.Create('最大时间跨度不能大于7天');
  if Yesterday < EndDate then
    TWXException.Create('结束日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getusersummary?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', BeginDate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', EndDate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取用户增减数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].UserSource := J.I['user_source'];
      Result[I].NewUser := J.I['new_user'];
      Result[I].CancelUser := J.I['cancel_user'];
      Result[I].AddUser := Result[I].NewUser - Result[I].CancelUser;
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUserCumulate(BeginDate, EndDate: TDate): TArray<TUserCumulate>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if 7-1 < DaysBetween(BeginDate, EndDate) then
    TWXException.Create('最大时间跨度不能大于7天');
  if Yesterday < EndDate then
    TWXException.Create('结束日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getusercumulate?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', BeginDate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', EndDate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取累计用户数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].CumulateUser := J.I['cumulate_user'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetArticleSummary(ADate: TDate): TArray<TArticleSummary>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if Yesterday < ADate then
    TWXException.Create('日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getarticlesummary?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取图文群发每日数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].msgId := J.S['msgid'];
      Result[I].Title := J.S['title'];
      Result[I].IntPageReadUser := J.I['int_page_read_user'];
      Result[I].IntPageReadCount := J.I['int_page_read_count'];
      Result[I].OriPageReadUser := J.I['ori_page_read_user'];
      Result[I].OriPageReadCount := J.I['ori_page_read_count'];
      Result[I].ShareUser := J.I['share_user'];
      Result[I].ShareCount := J.I['share_count'];
      Result[I].AddToFavUser := J.I['add_to_fav_user'];
      Result[I].AddToFavCount := J.I['add_to_fav_count'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetArticleTotal(ADate: TDate): TArray<TArticleTotal>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I, K: Integer;
  J: TJSONObject;
  D: TJSONObject;
begin
  if Yesterday < ADate then
    TWXException.Create('日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getarticletotal?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取图文群发总数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].msgId := J.S['msgid'];
      Result[I].Title := J.S['title'];
      SetLength(Result, J.A['details'].Count);
      for K := 0 to J.A['details'].Count - 1 do begin
        D := J.A['details'][K];
        Result[I].Details[K].StatDate := ISO8601ToDate(D.S['stat_date']);;
        Result[I].Details[K].TargetUser := D.I['target_user'];
        Result[I].Details[K].IntPageReadUser := D.I['int_page_read_user'];
        Result[I].Details[K].IntPageReadCount := D.I['int_page_read_count'];
        Result[I].Details[K].OriPageReadUser := D.I['ori_page_read_user'];
        Result[I].Details[K].OriPageReadCount := D.I['ori_page_read_count'];
        Result[I].Details[K].ShareUser := D.I['share_user'];
        Result[I].Details[K].ShareCount := D.I['share_count'];
        Result[I].Details[K].AddToFavUser := D.I['add_to_fav_user'];
        Result[I].Details[K].AddToFavCount := D.I['add_to_fav_count'];
        Result[I].Details[K].IntPageFromSessionReadUser := D.I['int_page_from_session_read_user'];
        Result[I].Details[K].IntPageFromSessionReadCount := D.I['int_page_from_session_read_count'];
        Result[I].Details[K].IntPageFromHistMsgReadUser := D.I['int_page_from_hist_msg_read_user'];
        Result[I].Details[K].IntPageFromHistMsgReadCount := D.I['int_page_from_hist_msg_read_count'];
        Result[I].Details[K].IntPageFromFeedReadUser := D.I['int_page_from_feed_read_user'];
        Result[I].Details[K].IntPageFromFeedReadCount := D.I['int_page_from_feed_read_count'];
        Result[I].Details[K].IntPageFromFriendsReadUser := D.I['int_page_from_friends_read_user'];
        Result[I].Details[K].IntPageFromFriendsReadCount := D.I['int_page_from_friends_read_count'];
        Result[I].Details[K].IntPageFromOtherReadUser := D.I['int_page_from_other_read_user'];
        Result[I].Details[K].IntPageFromOtherReadCount := D.I['int_page_from_other_read_count'];
        Result[I].Details[K].FeedShareFromSessionUser := D.I['feed_share_from_session_user'];
        Result[I].Details[K].FeedShareFromSessionCount := D.I['feed_share_from_session_cnt'];
        Result[I].Details[K].FeedShareFromFeedUser := D.I['feed_share_from_feed_user'];
        Result[I].Details[K].FeedShareFromFeedCount := D.I['feed_share_from_feed_cnt'];
        Result[I].Details[K].FeedShareFromOtherUser := D.I['feed_share_from_other_user'];
        Result[I].Details[K].FeedShareFromOtherCount := D.I['feed_share_from_other_cnt'];
      end;
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUserRead(BeginDate, EndDate: TDate): TArray<TUserRead>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if 3-1 < DaysBetween(BeginDate, EndDate) then
    TWXException.Create('最大时间跨度不能大于3天');
  if Yesterday < EndDate then
    TWXException.Create('结束日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getuserread?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', BeginDate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', EndDate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取图文统计数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].IntPageReadUser := J.I['int_page_read_user'];
      Result[I].IntPageReadCount := J.I['int_page_read_count'];
      Result[I].OriPageReadUser := J.I['ori_page_read_user'];
      Result[I].OriPageReadCount := J.I['ori_page_read_count'];
      Result[I].ShareUser := J.I['share_user'];
      Result[I].ShareCount := J.I['share_count'];
      Result[I].AddToFavUser := J.I['add_to_fav_user'];
      Result[I].AddToFavCount := J.I['add_to_fav_count'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUserReadHour(ADate: TDate): TArray<TUserReadHour>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if Yesterday < ADate then
    TWXException.Create('日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getuserreadhour?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取图文统计分时数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].RefHour := J.I['ref_hour'];
      Result[I].UserSource := J.I['user_source'];
      Result[I].IntPageReadUser := J.I['int_page_read_user'];
      Result[I].IntPageReadCount := J.I['int_page_read_count'];
      Result[I].OriPageReadUser := J.I['ori_page_read_user'];
      Result[I].OriPageReadCount := J.I['ori_page_read_count'];
      Result[I].ShareUser := J.I['share_user'];
      Result[I].ShareCount := J.I['share_count'];
      Result[I].AddToFavUser := J.I['add_to_fav_user'];
      Result[I].AddToFavCount := J.I['add_to_fav_count'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUserShare(BeginDate, EndDate: TDate): TArray<TUserShare>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if 7-1 < DaysBetween(BeginDate, EndDate) then
    TWXException.Create('最大时间跨度不能大于7天');
  if Yesterday < EndDate then
    TWXException.Create('结束日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getusershare?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', BeginDate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', EndDate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取图文分享转发数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].ShareScene := J.I['share_scene'];
      Result[I].ShareCount := J.I['share_count'];
      Result[I].ShareUser := J.I['share_user'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUserShareHour(ADate: TDate): TArray<TUserShareHour>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if Yesterday < ADate then
    TWXException.Create('日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getusersharehour?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取图文分享转发分时数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].RefHour := J.I['ref_hour'];
      Result[I].ShareScene := J.I['share_scene'];
      Result[I].ShareCount := J.I['share_count'];
      Result[I].ShareUser := J.I['share_user'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUpStreamMsg(BeginDate, EndDate: TDate): TArray<TUpStreamMsg>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if 7-1 < DaysBetween(BeginDate, EndDate) then
    TWXException.Create('最大时间跨度不能大于7天');
  if Yesterday < EndDate then
    TWXException.Create('结束日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getupstreammsg?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', BeginDate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', EndDate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取消息发送概况数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].MsgType := J.I['msg_type'];
      Result[I].MsgUser := J.I['msg_user'];
      Result[I].MsgCount := J.I['msg_count'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUpStreamMsgHour(ADate: TDate): TArray<TUpStreamMsgHour>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if Yesterday < ADate then
    TWXException.Create('日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getupstreammsghour?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取消息分送分时数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].RefHour := J.I['ref_hour'];
      Result[I].MsgType := J.I['msg_type'];
      Result[I].MsgUser := J.I['msg_user'];
      Result[I].MsgCount := J.I['msg_count'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUpStreamMsgWeek(ADate: TDate): TArray<TUpStreamMsgWeek>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if Yesterday < ADate then
    TWXException.Create('日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getupstreammsgweek?access_token=%s', [WX_DOMAIN, AccessToken]);
    ADate := StartOfTheWeek(ADate);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取消息发送周数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].MsgType := J.I['msg_type'];
      Result[I].MsgUser := J.I['msg_user'];
      Result[I].MsgCount := J.I['msg_count'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUpStreamMsgMonth(AYear, AMonth: Word): TArray<TUpStreamMsgMonth>;
var
  ADate: TDate;
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getupstreammsgmonth?access_token=%s', [WX_DOMAIN, AccessToken]);
    ADate := EncodeDate(AYear, AMonth, 1);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取消息发送月数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].MsgType := J.I['msg_type'];
      Result[I].MsgUser := J.I['msg_user'];
      Result[I].MsgCount := J.I['msg_count'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUpStreamMsgDist(BeginDate, EndDate: TDate): TArray<TUpStreamMsgDist>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if 15-1 < DaysBetween(BeginDate, EndDate) then
    TWXException.Create('最大时间跨度不能大于15天');
  if Yesterday < EndDate then
    TWXException.Create('结束日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getupstreammsgdist?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', BeginDate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', EndDate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取消息发送分布数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].CountInterval := J.I['count_interval'];
      Result[I].MsgUser := J.I['msg_user'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUpStreamMsgDistWeek(ADate: TDate): TArray<TUpStreamMsgDistWeek>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if Yesterday < ADate then
    TWXException.Create('日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getupstreammsgdistweek?access_token=%s', [WX_DOMAIN, AccessToken]);
    ADate := StartOfTheWeek(ADate);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取消息发送分布周数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].CountInterval := J.I['count_interval'];
      Result[I].MsgUser := J.I['msg_user'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetUpStreamMsgDistMonth(AYear, AMonth: Word): TArray<TUpStreamMsgDistMonth>;
var
  ADate: TDate;
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getupstreammsgdistmonth?access_token=%s', [WX_DOMAIN, AccessToken]);
    ADate := EncodeDate(AYear, AMonth, 1);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取消息发送分布月数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].CountInterval := J.I['count_interval'];
      Result[I].MsgUser := J.I['msg_user'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetInterfaceSummary(BeginDate, EndDate: TDate): TArray<TInterfaceSummary>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if 30-1 < DaysBetween(BeginDate, EndDate) then
    TWXException.Create('最大时间跨度不能大于30天');
  if Yesterday < EndDate then
    TWXException.Create('结束日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getinterfacesummary?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', BeginDate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', EndDate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取接口分析数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].CallBack_count := J.I['callback_count'];
      Result[I].FailCount := J.I['fail_count'];
      Result[I].TotalTimeCost := J.I['total_time_cost'];
      Result[I].MaxTimeCost := J.I['max_time_cost'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

function TWxApp.GetInterfaceSummaryHour(ADate: TDate): TArray<TInterfaceSummaryHour>;
var
  Url: string;
  Response: IHTTPResponse;
  jo: TJSONObject;
  jo2: TJSONObject;
  I: Integer;
  J: TJSONObject;
begin
  if Yesterday < ADate then
    TWXException.Create('日期不能大于昨天');
  jo2 := nil;
  jo := TJSONObject.Create;
  try
    Url := Format('https://%s/datacube/getinterfacesummaryhour?access_token=%s', [WX_DOMAIN, AccessToken]);
    jo.S['begin_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    jo.S['end_date'] := FormatDateTime('yyyy-mm-dd', ADate);
    Response := HTTPClient.Make.Post(Url, jo.ToStream.Value);
    ParseResponseJsonError(Response, '获取接口分析分时数据');
    jo2 := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
    SetLength(Result, jo2.A['list'].Count);
    for I := 0 to jo2.A['list'].Count - 1 do begin
      J := jo2.A['list'][I];
      Result[I].RefDate := ISO8601ToDate(J.S['ref_date']);
      Result[I].RefHour := J.I['ref_hour'];
      Result[I].CallBackCount := J.I['callback_count'];
      Result[I].FailCount := J.I['fail_count'];
      Result[I].TotalTimeCost := J.I['total_time_cost'];
      Result[I].MaxTimeCost := J.I['max_time_cost'];
    end;
  finally
    jo.Free;
    jo2.Free;
  end;
end;

{ TWxWebAuthorize }

constructor TWxWebAuthorize.Create;
begin
  FLockObject := TObject.Create;
end;

constructor TWxWebAuthorize.Create(const AppId, Secret, Code: string);
var
  url: string;
begin
  Create;
  FAppId := AppId;
  url :=  Format('https://%s/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code',
    [WX_DOMAIN, AppId, Secret, Code]);
  DoHttp(url, '换取网页授权',
    procedure (Response: IHTTPResponse)
    var
      jo: TJSONObject;
    begin
      jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
      try
        FAccessToken := jo.S['access_token'];
        FRefreshToken := jo.S['refresh_token'];
        FOpenId := jo.S['openid'];
        FExpiresTime := IncSecond(Now, jo.I['expires_in']);
      finally
        jo.Free;
      end;
    end);
end;

destructor TWxWebAuthorize.Destroy;
begin
  FLockObject.Free;
  inherited;
end;

function TWxWebAuthorize.GetUserInfo: IWxUserInfo;
var
  url: string;
  UserInfo: IWxUserInfo;
begin
  Lock;
  try
    url :=  Format('https://%s/sns/userinfo?access_token=%s&openid=%s&lang=zh_CN',
      [WX_DOMAIN, FAccessToken, FOpenId]);
    DoHttp(url, '拉取用户信息',
      procedure (Response: IHTTPResponse)
      var
        jo: TJSONObject;
        ExpiresIn: Integer;
        I: Integer;
      begin
        jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
        if jo.S['sex'] = '1' then
          jo.S['sex'] := '男' else
        if jo.S['sex'] = '2' then
          jo.S['sex'] := '女'
        else
          jo.S['sex'] := '未知';
        UserInfo := TwxUserInfo.Create;
        TwxUserInfo(UserInfo).FJsonObject := jo;
      end);
    Result := UserInfo;
  finally
    Unlock;
  end;
end;

procedure TWxWebAuthorize.Refresh;
var
  url: string;
begin
  Lock;
  try
    url :=  Format('https://%s/sns/oauth2/refresh_token?appid=%s&grant_type=refresh_token&refresh_token=%s',
      [WX_DOMAIN, FAppId, FRefreshToken]);
    DoHttp(url, '刷新网页授权access_token',
      procedure (Response: IHTTPResponse)
      var
        jo: TJSONObject;
      begin
        jo := TJSONObject.ParseUtf8(Response.ContentAsString) as TJSONObject;
        try
          FAccessToken := jo.S['access_token'];
          FRefreshToken := jo.S['refresh_token'];
          FOpenId := jo.S['openid'];
          FExpiresTime := IncSecond(Now, jo.I['expires_in']);
        finally
          jo.Free;
        end;
      end);
  finally
    Unlock;
  end;
end;

procedure TWxWebAuthorize.DoHttp(const url, Description: string; Proc: TProc<IHTTPResponse>);
var
  Response: IHTTPResponse;
begin
  Response := WX.Utils.HTTPClient.Make.Get(url);
  ParseResponseJsonError(Response, Description);
  Proc(Response);
end;

procedure TWxWebAuthorize.Lock;
begin
  System.TMonitor.Enter(FLockObject);
end;

procedure TWxWebAuthorize.Unlock;
begin
  System.TMonitor.Exit(FLockObject);
end;

function TWxWebAuthorize.GetAccessToken: string;
begin
  Result := FAccessToken;
end;

function TWxWebAuthorize.GetAppId: string;
begin
  Result := FAppId;
end;

function TWxWebAuthorize.GetBase64: string;
var
  jo: TJsonObject;
begin
  jo := TJsonObject.Create;
  try
    jo.S['open_id'] := FOpenId;
    jo.S['access_token'] := AccessToken;
    jo.S['refresh_token'] := RefreshToken;
    jo.F['expires_time'] := ExpiresTime;
    Result := TURLEncoding.Base64.Encode(jo.ToJSON);
  finally
    jo.Free;
  end;
end;

function TWxWebAuthorize.GetExpiresTime: TDateTime;
begin
  Result := FExpiresTime;
end;

function TWxWebAuthorize.GetRefreshToken: string;
begin
  Result := FRefreshToken;
end;

{ TwxUserInfo }

destructor TwxUserInfo.Destroy;
begin
  FJsonObject.Free;
  inherited;
end;

function TwxUserInfo.GetAccessToken: string;
begin
  Result := FJsonObject.S['access_token'];
end;

function TwxUserInfo.GetCity: string;
begin
  Result := FJsonObject.S['city'];
end;

function TwxUserInfo.GetCountry: string;
begin
  Result := FJsonObject.S['country'];
end;

function TwxUserInfo.GetHeadImgUrl: string;
begin
  Result := FJsonObject.S['headimgurl'];
end;

function TwxUserInfo.GetNickName: string;
begin
  Result := FJsonObject.S['nickname'];
end;

function TwxUserInfo.GetOpenId: string;
begin
  Result := FJsonObject.S['openid'];
end;

function TwxUserInfo.GetPrivilege: TArray<string>;
var
  I: Integer;
  ja: TJsonArray;
begin
  ja := FJsonObject.A['privilege'];
  SetLength(Result, ja.Count);
  for I := 0 to ja.Count - 1 do
   Result[I] := ja.S[I];
end;

function TwxUserInfo.GetProvince: string;
begin
  Result := FJsonObject.S['province'];
end;

function TwxUserInfo.GetRefreshToken: string;
begin
  Result := FJsonObject.S['refresh_token'];
end;

function TwxUserInfo.GetSex: string;
begin
  Result := FJsonObject.S['sex'];
end;

function TwxUserInfo.GetUnionId: string;
begin
  Result := FJsonObject.S['unionid'];
end;

function TwxUserInfo.ToJSON: string;
begin
  Result := FJsonObject.ToJSON;
end;

{ TJsApiSignature }

constructor TWxJsApiSignature.Create(const NonceStr: string;
  Timestamp: TwxDateTime; const Signature, AppId: string);
begin
  FNonceStr := NonceStr;
  FTimestamp := Timestamp;
  FSignature := Signature;
  FAppId := AppId;
end;

function TWxJsApiSignature.GetAppId: string;
begin
  Result := FAppId;
end;

function TWxJsApiSignature.GetNonceStr: string;
begin
  Result := FNonceStr;
end;

function TWxJsApiSignature.GetSignature: string;
begin
  Result := FSignature;
end;

function TWxJsApiSignature.GetTimestamp: TwxDateTime;
begin
  Result := FTimestamp;
end;

function TWxJsApiSignature.ToString: string;
begin
  Result := Format('{"nonceStr":"%s", "timestamp":%d, "signature":"%s", "appId":"%s"}',
    [NonceStr, Timestamp, Signature, AppId])
end;

end.
