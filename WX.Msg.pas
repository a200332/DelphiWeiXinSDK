unit WX.Msg;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom,
  Xml.omnixmldom, Xml.XMLIntf, WX.Common;

type
  IwxRecvBaseMsg = interface(IwxMsg)
  ['{A72B356F-3FFD-4176-9C14-1F6F039A2A86}']
    function GetMsgId: Int64;
    procedure SetMsgId(const Value: Int64);
    property MsgId: Int64 read GetMsgId write SetMsgId;
  end;

  TwxRecvBaseMsg = class(TwxBaseMsg, IwxRecvBaseMsg)
  private
    FMsgId: Int64;
    function GetMsgId: Int64;
    procedure SetMsgId(const Value: Int64);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property MsgId: Int64 read GetMsgId write SetMsgId;
  end;

  IwxRecvTextMsg = interface(IwxRecvBaseMsg)
  ['{B1634495-A782-4BED-8233-5BFEAF2A084C}']
    procedure SetContent(const Value: string);
    function GetContent: string;
    property Content: string read GetContent write SetContent;
  end;

  TwxRecvTextMsg = class(TwxRecvBaseMsg, IwxRecvTextMsg)
  private
    FContent: string;
    procedure SetContent(const Value: string);
    function GetContent: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property Content: string read GetContent write SetContent;
  end;

  IwxRecvPicMsg = interface(IwxRecvBaseMsg)
  ['{AC284CB4-1D05-4ED3-91B7-9BDCA8694A74}']
    procedure SetMediaId(const Value: Int64);
    procedure SetPicUrl(const Value: string);
    function GetMediaId: Int64;
    function GetPicUrl: string;
    property PicUrl: string read GetPicUrl write SetPicUrl;
    property MediaId: Int64 read GetMediaId write SetMediaId;
  end;

  TwxRecvPicMsg = class(TwxRecvBaseMsg, IwxRecvPicMsg)
  private
    FPicUrl: string;
    FMediaId: Int64;
    procedure SetMediaId(const Value: Int64);
    procedure SetPicUrl(const Value: string);
    function GetMediaId: Int64;
    function GetPicUrl: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property PicUrl: string read GetPicUrl write SetPicUrl;
    property MediaId: Int64 read GetMediaId write SetMediaId;
  end;

  IwxRecvVoiceMsg = interface(IwxRecvBaseMsg)
  ['{AC284CB4-1D05-4ED3-91B7-9BDCA8694A74}']
    procedure SetMediaId(const Value: Int64);
    procedure SetFormat(const Value: string);
    procedure SetRecognition(const Value: string);
    function GetFormat: string;
    function GetMediaId: Int64;
    function GetRecognition: string;
    property Format: string read GetFormat write SetFormat;
    property MediaId: Int64 read GetMediaId write SetMediaId;
    property Recognition: string read GetRecognition write SetRecognition;
  end;

  TwxRecvVoiceMsg = class(TwxRecvBaseMsg, IwxRecvVoiceMsg)
  private
    FFormat: string;
    FMediaId: Int64;
    FRecognition: string;
    procedure SetMediaId(const Value: Int64);
    procedure SetFormat(const Value: string);
    procedure SetRecognition(const Value: string);
    function GetFormat: string;
    function GetMediaId: Int64;
    function GetRecognition: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property Format: string read GetFormat write SetFormat;
    property MediaId: Int64 read GetMediaId write SetMediaId;
    property Recognition: string read GetRecognition write SetRecognition;
  end;

  IwxRecvVideoMsg = interface(IwxRecvBaseMsg)
  ['{F9AD2A85-D63B-4A89-95CA-3365344866D1}']
    procedure SetMediaId(const Value: Int64);
    procedure SetThumbMediaId(const Value: Int64);
    function GetMediaId: Int64;
    function GetThumbMediaId: Int64;
    property MediaId: Int64 read GetMediaId write SetMediaId;
    property ThumbMediaId: Int64 read GetThumbMediaId write SetThumbMediaId;
  end;

  TwxRecvVideoMsg = class(TwxRecvBaseMsg, IwxRecvVideoMsg)
  private
    FMediaId: Int64;
    FThumbMediaId: Int64;
    procedure SetMediaId(const Value: Int64);
    procedure SetThumbMediaId(const Value: Int64);
    function GetMediaId: Int64;
    function GetThumbMediaId: Int64;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property MediaId: Int64 read GetMediaId write SetMediaId;
    property ThumbMediaId: Int64 read GetThumbMediaId write SetThumbMediaId;
  end;

  TwxRecvShortVideoMsg = class(TwxRecvVideoMsg)
  end;

  IwxRecvLocationMsg = interface(IwxRecvBaseMsg)
  ['{163C4F0A-4655-4562-BA5C-4B0454B2FD7C}']
    procedure Set_Label(const Value: string);
    procedure SetLocationX(const Value: Double);
    procedure SetLocationY(const Value: Double);
    procedure SetScale(const Value: Double);
    function Get_Label: string;
    function GetLocationX: Double;
    function GetLocationY: Double;
    function GetScale: Double;
    property LocationX: Double read GetLocationX write SetLocationX;
    property LocationY: Double read GetLocationY write SetLocationY;
    property Scale: Double read GetScale write SetScale;
    property _Label: string read Get_Label write Set_Label;
  end;

  TwxRecvLocationMsg = class(TwxRecvBaseMsg, IwxRecvLocationMsg)
  private
    FLocationX: Double;
    FLocationY: Double;
    F_Label: string;
    FScale: Double;
    procedure Set_Label(const Value: string);
    procedure SetLocationX(const Value: Double);
    procedure SetLocationY(const Value: Double);
    procedure SetScale(const Value: Double);
    function Get_Label: string;
    function GetLocationX: Double;
    function GetLocationY: Double;
    function GetScale: Double;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property LocationX: Double read GetLocationX write SetLocationX;
    property LocationY: Double read GetLocationY write SetLocationY;
    property Scale: Double read GetScale write SetScale;
    property _Label: string read Get_Label write Set_Label;
  end;

  IwxRecvLinkMsg = interface(IwxRecvBaseMsg)
  ['{A137A88A-00D0-471E-9BBC-9C955F886322}']
    procedure SetDescription(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetUrl(const Value: string);
    function GetDescription: string;
    function GetTitle: string;
    function GetUrl: string;
    property Title: string read GetTitle write SetTitle;
    property Description: string read GetDescription write SetDescription;
    property Url: string read GetUrl write SetUrl;
  end;

  TwxRecvLinkMsg = class(TwxRecvBaseMsg, IwxRecvLinkMsg)
  private
    FTitle: string;
    FDescription: string;
    FUrl: string;
    procedure SetDescription(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetUrl(const Value: string);
    function GetDescription: string;
    function GetTitle: string;
    function GetUrl: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property Title: string read GetTitle write SetTitle;
    property Description: string read GetDescription write SetDescription;
    property Url: string read GetUrl write SetUrl;
  end;

  TwxReplyBaseMsg = class(TwxBaseMsg)
  public
    constructor Create; override;
  end;

  IwxReplyTextMsg = interface(IwxMsg)
  ['{B1843F63-A427-43EE-AA52-DCE92C90CA86}']
    procedure SetContent(const Value: string);
    function GetContent: string;
    procedure SetFuncFlag(const Value: Boolean);
    function GetFuncFlag: Boolean;
    property Content: string read GetContent write SetContent;
    property FuncFlag: Boolean read GetFuncFlag write SetFuncFlag;
  end;

  TwxReplyTextMsg = class(TwxReplyBaseMsg, IwxReplyTextMsg)
  private
    FFuncFlag: Boolean;
    FContent: string;
    procedure SetContent(const Value: string);
    function GetContent: string;
    procedure SetFuncFlag(const Value: Boolean);
    function GetFuncFlag: Boolean;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    property Content: string read GetContent write SetContent;
    property FuncFlag: Boolean read GetFuncFlag write SetFuncFlag;
  end;

  IwxReplyPicMsg = interface(IwxMsg)
  ['{43EFAB3A-F087-45A5-8E12-16DF708F4DE9}']
    procedure SetMediaId(const Value: string);
    function GetMediaId: string;
    property MediaId: string read GetMediaId write SetMediaId;
  end;

  TwxReplyPicMsg = class(TwxReplyBaseMsg, IwxReplyPicMsg)
  private
    FMediaId: string;
    procedure SetMediaId(const Value: string);
    function GetMediaId: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    property MediaId: string read GetMediaId write SetMediaId;
  end;

  IwxReplyVoiceMsg = interface(IwxMsg)
  ['{03157244-14FC-415A-8B61-153EDAACDFAD}']
    procedure SetMediaId(const Value: string);
    function GetMediaId: string;
    property MediaId: string read GetMediaId write SetMediaId;
  end;

  TwxReplyVoiceMsg = class(TwxReplyBaseMsg, IwxReplyVoiceMsg)
  private
    FMediaId: string;
    procedure SetMediaId(const Value: string);
    function GetMediaId: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    property MediaId: string read GetMediaId write SetMediaId;
  end;

  IwxReplyVideoMsg = interface(IwxMsg)
  ['{920654C2-520F-44C9-8738-114DF6307052}']
    procedure SetMediaId(const Value: string);
    function GetMediaId: string;
    procedure SetDescription(const Value: string);
    procedure SetTitle(const Value: string);
    function GetDescription: string;
    function GetTitle: string;
    property MediaId: string read GetMediaId write SetMediaId;
    property Title: string read GetTitle write SetTitle;
    property Description: string read GetDescription write SetDescription;
  end;

  TwxReplyVideoMsg = class(TwxReplyBaseMsg, IwxReplyVideoMsg)
  private
    FMediaId: string;
    FTitle: string;
    FDescription: string;
    procedure SetMediaId(const Value: string);
    function GetMediaId: string;
    procedure SetDescription(const Value: string);
    procedure SetTitle(const Value: string);
    function GetDescription: string;
    function GetTitle: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    property MediaId: string read GetMediaId write SetMediaId;
    property Title: string read GetTitle write SetTitle;
    property Description: string read GetDescription write SetDescription;
  end;

  IwxReplyMusicMsg = interface(IwxMsg)
  ['{89304423-702B-4A9B-B6F7-72D35089B889}']
    procedure SetDescription(const Value: string);
    procedure SetTitle(const Value: string);
    function GetDescription: string;
    function GetTitle: string;
    procedure SetHQMusicUrl(const Value: string);
    procedure SetMusicURL(const Value: string);
    procedure SetThumbMediaId(const Value: string);
    function GetHQMusicUrl: string;
    function GetMusicURL: string;
    function GetThumbMediaId: string;
    property Title: string read GetTitle write SetTitle;
    property Description: string read GetDescription write SetDescription;
    property MusicURL: string read GetMusicURL write SetMusicURL;
    property HQMusicUrl: string read GetHQMusicUrl write SetHQMusicUrl;
    property ThumbMediaId: string read GetThumbMediaId write SetThumbMediaId;
  end;

  TwxReplyMusicMsg = class(TwxReplyBaseMsg, IwxReplyMusicMsg)
  private
    FTitle: string;
    FDescription: string;
    FMusicURL: string;
    FThumbMediaId: string;
    FHQMusicUrl: string;
    procedure SetDescription(const Value: string);
    procedure SetTitle(const Value: string);
    function GetDescription: string;
    function GetTitle: string;
    procedure SetHQMusicUrl(const Value: string);
    procedure SetMusicURL(const Value: string);
    procedure SetThumbMediaId(const Value: string);
    function GetHQMusicUrl: string;
    function GetMusicURL: string;
    function GetThumbMediaId: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    property Title: string read GetTitle write SetTitle;
    property Description: string read GetDescription write SetDescription;
    property MusicURL: string read GetMusicURL write SetMusicURL;
    property HQMusicUrl: string read GetHQMusicUrl write SetHQMusicUrl;
    property ThumbMediaId: string read GetThumbMediaId write SetThumbMediaId;
  end;

  IwxReplyNewsMsg = interface(IwxMsg)
  ['{CC050260-8A38-4985-8C62-F59221C59030}']
  end;

  TwxArticle = class(TCollectionItem)
  private
    FTitle: string;
    FDescription: string;
    FUrl: string;
    FPicUrl: string;
    procedure SetDescription(const Value: string);
    procedure SetPicUrl(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetUrl(const Value: string);
  public
    constructor Create(Collection: TCollection; const Title, Description, PicUrl, Url: string);
    property Title: string read FTitle write SetTitle;
    property Description: string read FDescription write SetDescription;
    property PicUrl: string read FPicUrl write SetPicUrl;
    property Url: string read FUrl write SetUrl;
  end;

  TwxArticles = class(TCollection)
  private
    function GetItem(Index: Integer): TwxArticle;
    procedure SetItem(Index: Integer; const Value: TwxArticle);
  public
    function Add(const Title, Description, PicUrl, Url: string): TwxArticle;
    property Items[Index: Integer]: TwxArticle read GetItem write SetItem; default;
  end;

  TwxReplyNewsMsg = class(TwxReplyBaseMsg, IwxReplyNewsMsg)
  private
    FArticles: TwxArticles;
    function GetArticleCount: Integer;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property ArticleCount: Integer read GetArticleCount;
    property Articles: TwxArticles read FArticles;
  end;

implementation

uses WX.Utils;

{ TwxRecvBaseMsg }

procedure TwxRecvBaseMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  RootNode.ChildValues['MsgId'] := MsgId;
end;

procedure TwxRecvBaseMsg.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  MsgId := TWxHelper.VarToInt(RootNode.ChildValues['MsgId']);
end;

function TwxRecvBaseMsg.GetMsgId: Int64;
begin
  Result := FMsgId;
end;

procedure TwxRecvBaseMsg.SetMsgId(const Value: Int64);
begin
  FMsgId := Value;
end;

{ TwxRecvTextMsg }

procedure TwxRecvTextMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'Content', Content);
end;

procedure TwxRecvTextMsg.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  Content := VarToStr(RootNode.ChildValues['Content']);
end;

function TwxRecvTextMsg.GetContent: string;
begin
  Result := FContent;
end;

procedure TwxRecvTextMsg.SetContent(const Value: string);
begin
  FContent := Value
end;

{ TwxRecvPicMsg }

procedure TwxRecvPicMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'MediaId', MediaId.ToString);
  AddCDATA(RootNode, 'PicUrl', PicUrl);
end;

procedure TwxRecvPicMsg.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  MediaId := TWxHelper.VarToInt(RootNode.ChildValues['MediaId']);
  PicUrl  := VarToStr(RootNode.ChildValues['PicUrl']);
end;

function TwxRecvPicMsg.GetMediaId: Int64;
begin
  Result := FMediaId;
end;

function TwxRecvPicMsg.GetPicUrl: string;
begin
  Result := FPicUrl;
end;

procedure TwxRecvPicMsg.SetMediaId(const Value: Int64);
begin
  FMediaId := Value;
end;

procedure TwxRecvPicMsg.SetPicUrl(const Value: string);
begin
  FPicUrl := Value;
end;

{ TwxRecvVoiceMsg }

procedure TwxRecvVoiceMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'MediaId', MediaId.ToString);
  AddCDATA(RootNode, 'Format', Format);
  AddCDATA(RootNode, 'Recognition', Recognition);
