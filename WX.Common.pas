unit WX.Common;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom,
  Xml.XMLDoc, Xml.omnixmldom, Xml.XMLIntf, JsonDataObjects;

type
  TwxDateTime = Int64;

  TwxMsgType = (mtText, mtImage, mtVoice, mtVideo, mtShortVideo, mtLocation,
    mtLink, mtMusic, mtNews, mtEvent);

  TwxEventType = (etSubscribe, etUnsubscribe, etScan, etLocation, etClick,
    etView, etViewMiniProgram, etScancodePush, etScancodeWaitMsg, etPicSysPhoto,
    etPicPhotoOrAlbum, etPicWeiXin, etLocationSelect, etTemplateSendJobFinish);

  TwxMediaType = (Image, Voice, Video, Thumb, News);

  TwxSignType = (stMD5, stHMAC_SHA256);

  TwxTradeType = (
                    ttJSAPI,//JSAPI֧������С����֧������
                    ttNATIVE,//Native֧����
                    ttAPP,//app֧����
                    ttMICROPAY,//������֧��
                    ttMWEB//--H5֧��
  );

  TwxTradeState = (
                    tsSUCCESS,//֧���ɹ�
                    tsREFUND,//ת���˿�
                    tsNOTPAY,//δ֧��
                    tsCLOSED,//�ѹر�
                    tsREVOKED,//�ѳ�����������֧����
                    tsUSERPAYING,//�û�֧���У�������֧����
                    tsPAYERROR//֧��ʧ��(����ԭ�������з���ʧ��)
  );

  TwxPayResultCode = (prcSuccess, prcFail);

  TwxPayReturnCode = TwxPayResultCode;

  TwxBillType = (
                 btALL,//��Ĭ��ֵ�������ص������ж�����Ϣ��������ֵ�˿����
                 btSUCCESS,//���ص��ճɹ�֧���Ķ�����������ֵ�˿����
                 btREFUND,//���ص����˿����������ֵ�˿����
                 btRECHARGE_REFUND//���ص��ճ�ֵ�˿��
                );

  TwxAccountType = (
                    atBasic,// �����˻�
                    atOperation,//��Ӫ�˻�
                    atFees//�������˻�
                   );

  TMediaArticle = record
    Thumb_media_id: string;//	��	ͼ����Ϣ����ͼ��media_id�������ڻ���֧��-�ϴ���ý���ļ��ӿ��л��
    Author: string;//	��	ͼ����Ϣ������
    Title: string;//	��	ͼ����Ϣ�ı���
    ContentSourceUrl: string;//	��	��ͼ����Ϣҳ�������Ķ�ԭ�ġ����ҳ�棬�ܰ�ȫ���ƣ�������תAppstore������ʹ��itun.es��appsto.re�Ķ������񣬲��ڶ��������� #wechat_redirect ��׺��
    Content: string;//	��	ͼ����Ϣҳ������ݣ�֧��HTML��ǩ���߱�΢��֧��Ȩ�޵Ĺ��ںţ�����ʹ��a��ǩ���������ںŲ���ʹ�ã��������С����Ƭ���ɲο����ġ�
    Digest: string;//	��	ͼ����Ϣ���������籾�ֶ�Ϊ�գ���Ĭ��ץȡ����ǰ64����
    ShowCoverPic: Boolean;//	��	�Ƿ���ʾ���棬1Ϊ��ʾ��0Ϊ����ʾ
    NeedOpenComment: Boolean;//	��	Uint32 �Ƿ�����ۣ�0���򿪣�1��
    OnlyFansCanComment: Boolean;//	��	Uint32 �Ƿ��˿�ſ����ۣ�0�����˿����ۣ�1��˿�ſ�����
  end;

  TwxCreateSceneQRCodeResult = record
    Ticket: string;
    ExpireSeconds: Integer;
    Url: string;
    function ToString: string;
  end;

  TUserSummary = record
    RefDate: TDate;
    UserSource: Integer;
    NewUser: Integer;
    CancelUser: Integer;
    AddUser: Integer;
  end;

  TUserCumulate = record
    RefDate: TDate;
    CumulateUser: Integer;
  end;

  TArticleSummary = record
    RefDate: TDate;
    msgId: string;
    Title: string;
    IntPageReadUser: Integer;
    IntPageReadCount: Integer;
    OriPageReadUser: Integer;
    OriPageReadCount: Integer;
    ShareUser: Integer;
    ShareCount: Integer;
    AddToFavUser: Integer;
    AddToFavCount: Integer;
  end;

  TArticleTotal = record
  public type
    TDetail = record
      StatDate: TDate;
      TargetUser: Integer;
      IntPageReadUser: Integer;
      IntPageReadCount: Integer;
      OriPageReadUser: Integer;
      OriPageReadCount: Integer;
      ShareUser: Integer;
      ShareCount: Integer;
      AddToFavUser: Integer;
      AddToFavCount: Integer;
      IntPageFromSessionReadUser: Integer;
      IntPageFromSessionReadCount: Integer;
      IntPageFromHistMsgReadUser: Integer;
      IntPageFromHistMsgReadCount: Integer;
      IntPageFromFeedReadUser: Integer;
      IntPageFromFeedReadCount: Integer;
      IntPageFromFriendsReadUser: Integer;
      IntPageFromFriendsReadCount: Integer;
      IntPageFromOtherReadUser: Integer;
      IntPageFromOtherReadCount: Integer;
      FeedShareFromSessionUser: Integer;
      FeedShareFromSessionCount: Integer;
      FeedShareFromFeedUser: Integer;
      FeedShareFromFeedCount: Integer;
      FeedShareFromOtherUser: Integer;
      FeedShareFromOtherCount: Integer;
    end;
  public
    RefDate: TDate;
    msgId: string;
    Title: string;
    Details: TArray<TDetail>;
  end;

  TUserRead = record
    RefDate: TDate;
    IntPageReadUser: Integer;
    IntPageReadCount: Integer;
    OriPageReadUser: Integer;
    OriPageReadCount: Integer;
    ShareUser: Integer;
    ShareCount: Integer;
    AddToFavUser: Integer;
    AddToFavCount: Integer;
  end;

  TUserReadHour = record
    RefDate: TDate;
    RefHour: Integer;
    UserSource: Integer;
    IntPageReadUser: Integer;
    IntPageReadCount: Integer;
    OriPageReadUser: Integer;
    OriPageReadCount: Integer;
    ShareUser: Integer;
    ShareCount: Integer;
    AddToFavUser: Integer;
    AddToFavCount: Integer;
  end;

  TUserShare = record
    RefDate: TDate;
    ShareScene: Integer;
    ShareCount: Integer;
    ShareUser: Integer;
  end;

  TUserShareHour = record
    RefDate: TDate;
    RefHour: Integer;
    ShareScene: Integer;
    ShareCount: Integer;
    ShareUser: Integer;
  end;

  TUpStreamMsg = record
    RefDate: TDate;
    MsgType: Integer;
    MsgUser: Integer;
    MsgCount: Integer;
  end;

  TUpStreamMsgHour  = record
    RefDate: TDate;
    RefHour: Integer;
    MsgType: Integer;
    MsgUser: Integer;
    MsgCount: Integer;
  end;

  TUpStreamMsgWeek = type TUpStreamMsg;
  TUpStreamMsgMonth = type TUpStreamMsg;

  TUpStreamMsgDist = record
    RefDate: TDate;
    CountInterval: Integer;
    MsgUser: Integer;
  end;

  TUpStreamMsgDistWeek = type TUpStreamMsgDist;
  TUpStreamMsgDistMonth = type TUpStreamMsgDist;

  TInterfaceSummary = record
    RefDate: TDate;
    CallBack_count: Integer;
    FailCount: Integer;
    TotalTimeCost: Integer;
    MaxTimeCost: Integer;
  end;

  TInterfaceSummaryHour = record
    RefDate: TDate;
    RefHour: Integer;
    CallBackCount: Integer;
    FailCount: Integer;
    TotalTimeCost: Integer;
    MaxTimeCost: Integer;
  end;

  IwxUserInfo = interface;
  IWxWebAuthorize = interface;
  IWxJsApiSignature = interface;

  IWxApp = interface
  ['{102D4AF0-A348-4E4E-A262-7EB8D5786958}']
    {security}
    function GetAccessToken: string;
    function GetJsApiTicket: string;
    property AccessToken: string read GetAccessToken;
    property JsApiTicket: string read GetJsApiTicket;
    function GetJsApiSignature(const Url: string): IWxJsApiSignature;
    function WebAuthorize(const Code: string): IWxWebAuthorize;
    function WebAuthorizeFromBase64(const Base64: string): IWxWebAuthorize;

    {IP}
    function GetCallBackIP: TArray<string>;
    function GetApiDomainIP: TArray<string>;
    function CallbackCheck: TJSONObject;

	  {Menu}
    procedure CreateMenu(MenuJson: TJSONObject);
    procedure DeleteMenu;
	  function GetMenuInfo: TJSONObject;

    {KFAccount}
    procedure AddKFAccount(const KFAccount, NickName, Password: string);
    procedure UpdateKFAccount(const KFAccount, NickName, Password: string);
    procedure DelKFAccount(const KFAccount, NickName, Password: string);
    procedure UploadKFAccountHeadImg(const KFAccount, ImgFile: string);
    procedure InviteWorker(const KFAccount, InviteWx: string);
    function GetKFAccountList: TJSONObject;

	  {Custom Message}
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

	  {template}
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
  end;

  IWxWebAuthorize = interface
  ['{0D62C798-5B61-4B73-B915-83F300D23F50}']
    function GetUserInfo: IwxUserInfo;
    function GetAppId: string;
    function GetAccessToken: string;
    function GetRefreshToken: string;
    function GetExpiresTime: TDateTime;
    procedure Refresh;
    function GetBase64: string;
    property UserInfo: IwxUserInfo read GetUserInfo;
    property AppId: string read GetAppId;
    property AccessToken: string read GetAccessToken;
    property RefreshToken: string read GetRefreshToken;
    property ExpiresTime: TDateTime read GetExpiresTime;
  end;

  IwxUserInfo = interface
  ['{9BF5A9E1-E155-4FC7-950C-D06CFE2E5FFD}']
    function GetOpenId: string;
    function GetNickName: string;
    function GetSex: string;
    function GetProvince: string;
    function GetCity: string;
    function GetCountry: string;
    function GetHeadImgUrl: string;
    function GetPrivilege: TArray<string> ;
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
  end;

  IWxJsApiSignature = interface
  ['{3B9D725C-1EE7-45A1-B76D-E190794F4690}']
    function GetNonceStr: string;
    function GetTimestamp: TwxDateTime;
    function GetSignature: string;
    function GetAppId: string;
    property NonceStr: string read GetNonceStr;
    property Timestamp: TwxDateTime read GetTimestamp;
    property Signature: string read GetSignature;
    property AppId: string read GetAppId;
    function ToString: string;
  end;

  ITokenCacher = interface
  ['{0EDD75CD-3E1D-4B51-AEE1-301B61D80D38}']
    function GetAccessToken(const AppId, Secret: string): string;
    function GetJsApiTicket(const AppId, Secret: string): string;
  end;

  IwxXML = interface
  ['{FCD281E5-DC53-4BCF-8951-3CD63A9CE251}']
    function GetXML: string;
    property XML: string read GetXML;
  end;

  TwxXML = class(TInterfacedObject, IwxXML)
  private
    FXMLDocument: IXMLDocument;
    function GetXML: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); virtual; abstract;
    procedure DoInitFromXML(RootNode: IXMLNode); virtual; abstract;
    procedure AddCDATA(RootNode: IXMLNode; const TagName: DOMString; const Data: string);
    property XMLDocument: IXMLDocument read FXMLDocument;
  public
    constructor Create; overload; virtual;
    constructor Create(const XML: string); overload; virtual;
    destructor Destroy; override;
    function ToString: string; override;
    property XML: string read GetXML;
  end;

  IwxMsg = interface(IwxXML)
  ['{9078FCC6-6698-484E-8636-15C2E8A149BF}']
    function GetToUserName: string;
    procedure SetToUserName(const Value: string);
    function GetFromUserName: string;
    procedure SetFromUserName(const Value: string);
    function GetCreateTime: TDateTime;
    procedure SetCreateTime(const Value: TDateTime);
    function GetMsgType: TwxMsgType;
    procedure SetMsgType(const Value: TwxMsgType);
    property ToUserName: string read GetToUserName write SetToUserName;
    property FromUserName: string read GetFromUserName write SetFromUserName;
    property CreateTime: TDateTime read GetCreateTime write SetCreateTime;
    property MsgType: TwxMsgType read GetMsgType write SetMsgType;
  end;

  TwxBaseMsg = class(TwxXML, IwxMsg)
  private
    FToUserName: string;
    FFromUserName: string;
    FCreateTime: TDateTime;
    FMsgType: TwxMsgType;
    FXMLDocument: IXMLDocument;
    function GetToUserName: string;
    procedure SetToUserName(const Value: string);
    function GetFromUserName: string;
    procedure SetFromUserName(const Value: string);
    function GetCreateTime: TDateTime;
    procedure SetCreateTime(const Value: TDateTime);
    function GetMsgType: TwxMsgType;
    procedure SetMsgType(const Value: TwxMsgType);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property ToUserName: string read GetToUserName write SetToUserName;
    property FromUserName: string read GetFromUserName write SetFromUserName;
    property CreateTime: TDateTime read GetCreateTime write SetCreateTime;
    property MsgType: TwxMsgType read GetMsgType write SetMsgType;
  end;

  IwxXMLPayRequest = interface(IwxXML)
  ['{34803DEE-707B-4D04-8445-2BE92DFE8675}']
    function GetAppId: string;
    procedure SetAppId(const Value: string);
    function GetMchId: string;
    procedure SetMchId(const Value: string);
    function GetSignType: TwxSignType;
    procedure SetSignType(Value: TwxSignType);
    function GetNonceStr: string;
    procedure SetNonceStr(const Value: string);
    function XMLWithSign(const Key: string; SignType: TwxSignType): string;
    property AppId: string read GetAppId write SetAppId;
    property MchId: string read GetMchId write SetMchId;
    property SignType: TwxSignType read GetSignType write SetSignType;
    property NonceStr: string read GetNonceStr write SetNonceStr;
  end;

  TwxXMLPayRequest = class(TwxXML, IwxXMLPayRequest)
  private
    FAppId: string;
    FMchId: string;
    FSignType: TwxSignType;
    FNonceStr: string;
    function GetAppId: string;
    procedure SetAppId(const Value: string);
    function GetMchId: string;
    procedure SetMchId(const Value: string);
    function GetSignType: TwxSignType;
    procedure SetSignType(Value: TwxSignType);
    function GetNonceStr: string;
    procedure SetNonceStr(const Value: string);
    function XMLWithSign(const Key: string; SignType: TwxSignType): string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    property AppId: string read GetAppId write SetAppId;
    property MchId: string read GetMchId write SetMchId;
    property SignType: TwxSignType read GetSignType write SetSignType;
    property NonceStr: string read GetNonceStr write SetNonceStr;
  end;

  IwxXMLPayReponse = interface(IwxXML)
  ['{0CD63DA8-E52C-44C1-AA86-EB01449B5398}']
    function GetReturnCode: TwxPayReturnCode;
    function GetReturnMsg: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetSign: string;
    function GetErrCode: string;
    function GetErrCodeDes: string;
    function GetResultCode: TwxPayResultCode;
    procedure RaiseExceptionIfReturnFail;
    property ReturnCode: TwxPayReturnCode read GetReturnCode;
    property ReturnMsg: string read GetReturnMsg;
    property AppId: string read GetAppId;
    property MchId: string read GetMchId;
    property NonceStr: string read GetNonceStr;
    property Sign: string read GetSign;
    property ResultCode: TwxPayResultCode read GetResultCode;
    property ErrCode: string read GetErrCode;
    property ErrCodeDes: string read GetErrCodeDes;
  end;

  TwxXMLPayReponse = class(TwxXML, IwxXMLPayReponse)
  private
    FReturnCode: TwxPayReturnCode;
    FReturnMsg: string;
    FAppId: string;
    FMchId: string;
    FNonceStr: string;
    FSign: string;
    FErrCode: string;
    FErrCodeDes: string;
    FResultCode: TwxPayResultCode;
    function GetReturnCode: TwxPayReturnCode;
    function GetReturnMsg: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetSign: string;
    function GetErrCode: string;
    function GetErrCodeDes: string;
    function GetResultCode: TwxPayResultCode;
  protected
    procedure DoInitFromXML(RootNode: IXMLNode); override;
    procedure DoInitFromXMLOther(RootNode: IXMLNode); virtual;
  public
    procedure RaiseExceptionIfReturnFail;
    property ReturnCode: TwxPayReturnCode read GetReturnCode;
    property ReturnMsg: string read GetReturnMsg;
    property AppId: string read GetAppId;
    property MchId: string read GetMchId;
    property NonceStr: string read GetNonceStr;
    property Sign: string read GetSign;
    property ResultCode: TwxPayResultCode read GetResultCode;
    property ErrCode: string read GetErrCode;
    property ErrCodeDes: string read GetErrCodeDes;
  end;

