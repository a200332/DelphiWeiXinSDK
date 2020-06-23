unit WX.Event;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom,
  Xml.omnixmldom, Xml.XMLIntf, WX.Common;

type
  IwxEvent = interface(IwxMsg)
  ['{2915DF4F-D3B7-41FF-8315-D6FE94AE03AD}']
    procedure SetEvent(const Value: TwxEventType);
    function GetEvent: TwxEventType;
    property Event: TwxEventType read GetEvent write SetEvent;
  end;

  TwxEvent = class(TwxBaseMsg, IwxEvent)
  private
    FEvent: TwxEventType;
    function GetEvent: TwxEventType;
    procedure SetEvent(const Value: TwxEventType);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property Event: TwxEventType read GetEvent write SetEvent;
  end;

  IwxUnsubscribeEvent = IwxEvent;
  TwxUnsubscribeEvent = TwxEvent;

  IwxSubscribeEvent = interface(IwxEvent)
  ['{0E674DB5-109E-46F2-9E94-DC5D26E56D7C}']
    procedure SetEventKey(const Value: string);
    procedure SetTicket(const Value: string);
    function GetEventKey: string;
    function GetTicket: string;
    property EventKey: string read GetEventKey write SetEventKey;
    property Ticket: string read GetTicket write SetTicket;
  end;

  TwxSubscribeEvent = class(TwxEvent, IwxSubscribeEvent)
  private
    FTicket: string;
    FEventKey: string;
    procedure SetEventKey(const Value: string);
    procedure SetTicket(const Value: string);
    function GetEventKey: string;
    function GetTicket: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property EventKey: string read GetEventKey write SetEventKey;
    property Ticket: string read GetTicket write SetTicket;
  end;

  IwxScanEvent = IwxSubscribeEvent;
  TwxScanEvent = TwxSubscribeEvent;

  IwxLocationEvent = interface(IwxEvent)
  ['{42824451-198D-4F09-8A8B-B61B38214991}']
    procedure SetLatitude(const Value: Double);
    procedure SetLongitude(const Value: Double);
    procedure SetPrecision(const Value: Double);
    function GetLatitude: Double;
    function GetLongitude: Double;
    function GetPrecision: Double;
    property Latitude: Double read GetLatitude write SetLatitude;
    property Longitude: Double read GetLongitude write SetLongitude;
    property Precision: Double read GetPrecision write SetPrecision;
  end;

  TwxLocationEvent = class(TwxEvent, IwxLocationEvent)
  private
    FLatitude: Double;
    FPrecision: Double;
    FLongitude: Double;
    procedure SetLatitude(const Value: Double);
    procedure SetLongitude(const Value: Double);
    procedure SetPrecision(const Value: Double);
    function GetLatitude: Double;
    function GetLongitude: Double;
    function GetPrecision: Double;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property Latitude: Double read GetLatitude write SetLatitude;
    property Longitude: Double read GetLongitude write SetLongitude;
    property Precision: Double read GetPrecision write SetPrecision;
  end;

  IwxClickEvent = interface(IwxEvent)
  ['{9378CF68-9E98-474B-8F57-F191100E6214}']
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    property EventKey: string read GetEventKey write SetEventKey;
  end;

  TwxClickEvent = class(TwxEvent, IwxClickEvent)
  private
    FEventKey: string;
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property EventKey: string read GetEventKey write SetEventKey;
  end;

  IwxViewEvent = interface(IwxEvent)
  ['{9FCC7FA2-37EF-4F75-B6D6-9D2E5394218B}']
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    procedure SetMenuID(const Value: Integer);
    function GetMenuID: Integer;
    property EventKey: string read GetEventKey write SetEventKey;
    property MenuID: Integer read GetMenuID write SetMenuID;
  end;

  TwxViewEvent = class(TwxEvent, IwxViewEvent)
  private
    FEventKey: string;
    FMenuID: Integer;
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    procedure SetMenuID(const Value: Integer);
    function GetMenuID: Integer;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property EventKey: string read GetEventKey write SetEventKey;
    property MenuID: Integer read GetMenuID write SetMenuID;
  end;

  TwxScanCodeInfo = class
  private
    FScanType: string;
    FScanResult: string;
    procedure SetScanResult(const Value: string);
    procedure SetScanType(const Value: string);
  public
    property ScanType: string read FScanType write SetScanType;
    property ScanResult: string read FScanResult write SetScanResult;
  end;

  IwxScancodePushEvent = interface(IwxEvent)
  ['{9378CF68-9E98-474B-8F57-F191100E6214}']
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    function GetScanCodeInfo: TwxScanCodeInfo;
    property EventKey: string read GetEventKey write SetEventKey;
    property ScanCodeInfo: TwxScanCodeInfo read GetScanCodeInfo;
  end;

  TwxScancodePushEvent = class(TwxEvent, IwxScancodePushEvent)
  private
    FEventKey: string;
    FScanCodeInfo: TwxScanCodeInfo;
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    function GetScanCodeInfo: TwxScanCodeInfo;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property EventKey: string read GetEventKey write SetEventKey;
    property ScanCodeInfo: TwxScanCodeInfo read GetScanCodeInfo;
  end;

  IwxScancodeWaitMsgEvent = IwxScancodePushEvent;
  TwxScancodeWaitMsgEvent = TwxScancodePushEvent;

  TwxSendPicItem = class(TCollectionItem)
  private
    FPicMd5Sum: string;
    procedure SetPicMd5Sum(const Value: string);
  public
    constructor Create(Collection: TCollection; const PicMd5Sum: string);
    property PicMd5Sum: string read FPicMd5Sum write SetPicMd5Sum;
  end;

  TwxSendPicsInfo = class(TCollection)
  private
    function GetItem(Index: Integer): TwxSendPicItem;
    procedure SetItem(Index: Integer; const Value: TwxSendPicItem);
  public
    function Add(const PicMd5Sum: string): TwxSendPicItem;
    property Items[Index: Integer]: TwxSendPicItem read GetItem write SetItem; default;
  end;

  IwxPicSysPhotoEvent = interface(IwxEvent)
  ['{B8E59317-7E55-47BB-A7BB-9A08707A9082}']
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    function GetSendPicsInfo: TwxSendPicsInfo;
    property EventKey: string read GetEventKey write SetEventKey;
    property SendPicsInfo: TwxSendPicsInfo read GetSendPicsInfo;
  end;

  TwxPicSysPhotoEvent = class(TwxEvent, IwxPicSysPhotoEvent)
  private
    FEventKey: string;
    FSendPicsInfo: TwxSendPicsInfo;
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    function GetSendPicsInfo: TwxSendPicsInfo;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property EventKey: string read GetEventKey write SetEventKey;
    property SendPicsInfo: TwxSendPicsInfo read GetSendPicsInfo;
  end;

  IwxPicPhotoOrAlbumEvent = IwxPicSysPhotoEvent;
  TwxPicPhotoOrAlbumEvent = TwxPicSysPhotoEvent;

  IwxPicWeiXinEvent = IwxPicSysPhotoEvent;
  TwxPicWeiXinEvent = TwxPicSysPhotoEvent;

  TwxSendLocationInfo = class
  private
    FPoiname: string;
    FLocation_X: Double;
    FLocation_Y: Double;
    F_Label: string;
    FScale: Double;
    procedure Set_Label(const Value: string);
    procedure SetLocation_X(const Value: Double);
    procedure SetLocation_Y(const Value: Double);
    procedure SetPoiname(const Value: string);
    procedure SetScale(const Value: Double);
  public
    property Location_X: Double read FLocation_X write SetLocation_X;
    property Location_Y: Double read FLocation_Y write SetLocation_Y;
    property Scale: Double read FScale write SetScale;
    property _Label: string read F_Label write Set_Label;
    property Poiname: string read FPoiname write SetPoiname;
  end;

  IwxLocationSelectEvent = interface(IwxEvent)
  ['{F027A7B6-9537-412D-8C09-4F8D33E80A69}']
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    function GetSendLocationInfo: TwxSendLocationInfo;
    property EventKey: string read GetEventKey write SetEventKey;
    property SendLocationInfo: TwxSendLocationInfo read GetSendLocationInfo;
  end;

  TwxLocationSelectEvent = class(TwxEvent, IwxLocationSelectEvent)
  private
    FEventKey: string;
    FSendLocationInfo: TwxSendLocationInfo;
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    function GetSendLocationInfo: TwxSendLocationInfo;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property EventKey: string read GetEventKey write SetEventKey;
    property SendLocationInfo: TwxSendLocationInfo read GetSendLocationInfo;
  end;

  IwxViewMiniProgramEvent = interface(IwxEvent)
  ['{C5D083ED-8CAC-4440-901D-B3E5A662EAC4}']
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    procedure SetMenuID(const Value: Integer);
    function GetMenuID: Integer;
    property EventKey: string read GetEventKey write SetEventKey;
    property MenuID: Integer read GetMenuID write SetMenuID;
  end;

  TwxViewMiniProgramEvent = class(TwxEvent, IwxViewMiniProgramEvent)
  private
    FEventKey: string;
    FMenuID: Integer;
    procedure SetEventKey(const Value: string);
    function GetEventKey: string;
    procedure SetMenuID(const Value: Integer);
    function GetMenuID: Integer;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property EventKey: string read GetEventKey write SetEventKey;
    property MenuID: Integer read GetMenuID write SetMenuID;
  end;

  IwxTemplateSendJobFinishEvent = interface(IwxEvent)
  ['{FECF70F9-3B4B-429F-A4A2-633D45E2340D}']
    procedure SetMsgID(const Value: Int64);
    procedure SetStatus(const Value: string);
    function GetMsgID: Int64;
    function GetStatus: string;
    property MsgID: Int64 read GetMsgID write SetMsgID;
    property Status: string read GetStatus write SetStatus;
  end;

  TwxTemplateSendJobFinishEvent = class(TwxEvent, IwxTemplateSendJobFinishEvent)
  private
    FStatus: string;
    FMsgID: Int64;
    procedure SetMsgID(const Value: Int64);
    procedure SetStatus(const Value: string);
    function GetMsgID: Int64;
    function GetStatus: string;
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property MsgID: Int64 read GetMsgID write SetMsgID;
    property Status: string read GetStatus write SetStatus;
  end;