end;

procedure TwxRecvVoiceMsg.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  MediaId     := TWxHelper.VarToInt(RootNode.ChildValues['MediaId']);
  Format      := VarToStr(RootNode.ChildValues['Format']);
  Recognition := VarToStr(RootNode.ChildValues['Recognition']);
end;

function TwxRecvVoiceMsg.GetFormat: string;
begin
  Result := FFormat
end;

function TwxRecvVoiceMsg.GetMediaId: Int64;
begin
  Result := FMediaId;
end;

function TwxRecvVoiceMsg.GetRecognition: string;
begin
  Result := FRecognition;
end;

procedure TwxRecvVoiceMsg.SetFormat(const Value: string);
begin
  FFormat := Value;
end;

procedure TwxRecvVoiceMsg.SetMediaId(const Value: Int64);
begin
  FMediaId := Value;
end;

procedure TwxRecvVoiceMsg.SetRecognition(const Value: string);
begin
  FRecognition := Value;
end;

{ TwxRecvVideoMsg }

procedure TwxRecvVideoMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'MediaId', MediaId.ToString);
  AddCDATA(RootNode, 'ThumbMediaId', ThumbMediaId.ToString);
end;

procedure TwxRecvVideoMsg.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  MediaId      := TWxHelper.VarToInt(RootNode.ChildValues['MediaId']);
  ThumbMediaId := TWxHelper.VarToInt(RootNode.ChildValues['ThumbMediaId']);