const
  BOOL_INT: array[Boolean] of Integer = (0, 1);
  WX_DOMAIN = 'api.weixin.qq.com';

var
  WX_SDK_VERSION: string;//Format('Delphi/%.1f WXSDK/1.0.0', [System.CompilerVersion]);
  WX_PAYSDK_VERSION: string;//Format('Delphi/%.1f WXPaySDK/1.0.0', [System.CompilerVersion]);
  
implementation

uses
  WX.Utils;

{ TwxXML }

constructor TwxXML.Create;
var
  Doc: TXMLDocument;
begin
  inherited;
  Doc := TXMLDocument.Create(nil);
  Doc.DOMVendor := GetDOMVendor(sOmniXmlVendor);
  Doc.Active := True;
  FXMLDocument := Doc;
end;

constructor TwxXML.Create(const XML: string);
var
  RootNode: IXMLNode;
begin
  Create;
  XMLDocument.LoadFromXML(XML);
  DoInitFromXML(XMLDocument.DocumentElement);
end;

destructor TwxXML.Destroy;
begin
  FXMLDocument := nil;
  inherited;
end;

function TwxXML.GetXML: string;
var
  RootNode: IXMLNode;
begin
  RootNode := XMLDocument.DocumentElement;
  if RootNode = nil then
    RootNode := XMLDocument.AddChild('xml');
  DoBuildXML(RootNode);
  Result := XMLDocument.XML.Text;