implementation

uses WX.Utils;

{ TwxEvent }

procedure TwxEvent.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'Event', Event.ToString);
end;

procedure TwxEvent.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  Event := TwxEventType.ParseStr(VarToStr(RootNode.ChildValues['Event']));
end;

function TwxEvent.GetEvent: TwxEventType;
begin
  Result := FEvent;
end;

procedure TwxEvent.SetEvent(const Value: TwxEventType);
begin
  FEvent := Value;
end;

{ TwxSubscribeEvent }

procedure TwxSubscribeEvent.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'EventKey', EventKey);
  AddCDATA(RootNode, 'Ticket', Ticket);
end;

procedure TwxSubscribeEvent.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  EventKey := VarToStr(RootNode.ChildValues['EventKey']);
  Ticket   := VarToStr(RootNode.ChildValues['Ticket']);
end;

function TwxSubscribeEvent.GetEventKey: string;
begin
  Result := FEventKey;
end;

function TwxSubscribeEvent.GetTicket: string;
begin
  Result := FTicket;
end;

procedure TwxSubscribeEvent.SetEventKey(const Value: string);
begin
  FEventKey := Value;
end;

procedure TwxSubscribeEvent.SetTicket(const Value: string);
begin
  FTicket := Value;
end;

{ TwxLocationEvent }