end;

function TwxRecvVideoMsg.GetMediaId: Int64;
begin
  Result := FMediaId;
end;

function TwxRecvVideoMsg.GetThumbMediaId: Int64;
begin
  Result := ThumbMediaId;
end;

procedure TwxRecvVideoMsg.SetMediaId(const Value: Int64);
begin
  FMediaId := Value
end;

procedure TwxRecvVideoMsg.SetThumbMediaId(const Value: Int64);
begin
  FThumbMediaId := Value;
end;

{ TwxRecvLocationMsg }

procedure TwxRecvLocationMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  RootNode.ChildValues['Location_X'] := LocationX;
  RootNode.ChildValues['Location_Y'] := LocationY;
  RootNode.ChildValues['Scale'] := Scale;
  AddCDATA(RootNode, 'Label', _Label);
end;

procedure TwxRecvLocationMsg.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  LocationX := TWxHelper.VarToFloat(RootNode.ChildValues['Location_X']);
  LocationY := TWxHelper.VarToFloat(RootNode.ChildValues['Location_Y']);
  Scale     := TWxHelper.VarToFloat(RootNode.ChildValues['Scale']);
  _Label    := VarToStr(RootNode.ChildValues['Label']);
end;

function TwxRecvLocationMsg.GetLocationX: Double;
begin
  Result := FLocationX;