end;

function TwxXML.ToString: string;
begin
  Result := XML;
end;

procedure TwxXML.AddCDATA(RootNode: IXMLNode; const TagName: DOMString; const Data: string);
var
  N: IXMLNode;
  cd: IXMLNode;
begin
  cd := XMLDocument.CreateNode(Data, ntCData);
  N := RootNode.ChildNodes.FindNode(TagName);
  if N = nil then
    N := RootNode.AddChild(TagName)
  else
    N.ChildNodes.Clear;
  N.ChildNodes.Add(cd);
end;

{ TwxBaseMsg }

function TwxBaseMsg.GetCreateTime: TDateTime;
begin
  Result := FCreateTime;
end;

function TwxBaseMsg.GetFromUserName: string;
begin
  Result := FFromUserName;
end;

function TwxBaseMsg.GetMsgType: TwxMsgType;
begin
  Result := FMsgType;
end;

function TwxBaseMsg.GetToUserName: string;
begin
  Result := FToUserName;
end;

procedure TwxBaseMsg.SetCreateTime(const Value: TDateTime);
begin
  if FCreateTime <> Value then
    FCreateTime := Value;
end;

procedure TwxBaseMsg.SetFromUserName(const Value: string);
begin
  if FFromUserName <> Value then
    FFromUserName := Value;