procedure TwxLocationEvent.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  RootNode.ChildValues['Latitude']  := Format('%.6f', [Latitude]);
  RootNode.ChildValues['Longitude'] := Format('%.6f', [Longitude]);
  RootNode.ChildValues['Precision'] := Format('%.6f', [Precision]);
end;

procedure TwxLocationEvent.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  Latitude  := TWxHelper.VarToFloat(RootNode.ChildValues['Latitude']);
  Longitude := TWxHelper.VarToFloat(RootNode.ChildValues['Longitude']);
  Precision := TWxHelper.VarToFloat( RootNode.ChildValues['Precision']);
end;

function TwxLocationEvent.GetLatitude: Double;
begin
  Result := FLatitude;
end;

function TwxLocationEvent.GetLongitude: Double;
begin
  Result := FLongitude;
end;

function TwxLocationEvent.GetPrecision: Double;
begin
  Result := FPrecision;
end;

procedure TwxLocationEvent.SetLatitude(const Value: Double);
begin
  FLatitude := Value;
end;

procedure TwxLocationEvent.SetLongitude(const Value: Double);
begin
  FLongitude := Value;
end;

procedure TwxLocationEvent.SetPrecision(const Value: Double);
begin
  FPrecision := Value;
end;

{ TwxClickEvent }