end;

function TwxRecvLocationMsg.GetLocationY: Double;
begin
  Result := FLocationY;
end;

function TwxRecvLocationMsg.GetScale: Double;
begin
  Result := FScale;
end;

function TwxRecvLocationMsg.Get_Label: string;
begin
  Result := F_Label;
end;

procedure TwxRecvLocationMsg.SetLocationX(const Value: Double);
begin
  FLocationX := Value;
end;

procedure TwxRecvLocationMsg.SetLocationY(const Value: Double);
begin
  FLocationY := Value;
end;

procedure TwxRecvLocationMsg.SetScale(const Value: Double);
begin
  FScale := Value;
end;

procedure TwxRecvLocationMsg.Set_Label(const Value: string);
begin
  F_Label := Value;
end;

{ TwxRecvLinkMsg }

procedure TwxRecvLinkMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'Description', Description);
  AddCDATA(RootNode, 'Title', Title);
  AddCDATA(RootNode, 'Url', Url);
end;

procedure TwxRecvLinkMsg.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  Description := VarToStr(RootNode.ChildValues['Description']);
  Title       := VarToStr(RootNode.ChildValues['Title']);
  Url         := VarToStr(RootNode.ChildValues['Url']);
end;

function TwxRecvLinkMsg.GetDescription: string;
begin
  Result := FDescription;