end;

procedure TwxBaseMsg.SetMsgType(const Value: TwxMsgType);
begin
  if FMsgType <> Value then
    FMsgType := Value;
end;

procedure TwxBaseMsg.SetToUserName(const Value: string);
begin
  if FToUserName <> Value then
    FToUserName := Value;
end;

procedure TwxBaseMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'ToUserName', ToUserName);
  AddCDATA(RootNode, 'FromUserName', FromUserName);
  RootNode.ChildValues['CreateTime'] := TWxHelper.DateTimeToWxTime(CreateTime).ToString;
  AddCDATA(RootNode, 'MsgType', MsgType.ToString);
end;

procedure TwxBaseMsg.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  ToUserName   :=   RootNode.ChildValues['ToUserName'];
  FromUserName := RootNode.ChildValues['FromUserName'];
  CreateTime   := TWxHelper.WxTimeToDateTime(RootNode.ChildValues['CreateTime']);
  MsgType      := TwxMsgType.ParseStr(RootNode.ChildValues['MsgType']);
end;

{ TwxCreateSceneQRCodeResult }

function TwxCreateSceneQRCodeResult.ToString: string;
begin
  Result := Format('{"ticket":"%s", "expire_seconds":%d, "url":"%s"}',
    [Ticket, ExpireSeconds, Url]);