procedure TwxClickEvent.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'EventKey', EventKey);
end;

procedure TwxClickEvent.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  EventKey := VarToStr(RootNode.ChildValues['EventKey']);
end;

function TwxClickEvent.GetEventKey: string;
begin
  Result := FEventKey;
end;

procedure TwxClickEvent.SetEventKey(const Value: string);
begin
  FEventKey := Value;
end;

{ TwxViewEvent }

procedure TwxViewEvent.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'EventKey', EventKey);
end;

procedure TwxViewEvent.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  EventKey := VarToStr(RootNode.ChildValues['EventKey']);
end;

function TwxViewEvent.GetEventKey: string;
begin
  Result := FEventKey;
end;

function TwxViewEvent.GetMenuID: Integer;
begin
  Result := FMenuID;
end;

procedure TwxViewEvent.SetEventKey(const Value: string);
begin
  FEventKey := Value;
end;

procedure TwxViewEvent.SetMenuID(const Value: Integer);
begin
  FMenuID := Value;
end;

{ TwxScanCodeInfo }

procedure TwxScanCodeInfo.SetScanResult(const Value: string);
begin
  FScanResult := Value;
end;

procedure TwxScanCodeInfo.SetScanType(const Value: string);
begin
  FScanType := Value;
end;

{ TwxScancodePushEvent }

constructor TwxScancodePushEvent.Create;
begin
  inherited;
  FScanCodeInfo := TwxScanCodeInfo.Create;
end;

destructor TwxScancodePushEvent.Destroy;
begin
  FScanCodeInfo.Free;
  inherited;
end;

procedure TwxScancodePushEvent.DoBuildXML(RootNode: IXMLNode);
var
  n: IXMLNode;
begin
  inherited;
  AddCDATA(RootNode, 'EventKey', EventKey);
  n := RootNode.ChildNodes.FindNode('ScanCodeInfo');
  if n = nil then
    n := RootNode.AddChild('ScanCodeInfo');
  AddCDATA(n, 'ScanType', ScanCodeInfo.ScanType);
  AddCDATA(n, 'ScanResult', ScanCodeInfo.ScanResult);
end;

procedure TwxScancodePushEvent.DoInitFromXML(RootNode: IXMLNode);
var
  n: IXMLNode;
begin
  inherited;
  EventKey := VarToStr(RootNode.ChildValues['EventKey']);
  n := RootNode.ChildNodes.FindNode('ScanCodeInfo');
  if n <> nil then begin
    ScanCodeInfo.ScanType := VarToStr(n.ChildValues['ScanType']);
    ScanCodeInfo.ScanResult := VarToStr(n.ChildValues['ScanResult']);
  end;
end;

function TwxScancodePushEvent.GetEventKey: string;
begin
  Result := FEventKey;
end;

function TwxScancodePushEvent.GetScanCodeInfo: TwxScanCodeInfo;
begin
  Result := FScanCodeInfo;