end;

function TwxRecvLinkMsg.GetTitle: string;
begin
  Result := FTitle;
end;

function TwxRecvLinkMsg.GetUrl: string;
begin
  Result := FUrl;
end;

procedure TwxRecvLinkMsg.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TwxRecvLinkMsg.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TwxRecvLinkMsg.SetUrl(const Value: string);
begin
  FUrl := Value;
end;

{ TwxReplyBaseMsg }

constructor TwxReplyBaseMsg.Create;
begin
  inherited;
  CreateTime := Now;
end;

{ TwxReplyTextMsg }

constructor TwxReplyTextMsg.Create;
begin
  inherited;
  MsgType := mtText;
end;

procedure TwxReplyTextMsg.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  if FuncFlag then
    RootNode.ChildValues['FuncFlag'] := 1
  else
    RootNode.ChildValues['FuncFlag'] := 0;
  AddCDATA(RootNode, 'Content', Content);
end;

function TwxReplyTextMsg.GetFuncFlag: Boolean;
begin
  Result := FFuncFlag;
end;

procedure TwxReplyTextMsg.SetFuncFlag(const Value: Boolean);
begin
  FFuncFlag := Value;
end;

function TwxReplyTextMsg.GetContent: string;
begin
  Result := FContent
end;

procedure TwxReplyTextMsg.SetContent(const Value: string);
begin
  FContent := Value;