end;

{ TwxXMLPayRequest }

constructor TwxXMLPayRequest.Create;
begin
  inherited;
  FSignType := stMD5;
  FNonceStr := TWxHelper.GenNonceStr;
end;

function TwxXMLPayRequest.XMLWithSign(const Key: string; SignType: TwxSignType): string;

  function GetXMLDoc: IXMLDocument;
  var
    Doc: TXMLDocument;
  begin
    inherited;
    Doc := TXMLDocument.Create(nil);
    Doc.DOMVendor := GetDOMVendor(sOmniXmlVendor);
    Doc.Active := True;
    Doc.LoadFromXML(XML);
    Result := Doc;
  end;

var
  XMLDocument: IXMLDocument;
  Sign: string;
begin
  XMLDocument := GetXMLDoc;
  Sign := TWxHelper.GetSign(XMLDocument, Key, SignType);
  XMLDocument.DocumentElement.ChildValues['sign'] := Sign;
  Result := XMLDocument.XML.Text;
end;

procedure TwxXMLPayRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'appid', AppId);
  AddCDATA(RootNode, 'mch_id', MchId);
  AddCDATA(RootNode, 'sign_type', SignType.ToString);
  AddCDATA(RootNode, 'nonce_str', NonceStr);
end;

function TwxXMLPayRequest.GetAppId: string;
begin
  Result := FAppId;