end;

procedure TwxScancodePushEvent.SetEventKey(const Value: string);
begin
  FEventKey := Value;
end;

{ TwxSendPicItem }

constructor TwxSendPicItem.Create(Collection: TCollection;
  const PicMd5Sum: string);
begin
  inherited Create(Collection);
  FPicMd5Sum := PicMd5Sum;
end;

procedure TwxSendPicItem.SetPicMd5Sum(const Value: string);
begin
  FPicMd5Sum := Value;
end;

{ TwxSendPicsInfo }

function TwxSendPicsInfo.Add(const PicMd5Sum: string): TwxSendPicItem;
begin
  Result := TwxSendPicItem.Create(Self, PicMd5Sum);
end;

function TwxSendPicsInfo.GetItem(Index: Integer): TwxSendPicItem;
begin
  Result := inherited GetItem(Index) as TwxSendPicItem;
end;

procedure TwxSendPicsInfo.SetItem(Index: Integer; const Value: TwxSendPicItem);
begin
  inherited SetItem(Index, Value);
end;

{ TwxPicSysPhotoEvent }

constructor TwxPicSysPhotoEvent.Create;
begin
  inherited;
  FSendPicsInfo := TwxSendPicsInfo.Create(TwxSendPicItem);
end;

destructor TwxPicSysPhotoEvent.Destroy;
begin
  FSendPicsInfo.Free;
  inherited;
end;

procedure TwxPicSysPhotoEvent.DoBuildXML(RootNode: IXMLNode);
var
  n: IXMLNode;
  pn: IXMLNode;
  Item: IXMLNode;
  I: Integer;
begin
  inherited;
  AddCDATA(RootNode, 'EventKey', EventKey);
  n := RootNode.ChildNodes.FindNode('SendPicsInfo');
  if n = nil then
    n := RootNode.AddChild('SendPicsInfo');
  n.ChildValues['Count'] := SendPicsInfo.Count;
  pn := n.ChildNodes.FindNode('PicList');
  if pn = nil then
    pn := n.AddChild('PicList')
  else
    pn.ChildNodes.Clear;
  for I := 0 to SendPicsInfo.Count - 1 do begin
    Item := pn.AddChild('item');
    AddCDATA(Item, 'PicMd5Sum', SendPicsInfo[I].PicMd5Sum);
  end;
end;

procedure TwxPicSysPhotoEvent.DoInitFromXML(RootNode: IXMLNode);
var
  n: IXMLNode;
  Item: IXMLNode;
  I: Integer;
begin
  inherited;
  EventKey := VarToStr(RootNode.ChildValues['EventKey']);
  SendPicsInfo.Clear;
  n := RootNode.ChildNodes.FindNode('SendPicsInfo');
  if n <> nil then begin
    n := n.ChildNodes.FindNode('PicList');
    if n <> nil then
    for I := 0 to n.ChildNodes.Count - 1 do begin
      Item := n.ChildNodes[I];
      SendPicsInfo.Add(Item.ChildValues['PicMd5Sum']);
    end;
  end;
end;

function TwxPicSysPhotoEvent.GetEventKey: string;
begin
  Result := FEventKey;
end;

function TwxPicSysPhotoEvent.GetSendPicsInfo: TwxSendPicsInfo;
begin
  Result := FSendPicsInfo;
end;

procedure TwxPicSysPhotoEvent.SetEventKey(const Value: string);
begin
  FEventKey := Value;
end;

{ TwxSendLocationInfo }

procedure TwxSendLocationInfo.SetLocation_X(const Value: Double);
begin
  FLocation_X := Value;
end;

procedure TwxSendLocationInfo.SetLocation_Y(const Value: Double);
begin
  FLocation_Y := Value;
end;

procedure TwxSendLocationInfo.SetPoiname(const Value: string);
begin
  FPoiname := Value;
end;

procedure TwxSendLocationInfo.SetScale(const Value: Double);
begin
  FScale := Value;
end;