end;

{ TwxReplyPicMsg }

constructor TwxReplyPicMsg.Create;
begin
  inherited;
  MsgType := mtImage;
end;

procedure TwxReplyPicMsg.DoBuildXML(RootNode: IXMLNode);
var
  n: IXMLNode;
begin
  inherited;
  n := RootNode.ChildNodes.FindNode('Image');
  if n = nil then
    n := RootNode.AddChild('Image');
  AddCDATA(n, 'MediaId', MediaId);
end;

function TwxReplyPicMsg.GetMediaId: string;
begin
  Result := FMediaId;
end;

procedure TwxReplyPicMsg.SetMediaId(const Value: string);
begin
  FMediaId := Value;
end;

{ TwxReplyVoiceMsg }

constructor TwxReplyVoiceMsg.Create;
begin
  inherited;
  MsgType := mtVoice;
end;

procedure TwxReplyVoiceMsg.DoBuildXML(RootNode: IXMLNode);
var
  n: IXMLNode;
begin
  inherited;
  n := RootNode.ChildNodes.FindNode('Voice');
  if n = nil then
    n := RootNode.AddChild('Voice');
  AddCDATA(n, 'MediaId', MediaId);
end;

function TwxReplyVoiceMsg.GetMediaId: string;
begin
  Result := FMediaId;
end;

procedure TwxReplyVoiceMsg.SetMediaId(const Value: string);
begin
  FMediaId := Value;
end;

{ TwxReplyVideoMsg }

constructor TwxReplyVideoMsg.Create;
begin
  inherited;
  MsgType := mtVideo;
end;

procedure TwxReplyVideoMsg.DoBuildXML(RootNode: IXMLNode);
var
  n: IXMLNode;
begin
  inherited;
  n := RootNode.ChildNodes.FindNode('Video');
  if n = nil then
    n := RootNode.AddChild('Video');
  AddCDATA(n, 'MediaId', MediaId);
  AddCDATA(n, 'Title', Title);
  AddCDATA(n, 'Description', Description);
end;

function TwxReplyVideoMsg.GetDescription: string;
begin
  Result := FDescription;
end;

function TwxReplyVideoMsg.GetMediaId: string;
begin
  Result := FMediaId;
end;

function TwxReplyVideoMsg.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TwxReplyVideoMsg.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TwxReplyVideoMsg.SetMediaId(const Value: string);
begin
  FMediaId := Value
end;

procedure TwxReplyVideoMsg.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

{ TwxReplyMusicMsg }