end;

function TwxXMLPayRequest.GetMchId: string;
begin
  Result := FMchId;
end;

function TwxXMLPayRequest.GetNonceStr: string;
begin
  Result := FNonceStr;
end;

function TwxXMLPayRequest.GetSignType: TwxSignType;
begin
  Result := FSignType;
end;

procedure TwxXMLPayRequest.SetAppId(const Value: string);
begin
  FAppId := Value;
end;

procedure TwxXMLPayRequest.SetMchId(const Value: string);
begin
  FMchId := Value;
end;

procedure TwxXMLPayRequest.SetNonceStr(const Value: string);
begin
  FNonceStr := Value;
end;

procedure TwxXMLPayRequest.SetSignType(Value: TwxSignType);
begin
  FSignType := Value;
end;

{ TwxXMLSignReponse }

procedure TwxXMLPayReponse.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  FReturnCode := TwxPayReturnCode.ParseStr(VarToStr(RootNode.ChildValues['return_code']));
  FReturnMsg  := VarToStr(RootNode.ChildValues['return_msg']);
  if FReturnCode = prcSuccess then
    DoInitFromXMLOther(RootNode);
end;

procedure TwxXMLPayReponse.DoInitFromXMLOther(RootNode: IXMLNode);
begin
  FAppId      := RootNode.ChildValues['appid'];
  FMchId      := RootNode.ChildValues['mch_id'];
  FNonceStr   := RootNode.ChildValues['nonce_str'];
  FSign       := RootNode.ChildValues['sign'];
  FResultCode := TwxPayResultCode.ParseStr(VarToStr(RootNode.ChildValues['result_code']));
  FErrCode    := VarToStr(RootNode.ChildValues['err_code']);
  FErrCodeDes := VarToStr(RootNode.ChildValues['err_code_des']);
end;

function TwxXMLPayReponse.GetAppId: string;
begin
  Result := FAppId;
end;

function TwxXMLPayReponse.GetErrCode: string;
begin
  Result := FErrCode;
end;

function TwxXMLPayReponse.GetErrCodeDes: string;
begin
  Result := FErrCodeDes;
end;

function TwxXMLPayReponse.GetMchId: string;
begin
  Result := FMchId;
end;

function TwxXMLPayReponse.GetNonceStr: string;
begin
  Result := FNonceStr;
end;

function TwxXMLPayReponse.GetResultCode: TwxPayResultCode;
begin
  Result := FResultCode;
end;

function TwxXMLPayReponse.GetReturnCode: TwxPayReturnCode;
begin
  Result := FReturnCode;
end;

function TwxXMLPayReponse.GetReturnMsg: string;
begin
  Result := FReturnMsg;
end;

function TwxXMLPayReponse.GetSign: string;
begin
  Result := FSign;
end;

procedure TwxXMLPayReponse.RaiseExceptionIfReturnFail;
begin
  if ReturnCode = prcFail then
    raise Exception.Create(ReturnMsg);
end;

initialization
  WX_SDK_VERSION := Format('%s Delphi/%.1f WXSDK/1.0.0',
    [TOSVersion.ToString, System.CompilerVersion]);
  WX_PAYSDK_VERSION := Format('%s Delphi/%.1f WXPaySDK/1.0.0',
    [TOSVersion.ToString, System.CompilerVersion]);

end.