procedure TwxSendLocationInfo.Set_Label(const Value: string);
begin
  F_Label := Value;
end;

{ TwxLocationSelectEvent }

constructor TwxLocationSelectEvent.Create;
begin
  inherited;
  FSendLocationInfo := TwxSendLocationInfo.Create;
end;

destructor TwxLocationSelectEvent.Destroy;
begin
  FSendLocationInfo.Free;
  inherited;
end;

procedure TwxLocationSelectEvent.DoBuildXML(RootNode: IXMLNode);
var
  n: IXMLNode;
begin
  inherited;
  AddCDATA(RootNode, 'EventKey', EventKey);
  n := RootNode.AddChild('SendLocationInfo');
  AddCDATA(N, 'Location_X', Format('%.6', [SendLocationInfo.Location_X]));
  AddCDATA(N, 'Location_Y', Format('%.6', [SendLocationInfo.Location_Y]));
  AddCDATA(N, 'Label', SendLocationInfo._Label);
  AddCDATA(N, 'Poiname', SendLocationInfo.Poiname);
end;

procedure TwxLocationSelectEvent.DoInitFromXML(RootNode: IXMLNode);
var
  n: IXMLNode;
begin
  inherited;
  EventKey := VarToStr(RootNode.ChildValues['EventKey']);
  n := RootNode.ChildNodes.FindNode('SendLocationInfo');
  SendLocationInfo.Location_X := TWxHelper.VarToFloat(n.ChildValues['Location_X']);
  SendLocationInfo.Location_Y := TWxHelper.VarToFloat(n.ChildValues['Location_Y']);
  SendLocationInfo.Scale      := TWxHelper.VarToFloat(n.ChildValues['Scale']);
  SendLocationInfo._Label     := VarToStr(n.ChildValues['Label']);
  SendLocationInfo.Poiname    := VarToStr(n.ChildValues['Poiname']);
end;

function TwxLocationSelectEvent.GetEventKey: string;
begin
  Result := FEventKey;
end;

function TwxLocationSelectEvent.GetSendLocationInfo: TwxSendLocationInfo;
begin
  Result := FSendLocationInfo;
end;

procedure TwxLocationSelectEvent.SetEventKey(const Value: string);
begin
  FEventKey := Value;
end;

{ TwxViewMiniProgramEvent }

procedure TwxViewMiniProgramEvent.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'EventKey', EventKey);
  RootNode.ChildValues['MenuID'] := MenuID;
end;

procedure TwxViewMiniProgramEvent.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  EventKey := VarToStr(RootNode.ChildValues['EventKey']);
  MenuID   := TWxHelper.VarToInt(RootNode.ChildValues['MenuID']);
end;

function TwxViewMiniProgramEvent.GetEventKey: string;
begin
  Result := FEventKey;
end;

function TwxViewMiniProgramEvent.GetMenuID: Integer;
begin
  Result := FMenuID;
end;

procedure TwxViewMiniProgramEvent.SetEventKey(const Value: string);
begin
  FEventKey := Value;
end;

procedure TwxViewMiniProgramEvent.SetMenuID(const Value: Integer);
begin
  FMenuID := Value;
end;

{ TwxTemplateSendJobFinishEvent }

procedure TwxTemplateSendJobFinishEvent.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  RootNode.ChildValues['MsgID'] := MsgID;
  AddCDATA(RootNode, 'Status', Status);
end;

procedure TwxTemplateSendJobFinishEvent.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  MsgID  := TWxHelper.VarToInt(RootNode.ChildValues['MsgID']);
  Status := VarToStr(RootNode.ChildValues['Status']);
end;

function TwxTemplateSendJobFinishEvent.GetMsgID: Int64;
begin
  Result := FMsgID;
end;

function TwxTemplateSendJobFinishEvent.GetStatus: string;
begin
  Result := FStatus;
end;

procedure TwxTemplateSendJobFinishEvent.SetMsgID(const Value: Int64);
begin
  FMsgID := Value;
end;

procedure TwxTemplateSendJobFinishEvent.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

end.