constructor TwxReplyMusicMsg.Create;
begin
  inherited;
  MsgType := mtMusic;
end;

procedure TwxReplyMusicMsg.DoBuildXML(RootNode: IXMLNode);
var
  n: IXMLNode;
begin
  inherited;
  n := RootNode.ChildNodes.FindNode('Music');
  if n = nil then
    n := RootNode.AddChild('Music');
  AddCDATA(n, 'Title', Title);
  AddCDATA(n, 'Description', Description);
  AddCDATA(n, 'MusicURL', MusicURL);
  AddCDATA(n, 'HQMusicUrl', HQMusicUrl);
  AddCDATA(n, 'ThumbMediaId', ThumbMediaId);
end;

function TwxReplyMusicMsg.GetDescription: string;
begin
  Result := FDescription;
end;

function TwxReplyMusicMsg.GetHQMusicUrl: string;
begin
  Result := FHQMusicUrl;
end;

function TwxReplyMusicMsg.GetMusicURL: string;
begin
  Result := FMusicURL;
end;

function TwxReplyMusicMsg.GetThumbMediaId: string;
begin
  Result := FThumbMediaId;
end;

function TwxReplyMusicMsg.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TwxReplyMusicMsg.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TwxReplyMusicMsg.SetHQMusicUrl(const Value: string);
begin
  FHQMusicUrl := Value;
end;

procedure TwxReplyMusicMsg.SetMusicURL(const Value: string);
begin
  FMusicURL := Value;
end;

procedure TwxReplyMusicMsg.SetThumbMediaId(const Value: string);
begin
  FThumbMediaId := Value;
end;

procedure TwxReplyMusicMsg.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

{ TwxArticle }

constructor TwxArticle.Create(Collection: TCollection; const Title, Description, PicUrl, Url: string);
begin
  inherited Create(Collection);
  Self.Title := Title;
  Self.Description := Description;
  Self.PicUrl := PicUrl;
  Self.Url := Url;
end;

procedure TwxArticle.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TwxArticle.SetPicUrl(const Value: string);
begin
  FPicUrl := Value;
end;

procedure TwxArticle.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TwxArticle.SetUrl(const Value: string);
begin
  FUrl := Value;
end;

{ TwxArticles }

function TwxArticles.Add(const Title, Description, PicUrl,
  Url: string): TwxArticle;
begin
  Result := TwxArticle.Create(Self, Title, Description, PicUrl, Url);
end;

function TwxArticles.GetItem(Index: Integer): TwxArticle;
begin
  Result := inherited GetItem(Index) as TwxArticle;
end;

procedure TwxArticles.SetItem(Index: Integer; const Value: TwxArticle);
begin
  inherited SetItem(Index, Value);
end;

{ TwxReplyNewsMsg }

constructor TwxReplyNewsMsg.Create;
begin
  inherited;
  MsgType := mtNews;
  FArticles := TwxArticles.Create(TwxArticle);
end;

destructor TwxReplyNewsMsg.Destroy;
begin
  FArticles.Free;
  inherited;
 end;

procedure TwxReplyNewsMsg.DoBuildXML(RootNode: IXMLNode);
var
  an: IXMLNode;
  Item: IXMLNode;
  I: Integer;
  Article: TwxArticle;
begin
  inherited;
  RootNode.ChildValues['ArticleCount'] := ArticleCount;
  an := RootNode.ChildNodes.FindNode('Articles');
  if an = nil then
    an := RootNode.AddChild('Articles');
  for I := 0 to Articles.Count - 1 do begin
    Article := Articles[I];
    Item := an.AddChild('Item');
    AddCDATA(Item, 'Title', Article.Title);
    AddCDATA(Item, 'Description', Article.Description);
    AddCDATA(Item, 'PicUrl', Article.PicUrl);
    AddCDATA(Item, 'Url', Article.Url);
  end;
end;

function TwxReplyNewsMsg.GetArticleCount: Integer;
begin
  Result := FArticles.Count;
end;

end.
