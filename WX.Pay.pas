unit WX.Pay;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom,
  Xml.XMLDoc, Xml.omnixmldom, Xml.XMLIntf, WX.Common, System.Net.HttpClient,
  JsonDataObjects;

type
  IwxUnifiedOrderRequest = interface(IwxXMLPayRequest)
  ['{38DF0125-31DE-4000-B8E3-8009B450735F}']
    function GetBody: string;
    procedure SetBody(const Value: string);
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    function GetTotalFee: Integer;
    procedure SetTotalFee(const Value: Integer);
    function GetNotifyUrl: string;
    procedure SetNotifyUrl(const Value: string);
    function GetSpbillCreateIp: string;
    procedure SetSpbillCreateIp(const Value: string);
    function GetTradeType: TwxTradeType;
    procedure SetTradeType(const Value: TwxTradeType);
    function GetAttach: string;
    function GetDetail: string;
    function GetDeviceInfo: string;
    function GetFeeType: string;
    function GetGoodsTag: string;
    function GetLimitPay: string;
    function GetOpenId: string;
    function GetProductId: string;
    function GetReceipt: string;
    function GetSceneInfo: string;
    procedure SetSceneInfo(const Value: string);
    function GetTimeExpire: TDateTime;
    function GetTimeStart: TDateTime;
    procedure SetAttach(const Value: string);
    procedure SetDetail(const Value: string);
    procedure SetFeeType(const Value: string);
    procedure SetGoodsTag(const Value: string);
    procedure SetLimitPay(const Value: string);
    procedure SetDeviceInfo(const Value: string);
    procedure SetOpenId(const Value: string);
    procedure SetProductId(const Value: string);
    procedure SetReceipt(const Value: string);
    procedure SetTimeExpire(const Value: TDateTime);
    procedure SetTimeStart(const Value: TDateTime);
    //----------begin 必填----------
    property Body: string read GetBody write SetBody;
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    property TotalFee: Integer read GetTotalFee write SetTotalFee;
    property NotifyUrl: string read GetNotifyUrl write SetNotifyUrl;
    property SpbillCreateIp: string read GetSpbillCreateIp write SetSpbillCreateIp;
    property TradeType: TwxTradeType read GetTradeType write SetTradeType;
    //----------end 必填----------
    property OpenId: string Read GetOpenId write SetOpenId;
    property DeviceInfo: string Read GetDeviceInfo write SetDeviceInfo;
    property Detail: string Read GetDetail write SetDetail;
    property Attach: string Read GetAttach write SetAttach;
    property FeeType: string Read GetFeeType write SetFeeType;
    property TimeStart: TDateTime Read GetTimeStart write SetTimeStart;
    property TimeExpire: TDateTime Read GetTimeExpire write SetTimeExpire;
    property GoodsTag: string Read GetGoodsTag write SetGoodsTag;
    property ProductId: string Read GetProductId write SetProductId;
    property LimitPay: string Read GetLimitPay write SetLimitPay;
    property Receipt: string Read GetReceipt write SetReceipt;
    property SceneInfo: string Read GetSceneInfo write SetSceneInfo;
  end;

  TwxUnifiedOrderRequest = class(TwxXMLPayRequest, IwxUnifiedOrderRequest)
  private
    FBody: string;
    FNotifyUrl: string;
    FOutTradeNo: string;
    FTotalFee: Integer;
    FSpbillCreateIp: string;
    FTradeType: TwxTradeType;
    FOpenId: string;
    FDeviceInfo: string;
    FDetail: string;
    FAttach: string;
    FFeeType: string;
    FTimeStart: TDateTime;
    FTimeExpire: TDateTime;
    FGoodsTag: string;
    FProductId: string;
    FLimitPay: string;
    FReceipt: string;
    FSceneInfo: string;
    function GetBody: string;
    function GetNotifyUrl: string;
    function GetOutTradeNo: string;
    function GetTotalFee: Integer;
    procedure SetBody(const Value: string);
    procedure SetNotifyUrl(const Value: string);
    procedure SetOutTradeNo(const Value: string);
    procedure SetTotalFee(const Value: Integer);
    function GetSpbillCreateIp: string;
    function GetTradeType: TwxTradeType;
    procedure SetSpbillCreateIp(const Value: string);
    procedure SetTradeType(const Value: TwxTradeType);
    function GetAttach: string;
    function GetDetail: string;
    function GetDeviceInfo: string;
    function GetFeeType: string;
    function GetGoodsTag: string;
    function GetLimitPay: string;
    function GetOpenId: string;
    function GetProductId: string;
    function GetReceipt: string;
    function GetSceneInfo: string;
    function GetTimeExpire: TDateTime;
    function GetTimeStart: TDateTime;
    procedure SetAttach(const Value: string);
    procedure SetDetail(const Value: string);
    procedure SetFeeType(const Value: string);
    procedure SetGoodsTag(const Value: string);
    procedure SetLimitPay(const Value: string);
    procedure SetDeviceInfo(const Value: string);
    procedure SetOpenId(const Value: string);
    procedure SetProductId(const Value: string);
    procedure SetReceipt(const Value: string);
    procedure SetTimeExpire(const Value: TDateTime);
    procedure SetTimeStart(const Value: TDateTime);
    procedure SetSceneInfo(const Value: string);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    //----------begin 必填----------
    property Body: string read GetBody write SetBody;
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    property TotalFee: Integer read GetTotalFee write SetTotalFee;
    property NotifyUrl: string read GetNotifyUrl write SetNotifyUrl;
    property SpbillCreateIp: string read GetSpbillCreateIp write SetSpbillCreateIp;
    property TradeType: TwxTradeType read GetTradeType write SetTradeType;
    //----------end 必填----------
    property OpenId: string Read GetOpenId write SetOpenId;
    property DeviceInfo: string Read GetDeviceInfo write SetDeviceInfo;
    property Detail: string Read GetDetail write SetDetail;
    property Attach: string Read GetAttach write SetAttach;
    property FeeType: string Read GetFeeType write SetFeeType;
    property TimeStart: TDateTime Read GetTimeStart write SetTimeStart;
    property TimeExpire: TDateTime Read GetTimeExpire write SetTimeExpire;
    property GoodsTag: string Read GetGoodsTag write SetGoodsTag;
    property ProductId: string Read GetProductId write SetProductId;
    property LimitPay: string Read GetLimitPay write SetLimitPay;
    property Receipt: string Read GetReceipt write SetReceipt;
    property SceneInfo: string Read GetSceneInfo write SetSceneInfo;
  end;

  IwxUnifiedOrderReponse = interface(IwxXMLPayReponse)
  ['{30F1F50A-C3F7-4632-8372-31A85094F9E9}']
    function GetDeviceInfo: string;
    function GetTradeType: TwxTradeType;
    function GetPrepayId: string;
    function GetCodeUrl: string;
    function GetMWebUrl: string;
    property DeviceInfo: string Read GetDeviceInfo;
    property TradeType: TwxTradeType read GetTradeType;
    property PrepayId: string read GetPrepayId;
    property CodeUrl: string read GetCodeUrl;
    property MWebUrl: string read GetMWebUrl;
  end;

  TwxUnifiedOrderReponse = class(TwxXMLPayReponse, IwxUnifiedOrderReponse)
  private
    FDeviceInfo: string;
    FTradeType: TwxTradeType;
    FPrepayId: string;
    FCodeUrl: string;
    FMWebUrl: string;
    function GetDeviceInfo: string;
    function GetTradeType: TwxTradeType;
    function GetPrepayId: string;
    function GetCodeUrl: string;
    function GetMWebUrl: string;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property DeviceInfo: string Read GetDeviceInfo;
    property TradeType: TwxTradeType read GetTradeType;
    property PrepayId: string read GetPrepayId;
    property CodeUrl: string read GetCodeUrl;
    property MWebUrl: string read GetMWebUrl;
  end;

  IwxQueryOrderRequest = interface(IwxXMLPayRequest)
  ['{0962D86A-B92B-4933-BB96-93A5634484EE}']
    function GetAppId: string;
    procedure SetAppId(const Value: string);
    function GetMchId: string;
    procedure SetMchId(const Value: string);
    function GetTransactionId: string;
    procedure SetTransactionId(const Value: string);
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    property AppId: string read GetAppId write SetAppId;
    property MchId: string read GetMchId write SetMchId;
    property TransactionId: string read GetTransactionId write SetTransactionId;
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
  end;

  TwxQueryOrderRequest = class(TwxXMLPayRequest, IwxQueryOrderRequest)
  private
    FOutTradeNo: string;
    FTransactionId: string;
    function GetOutTradeNo: string;
    function GetTransactionId: string;
    procedure SetOutTradeNo(const Value: string);
    procedure SetTransactionId(const Value: string);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    property TransactionId: string read GetTransactionId write SetTransactionId;
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
  end;

  TwxCoupon = record
    _Type: string;
    Id: string;
    Fee: Integer;
  end;

  TwxCoupons = TArray<TwxCoupon>;

  IwxQueryOrderReponse = interface(IwxXMLPayReponse)
  ['{B4283379-FC6D-444B-BBB6-C8CBA6A043CB}']
    function GetBankType: string;
    function GetCashFee: Integer;
    function GetDeviceInfo: string;
    function GetIsSubscribe: Boolean;
    function GetOpenId: string;
    function GetOutTradeNo: string;
    function GetTimeEnd: TDateTime;
    function GetTotalFee: Integer;
    function GetTradeState: TwxTradeState;
    function GetTradeStateDesc: string;
    function GetTradeType: TwxTradeType;
    function GetTransactionId: string;
    function GetAttach: string;
    function GetCashFeeType: string;
    function GetCouponFee: Integer;
    function GetCoupons: TwxCoupons;
    function GetFeeType: string;
    function GetSettlementTotalFee: Integer;
    property TradeType: TwxTradeType read GetTradeType;
    property TradeState: TwxTradeState read GetTradeState;
    property OpenId: string read GetOpenId;
    property IsSubscribe: Boolean read GetIsSubscribe;
    property BankType: string read GetBankType;
    property TotalFee: Integer read GetTotalFee;
    property CashFee: Integer read GetCashFee;
    property TransactionId: string read GetTransactionId;
    property OutTradeNo: string read GetOutTradeNo;
    property TimeEnd: TDateTime read GetTimeEnd;
    property TradeStateDesc: string read GetTradeStateDesc;
    property DeviceInfo: string Read GetDeviceInfo;
    property SettlementTotalFee: Integer Read GetSettlementTotalFee;
    property FeeType: string Read GetFeeType;
    property CashFeeType: string Read GetCashFeeType;
    property CouponFee: Integer Read GetCouponFee;
    property Coupons: TwxCoupons Read GetCoupons;
    property Attach: string Read GetAttach;
  end;

  TwxQueryOrderReponse = class(TwxXMLPayReponse, IwxQueryOrderReponse)
  private
    FBankType: string;
    FCashFee: Integer;
    FDeviceInfo: string;
    FIsSubscribe: Boolean;
    FOpenId: string;
    FOutTradeNo: string;
    FTimeEnd: TDateTime;
    FTotalFee: Integer;
    FTradeState: TwxTradeState;
    FTradeStateDesc: string;
    FTradeType: TwxTradeType;
    FTransactionId: string;
    FAttach: string;
    FCashFeeType: string;
    FCouponFee: Integer;
    FCoupons: TwxCoupons;
    FFeeType: string;
    FSettlementTotalFee: Integer;
    function GetBankType: string;
    function GetCashFee: Integer;
    function GetDeviceInfo: string;
    function GetIsSubscribe: Boolean;
    function GetOpenId: string;
    function GetOutTradeNo: string;
    function GetTimeEnd: TDateTime;
    function GetTotalFee: Integer;
    function GetTradeState: TwxTradeState;
    function GetTradeStateDesc: string;
    function GetTradeType: TwxTradeType;
    function GetTransactionId: string;
    function GetAttach: string;
    function GetCashFeeType: string;
    function GetCouponFee: Integer;
    function GetCoupons: TwxCoupons;
    function GetFeeType: string;
    function GetSettlementTotalFee: Integer;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property TradeType: TwxTradeType read GetTradeType;
    property TradeState: TwxTradeState read GetTradeState;
    property OpenId: string read GetOpenId;
    property IsSubscribe: Boolean read GetIsSubscribe;
    property BankType: string read GetBankType;
    property TotalFee: Integer read GetTotalFee;
    property CashFee: Integer read GetCashFee;
    property TransactionId: string read GetTransactionId;
    property OutTradeNo: string read GetOutTradeNo;
    property TimeEnd: TDateTime read GetTimeEnd;
    property TradeStateDesc: string read GetTradeStateDesc;
    property DeviceInfo: string Read GetDeviceInfo;
    property SettlementTotalFee: Integer Read GetSettlementTotalFee;
    property FeeType: string Read GetFeeType;
    property CashFeeType: string Read GetCashFeeType;
    property CouponFee: Integer Read GetCouponFee;
    property Coupons: TwxCoupons Read GetCoupons;
    property Attach: string Read GetAttach;
  end;

  IwxCloseOrderRequest = interface(IwxXMLPayRequest)
  ['{05A7869F-B2E0-4CB8-A016-B0B7958EDB6E}']
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
  end;

  TwxCloseOrderRequest = class(TwxXMLPayRequest, IwxCloseOrderRequest)
  private
    FOutTradeNo: string;
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
  end;

  IwxCloseOrderReponse = interface(IwxXMLPayReponse)
  ['{AE924390-BB96-4F3C-8D34-0A3FA0E84902}']
    function GetResultMsg: string;
    property ResultMsg: string read GetResultMsg;
  end;

  TwxCloseOrderReponse = class(TwxXMLPayReponse, IwxCloseOrderReponse)
  private
    FResultMsg: string;
    function GetResultMsg: string;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property ResultMsg: string read GetResultMsg;
  end;

  IwxMicroPayRequest = interface(IwxXMLPayRequest)
  ['{00FCAB00-37A8-4784-A7FC-1A4F948070D6}']
    function GetBody: string;
    procedure SetBody(const Value: string);
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    function GetTotalFee: Integer;
    procedure SetTotalFee(const Value: Integer);
    function GetSpbillCreateIp: string;
    procedure SetSpbillCreateIp(const Value: string);
    function GetAttach: string;
    function GetDetail: string;
    function GetDeviceInfo: string;
    function GetFeeType: string;
    function GetGoodsTag: string;
    function GetLimitPay: string;
    function GetReceipt: string;
    function GetSceneInfo: string;
    procedure SetSceneInfo(const Value: string);
    function GetTimeExpire: TDateTime;
    function GetTimeStart: TDateTime;
    function GetAuthCode: string;
    procedure SetAuthCode(const Value: string);
    procedure SetAttach(const Value: string);
    procedure SetDetail(const Value: string);
    procedure SetFeeType(const Value: string);
    procedure SetGoodsTag(const Value: string);
    procedure SetLimitPay(const Value: string);
    procedure SetDeviceInfo(const Value: string);
    procedure SetReceipt(const Value: string);
    procedure SetTimeExpire(const Value: TDateTime);
    procedure SetTimeStart(const Value: TDateTime);
    //----------begin 必填----------
    property Body: string read GetBody write SetBody;
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    property TotalFee: Integer read GetTotalFee write SetTotalFee;
    property SpbillCreateIp: string read GetSpbillCreateIp write SetSpbillCreateIp;
    property AuthCode: string read GetAuthCode write SetAuthCode;
    //----------end 必填----------
    property DeviceInfo: string Read GetDeviceInfo write SetDeviceInfo;
    property Detail: string Read GetDetail write SetDetail;
    property Attach: string Read GetAttach write SetAttach;
    property FeeType: string Read GetFeeType write SetFeeType;
    property TimeStart: TDateTime Read GetTimeStart write SetTimeStart;
    property TimeExpire: TDateTime Read GetTimeExpire write SetTimeExpire;
    property GoodsTag: string Read GetGoodsTag write SetGoodsTag;
    property LimitPay: string Read GetLimitPay write SetLimitPay;
    property Receipt: string Read GetReceipt write SetReceipt;
    property SceneInfo: string Read GetSceneInfo write SetSceneInfo;
  end;

  TwxMicroPayRequest = class(TwxXMLPayRequest, IwxMicroPayRequest)
  private
    FBody: string;
    FOutTradeNo: string;
    FTotalFee: Integer;
    FSpbillCreateIp: string;
    FDeviceInfo: string;
    FDetail: string;
    FAttach: string;
    FFeeType: string;
    FTimeStart: TDateTime;
    FTimeExpire: TDateTime;
    FGoodsTag: string;
    FLimitPay: string;
    FReceipt: string;
    FSceneInfo: string;
    FAuthCode: string;
    function GetBody: string;
    procedure SetBody(const Value: string);
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    function GetTotalFee: Integer;
    procedure SetTotalFee(const Value: Integer);
    function GetSpbillCreateIp: string;
    procedure SetSpbillCreateIp(const Value: string);
    function GetAttach: string;
    function GetDetail: string;
    function GetDeviceInfo: string;
    function GetFeeType: string;
    function GetGoodsTag: string;
    function GetLimitPay: string;
    function GetReceipt: string;
    function GetSceneInfo: string;
    procedure SetSceneInfo(const Value: string);
    function GetTimeExpire: TDateTime;
    function GetTimeStart: TDateTime;
    function GetAuthCode: string;
    procedure SetAuthCode(const Value: string);
    procedure SetAttach(const Value: string);
    procedure SetDetail(const Value: string);
    procedure SetFeeType(const Value: string);
    procedure SetGoodsTag(const Value: string);
    procedure SetLimitPay(const Value: string);
    procedure SetDeviceInfo(const Value: string);
    procedure SetReceipt(const Value: string);
    procedure SetTimeExpire(const Value: TDateTime);
    procedure SetTimeStart(const Value: TDateTime);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    //----------begin 必填----------
    property Body: string read GetBody write SetBody;
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    property TotalFee: Integer read GetTotalFee write SetTotalFee;
    property SpbillCreateIp: string read GetSpbillCreateIp write SetSpbillCreateIp;
    property AuthCode: string read GetAuthCode write SetAuthCode;
    //----------end 必填----------
    property DeviceInfo: string Read GetDeviceInfo write SetDeviceInfo;
    property Detail: string Read GetDetail write SetDetail;
    property Attach: string Read GetAttach write SetAttach;
    property FeeType: string Read GetFeeType write SetFeeType;
    property TimeStart: TDateTime Read GetTimeStart write SetTimeStart;
    property TimeExpire: TDateTime Read GetTimeExpire write SetTimeExpire;
    property GoodsTag: string Read GetGoodsTag write SetGoodsTag;
    property LimitPay: string Read GetLimitPay write SetLimitPay;
    property Receipt: string Read GetReceipt write SetReceipt;
    property SceneInfo: string Read GetSceneInfo write SetSceneInfo;
  end;

  IwxMicroPayReponse = interface(IwxXMLPayReponse)
  ['{0CCBE609-29B5-4EF7-8C92-A86DD1463A33}']
    function GeCashFee: Integer;
    function GetAttach: string;
    function GetBankType: string;
    function GetCashFeeType: string;
    function GetCouponFee: Integer;
    function GetDeviceInfo: string;
    function GetFeeType: string;
    function GetIsSubscribe: Boolean;
    function GetOpenId: string;
    function GetOutTradeNo: string;
    function GetPromotionDetail: string;
    function GetSettlementTotalFee: Integer;
    function GetTimeEnd: TDateTime;
    function GetTotalFee: Integer;
    function GetTradeType: TwxTradeType;
    function GetTransactionId: string;
    property TradeType: TwxTradeType read GetTradeType;
    property OpenId: string read GetOpenId;
    property IsSubscribe: Boolean read GetIsSubscribe;
    property BankType: string read GetBankType;
    property TotalFee: Integer read GetTotalFee;
    property CashFee: Integer read GeCashFee;
    property TransactionId: string read GetTransactionId;
    property OutTradeNo: string read GetOutTradeNo;
    property TimeEnd: TDateTime read GetTimeEnd;
    property DeviceInfo: string Read GetDeviceInfo;
    property FeeType: string read GetFeeType;
    property SettlementTotalFee: Integer read GetSettlementTotalFee;
    property CouponFee: Integer read GetCouponFee;
    property CashFeeType: string read GetCashFeeType;
    property Attach: string read GetAttach;
    property PromotionDetail: string read GetPromotionDetail;
  end;

  TwxMicroPayReponse = class(TwxXMLPayReponse, IwxMicroPayReponse)
  private
    FTradeType: TwxTradeType;
    FOpenId: string;
    FIsSubscribe: Boolean;
    FBankType: string;
    FTotalFee: Integer;
    FCashFee: Integer;
    FTransactionId: string;
    FOutTradeNo: string ;
    FTimeEnd: TDateTime;
    FDeviceInfo: string;
    FFeeType: string;
    FSettlementTotalFee: Integer;
    FCouponFee: Integer;
    FCashFeeType: string;
    FAttach: string;
    FPromotionDetail: string;
    function GeCashFee: Integer;
    function GetAttach: string;
    function GetBankType: string;
    function GetCashFeeType: string;
    function GetCouponFee: Integer;
    function GetDeviceInfo: string;
    function GetFeeType: string;
    function GetIsSubscribe: Boolean;
    function GetOpenId: string;
    function GetOutTradeNo: string;
    function GetPromotionDetail: string;
    function GetSettlementTotalFee: Integer;
    function GetTimeEnd: TDateTime;
    function GetTotalFee: Integer;
    function GetTradeType: TwxTradeType;
    function GetTransactionId: string;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property TradeType: TwxTradeType read GetTradeType;
    property OpenId: string read GetOpenId;
    property IsSubscribe: Boolean read GetIsSubscribe;
    property BankType: string read GetBankType;
    property TotalFee: Integer read GetTotalFee;
    property CashFee: Integer read GeCashFee;
    property TransactionId: string read GetTransactionId;
    property OutTradeNo: string read GetOutTradeNo;
    property TimeEnd: TDateTime read GetTimeEnd;
    property DeviceInfo: string Read GetDeviceInfo;
    property FeeType: string read GetFeeType;
    property SettlementTotalFee: Integer read GetSettlementTotalFee;
    property CouponFee: Integer read GetCouponFee;
    property CashFeeType: string read GetCashFeeType;
    property Attach: string read GetAttach;
    property PromotionDetail: string read GetPromotionDetail;
  end;

  IwxAuthCodeToOpenIdRequest = interface(IwxXMLPayRequest)
  ['{3C7EB308-F6D7-4552-A868-35DEE8352DC0}']
    function GetAuthCode: string;
    procedure SetAuthCode(const Value: string);
    property AuthCode: string read GetAuthCode write SetAuthCode;
  end;

  TwxAuthCodeToOpenIdRequest = class(TwxXMLPayRequest, IwxAuthCodeToOpenIdRequest)
  private
    FAuthCode: string;
    function GetAuthCode: string;
    procedure SetAuthCode(const Value: string);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    property AuthCode: string read GetAuthCode write SetAuthCode;
  end;

  IwxAuthCodeToOpenIdReponse = interface(IwxXMLPayReponse)
  ['{FFFFC64E-8A82-4DDE-ACA9-DB79ECF53A95}']
    function GetOpenId: string;
    property OpenId: string read GetOpenId;
  end;

  TwxAuthCodeToOpenIdReponse = class(TwxXMLPayReponse, IwxAuthCodeToOpenIdReponse)
  private
    FOpenId: string;
    function GetOpenId: string;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property OpenId: string read GetOpenId;
  end;

  IwxLongUrlToShortUrlRequest = interface(IwxXMLPayRequest)
  ['{A48C84E7-9A19-43D6-AC8B-FF29B82F44C0}']
    function GetLongUrl: string;
    procedure SetLongUrl(const Value: string);
    property LongUrl: string read GetLongUrl write SetLongUrl;
  end;

  TwxLongUrlToShortUrlRequest = class(TwxXMLPayRequest, IwxLongUrlToShortUrlRequest)
  private
    FLongUrl: string;
    function GetLongUrl: string;
    procedure SetLongUrl(const Value: string);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    property LongUrl: string read GetLongUrl write SetLongUrl;
  end;

  IwxLongUrlToShortUrlReponse = interface(IwxXMLPayReponse)
  ['{3FBDAD60-213B-49DC-A6B6-E111E322CA2C}']
    function GetShortUrl: string;
    property ShortUrl: string read GetShortUrl;
  end;

  TwxLongUrlToShortUrlReponse = class(TwxXMLPayReponse, IwxLongUrlToShortUrlReponse)
  private
    FShortUrl: string;
    function GetShortUrl: string;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property ShortUrl: string read GetShortUrl;
  end;

  IwxReverseRequest = interface(IwxXMLPayRequest)
  ['{207C53D6-FB72-46C3-AEC3-ECA3429007BC}']
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    function GetTransactionId: string;
    procedure SetTransactionId(const Value: string);
    //----------begin 必填----------
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    //----------end 必填----------
    property TransactionId: string Read GetTransactionId write SetTransactionId;
  end;

  TwxReverseRequest = class(TwxXMLPayRequest, IwxReverseRequest)
  private
    FOutTradeNo: string;
    FTransactionId: string;
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    function GetTransactionId: string;
    procedure SetTransactionId(const Value: string);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    //----------begin 必填----------
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    //----------end 必填----------
    property TransactionId: string Read GetTransactionId write SetTransactionId;
  end;

  IwxReverseReponse = interface(IwxXMLPayReponse)
  ['{E63CE615-AB8F-4644-A0B7-A5B30629DA07}']
    function GetRecall: Boolean;
    property Recall: Boolean read GetRecall;
  end;

  TwxReverseReponse = class(TwxXMLPayReponse, IwxReverseReponse)
  private
    FRecall: Boolean;
    function GetRecall: Boolean;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property Recall: Boolean read GetRecall;
  end;

  IwxRefundRequest = interface(IwxXMLPayRequest)
  ['{BBC8D1B0-7729-4BC5-A064-C4C1489881C2}']
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    function GetTransactionId: string;
    procedure SetTransactionId(const Value: string);
    function GetOutRefundNo: string;
    procedure SetOutRefundNo(const Value: string);
    function GetTotalFee: Integer;
    procedure SetTotalFee(const Value: Integer);
    function GetRefundFee: Integer;
    procedure SetRefundFee(const Value: Integer);
    function GetRefundFeeType: string;
    procedure SetRefundFeeType(const Value: string);
    function GetRefundDesc: string;
    procedure SetRefundDesc(const Value: string);
    function GetRefundAccount: string;
    procedure SetRefundAccount(const Value: string);
    function GetNotifyUrl: string;
    procedure SetNotifyUrl(const Value: string);
    //----------begin 必填----------
    property OutRefundNo: string read GetOutRefundNo write SetOutRefundNo;
    property TotalFee: Integer read GetTotalFee write SetTotalFee;
    property RefundFee: Integer read GetRefundFee write SetRefundFee;
    //----------end 必填----------
    //二选一，如果同时存在优先级：TransactionId > OutTradeNo
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    property TransactionId: string Read GetTransactionId write SetTransactionId;
    //选填
    property RefundFeeType: string Read GetRefundFeeType write SetRefundFeeType;
    property RefundDesc: string Read GetRefundDesc write SetRefundDesc;
    property RefundAccount: string Read GetRefundAccount write SetRefundAccount;
    property NotifyUrl: string Read GetNotifyUrl write SetNotifyUrl;
  end;

  TwxRefundRequest = class(TwxXMLPayRequest, IwxRefundRequest)
  private
    FOutRefundNo: string;
    FTotalFee: Integer;
    FRefundFee: Integer;
    FOutTradeNo: string;
    FTransactionId: string;
    FRefundFeeType: string;
    FRefundDesc: string;
    FRefundAccount: string;
    FNotifyUrl: string;
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    function GetTransactionId: string;
    procedure SetTransactionId(const Value: string);
    function GetOutRefundNo: string;
    procedure SetOutRefundNo(const Value: string);
    function GetTotalFee: Integer;
    procedure SetTotalFee(const Value: Integer);
    function GetRefundFee: Integer;
    procedure SetRefundFee(const Value: Integer);
    function GetRefundFeeType: string;
    procedure SetRefundFeeType(const Value: string);
    function GetRefundDesc: string;
    procedure SetRefundDesc(const Value: string);
    function GetRefundAccount: string;
    procedure SetRefundAccount(const Value: string);
    function GetNotifyUrl: string;
    procedure SetNotifyUrl(const Value: string);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    //----------begin 必填----------
    property OutRefundNo: string read GetOutRefundNo write SetOutRefundNo;
    property TotalFee: Integer read GetTotalFee write SetTotalFee;
    property RefundFee: Integer read GetRefundFee write SetRefundFee;
    //----------end 必填----------
    //二选一，如果同时存在优先级：TransactionId > OutTradeNo
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    property TransactionId: string Read GetTransactionId write SetTransactionId;
    //选填
    property RefundFeeType: string Read GetRefundFeeType write SetRefundFeeType;
    property RefundDesc: string Read GetRefundDesc write SetRefundDesc;
    property RefundAccount: string Read GetRefundAccount write SetRefundAccount;
    property NotifyUrl: string Read GetNotifyUrl write SetNotifyUrl;
  end;

  IwxRefundReponse = interface(IwxXMLPayReponse)
  ['{2BC1EFDF-1881-423D-B2EC-1897AF5C0DBA}']
    function GetOutTradeNo: string;
    function GetTransactionId: string;
    function GetOutRefundNo: string;
    function GetRefundId: string;
    function GetRefundFee: Integer;
    function GetSettlementRefundFee: Integer;
    function GetTotalFee: Integer;
    function GetSettlementTotalFee: Integer;
    function GetFeeType: string;
    function GetCashFee: Integer;
    function GetCashFeeType: string;
    function GetCashRefundFee: Integer;
    function GetCouponRefundFee: Integer;
    function GetCouponRefundCount: Integer;
    function GetCouponRefunds: TwxCoupons;
    property OutTradeNo: string read GetOutTradeNo;
    property TransactionId: string Read GetTransactionId;
    property OutRefundNo: string read GetOutRefundNo;
    property RefundId: string read GetRefundId;
    property RefundFee: Integer read GetRefundFee;
    property SettlementRefundFee: Integer read GetSettlementRefundFee;
    property TotalFee: Integer read GetTotalFee;
    property SettlementTotalFee: Integer read GetSettlementTotalFee;
    property FeeType: string read GetFeeType;
    property CashFee: Integer read GetCashFee;
    property CashFeeType: string read GetCashFeeType;
    property CashRefundFee: Integer read GetCashRefundFee;
    property CouponRefundFee: Integer read GetCouponRefundFee;
    property CouponRefundCount: Integer read GetCouponRefundCount;
    property CouponRefunds: TwxCoupons read GetCouponRefunds;
  end;

  TwxRefundReponse = class(TwxXMLPayReponse, IwxRefundReponse)
  private
    FOutTradeNo: string;
    FTransactionId: string;
    FOutRefundNo: string;
    FRefundId: string;
    FRefundFee: Integer;
    FSettlementRefundFee: Integer;
    FTotalFee: Integer;
    FSettlementTotalFee: Integer;
    FFeeType: string;
    FCashFee: Integer;
    FCashFeeType: string;
    FCashRefundFee: Integer;
    FCouponRefundFee: Integer;
    FCouponRefundCount: Integer;
    FCouponRefunds: TwxCoupons;
    function GetOutTradeNo: string;
    function GetTransactionId: string;
    function GetOutRefundNo: string;
    function GetRefundId: string;
    function GetRefundFee: Integer;
    function GetSettlementRefundFee: Integer;
    function GetTotalFee: Integer;
    function GetSettlementTotalFee: Integer;
    function GetFeeType: string;
    function GetCashFee: Integer;
    function GetCashFeeType: string;
    function GetCashRefundFee: Integer;
    function GetCouponRefundFee: Integer;
    function GetCouponRefundCount: Integer;
    function GetCouponRefunds: TwxCoupons;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property OutTradeNo: string read GetOutTradeNo;
    property TransactionId: string Read GetTransactionId;
    property OutRefundNo: string read GetOutRefundNo;
    property RefundId: string read GetRefundId;
    property RefundFee: Integer read GetRefundFee;
    property SettlementRefundFee: Integer read GetSettlementRefundFee;
    property TotalFee: Integer read GetTotalFee;
    property SettlementTotalFee: Integer read GetSettlementTotalFee;
    property FeeType: string read GetFeeType;
    property CashFee: Integer read GetCashFee;
    property CashFeeType: string read GetCashFeeType;
    property CashRefundFee: Integer read GetCashRefundFee;
    property CouponRefundFee: Integer read GetCouponRefundFee;
    property CouponRefundCount: Integer read GetCouponRefundCount;
    property CouponRefunds: TwxCoupons read GetCouponRefunds;
  end;

  IwxQueryRefundRequest = interface(IwxXMLPayRequest)
  ['{94C3FA53-0A9C-4D87-BE3D-359A8143C53A}']
    function GetOutTradeNo: string;
    procedure SetOutTradeNo(const Value: string);
    function GetTransactionId: string;
    procedure SetTransactionId(const Value: string);
    function GetOutRefundNo: string;
    procedure SetOutRefundNo(const Value: string);
    function GetRefundId: string;
    procedure SetRefundId(const Value: string);
    function GetOffset: Integer;
    procedure SetOffset(const Value: Integer);
    //四选一，如果同时存在优先级：refund_id > out_refund_no > transaction_id > out_trade_no
    property TransactionId: string Read GetTransactionId write SetTransactionId;
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    property OutRefundNo: string read GetOutRefundNo write SetOutRefundNo;
    property RefundId: string read GetRefundId write SetRefundId;
    //选填
    property Offset: Integer Read GetOffset write SetOffset;
  end;

  TwxQueryRefundRequest = class(TwxXMLPayRequest, IwxQueryRefundRequest)
  private
    FTransactionId: string;
    FOutTradeNo: string;
    FOutRefundNo: string;
    FRefundId: string;
    FOffset: Integer;
    function GetOutTradeNo: string;
    function GetTransactionId: string;
    function GetOutRefundNo: string;
    function GetRefundId: string;
    function GetOffset: Integer;
    procedure SetOutTradeNo(const Value: string);
    procedure SetTransactionId(const Value: string);
    procedure SetOutRefundNo(const Value: string);
    procedure SetRefundId(const Value: string);
    procedure SetOffset(const Value: Integer);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    //四选一，如果同时存在优先级：refund_id > out_refund_no > transaction_id > out_trade_no
    property TransactionId: string Read GetTransactionId write SetTransactionId;
    property OutTradeNo: string read GetOutTradeNo write SetOutTradeNo;
    property OutRefundNo: string read GetOutRefundNo write SetOutRefundNo;
    property RefundId: string read GetRefundId write SetRefundId;
    //选填
    property Offset: Integer Read GetOffset write SetOffset;
  end;

  TwxRefund = record
    OutTradeNo: string;
    RefundId: string;
    RefundChannel: string;
    RefundFee: Integer;
    SettlementRefundFee: Integer;
    CouponRefundFee: Integer;
    CouponRefundCount: Integer;
    CouponRefunds: TwxCoupons;
    RefundStatus: string;
    RefundAccount: string;
    RefundRecvAccout: string;
    RefundSuccessTime: string;
  end;

  TwxRefunds = TArray<TwxRefund>;

  IwxQueryRefundReponse = interface(IwxXMLPayReponse)
  ['{575E3A62-2EEA-4091-A99B-77418993E8E5}']
    function GetOutTradeNo: string;
    function GetTransactionId: string;
    function GetTotalFee: Integer;
    function GetSettlementTotalFee: Integer;
    function GetFeeType: string;
    function GetCashFee: Integer;
    function GetTotalRefundCount: Integer;
    function GetRefundCount: Integer;
    function GetRefunds: TwxRefunds;
    property OutTradeNo: string read GetOutTradeNo;
    property TransactionId: string Read GetTransactionId;
    property TotalFee: Integer read GetTotalFee;
    property SettlementTotalFee: Integer read GetSettlementTotalFee;
    property FeeType: string read GetFeeType;
    property CashFee: Integer read GetCashFee;
    property TotalRefundCount: Integer read GetTotalRefundCount;
    property RefundCount: Integer read GetRefundCount;
    property Refunds: TwxRefunds read GetRefunds;
  end;

  TwxQueryRefundReponse = class(TwxXMLPayReponse, IwxQueryRefundReponse)
  private
    FOutTradeNo: string;
    FTransactionId: string;
    FTotalFee: Integer;
    FSettlementTotalFee: Integer;
    FFeeType: string;
    FCashFee: Integer;
    FTotalRefundCount: Integer;
    FRefundCount: Integer;
    FRefunds: TwxRefunds;
    function GetOutTradeNo: string;
    function GetTransactionId: string;
    function GetTotalFee: Integer;
    function GetSettlementTotalFee: Integer;
    function GetFeeType: string;
    function GetCashFee: Integer;
    function GetTotalRefundCount: Integer;
    function GetRefundCount: Integer;
    function GetRefunds: TwxRefunds;
  protected
    procedure DoInitFromXMLOther(RootNode: IXMLNode); override;
  public
    property OutTradeNo: string read GetOutTradeNo;
    property TransactionId: string Read GetTransactionId;
    property TotalFee: Integer read GetTotalFee;
    property SettlementTotalFee: Integer read GetSettlementTotalFee;
    property FeeType: string read GetFeeType;
    property CashFee: Integer read GetCashFee;
    property TotalRefundCount: Integer read GetTotalRefundCount;
    property RefundCount: Integer read GetRefundCount;
    property Refunds: TwxRefunds read GetRefunds;
  end;

  //扫码支付(模式一)回调输入参数
  IwxBizPayInputParams = interface(IwxXML)
  ['{E19AA186-942C-4761-BFB9-11C8FDA557B9}']
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetSign: string;
    function GetOpenId: string;
    function GetIsSubscribe: Boolean;
    function GetProductId: string;
    function ValidSign(const Key: string): Boolean;
    property AppId: string read GetAppId;
    property MchId: string read GetMchId;
    property NonceStr: string read GetNonceStr;
    property Sign: string read GetSign;
    property OpenId: string read GetOpenId;
    property IsSubscribe: Boolean read GetIsSubscribe;
    property ProductId: string read GetProductId;
  end;

  TwxBizPayInputParams = class(TwxXML, IwxBizPayInputParams)
  private
    FAppId: string;
    FMchId: string;
    FNonceStr: string;
    FSign: string;
    FOpenId: string;
    FIsSubscribe: Boolean;
    FProductId: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetSign: string;
    function GetOpenId: string;
    function GetIsSubscribe: Boolean;
    function GetProductId: string;
  protected
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    function ValidSign(const Key: string): Boolean;
    property AppId: string read GetAppId;
    property MchId: string read GetMchId;
    property NonceStr: string read GetNonceStr;
    property Sign: string read GetSign;
    property OpenId: string read GetOpenId;
    property IsSubscribe: Boolean read GetIsSubscribe;
    property ProductId: string read GetProductId;
  end;

  //扫码支付(模式一)回调输出参数
  IwxBizPayOutputParams = interface(IwxXML)
  ['{2EF73B1D-DEE8-42F1-8822-218667675136}']
    function GetReturnCode: TwxPayReturnCode;
    function GetReturnMsg: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetResultCode: TwxPayResultCode;
    function GetErrCodeDes: string;
    function GetPrepayId: string;
    procedure SetReturnCode(const Value: TwxPayReturnCode);
    procedure SetReturnMsg(const Value: string);
    procedure SetAppId(const Value: string);
    procedure SetMchId(const Value: string);
    procedure SetNonceStr(const Value: string);
    procedure SetResultCode(const Value: TwxPayResultCode);
    procedure SetErrCodeDes(const Value: string);
    procedure SetPrepayId(const Value: string);
    function XMLWithSign(const Key: string): string;
    property ReturnCode: TwxPayReturnCode read GetReturnCode write SetReturnCode;
    property ReturnMsg: string read GetReturnMsg write SetReturnMsg;
    property AppId: string read GetAppId write SetAppId;
    property MchId: string read GetMchId write SetMchId;
    property NonceStr: string read GetNonceStr write SetNonceStr;
    property ResultCode: TwxPayResultCode read GetResultCode write SetResultCode;
    property ErrCodeDes: string read GetErrCodeDes write SetErrCodeDes;
    property PrepayId: string read GetPrepayId write SetPrepayId;
  end;

  TwxBizPayOutputParams = class(TwxXML, IwxBizPayOutputParams)
  private
    FReturnCode: TwxPayReturnCode;
    FReturnMsg: string;
    FAppId: string;
    FMchId: string;
    FNonceStr: string;
    FResultCode: TwxPayResultCode;
    FErrCodeDes: string;
    FPrepayId: string;
    function GetReturnCode: TwxPayReturnCode;
    function GetReturnMsg: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetResultCode: TwxPayResultCode;
    function GetErrCodeDes: string;
    function GetPrepayId: string;
    procedure SetReturnCode(const Value: TwxPayReturnCode);
    procedure SetReturnMsg(const Value: string);
    procedure SetAppId(const Value: string);
    procedure SetMchId(const Value: string);
    procedure SetNonceStr(const Value: string);
    procedure SetResultCode(const Value: TwxPayResultCode);
    procedure SetErrCodeDes(const Value: string);
    procedure SetPrepayId(const Value: string);
  protected
    procedure DoBuildXML(RootNode: IXMLNode); override;
  public
    constructor Create; override;
    function XMLWithSign(const Key: string): string;
    //-----begin 必填-------
    property ReturnCode: TwxPayReturnCode read GetReturnCode write SetReturnCode;
    property AppId: string read GetAppId write SetAppId;
    property MchId: string read GetMchId write SetMchId;
    property NonceStr: string read GetNonceStr write SetNonceStr;
    property ResultCode: TwxPayResultCode read GetResultCode write SetResultCode;
    property PrepayId: string read GetPrepayId write SetPrepayId;
    //-----end 必填-------
    property ReturnMsg: string read GetReturnMsg write SetReturnMsg;
    property ErrCodeDes: string read GetErrCodeDes write SetErrCodeDes;
  end;

  //支付结果通知
  IwxPayNotification = interface(IwxXML)
  ['{19294D13-D8E6-4022-89F9-9D4BADA5AD55}']
    function GetReturnCode: TwxPayReturnCode;
    function GetReturnMsg: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetSign: string;
    function GetSignType: TwxSignType;
    function GetErrCode: string;
    function GetErrCodeDes: string;
    function GetResultCode: TwxPayResultCode;
    function GetBankType: string;
    function GetCashFee: Integer;
    function GetDeviceInfo: string;
    function GetIsSubscribe: Boolean;
    function GetOpenId: string;
    function GetOutTradeNo: string;
    function GetTimeEnd: TDateTime;
    function GetTotalFee: Integer;
    function GetTradeType: TwxTradeType;
    function GetTransactionId: string;
    function GetAttach: string;
    function GetCashFeeType: string;
    function GetCouponFee: Integer;
    function GetCoupons: TwxCoupons;
    function GetFeeType: string;
    property ReturnCode: TwxPayReturnCode read GetReturnCode;
    property ReturnMsg: string read GetReturnMsg;
    property AppId: string read GetAppId;
    property MchId: string read GetMchId;
    property NonceStr: string read GetNonceStr;
    property Sign: string read GetSign;
    property SignType: TwxSignType read GetSignType;
    property ResultCode: TwxPayResultCode read GetResultCode;
    property ErrCode: string read GetErrCode;
    property ErrCodeDes: string read GetErrCodeDes;
    property TradeType: TwxTradeType read GetTradeType;
    property OpenId: string read GetOpenId;
    property IsSubscribe: Boolean read GetIsSubscribe;
    property BankType: string read GetBankType;
    property TotalFee: Integer read GetTotalFee;
    property CashFee: Integer read GetCashFee;
    property TransactionId: string read GetTransactionId;
    property OutTradeNo: string read GetOutTradeNo;
    property TimeEnd: TDateTime read GetTimeEnd;
    property DeviceInfo: string Read GetDeviceInfo;
    property FeeType: string Read GetFeeType;
    property CashFeeType: string Read GetCashFeeType;
    property CouponFee: Integer Read GetCouponFee;
    property Coupons: TwxCoupons Read GetCoupons;
    property Attach: string Read GetAttach;
  end;

  TwxPayNotification = class(TwxXML, IwxPayNotification)
  public const
    SUCCESS = '<xml>'#13#10+
              '<return_code><![CDATA[SUCCESS]]></return_code>'#13#10+
              '<return_msg><![CDATA[OK]]></return_msg>'#13#10+
              '</xml>';
  private
    FReturnCode: TwxPayReturnCode;
    FReturnMsg: string;
    FAppId: string;
    FMchId: string;
    FNonceStr: string;
    FSign: string;
    FSignType: TwxSignType;
    FErrCode: string;
    FErrCodeDes: string;
    FResultCode: TwxPayResultCode;
    FBankType: string;
    FCashFee: Integer;
    FDeviceInfo: string;
    FIsSubscribe: Boolean;
    FOpenId: string;
    FOutTradeNo: string;
    FTimeEnd: TDateTime;
    FTotalFee: Integer;
    FTradeType: TwxTradeType;
    FTransactionId: string;
    FAttach: string;
    FCashFeeType: string;
    FCouponFee: Integer;
    FCoupons: TwxCoupons;
    FFeeType: string;
    function GetReturnCode: TwxPayReturnCode;
    function GetReturnMsg: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetSign: string;
    function GetSignType: TwxSignType;
    function GetErrCode: string;
    function GetErrCodeDes: string;
    function GetResultCode: TwxPayResultCode;
    function GetBankType: string;
    function GetCashFee: Integer;
    function GetDeviceInfo: string;
    function GetIsSubscribe: Boolean;
    function GetOpenId: string;
    function GetOutTradeNo: string;
    function GetTimeEnd: TDateTime;
    function GetTotalFee: Integer;
    function GetTradeType: TwxTradeType;
    function GetTransactionId: string;
    function GetAttach: string;
    function GetCashFeeType: string;
    function GetCouponFee: Integer;
    function GetCoupons: TwxCoupons;
    function GetFeeType: string;
  protected
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property ReturnCode: TwxPayReturnCode read GetReturnCode;
    property ReturnMsg: string read GetReturnMsg;
    property AppId: string read GetAppId;
    property MchId: string read GetMchId;
    property NonceStr: string read GetNonceStr;
    property Sign: string read GetSign;
    property SignType: TwxSignType read GetSignType;
    property ResultCode: TwxPayResultCode read GetResultCode;
    property ErrCode: string read GetErrCode;
    property ErrCodeDes: string read GetErrCodeDes;
    property TradeType: TwxTradeType read GetTradeType;
    property OpenId: string read GetOpenId;
    property IsSubscribe: Boolean read GetIsSubscribe;
    property BankType: string read GetBankType;
    property TotalFee: Integer read GetTotalFee;
    property CashFee: Integer read GetCashFee;
    property TransactionId: string read GetTransactionId;
    property OutTradeNo: string read GetOutTradeNo;
    property TimeEnd: TDateTime read GetTimeEnd;
    property DeviceInfo: string Read GetDeviceInfo;
    property FeeType: string Read GetFeeType;
    property CashFeeType: string Read GetCashFeeType;
    property CouponFee: Integer Read GetCouponFee;
    property Coupons: TwxCoupons Read GetCoupons;
    property Attach: string Read GetAttach;
  end;

  TwxRefundNotificationReqDetail = record
    TransactionId: string;
    OutTradeNo: string;
    RefundId: string;
    OutRefundNo: string;
    TotalFee: Integer;
    SettlementTotalFee: Integer;
    RefundFee: Integer;
    SettlementRefundFee: Integer;
    RefundStatus: string;
    SuccessTime: string;
    RefundRecvAccout: string;
    RefundAccount: string;
    RefundRequestSource: string;
  end;

  //退款结果通知
  IwxRefundNotification = interface(IwxXML)
  ['{C03553BA-0BFD-4C0B-A340-CF93A788EFCB}']
    function GetReturnCode: TwxPayReturnCode;
    function GetReturnMsg: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetReqInfo: string;
    function DecryptReqInfo(const Key: string): TwxRefundNotificationReqDetail;
    property ReturnCode: TwxPayReturnCode read GetReturnCode;
    property ReturnMsg: string read GetReturnMsg;
    property AppId: string read GetAppId;
    property MchId: string read GetMchId;
    property NonceStr: string read GetNonceStr;
    property ReqInfo: string read GetReqInfo;
  end;

  TwxRefundNotification = class(TwxXML, IwxRefundNotification)
  public const
    SUCCESS = '<xml>'#13#10+
              '<return_code><![CDATA[SUCCESS]]></return_code>'#13#10+
              '<return_msg><![CDATA[OK]]></return_msg>'#13#10+
              '</xml>';
  private
    FReturnCode: TwxPayReturnCode;
    FReturnMsg: string;
    FAppId: string;
    FMchId: string;
    FNonceStr: string;
    FReqInfo: string;
    function GetReturnCode: TwxPayReturnCode;
    function GetReturnMsg: string;
    function GetAppId: string;
    function GetMchId: string;
    function GetNonceStr: string;
    function GetReqInfo: string;
    function DecryptReqInfo(const Key: string): TwxRefundNotificationReqDetail;
  protected
    procedure DoInitFromXML(RootNode: IXMLNode); override;
  public
    property ReturnCode: TwxPayReturnCode read GetReturnCode;
    property ReturnMsg: string read GetReturnMsg;
    property AppId: string read GetAppId;
    property MchId: string read GetMchId;
    property NonceStr: string read GetNonceStr;
    property ReqInfo: string read GetReqInfo;
  end;

  IwxBrandWCPayRequest = interface
    function GetKey: string;
    function GetAppId: string;
    function GetNonceStr: string;
    function GetTimeStamp: TwxDateTime;
    function GetSignType: TwxSignType;
    function GetPrepayId: string;
    procedure SetKey(const Value: string);
    procedure SetAppId(const Value: string);
    procedure SetTimeStamp(const Value: TwxDateTime);
    procedure SetNonceStr(const Value: string);
    procedure SetSignType(const Value: TwxSignType);
    procedure SetPrepayId(const Value: string);
    function ToJSON: string;
    property Key: string read GetKey write SetKey;
    property AppId: string read GetAppId write SetAppId;
    property TimeStamp: TwxDateTime read GetTimeStamp write SetTimeStamp;
    property NonceStr: string read GetNonceStr write SetNonceStr;
    property SignType: TwxSignType read GetSignType write SetSignType;
    property PrepayId: string read GetPrepayId write SetPrepayId;
  end;

  TwxBrandWCPayRequest = class(TInterfacedObject, IwxBrandWCPayRequest)
  private
    FKey: string;
    FAppId: string;
    FNonceStr: string;
    FTimeStamp: TwxDateTime;
    FSignType: TwxSignType;
    FPrepayId: string;
    function GetKey: string;
    function GetAppId: string;
    function GetNonceStr: string;
    function GetTimeStamp: TwxDateTime;
    function GetSignType: TwxSignType;
    function GetPrepayId: string;
    procedure SetKey(const Value: string);
    procedure SetAppId(const Value: string);
    procedure SetTimeStamp(const Value: TwxDateTime);
    procedure SetNonceStr(const Value: string);
    procedure SetSignType(const Value: TwxSignType);
    procedure SetPrepayId(const Value: string);
  public
    constructor Create;
    function ToJSON: string;
    property Key: string read GetKey write SetKey;
    property AppId: string read GetAppId write SetAppId;
    property TimeStamp: TwxDateTime read GetTimeStamp write SetTimeStamp;
    property NonceStr: string read GetNonceStr write SetNonceStr;
    property SignType: TwxSignType read GetSignType write SetSignType;
    property PrepayId: string read GetPrepayId write SetPrepayId;
  end;

  IwxPay = interface
    function UnifiedOrder(Request: IwxUnifiedOrderRequest): IwxUnifiedOrderReponse;//统一下单
    function QueryOrder(Request: IwxQueryOrderRequest): IwxQueryOrderReponse;//查询订单
    function CloseOrder(Request: IwxCloseOrderRequest): IwxCloseOrderReponse;//关闭订单
    function Reverse(Request: IwxReverseRequest): IwxReverseReponse;//撤销订单
    function Refund(Request: IwxRefundRequest): IwxRefundReponse;//申请退款
    function QueryRefund(Request: IwxQueryRefundRequest): IwxQueryRefundReponse;//查询退款
    function MicroPay(Request: IwxMicroPayRequest): IwxMicroPayReponse;//付款码支付
    //按授权码查询openid
    function AuthCodeToOpenId(const AuthCode: string): string;
    //生成'扫一扫'支付链接
    function GetBizPayUrl(const ProductId: string; ToShortUrl: Boolean{是否转换成短链接}): string;
    //Native支付模式一中的二维码链接转成短链接(weixin://wxpay/s/XXXXXX)，减小二维码数据量，提升扫描速度和精确度
    function LongUrlToShortUrl(const BizPayUrl: string): string;
    //生成微信内H5调起支付getBrandWCPayRequest方法的参数，注意SignType需与统一下单的签名类型一致
    function GetBrandWCPayRequest(const PrepayId: string; SignType: TwxSignType = stMD5): IwxBrandWCPayRequest;
    procedure DownloadBill(BillType: TwxBillType; BillDate: TDate;
      out DetailData, SumData: Variant); //下载对账单
    procedure DownloadFundFlow(AccountType: TwxAccountType; //下载资金账单
      BillDate: TDate; out DetailData, SumData: Variant);
    procedure BatchQueryComment(BeginDate, EndDate: TDate;//拉取订单评价数据
      Offset: Integer; out CommentData: Variant);
  end;

  IwxPayBuilder = interface
  ['{39A82E4F-2407-49EA-8CD4-D7D40661A498}']
    function AppId(const AppId: String): IwxPayBuilder;
    function MchId(const MchId: String): IwxPayBuilder;
    function Key(const Key: String): IwxPayBuilder;
    function AutoReport(const AutoReport: Boolean): IwxPayBuilder;
    function UseSandbox(const UseSandbox: Boolean): IwxPayBuilder;
    function Build: IwxPay;
  end;

  TwxPayBuilder = class(TInterfacedObject, IwxPayBuilder)
  private
    FAppId: string;
    FMchId: string;
    FKey: string;
    FAutoReport: Boolean;
    FUseSandbox: Boolean;
  public
    class function New: IwxPayBuilder;
    function AppId(const AppId: String): IwxPayBuilder;
    function MchId(const MchId: String): IwxPayBuilder;
    function Key(const Key: String): IwxPayBuilder;
    function AutoReport(const AutoReport: Boolean): IwxPayBuilder;
    function UseSandbox(const UseSandbox: Boolean): IwxPayBuilder;
    function Build: IwxPay;
  end;

implementation

uses
  WX.Utils, System.Diagnostics, System.Threading, WX.Pay.Report,
  System.NetEncoding, System.Hash, AES, ElAES;

const
  WX_PAY_DOMAIN_API = 'api.mch.weixin.qq.com';

  MICROPAY_URL_SUFFIX     = '/pay/micropay';
  UNIFIEDORDER_URL_SUFFIX = '/pay/unifiedorder';
  ORDERQUERY_URL_SUFFIX   = '/pay/orderquery';
  REVERSE_URL_SUFFIX      = '/secapi/pay/reverse';
  CLOSEORDER_URL_SUFFIX   = '/pay/closeorder';
  REFUND_URL_SUFFIX       = '/secapi/pay/refund';
  REFUNDQUERY_URL_SUFFIX  = '/pay/refundquery';
  DOWNLOADBILL_URL_SUFFIX = '/pay/downloadbill';
  REPORT_URL_SUFFIX       = '/payitil/report';
  SHORTURL_URL_SUFFIX     = '/tools/shorturl';
  AUTHCODETOOPENID_URL_SUFFIX = '/tools/authcodetoopenid';
  DOWNLOADFUNDFLOW_URL_SUFFIX = '/pay/downloadfundflow';
  BATCHQUERYCOMMENT_URL_SUFFIX = '/billcommentsp/batchquerycomment';

  // sandbox
  SANDBOX_MICROPAY_URL_SUFFIX     = '/sandboxnew/pay/micropay';
  SANDBOX_UNIFIEDORDER_URL_SUFFIX = '/sandboxnew/pay/unifiedorder';
  SANDBOX_ORDERQUERY_URL_SUFFIX   = '/sandboxnew/pay/orderquery';
  SANDBOX_REVERSE_URL_SUFFIX      = '/sandboxnew/secapi/pay/reverse';
  SANDBOX_CLOSEORDER_URL_SUFFIX   = '/sandboxnew/pay/closeorder';
  SANDBOX_REFUND_URL_SUFFIX       = '/sandboxnew/secapi/pay/refund';
  SANDBOX_REFUNDQUERY_URL_SUFFIX  = '/sandboxnew/pay/refundquery';
  SANDBOX_DOWNLOADBILL_URL_SUFFIX = '/sandboxnew/pay/downloadbill';
  SANDBOX_REPORT_URL_SUFFIX       = '/sandboxnew/payitil/report';
  SANDBOX_SHORTURL_URL_SUFFIX     = '/sandboxnew/tools/shorturl';
  SANDBOX_AUTHCODETOOPENID_URL_SUFFIX = '/sandboxnew/tools/authcodetoopenid';
  SANDBOX_DOWNLOADFUNDFLOW_URL_SUFFIX = '/sandboxnew/pay/downloadfundflow';
  SANDBOX_BATCHQUERYCOMMENT_URL_SUFFIX = '/sandboxnew/billcommentsp/batchquerycomment';

type
  //线程安全
  TwxPay = class(TInterfacedObject, IwxPay)
  private
    {begin IwxPay}
    function UnifiedOrder(Request: IwxUnifiedOrderRequest): IwxUnifiedOrderReponse;//统一下单
    function QueryOrder(Request: IwxQueryOrderRequest): IwxQueryOrderReponse;//查询订单
    function CloseOrder(Request: IwxCloseOrderRequest): IwxCloseOrderReponse;//关闭订单
    function Reverse(Request: IwxReverseRequest): IwxReverseReponse;//撤销订单
    function Refund(Request: IwxRefundRequest): IwxRefundReponse;//申请退款
    function QueryRefund(Request: IwxQueryRefundRequest): IwxQueryRefundReponse;//查询退款
    function MicroPay(Request: IwxMicroPayRequest): IwxMicroPayReponse;//付款码支付
    //按授权码查询openid
    function AuthCodeToOpenId(const AuthCode: string): string;
    //生成'扫一扫'支付链接
    function GetBizPayUrl(const ProductId: string; ToShortUrl: Boolean{是否转换成短链接}): string;
    //Native支付模式一中的二维码链接转成短链接(weixin://wxpay/s/XXXXXX)，减小二维码数据量，提升扫描速度和精确度
    function LongUrlToShortUrl(const LongUrl: string): string;
    //生成微信内H5调起支付getBrandWCPayRequest方法的参数，注意SignType需与统一下单的签名类型一致
    function GetBrandWCPayRequest(const PrepayId: string; SignType: TwxSignType = stMD5): IwxBrandWCPayRequest;
    procedure DownloadBill(BillType: TwxBillType; BillDate: TDate;
      out DetailData, SumData: Variant); //下载对账单
    procedure DownloadFundFlow(AccountType: TwxAccountType; //下载资金账单
      BillDate: TDate; out DetailData, SumData: Variant);
    procedure BatchQueryComment(BeginDate, EndDate: TDate;//拉取订单评价数据
      Offset: Integer; out CommentData: Variant);
    {end IwxPay}
  private
    FAppId: string;
    FMchId: string;
    FKey: string;
    FAutoReport: Boolean;//是否上报交易保障信息
    FUseSandbox: Boolean;//是否沙箱测试环境
    function GetURL(const UrlSuffix: string): string; inline;
    procedure DoReport(const AppId, MchId, Key, Url, ContentString: string;
      ExecuteTime: Integer); inline;
  protected
    function DoHTTPPost(Request: IwxXMLPayRequest; const url: string;
      UseCert: Boolean = False; ConnectionTimeout: Integer = 6000; ResponseTimeout: Integer = 8000): string;
  public
    constructor Create(const AppId, MchId, Key: string; AutoReport, UseSandbox: Boolean);
  end;

{ TwxPayBuilder }

function TwxPayBuilder.Build: IwxPay;
begin
  Result := TwxPay.Create(FAppId, FMchId, FKey, FAutoReport, FUseSandbox);
end;

class function TwxPayBuilder.New: IwxPayBuilder;
begin
  Result := TwxPayBuilder.Create;
  Result.AutoReport(True).UseSandbox(False);
end;

function TwxPayBuilder.AppId(const AppId: String): IwxPayBuilder;
begin
  FAppId := AppId;
  Result := Self;
end;

function TwxPayBuilder.AutoReport(const AutoReport: Boolean): IwxPayBuilder;
begin
  FAutoReport := AutoReport;
  Result := Self;
end;

function TwxPayBuilder.Key(const Key: String): IwxPayBuilder;
begin
  FKey := Key;
  Result := Self;
end;

function TwxPayBuilder.MchId(const MchId: String): IwxPayBuilder;
begin
  FMchId := MchId;
  Result := Self;
end;

function TwxPayBuilder.UseSandbox(const UseSandbox: Boolean): IwxPayBuilder;
begin
  FUseSandbox := UseSandbox;
  Result := Self;
end;

{ TwxPay }

constructor TwxPay.Create(const AppId, MchId, Key: string; AutoReport, UseSandbox: Boolean);
begin
  FAppId := AppId;
  FMchId := MchId;
  FKey := Key;
  FAutoReport := AutoReport;
  FUseSandbox := UseSandbox;
end;

function TwxPay.DoHTTPPost(Request: IwxXMLPayRequest; const url: string;
  UseCert: Boolean; ConnectionTimeout, ResponseTimeout: Integer): string;
var
  HTTPClient: IHTTPClient;
  Response: IHTTPResponse;
  ss: TStringStream;
  ContentString: string;
  sw: TStopwatch;
begin
  HTTPClient := WX.Utils.HTTPClient.Make;
  HTTPClient.ContentType := 'text/xml';
  HTTPClient.UserAgent := WX_PAYSDK_VERSION;
  HTTPClient.ConnectionTimeout := ConnectionTimeout;
  HTTPClient.ResponseTimeout := ResponseTimeout;
  ss := TStringStream.Create(Request.XMLWithSign(FKey, Request.SignType), TEncoding.UTF8);
  try
    ss.Position := 0;
    sw := TStopwatch.StartNew;
    Response := HTTPClient.Post(url, ss);
    sw.Stop;
    ContentString := Response.ContentAsString(TEncoding.UTF8);
    if not TWxHelper.ValidSign(ContentString, FKey, Request.SignType) then
      raise Exception.Create('请求返回非法数据, 验证Sign失败');
    if FAutoReport then
      DoReport(FAppId, FMchId, FKey, url, ContentString, sw.ElapsedMilliseconds);
    Result := ContentString;
  finally
    ss.Free;
  end;
end;

procedure TwxPay.DoReport(const AppId, MchId, Key, Url, ContentString: string; ExecuteTime: Integer);
begin
  TTask.Run(
    procedure
    var
      ContentDoc: TXMLDocument;
      Doc: TXMLDocument;
    begin
      ContentDoc := TXMLDocument.Create(nil);
      ContentDoc.DOMVendor := GetDOMVendor(sOmniXmlVendor);
      ContentDoc.Active := True;
      ContentDoc.LoadFromXML(ContentString);
      if (ContentDoc.DocumentElement.ChildNodes.FindNode('return_code') = nil) or
         (ContentDoc.DocumentElement.ChildNodes.FindNode('return_msg') = nil) or
         (ContentDoc.DocumentElement.ChildNodes.FindNode('result_code') = nil)
      then
        Exit;
      Doc:= TXMLDocument.Create(nil);
      Doc.DOMVendor := GetDOMVendor(sOmniXmlVendor);
      Doc.Active := True;
      Doc.DocumentElement.ChildValues['appid'] := AppId;
      Doc.DocumentElement.ChildValues['mch_id'] := MchId;
      Doc.DocumentElement.ChildValues['nonce_str'] := TWxHelper.GenNonceStr;
      Doc.DocumentElement.AddChild('interface_url').ChildNodes.Add(Doc.CreateNode(Url, ntCData));
      Doc.DocumentElement.ChildValues['execute_time'] := ExecuteTime;
      Doc.DocumentElement.ChildValues['return_code'] := ContentDoc.DocumentElement.ChildValues['return_code'];
      Doc.DocumentElement.ChildValues['return_msg'] := ContentDoc.DocumentElement.ChildValues['return_msg'];
      Doc.DocumentElement.ChildValues['result_code'] := ContentDoc.DocumentElement.ChildValues['result_code'];
      Doc.DocumentElement.ChildValues['user_ip'] := TWxHelper.GetLocalIP;
      Doc.DocumentElement.ChildValues['time'] := TWxHelper.DateTimeToWxDateTimeStr(Now);
      if ContentDoc.DocumentElement.ChildNodes.FindNode('err_code') <> nil then
        Doc.DocumentElement.ChildValues['err_code'] := ContentDoc.DocumentElement.ChildValues['err_code'];
      if ContentDoc.DocumentElement.ChildNodes.FindNode('err_code_des') <> nil then
        Doc.DocumentElement.ChildValues['err_code_des'] := ContentDoc.DocumentElement.ChildValues['err_code_des'];
      if ContentDoc.DocumentElement.ChildNodes.FindNode('out_trade_no') <> nil then
        Doc.DocumentElement.ChildValues['out_trade_no'] := ContentDoc.DocumentElement.ChildValues['out_trade_no'];
      if ContentDoc.DocumentElement.ChildNodes.FindNode('device_info') <> nil then
        Doc.DocumentElement.ChildValues['device_info'] := ContentDoc.DocumentElement.ChildValues['device_info'];
      Doc.DocumentElement.ChildValues['sign_type'] := stMD5.ToString;
      Doc.DocumentElement.ChildValues['sign'] := TWxHelper.GetSign(Doc, Key, stMD5);//必须放最后
      TwxPayReport.Instance.Enqueue(Doc.XML.Text);
    end);
end;

function TwxPay.GetURL(const UrlSuffix: string): string;
begin
  Result := Format('https://%s%s', [WX_PAY_DOMAIN_API, UrlSuffix]);
end;

function TwxPay.UnifiedOrder(Request: IwxUnifiedOrderRequest): IwxUnifiedOrderReponse;
var
  url: string;
begin
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  if FUseSandbox then
    url := GetURL(SANDBOX_UNIFIEDORDER_URL_SUFFIX)
  else
    url := GetURL(UNIFIEDORDER_URL_SUFFIX);
  Result := TwxUnifiedOrderReponse.Create(DoHTTPPost(Request, url));
end;

function TwxPay.QueryOrder(Request: IwxQueryOrderRequest): IwxQueryOrderReponse;
var
  url: string;
begin
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  if FUseSandbox then
    url := GetURL(SANDBOX_ORDERQUERY_URL_SUFFIX)
  else
    url := GetURL(ORDERQUERY_URL_SUFFIX);
  Result := TwxQueryOrderReponse.Create(DoHTTPPost(Request, url));
end;

function TwxPay.CloseOrder(Request: IwxCloseOrderRequest): IwxCloseOrderReponse;
var
  url: string;
begin
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  if FUseSandbox then
    url := GetURL(SANDBOX_CLOSEORDER_URL_SUFFIX)
  else
    url := GetURL(CLOSEORDER_URL_SUFFIX);
  Result := TwxCloseOrderReponse.Create(DoHTTPPost(Request, url));
end;

function TwxPay.Reverse(Request: IwxReverseRequest): IwxReverseReponse;
var
  url: string;
begin
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  if FUseSandbox then
    url := GetURL(SANDBOX_REVERSE_URL_SUFFIX)
  else
    url := GetURL(REVERSE_URL_SUFFIX);
  Result := TwxReverseReponse.Create(DoHTTPPost(Request, url, True));
end;

function TwxPay.Refund(Request: IwxRefundRequest): IwxRefundReponse;
var
  url: string;
begin
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  if FUseSandbox then
    url := GetURL(SANDBOX_REFUND_URL_SUFFIX)
  else
    url := GetURL(REFUND_URL_SUFFIX);
  Result := TwxRefundReponse.Create(DoHTTPPost(Request, url, True));
end;

function TwxPay.QueryRefund(
  Request: IwxQueryRefundRequest): IwxQueryRefundReponse;
var
  url: string;
begin
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  if FUseSandbox then
    url := GetURL(SANDBOX_REFUNDQUERY_URL_SUFFIX)
  else
    url := GetURL(REFUNDQUERY_URL_SUFFIX);
  Result := TwxQueryRefundReponse.Create(DoHTTPPost(Request, url, True));
end;

function TwxPay.MicroPay(Request: IwxMicroPayRequest): IwxMicroPayReponse;
var
  url: string;
begin
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  if FUseSandbox then
    url := GetURL(SANDBOX_MICROPAY_URL_SUFFIX)
  else
    url := GetURL(MICROPAY_URL_SUFFIX);
  Result := TwxMicroPayReponse.Create(DoHTTPPost(Request, url));
end;

function TwxPay.AuthCodeToOpenId(const AuthCode: string): string;
var
  url: string;
  Request: IwxAuthCodeToOpenIdRequest;
  Reponse: IwxAuthCodeToOpenIdReponse;
begin
  if FUseSandbox then
    url := GetURL(SANDBOX_AUTHCODETOOPENID_URL_SUFFIX)
  else
    url := GetURL(AUTHCODETOOPENID_URL_SUFFIX);
  Request := TwxAuthCodeToOpenIdRequest.Create;
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  Request.AuthCode := AuthCode;
  Reponse := TwxAuthCodeToOpenIdReponse.Create(DoHTTPPost(Request, url));
  if Reponse.ReturnCode = prcFail then
    raise Exception.Create('按授权码查询OpenId时，发生错误：' + Reponse.ReturnMsg);
  Result := Reponse.OpenId;
end;

function TwxPay.GetBizPayUrl(const ProductId: string; ToShortUrl: Boolean): string;
var
  XMLDocument: IXMLDocument;
  RootNode: IXMLNode;
begin
  XMLDocument := TXMLDocument.Create(nil);
  TXMLDocument(XMLDocument).DOMVendor := GetDOMVendor(sOmniXmlVendor);
  RootNode := XMLDocument.AddChild('xml');
  RootNode.ChildValues['appid'] := FAppId;
  RootNode.ChildValues['time_stamp'] := TWxHelper.DateTimeToWxTime(Now).ToString;
  RootNode.ChildValues['nonce_str'] := TWxHelper.GenNonceStr;
  RootNode.ChildValues['mch_id'] := FMchId;
  RootNode.ChildValues['product_id'] := ProductId;
  RootNode.ChildValues['sign'] := TWxHelper.GetSign(XMLDocument, FKey, stMD5);//必须放最后
  with RootNode do
    Result := Format('weixin://wxpay/bizpayurl?sign=%s&appid=%s&mch_id=%s&product_id=%s&time_stamp=%s&nonce_str=%s',
      [ChildValues['sign'], ChildValues['appid'], ChildValues['mch_id'], ChildValues['product_id'],
       ChildValues['time_stamp'], ChildValues['nonce_str']]);
  if ToShortUrl then
    Result := LongUrlToShortUrl(Result);
end;

function TwxPay.LongUrlToShortUrl(const LongUrl: string): string;
var
  url: string;
  Request: IwxLongUrlToShortUrlRequest;
  Reponse: IwxLongUrlToShortUrlReponse;
begin
  if FUseSandbox then
    url := GetURL(SANDBOX_AUTHCODETOOPENID_URL_SUFFIX)
  else
    url := GetURL(AUTHCODETOOPENID_URL_SUFFIX);
  Request := TwxLongUrlToShortUrlRequest.Create;
  Request.AppId := FAppId;
  Request.MchId := FMchId;
  Request.LongUrl := LongUrl;
  Reponse := TwxLongUrlToShortUrlReponse.Create(DoHTTPPost(Request, url));
  if Reponse.ReturnCode = prcFail then
    raise Exception.Create('转换短链接时，发生错误：' + Reponse.ReturnMsg);
  Result := Reponse.ShortUrl;
end;

function TwxPay.GetBrandWCPayRequest(const PrepayId: string;
  SignType: TwxSignType): IwxBrandWCPayRequest;
begin
  Result := TwxBrandWCPayRequest.Create;
  Result.Key := FKey;
  Result.AppId := FAppId;
  Result.PrepayId := PrepayId;
  Result.SignType := SignType;
end;

procedure TwxPay.DownloadBill(BillType: TwxBillType; BillDate: TDate;
  out DetailData, SumData: Variant);
const
  BillTypeStr: array[TwxBillType] of string = (
               'ALL',//（默认值），返回当日所有订单信息（不含充值退款订单）
               'SUCCESS',//返回当日成功支付的订单（不含充值退款订单）
               'REFUND',//返回当日退款订单（不含充值退款订单）
               'RECHARGE_REFUND');//返回当日充值退款订单
var
  XMLDocument: IXMLDocument;
  RootNode: IXMLNode;
  HTTPClient: IHTTPClient;
  Response: IHTTPResponse;
  ss: TStringStream;
  ContentString: string;
  ReturnCode: string;
  ReturnMsg: string;
  ErrorCode: string;
  url: string;
begin
  XMLDocument := TXMLDocument.Create(nil);
  TXMLDocument(XMLDocument).DOMVendor := GetDOMVendor(sOmniXmlVendor);
  RootNode := XMLDocument.AddChild('xml');
  RootNode.ChildValues['appid']     := FAppId;
  RootNode.ChildValues['nonce_str'] := TWxHelper.GenNonceStr;
  RootNode.ChildValues['mch_id']    := FMchId;
  RootNode.ChildValues['bill_date'] := FormatDateTime('yyyymmdd', BillDate);
  RootNode.ChildValues['bill_type'] := BillTypeStr[BillType];
  RootNode.ChildValues['tar_type']  := 'GZIP';
  RootNode.ChildValues['sign_type'] := stMD5.ToString;
  RootNode.ChildValues['sign']      := TWxHelper.GetSign(XMLDocument, FKey, stMD5);//必须放最后
  HTTPClient := WX.Utils.HTTPClient.Make;
  HTTPClient.UserAgent := WX_PAYSDK_VERSION;
  HTTPClient.ContentType := 'text/xml';
  ss := TStringStream.Create(XMLDocument.XML.ToString, TEncoding.UTF8);
  try
    ss.Position := 0;
    if FUseSandbox then
      url := GetURL(SANDBOX_DOWNLOADBILL_URL_SUFFIX)
    else
      url := GetURL(DOWNLOADBILL_URL_SUFFIX);
    Response := HTTPClient.Post(url, ss);
  finally
    ss.Free;
  end;
  ContentString := Response.ContentAsString(TEncoding.UTF8).Trim;
  if ContentString.StartsWith('<xml>') or ContentString.StartsWith('<XML>') then begin
    XMLDocument.LoadFromXML(ContentString);
    with XMLDocument.DocumentElement do begin
      ReturnCode := VarToStr(ChildValues['return_code']);
      if SameText(ReturnCode, 'FAIL') then begin
        if ChildNodes.FindNode('return_msg') <> nil then
          ReturnMsg := VarToStr(ChildValues['return_msg'])
        else
          ReturnMsg := '';
        if ChildNodes.FindNode('error_code') <> nil then
          ErrorCode := VarToStr(ChildValues['error_code'])
        else
          ErrorCode := '';
        raise Exception.CreateFmt('下载对账单出错: %s - %s', [ErrorCode, ReturnMsg]);
      end;
    end;
  end
  else TWxHelper.ParseBillText(ContentString, DetailData, SumData);
end;

procedure TwxPay.DownloadFundFlow(AccountType: TwxAccountType; BillDate: TDate;
  out DetailData, SumData: Variant);
const
  AccountTypeStr: array[TwxAccountType] of string = (
    'Basic',//基本账户
    'Operation',//运营账户
    'Fees');//手续费账户
var
  XMLDocument: IXMLDocument;
  RootNode: IXMLNode;
  HTTPClient: IHTTPClient;
  Response: IHTTPResponse;
  ss: TStringStream;
  ContentString: string;
  ReturnCode: string;
  ReturnMsg: string;
  ErrorCode: string;
  url: string;
begin
  XMLDocument := TXMLDocument.Create(nil);
  TXMLDocument(XMLDocument).DOMVendor := GetDOMVendor(sOmniXmlVendor);
  RootNode := XMLDocument.AddChild('xml');
  RootNode.ChildValues['appid']        := FAppId;
  RootNode.ChildValues['nonce_str']    := TWxHelper.GenNonceStr;
  RootNode.ChildValues['mch_id']       := FMchId;
  RootNode.ChildValues['bill_date']    := FormatDateTime('yyyymmdd', BillDate);
  RootNode.ChildValues['account_type'] := AccountTypeStr[AccountType];
  RootNode.ChildValues['tar_type']     := 'GZIP';
  RootNode.ChildValues['sign_type']    := stHMAC_SHA256.ToString;
  RootNode.ChildValues['sign']         := TWxHelper.GetSign(XMLDocument, FKey, stHMAC_SHA256);//必须放最后
  HTTPClient := WX.Utils.HTTPClient.Make;
  HTTPClient.UserAgent := WX_PAYSDK_VERSION;
  HTTPClient.ContentType := 'text/xml';
  ss := TStringStream.Create(XMLDocument.XML.ToString, TEncoding.UTF8);
  try
    ss.Position := 0;
    if FUseSandbox then
      url := GetURL(SANDBOX_DOWNLOADFUNDFLOW_URL_SUFFIX)
    else
      url := GetURL(DOWNLOADFUNDFLOW_URL_SUFFIX);
    Response := HTTPClient.Post(url, ss);
  finally
    ss.Free;
  end;
  ContentString := Response.ContentAsString(TEncoding.UTF8).Trim;
  if ContentString.StartsWith('<xml>') or ContentString.StartsWith('<XML>') then begin
    XMLDocument.LoadFromXML(ContentString);
    with XMLDocument.DocumentElement do begin
      if ChildValues['return_code'] = 'FAIL' then
        raise Exception.Create(ChildValues['return_msg']);
      ReturnCode := VarToStr(ChildValues['return_code']);
      if SameText(ReturnCode, 'FAIL') then begin
        if ChildNodes.FindNode('return_msg') <> nil then
          ReturnMsg := VarToStr(ChildValues['return_msg'])
        else
          ReturnMsg := '';
        if ChildNodes.FindNode('error_code') <> nil then
          ErrorCode := VarToStr(ChildValues['error_code'])
        else
          ErrorCode := '';
        raise Exception.CreateFmt('下载资金账单出错: %s - %s', [ErrorCode, ReturnMsg]);
      end;
    end;
  end
  else TWxHelper.ParseBillText(ContentString, DetailData, SumData);
end;

procedure TwxPay.BatchQueryComment(BeginDate, EndDate: TDate; Offset: Integer;
  out CommentData: Variant);
var
  XMLDocument: IXMLDocument;
  RootNode: IXMLNode;
  HTTPClient: IHTTPClient;
  Response: IHTTPResponse;
  ss: TStringStream;
  ContentString: string;
  ReturnCode: string;
  ReturnMsg: string;
  ResultCode: string;
  ErrorCode: string;
  ErrorCodeDes: string;
  url: string;
begin
  XMLDocument := TXMLDocument.Create(nil);
  TXMLDocument(XMLDocument).DOMVendor := GetDOMVendor(sOmniXmlVendor);
  RootNode := XMLDocument.AddChild('xml');
  RootNode.ChildValues['appid']      := FAppId;
  RootNode.ChildValues['nonce_str']  := TWxHelper.GenNonceStr;
  RootNode.ChildValues['mch_id']     := FMchId;
  RootNode.ChildValues['begin_time'] := TWxHelper.DateTimeToWxDateTimeStr(BeginDate);
  RootNode.ChildValues['end_time']   := TWxHelper.DateTimeToWxDateTimeStr(EndDate);
  RootNode.ChildValues['offset']     := Offset;
  RootNode.ChildValues['sign_type']  := stHMAC_SHA256.ToString;
  RootNode.ChildValues['sign']       := TWxHelper.GetSign(XMLDocument, FKey, stHMAC_SHA256);//必须放最后
  HTTPClient := WX.Utils.HTTPClient.Make;
  HTTPClient.UserAgent := WX_PAYSDK_VERSION;
  HTTPClient.ContentType := 'text/xml';
  ss := TStringStream.Create(XMLDocument.XML.ToString, TEncoding.UTF8);
  try
    ss.Position := 0;
    if FUseSandbox then
      url := GetURL(SANDBOX_BATCHQUERYCOMMENT_URL_SUFFIX)
    else
      url := GetURL(BATCHQUERYCOMMENT_URL_SUFFIX);
    Response := HTTPClient.Post(url, ss);
  finally
    ss.Free;
  end;
  ContentString := Response.ContentAsString(TEncoding.UTF8).Trim;
  if ContentString.StartsWith('<xml>') or ContentString.StartsWith('<XML>') then begin
    XMLDocument.LoadFromXML(ContentString);
    with XMLDocument.DocumentElement do begin
      ReturnCode := VarToStr(ChildValues['return_code']);
      ReturnMsg  := VarToStr(ChildValues['return_msg']);
      if ReturnCode = 'FAIL' then
        raise Exception.CreateFmt('下载资金账单出错: %s', [ReturnMsg]);
      ResultCode   := VarToStr(ChildValues['result_code']);
      ErrorCode    := VarToStr(ChildValues['err_code']);
      ErrorCodeDes := VarToStr(ChildValues['err_code_des']);
      if ResultCode = 'FAIL' then
        raise Exception.CreateFmt('下载资金账单出错: %s - %s', [ErrorCode, ErrorCodeDes]);
    end;
  end
  else TWxHelper.ParseCommentText(ContentString, CommentData);
end;

{ TwxUnifiedOrderRequest }

procedure TwxUnifiedOrderRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  //----begin 必填------
  RootNode.ChildValues['total_fee'] := TotalFee.ToString;
  AddCDATA(RootNode, 'notify_url', NotifyUrl);
  AddCDATA(RootNode, 'out_trade_no', OutTradeNo);
  AddCDATA(RootNode, 'body', Body);
  AddCDATA(RootNode, 'trade_type', TradeType.ToString);
  AddCDATA(RootNode, 'spbill_create_ip', SpbillCreateIp);
  //----end 必填------
  if not OpenId.IsEmpty     then AddCDATA(RootNode, 'openid', OpenId);
  if not DeviceInfo.IsEmpty then AddCDATA(RootNode, 'device_info', DeviceInfo);
  if not Detail.IsEmpty     then AddCDATA(RootNode, 'detail', Detail);
  if not Attach.IsEmpty     then AddCDATA(RootNode, 'attach', Attach);
  if not FeeType.IsEmpty    then AddCDATA(RootNode, 'fee_type', FeeType);
  if TimeStart <> 0         then RootNode.ChildValues['time_start'] := FormatDateTime('yyyymmddhhnnss', TimeStart);
  if TimeExpire <> 0        then RootNode.ChildValues['time_expire'] := FormatDateTime('yyyymmddhhnnss', TimeExpire);
  if not GoodsTag.IsEmpty   then AddCDATA(RootNode, 'goods_tag', GoodsTag);
  if not ProductId.IsEmpty  then AddCDATA(RootNode, 'product_id', ProductId);
  if not LimitPay.IsEmpty   then AddCDATA(RootNode, 'limit_pay', LimitPay);
  if not Receipt.IsEmpty    then AddCDATA(RootNode, 'receipt', Receipt);
  if not SceneInfo.IsEmpty  then AddCDATA(RootNode, 'scene_info', SceneInfo);
end;

function TwxUnifiedOrderRequest.GetAttach: string;
begin
  Result := FAttach;
end;

function TwxUnifiedOrderRequest.GetBody: string;
begin
  Result := FBody;
end;

function TwxUnifiedOrderRequest.GetDetail: string;
begin
  Result := FDetail;
end;

function TwxUnifiedOrderRequest.GetDeviceInfo: string;
begin
  Result := FDeviceInfo;
end;

function TwxUnifiedOrderRequest.GetFeeType: string;
begin
  Result := FFeeType;
end;

function TwxUnifiedOrderRequest.GetGoodsTag: string;
begin
  Result := FGoodsTag;
end;

function TwxUnifiedOrderRequest.GetLimitPay: string;
begin
  Result := FLimitPay;
end;

function TwxUnifiedOrderRequest.GetNotifyUrl: string;
begin
  Result := FNotifyUrl;
end;

function TwxUnifiedOrderRequest.GetOpenId: string;
begin
  Result := FOpenId;
end;

function TwxUnifiedOrderRequest.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxUnifiedOrderRequest.GetProductId: string;
begin
  Result := FProductId;
end;

function TwxUnifiedOrderRequest.GetReceipt: string;
begin
  Result := FReceipt;
end;

function TwxUnifiedOrderRequest.GetSceneInfo: string;
begin
  Result := FSceneInfo;
end;

function TwxUnifiedOrderRequest.GetSpbillCreateIp: string;
begin
  Result := FSpbillCreateIp;
end;

function TwxUnifiedOrderRequest.GetTimeExpire: TDateTime;
begin
  Result := FTimeExpire;
end;

function TwxUnifiedOrderRequest.GetTimeStart: TDateTime;
begin
  Result := FTimeStart;
end;

function TwxUnifiedOrderRequest.GetTotalFee: Integer;
begin
  Result := FTotalFee;
end;

function TwxUnifiedOrderRequest.GetTradeType: TwxTradeType;
begin
  Result := FTradeType;
end;

procedure TwxUnifiedOrderRequest.SetAttach(const Value: string);
begin
  FAttach := Value;
end;

procedure TwxUnifiedOrderRequest.SetBody(const Value: string);
begin
  FBody := Value;
end;

procedure TwxUnifiedOrderRequest.SetDetail(const Value: string);
begin
  FDetail := Value;
end;

procedure TwxUnifiedOrderRequest.SetFeeType(const Value: string);
begin
  FFeeType := Value;
end;

procedure TwxUnifiedOrderRequest.SetGoodsTag(const Value: string);
begin
  FGoodsTag := Value;
end;

procedure TwxUnifiedOrderRequest.SetLimitPay(const Value: string);
begin
  FLimitPay := Value;
end;

procedure TwxUnifiedOrderRequest.SetNotifyUrl(const Value: string);
begin
  FNotifyUrl := Value;
end;

procedure TwxUnifiedOrderRequest.SetDeviceInfo(const Value: string);
begin
  FDeviceInfo := Value;
end;

procedure TwxUnifiedOrderRequest.SetOpenId(const Value: string);
begin
  FOpenId := Value;
end;

procedure TwxUnifiedOrderRequest.SetOutTradeNo(const Value: string);
begin
  FOutTradeNo := Value;
end;

procedure TwxUnifiedOrderRequest.SetProductId(const Value: string);
begin
  FProductId := Value;
end;

procedure TwxUnifiedOrderRequest.SetReceipt(const Value: string);
begin
  FReceipt := Value;
end;

procedure TwxUnifiedOrderRequest.SetSceneInfo(const Value: string);
begin
  FSceneInfo := Value;
end;

procedure TwxUnifiedOrderRequest.SetSpbillCreateIp(const Value: string);
begin
  FSpbillCreateIp := Value;
end;

procedure TwxUnifiedOrderRequest.SetTimeExpire(const Value: TDateTime);
begin
  FTimeExpire := Value;
end;

procedure TwxUnifiedOrderRequest.SetTimeStart(const Value: TDateTime);
begin
  FTimeStart := Value;
end;

procedure TwxUnifiedOrderRequest.SetTotalFee(const Value: Integer);
begin
  FTotalFee := Value;
end;

procedure TwxUnifiedOrderRequest.SetTradeType(const Value: TwxTradeType);
begin
  FTradeType := Value;
end;

{ TwxUnifiedOrderReponse }

procedure TwxUnifiedOrderReponse.DoInitFromXMLOther(RootNode: IXMLNode);
begin
  inherited;
  FTradeType  := TwxTradeType.ParseStr(VarToStr(RootNode.ChildValues['trade_type']));
  FDeviceInfo := VarToStr(RootNode.ChildValues['device_info']);
  FCodeUrl    := VarToStr(RootNode.ChildValues['code_url']);
  FMWebUrl    := VarToStr(RootNode.ChildValues['mweb_url']);
end;

function TwxUnifiedOrderReponse.GetCodeUrl: string;
begin
  Result := FCodeUrl;
end;

function TwxUnifiedOrderReponse.GetDeviceInfo: string;
begin
  Result := FDeviceInfo;
end;

function TwxUnifiedOrderReponse.GetMWebUrl: string;
begin
  Result := FMWebUrl;
end;

function TwxUnifiedOrderReponse.GetPrepayId: string;
begin
  Result := FPrepayId;
end;

function TwxUnifiedOrderReponse.GetTradeType: TwxTradeType;
begin
  Result := FTradeType;
end;

{ TwxQueryOrderRequest }

procedure TwxQueryOrderRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'transaction_id', TransactionId);
  AddCDATA(RootNode, 'out_trade_no', OutTradeNo);
end;

function TwxQueryOrderRequest.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxQueryOrderRequest.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

procedure TwxQueryOrderRequest.SetOutTradeNo(const Value: string);
begin
  FOutTradeNo := Value;
end;

procedure TwxQueryOrderRequest.SetTransactionId(const Value: string);
begin
  FTransactionId := Value;
end;

{ TwxQueryOrderReponse }

procedure TwxQueryOrderReponse.DoInitFromXMLOther(RootNode: IXMLNode);
var
  I: Integer;
begin
  inherited;
  FTradeType      := TwxTradeType.ParseStr(VarToStr(RootNode.ChildValues['trade_type']));
  FTradeState     := TwxTradeState.ParseStr(VarToStr(RootNode.ChildValues['trade_state']));
  FOpenId         := VarToStr(RootNode.ChildValues['openid']);
  FIsSubscribe    := VarToStr(RootNode.ChildValues['is_subscribe']) = 'Y';
  FBankType       := VarToStr(RootNode.ChildValues['bank_type']);
  FTotalFee       := TWxHelper.VarToInt(RootNode.ChildValues['total_fee']);
  FCashFee        := TWxHelper.VarToInt(RootNode.ChildValues['cash_fee']);
  FTransactionId  := VarToStr(RootNode.ChildValues['transaction_id']);
  FOutTradeNo     := VarToStr(RootNode.ChildValues['out_trade_no']);
  FTimeEnd        := TWxHelper.WxDateTimeStrToDateTime(VarToStr(RootNode.ChildValues['time_end']));
  FTradeStateDesc := VarToStr(RootNode.ChildValues['trade_state_desc']);
  FDeviceInfo         := VarToStr(RootNode.ChildValues['device_info']);
  FSettlementTotalFee := TWxHelper.VarToInt(RootNode.ChildValues['settlement_total_fee']);
  FFeeType            := VarToStr(RootNode.ChildValues['fee_type']);
  FCashFeeType        := VarToStr(RootNode.ChildValues['cash_fee_type']);
  FCouponFee          := TWxHelper.VarToInt(RootNode.ChildValues['coupon_fee']);
  SetLength(FCoupons, TWxHelper.VarToInt(RootNode.ChildValues['coupon_count']));
  for I := Low(FCoupons) to High(FCoupons) do begin
    FCoupons[I]._Type := VarToStr(RootNode.ChildValues[Format('coupon_type_$%d', [I])]);
    FCoupons[I].Id    := VarToStr(RootNode.ChildValues[Format('coupon_id_$%d', [I])]);
    FCoupons[I].Fee   := TWxHelper.VarToInt(RootNode.ChildValues[Format('coupon_fee_$%d', [I])]);
  end;
  FAttach := VarToStr(RootNode.ChildValues['attach']);
end;

function TwxQueryOrderReponse.GetAttach: string;
begin
  Result := FAttach;
end;

function TwxQueryOrderReponse.GetBankType: string;
begin
  Result := FBankType;
end;

function TwxQueryOrderReponse.GetCashFee: Integer;
begin
  Result := FCashFee;
end;

function TwxQueryOrderReponse.GetCashFeeType: string;
begin
  Result := FCashFeeType;
end;

function TwxQueryOrderReponse.GetCouponFee: Integer;
begin
  Result := FCouponFee;
end;

function TwxQueryOrderReponse.GetCoupons: TwxCoupons;
begin
  Result := FCoupons;
end;

function TwxQueryOrderReponse.GetDeviceInfo: string;
begin
  Result := FDeviceInfo;
end;

function TwxQueryOrderReponse.GetFeeType: string;
begin
  Result := FFeeType;
end;

function TwxQueryOrderReponse.GetIsSubscribe: Boolean;
begin
  Result := FIsSubscribe;
end;

function TwxQueryOrderReponse.GetOpenId: string;
begin
  Result := FOpenId;
end;

function TwxQueryOrderReponse.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxQueryOrderReponse.GetSettlementTotalFee: Integer;
begin
  Result := FSettlementTotalFee;
end;

function TwxQueryOrderReponse.GetTimeEnd: TDateTime;
begin
  Result := FTimeEnd;
end;

function TwxQueryOrderReponse.GetTotalFee: Integer;
begin
  Result := FTotalFee;
end;

function TwxQueryOrderReponse.GetTradeState: TwxTradeState;
begin
  Result := FTradeState;
end;

function TwxQueryOrderReponse.GetTradeStateDesc: string;
begin
  Result := FTradeStateDesc;
end;

function TwxQueryOrderReponse.GetTradeType: TwxTradeType;
begin
  Result := FTradeType;
end;

function TwxQueryOrderReponse.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

{ TwxCloseOrderRequest }

procedure TwxCloseOrderRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'out_trade_no', OutTradeNo);
end;

function TwxCloseOrderRequest.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

procedure TwxCloseOrderRequest.SetOutTradeNo(const Value: string);
begin
  FOutTradeNo := Value;
end;

{ TwxCloseOrderReponse }

procedure TwxCloseOrderReponse.DoInitFromXMLOther(RootNode: IXMLNode);
begin
  inherited;
  FResultMsg := VarToStr(RootNode.ChildValues['result_msg']);
end;

function TwxCloseOrderReponse.GetResultMsg: string;
begin
  Result := FResultMsg;
end;

{ TwxMicroPayRequest }

procedure TwxMicroPayRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  //----begin 必填------
  RootNode.ChildValues['total_fee'] := TotalFee.ToString;
  AddCDATA(RootNode, 'out_trade_no', OutTradeNo);
  AddCDATA(RootNode, 'body', Body);
  AddCDATA(RootNode, 'spbill_create_ip', SpbillCreateIp);
  AddCDATA(RootNode, 'auth_code', AuthCode);
  //----end 必填------
  if not DeviceInfo.IsEmpty then AddCDATA(RootNode, 'device_info', DeviceInfo);
  if not Detail.IsEmpty     then AddCDATA(RootNode, 'detail', Detail);
  if not Attach.IsEmpty     then AddCDATA(RootNode, 'attach', Attach);
  if not FeeType.IsEmpty    then AddCDATA(RootNode, 'fee_type', FeeType);
  if TimeStart <> 0         then RootNode.ChildValues['time_start'] := FormatDateTime('yyyymmddhhnnss', TimeStart);
  if TimeExpire <> 0        then RootNode.ChildValues['time_expire'] := FormatDateTime('yyyymmddhhnnss', TimeExpire);
  if not GoodsTag.IsEmpty   then AddCDATA(RootNode, 'goods_tag', GoodsTag);
  if not LimitPay.IsEmpty   then AddCDATA(RootNode, 'limit_pay', LimitPay);
  if not Receipt.IsEmpty    then AddCDATA(RootNode, 'receipt', Receipt);
  if not SceneInfo.IsEmpty  then AddCDATA(RootNode, 'scene_info', SceneInfo);
end;

function TwxMicroPayRequest.GetAttach: string;
begin
  Result := FAttach;
end;

function TwxMicroPayRequest.GetAuthCode: string;
begin
  Result := FAuthCode;
end;

function TwxMicroPayRequest.GetBody: string;
begin
  Result := FBody;
end;

function TwxMicroPayRequest.GetDetail: string;
begin
  Result := FDetail;
end;

function TwxMicroPayRequest.GetDeviceInfo: string;
begin
  Result := FDeviceInfo;
end;

function TwxMicroPayRequest.GetFeeType: string;
begin
  Result := FFeeType;
end;

function TwxMicroPayRequest.GetGoodsTag: string;
begin
  Result := FGoodsTag;
end;

function TwxMicroPayRequest.GetLimitPay: string;
begin
  Result := FLimitPay;
end;

function TwxMicroPayRequest.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxMicroPayRequest.GetReceipt: string;
begin
  Result := FReceipt;
end;

function TwxMicroPayRequest.GetSceneInfo: string;
begin
  Result := FSceneInfo;
end;

function TwxMicroPayRequest.GetSpbillCreateIp: string;
begin
  Result := FSpbillCreateIp;
end;

function TwxMicroPayRequest.GetTimeExpire: TDateTime;
begin
  Result := FTimeExpire;
end;

function TwxMicroPayRequest.GetTimeStart: TDateTime;
begin
  Result := FTimeStart;
end;

function TwxMicroPayRequest.GetTotalFee: Integer;
begin
  Result := FTotalFee;
end;

procedure TwxMicroPayRequest.SetAttach(const Value: string);
begin
  FAttach := Value;
end;

procedure TwxMicroPayRequest.SetAuthCode(const Value: string);
begin
  FAuthCode := Value;
end;

procedure TwxMicroPayRequest.SetBody(const Value: string);
begin
  FBody := Value;
end;

procedure TwxMicroPayRequest.SetDetail(const Value: string);
begin
  FDetail := Value;
end;

procedure TwxMicroPayRequest.SetDeviceInfo(const Value: string);
begin
  FDeviceInfo := Value;
end;

procedure TwxMicroPayRequest.SetFeeType(const Value: string);
begin
  FFeeType := Value;
end;

procedure TwxMicroPayRequest.SetGoodsTag(const Value: string);
begin
  FGoodsTag := Value;
end;

procedure TwxMicroPayRequest.SetLimitPay(const Value: string);
begin
  FLimitPay := Value;
end;

procedure TwxMicroPayRequest.SetOutTradeNo(const Value: string);
begin
  FOutTradeNo := Value;
end;

procedure TwxMicroPayRequest.SetReceipt(const Value: string);
begin
  FReceipt := Value;
end;

procedure TwxMicroPayRequest.SetSceneInfo(const Value: string);
begin
  FSceneInfo := Value;
end;

procedure TwxMicroPayRequest.SetSpbillCreateIp(const Value: string);
begin
  FSpbillCreateIp := Value;
end;

procedure TwxMicroPayRequest.SetTimeExpire(const Value: TDateTime);
begin
  FTimeExpire := Value;
end;

procedure TwxMicroPayRequest.SetTimeStart(const Value: TDateTime);
begin
  FTimeStart := Value;
end;

procedure TwxMicroPayRequest.SetTotalFee(const Value: Integer);
begin
  FTotalFee := Value;
end;

{ TwxMicroPayReponse }

procedure TwxMicroPayReponse.DoInitFromXMLOther(RootNode: IXMLNode);
begin
  inherited;
  FTradeType     := TwxTradeType.ParseStr(VarToStr(RootNode.ChildValues['trade_type']));
  FOpenId        := VarToStr(RootNode.ChildValues['openid']);
  FIsSubscribe   := VarToStr(RootNode.ChildValues['is_subscribe']) = 'Y';
  FBankType      := VarToStr(RootNode.ChildValues['bank_type']);
  FTotalFee      := TWxHelper.VarToInt(RootNode.ChildValues['total_fee']);
  FCashFee       := TWxHelper.VarToInt(RootNode.ChildValues['cash_fee']);
  FTransactionId := VarToStr(RootNode.ChildValues['transaction_id']);
  FOutTradeNo    := VarToStr(RootNode.ChildValues['out_trade_no']);
  FTimeEnd       := TWxHelper.WxDateTimeStrToDateTime(VarToStr(RootNode.ChildValues['time_end']));
  FDeviceInfo := VarToStr(RootNode.ChildValues['device_info']);
  FFeeType := VarToStr(RootNode.ChildValues['fee_type']);
  FSettlementTotalFee := TWxHelper.VarToInt(RootNode.ChildValues['settlement_total_fee']);
  FCouponFee := TWxHelper.VarToInt(RootNode.ChildValues['coupon_fee']);
  FCashFeeType := VarToStr(RootNode.ChildValues['cash_fee_type']);
  FAttach := VarToStr(RootNode.ChildValues['attach']);
  FPromotionDetail := VarToStr(RootNode.ChildValues['promotion_detail']);
end;

function TwxMicroPayReponse.GeCashFee: Integer;
begin
  Result := FCashFee;
end;

function TwxMicroPayReponse.GetAttach: string;
begin
  Result := FAttach;
end;

function TwxMicroPayReponse.GetBankType: string;
begin
  Result := FBankType;
end;

function TwxMicroPayReponse.GetCashFeeType: string;
begin
  Result := FCashFeeType;
end;

function TwxMicroPayReponse.GetCouponFee: Integer;
begin
  Result := FCouponFee;
end;

function TwxMicroPayReponse.GetDeviceInfo: string;
begin
  Result := FDeviceInfo;
end;

function TwxMicroPayReponse.GetFeeType: string;
begin
  Result := FFeeType;
end;

function TwxMicroPayReponse.GetIsSubscribe: Boolean;
begin
  Result := FIsSubscribe;
end;

function TwxMicroPayReponse.GetOpenId: string;
begin
  Result := FOpenId;
end;

function TwxMicroPayReponse.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxMicroPayReponse.GetPromotionDetail: string;
begin
  Result := FPromotionDetail;
end;

function TwxMicroPayReponse.GetSettlementTotalFee: Integer;
begin
  Result := FSettlementTotalFee;
end;

function TwxMicroPayReponse.GetTimeEnd: TDateTime;
begin
  Result := FTimeEnd;
end;

function TwxMicroPayReponse.GetTotalFee: Integer;
begin
  Result := FTotalFee;
end;

function TwxMicroPayReponse.GetTradeType: TwxTradeType;
begin
  Result := FTradeType;
end;

function TwxMicroPayReponse.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

{ TwxBizPayInputParams }

procedure TwxBizPayInputParams.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  FOpenId      := VarToStr(RootNode.ChildValues['openid']);
  FIsSubscribe := VarToStr(RootNode.ChildValues['is_subscribe']) = 'Y';
  FProductId   := VarToStr(RootNode.ChildValues['product_id']);
  FAppId       := VarToStr(RootNode.ChildValues['appid']);
  FMchId       := VarToStr(RootNode.ChildValues['mch_id']);
  FNonceStr    := VarToStr(RootNode.ChildValues['nonce_str']);
  FSign        := VarToStr(RootNode.ChildValues['sign']);
end;

function TwxBizPayInputParams.GetAppId: string;
begin
  Result := FAppId;
end;

function TwxBizPayInputParams.GetIsSubscribe: Boolean;
begin
  Result := FIsSubscribe;
end;

function TwxBizPayInputParams.GetMchId: string;
begin
  Result := FMchId;
end;

function TwxBizPayInputParams.GetNonceStr: string;
begin
  Result := FNonceStr;
end;

function TwxBizPayInputParams.GetOpenId: string;
begin
  Result := FOpenId;
end;

function TwxBizPayInputParams.GetProductId: string;
begin
  Result := FProductId;
end;

function TwxBizPayInputParams.GetSign: string;
begin
  Result := FSign;
end;

function TwxBizPayInputParams.ValidSign(const Key: string): Boolean;
begin
  Result := TWxHelper.ValidSign(XML, Key, stMD5);
end;

{ TwxBizPayOutputParams }

constructor TwxBizPayOutputParams.Create;
begin
  inherited;
  FNonceStr := TWxHelper.GenNonceStr;
end;

procedure TwxBizPayOutputParams.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  RootNode.ChildValues['return_code'] := ReturnCode.ToString;
  AddCDATA(RootNode, 'appid', AppId);
  AddCDATA(RootNode, 'mch_id', MchId);
  AddCDATA(RootNode, 'nonce_str', NonceStr);
  AddCDATA(RootNode, 'prepay_id', PrepayId);
  RootNode.ChildValues['result_code'] := ResultCode.ToString;
  if not ReturnMsg.IsEmpty  then AddCDATA(RootNode, 'return_msg', ReturnMsg);
  if not ErrCodeDes.IsEmpty then AddCDATA(RootNode, 'err_code_des', ReturnMsg);
end;

function TwxBizPayOutputParams.XMLWithSign(const Key: string): string;
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
  Sign := TWxHelper.GetSign(XMLDocument, Key, stMD5);
  XMLDocument.DocumentElement.ChildValues['sign'] := Sign;
  Result := XMLDocument.XML.Text;
end;

function TwxBizPayOutputParams.GetAppId: string;
begin
  Result := FAppId;
end;

function TwxBizPayOutputParams.GetErrCodeDes: string;
begin
  Result := FErrCodeDes;
end;

function TwxBizPayOutputParams.GetMchId: string;
begin
  Result := FMchId;
end;

function TwxBizPayOutputParams.GetNonceStr: string;
begin
  Result := FNonceStr;
end;

function TwxBizPayOutputParams.GetPrepayId: string;
begin
  Result := FPrepayId;
end;

function TwxBizPayOutputParams.GetResultCode: TwxPayResultCode;
begin
  Result := FResultCode;
end;

function TwxBizPayOutputParams.GetReturnCode: TwxPayReturnCode;
begin
  Result := FReturnCode;
end;

function TwxBizPayOutputParams.GetReturnMsg: string;
begin
  Result := FReturnMsg;
end;

procedure TwxBizPayOutputParams.SetAppId(const Value: string);
begin
  FAppId := Value;
end;

procedure TwxBizPayOutputParams.SetErrCodeDes(const Value: string);
begin
  FErrCodeDes := Value;
end;

procedure TwxBizPayOutputParams.SetMchId(const Value: string);
begin
  FMchId := Value;
end;

procedure TwxBizPayOutputParams.SetNonceStr(const Value: string);
begin
  FNonceStr := Value;
end;

procedure TwxBizPayOutputParams.SetPrepayId(const Value: string);
begin
  FPrepayId := Value;
end;

procedure TwxBizPayOutputParams.SetResultCode(const Value: TwxPayResultCode);
begin
  FResultCode := Value;
end;

procedure TwxBizPayOutputParams.SetReturnCode(const Value: TwxPayReturnCode);
begin
  FReturnCode := Value;
end;

procedure TwxBizPayOutputParams.SetReturnMsg(const Value: string);
begin
  FReturnMsg := Value;
end;

{ TwxPayNotification }

procedure TwxPayNotification.DoInitFromXML(RootNode: IXMLNode);
var
  I: Integer;
begin
  inherited;
  FReturnCode   := TwxPayReturnCode.ParseStr(VarToStr(RootNode.ChildValues['return_code']));
  FReturnMsg    := VarToStr(RootNode.ChildValues['return_msg']);
  if FReturnCode = prcSuccess then begin
    FAppId      := VarToStr(RootNode.ChildValues['appid']);
    FMchId      := VarToStr(RootNode.ChildValues['mch_id']);
    FNonceStr   := VarToStr(RootNode.ChildValues['nonce_str']);
    FSign       := VarToStr(RootNode.ChildValues['sign']);
    FSignType   := TwxSignType.ParseStr(VarToStr(RootNode.ChildValues['sign_type']));
    FResultCode := TwxPayResultCode.ParseStr(VarToStr(RootNode.ChildValues['result_code']));
    FErrCode    := VarToStr(RootNode.ChildValues['err_code']);
    FErrCodeDes := VarToStr(RootNode.ChildValues['err_code_des']);
    FTradeType  := TwxTradeType.ParseStr(VarToStr(RootNode.ChildValues['trade_type']));
    FOpenId     := VarToStr(RootNode.ChildValues['openid']);
    FIsSubscribe := VarToStr(RootNode.ChildValues['is_subscribe']) = 'Y';
    FBankType   := VarToStr(RootNode.ChildValues['bank_type']);
    FTotalFee   := TWxHelper.VarToInt(RootNode.ChildValues['total_fee']);
    FCashFee    := TWxHelper.VarToInt(RootNode.ChildValues['cash_fee']);
    FTransactionId := VarToStr(RootNode.ChildValues['transaction_id']);
    FOutTradeNo := VarToStr(RootNode.ChildValues['out_trade_no']);
    FTimeEnd    := TWxHelper.WxDateTimeStrToDateTime(VarToStr(RootNode.ChildValues['time_end']));
    FDeviceInfo := VarToStr(RootNode.ChildValues['device_info']);
    FFeeType    := VarToStr(RootNode.ChildValues['fee_type']);
    FCashFeeType := VarToStr(RootNode.ChildValues['cash_fee_type']);
    FCouponFee  := TWxHelper.VarToInt(RootNode.ChildValues['coupon_fee']);
    SetLength(FCoupons, TWxHelper.VarToInt(RootNode.ChildValues['coupon_count']));
    for I := Low(FCoupons) to High(FCoupons) do begin
      FCoupons[I]._Type := VarToStr(RootNode.ChildValues[Format('coupon_type_$%d', [I])]);
      FCoupons[I].Id    := VarToStr(RootNode.ChildValues[Format('coupon_id_$%d', [I])]);
      FCoupons[I].Fee   := TWxHelper.VarToInt(RootNode.ChildValues[Format('coupon_fee_$%d', [I])]);
    end;
    FAttach := VarToStr(RootNode.ChildValues['attach']);
  end;
end;

function TwxPayNotification.GetAppId: string;
begin
  Result := FAppId;
end;

function TwxPayNotification.GetAttach: string;
begin
  Result := FAttach;
end;

function TwxPayNotification.GetBankType: string;
begin
  Result := FBankType;
end;

function TwxPayNotification.GetCashFee: Integer;
begin
  Result := FCashFee;
end;

function TwxPayNotification.GetCashFeeType: string;
begin
  Result := FCashFeeType;
end;

function TwxPayNotification.GetCouponFee: Integer;
begin
  Result := FCouponFee;
end;

function TwxPayNotification.GetCoupons: TwxCoupons;
begin
  Result := FCoupons;
end;

function TwxPayNotification.GetDeviceInfo: string;
begin
  Result := FDeviceInfo;
end;

function TwxPayNotification.GetErrCode: string;
begin
  Result := FErrCode;
end;

function TwxPayNotification.GetErrCodeDes: string;
begin
  Result := FErrCodeDes;
end;

function TwxPayNotification.GetFeeType: string;
begin
  Result := FFeeType;
end;

function TwxPayNotification.GetIsSubscribe: Boolean;
begin
  Result := FIsSubscribe;
end;

function TwxPayNotification.GetMchId: string;
begin
  Result := FMchId;
end;

function TwxPayNotification.GetNonceStr: string;
begin
  Result := FNonceStr;
end;

function TwxPayNotification.GetOpenId: string;
begin
  Result := FOpenId;
end;

function TwxPayNotification.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxPayNotification.GetResultCode: TwxPayResultCode;
begin
  Result := FResultCode;
end;

function TwxPayNotification.GetReturnCode: TwxPayReturnCode;
begin
  Result := FReturnCode;
end;

function TwxPayNotification.GetReturnMsg: string;
begin
  Result := FReturnMsg;
end;

function TwxPayNotification.GetSign: string;
begin
  Result := FSign;
end;

function TwxPayNotification.GetSignType: TwxSignType;
begin
  Result := FSignType;
end;

function TwxPayNotification.GetTimeEnd: TDateTime;
begin
  Result := FTimeEnd;
end;

function TwxPayNotification.GetTotalFee: Integer;
begin
  Result := FTotalFee;
end;

function TwxPayNotification.GetTradeType: TwxTradeType;
begin
  Result := FTradeType;
end;

function TwxPayNotification.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

{ TwxReverseRequest }

procedure TwxReverseRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  //----begin 必填------
  AddCDATA(RootNode, 'out_trade_no', OutTradeNo);
  //----end 必填------
  if not TransactionId.IsEmpty then AddCDATA(RootNode, 'transaction_id', TransactionId);
end;

function TwxReverseRequest.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxReverseRequest.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

procedure TwxReverseRequest.SetOutTradeNo(const Value: string);
begin
  FOutTradeNo := Value;
end;

procedure TwxReverseRequest.SetTransactionId(const Value: string);
begin
  FTransactionId := Value;
end;

{ TwxReverseReponse }

procedure TwxReverseReponse.DoInitFromXMLOther(RootNode: IXMLNode);
begin
  inherited;
  FRecall := SameText(VarToStr(RootNode.ChildValues['recall']), 'Y');
end;

function TwxReverseReponse.GetRecall: Boolean;
begin
  Result := FRecall;
end;

{ TwxRefundRequest }

procedure TwxRefundRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  //----begin 必填------
  AddCDATA(RootNode, 'out_refund_no', OutRefundNo);
  RootNode.ChildValues['total_fee'] := TotalFee;
  RootNode.ChildValues['refund_fee'] := RefundFee;
  //----end 必填------
  //二选一，如果同时存在优先级：TransactionId > OutTradeNo
  if not OutTradeNo.IsEmpty    then AddCDATA(RootNode, 'out_trade_no', OutTradeNo);
  if not TransactionId.IsEmpty then AddCDATA(RootNode, 'transaction_id', TransactionId);
  //选填
  if not RefundFeeType.IsEmpty then AddCDATA(RootNode, 'refund_fee_type', RefundFeeType);
  if not RefundDesc.IsEmpty    then AddCDATA(RootNode, 'refund_desc', RefundDesc);
  if not RefundAccount.IsEmpty then AddCDATA(RootNode, 'refund_account', RefundAccount);
  if not NotifyUrl.IsEmpty     then AddCDATA(RootNode, 'notify_url', NotifyUrl);
end;

function TwxRefundRequest.GetNotifyUrl: string;
begin
  Result := FNotifyUrl;
end;

function TwxRefundRequest.GetOutRefundNo: string;
begin
  Result := FOutRefundNo;
end;

function TwxRefundRequest.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxRefundRequest.GetRefundAccount: string;
begin
  Result := FRefundAccount;
end;

function TwxRefundRequest.GetRefundDesc: string;
begin
  Result := FRefundDesc;
end;

function TwxRefundRequest.GetRefundFee: Integer;
begin
  Result := FRefundFee;
end;

function TwxRefundRequest.GetRefundFeeType: string;
begin
  Result := FRefundFeeType;
end;

function TwxRefundRequest.GetTotalFee: Integer;
begin
  Result := FTotalFee;
end;

function TwxRefundRequest.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

procedure TwxRefundRequest.SetNotifyUrl(const Value: string);
begin
  FNotifyUrl := Value;
end;

procedure TwxRefundRequest.SetOutRefundNo(const Value: string);
begin
  FOutRefundNo := Value;
end;

procedure TwxRefundRequest.SetOutTradeNo(const Value: string);
begin
  FOutTradeNo := Value;
end;

procedure TwxRefundRequest.SetRefundAccount(const Value: string);
begin
  FRefundAccount := Value;
end;

procedure TwxRefundRequest.SetRefundDesc(const Value: string);
begin
  FRefundDesc := Value;
end;

procedure TwxRefundRequest.SetRefundFee(const Value: Integer);
begin
  FRefundFee := Value;
end;

procedure TwxRefundRequest.SetRefundFeeType(const Value: string);
begin
  FRefundFeeType := Value;
end;

procedure TwxRefundRequest.SetTotalFee(const Value: Integer);
begin
  FTotalFee := Value;
end;

procedure TwxRefundRequest.SetTransactionId(const Value: string);
begin
  FTransactionId:= Value;
end;

{ TwxRefundReponse }

procedure TwxRefundReponse.DoInitFromXMLOther(RootNode: IXMLNode);
var
  I: Integer;
begin
  inherited;
  FTransactionId := VarToStr(RootNode.ChildValues['transaction_id']);
  FOutTradeNo    := VarToStr(RootNode.ChildValues['out_trade_no']);
  FOutRefundNo   := VarToStr(RootNode.ChildValues['out_refund_no']);
  FRefundId      := VarToStr(RootNode.ChildValues['refund_id']);
  FRefundFee     := TWxHelper.VarToInt(RootNode.ChildValues['refund_fee']);
  FTotalFee      := TWxHelper.VarToInt(RootNode.ChildValues['total_fee']);
  FCashFee       := TWxHelper.VarToInt(RootNode.ChildValues['cash_fee']);
  FSettlementRefundFee := TWxHelper.VarToInt(RootNode.ChildValues['settlement_refund_fee']);
  FSettlementTotalFee  := TWxHelper.VarToInt(RootNode.ChildValues['settlement_total_fee']);
  FFeeType             := VarToStr(RootNode.ChildValues['fee_type']);
  FCashFeeType         := VarToStr(RootNode.ChildValues['cash_fee_type']);
  FCashRefundFee       := TWxHelper.VarToInt(RootNode.ChildValues['cash_refund_fee']);
  FCouponRefundFee     := TWxHelper.VarToInt(RootNode.ChildValues['coupon_refund_fee']);
  FCouponRefundCount   := TWxHelper.VarToInt(RootNode.ChildValues['coupon_refund_count']);
  SetLength(FCouponRefunds, FCouponRefundCount);
  for I := Low(FCouponRefunds) to High(FCouponRefunds) do begin
    FCouponRefunds[I]._Type := VarToStr(RootNode.ChildValues[Format('coupon_type_$%d', [I])]);
    FCouponRefunds[I].Id    := VarToStr(RootNode.ChildValues[Format('coupon_refund_id_$%d', [I])]);
    FCouponRefunds[I].Fee   := TWxHelper.VarToInt(RootNode.ChildValues[Format('coupon_refund_fee_$%d', [I])]);
  end;
end;

function TwxRefundReponse.GetCashFee: Integer;
begin
  Result := FCashFee;
end;

function TwxRefundReponse.GetCashFeeType: string;
begin
  Result := FCashFeeType;
end;

function TwxRefundReponse.GetCashRefundFee: Integer;
begin
  Result := FCashRefundFee;
end;

function TwxRefundReponse.GetCouponRefundCount: Integer;
begin
  Result := FCouponRefundCount;
end;

function TwxRefundReponse.GetCouponRefundFee: Integer;
begin
  Result := FCouponRefundFee;
end;

function TwxRefundReponse.GetCouponRefunds: TwxCoupons;
begin
  Result := FCouponRefunds;
end;

function TwxRefundReponse.GetFeeType: string;
begin
  Result := FFeeType;
end;

function TwxRefundReponse.GetOutRefundNo: string;
begin
  Result := FOutRefundNo;
end;

function TwxRefundReponse.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxRefundReponse.GetRefundFee: Integer;
begin
  Result := FRefundFee;
end;

function TwxRefundReponse.GetRefundId: string;
begin
  Result := FRefundId;
end;

function TwxRefundReponse.GetSettlementRefundFee: Integer;
begin
  Result := FSettlementRefundFee;
end;

function TwxRefundReponse.GetSettlementTotalFee: Integer;
begin
  Result := FSettlementTotalFee;
end;

function TwxRefundReponse.GetTotalFee: Integer;
begin
  Result := FTotalFee;
end;

function TwxRefundReponse.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

{ TwxBrandWCPayRequest }

constructor TwxBrandWCPayRequest.Create;
begin
  FNonceStr := TWxHelper.GenNonceStr;
  FTimeStamp := TWxHelper.DateTimeToWxTime(Now);
end;

function TwxBrandWCPayRequest.GetAppId: string;
begin
  Result := FAppId;
end;

function TwxBrandWCPayRequest.GetKey: string;
begin
  Result := FKey;
end;

function TwxBrandWCPayRequest.GetNonceStr: string;
begin
  Result := FNonceStr;
end;

function TwxBrandWCPayRequest.GetPrepayId: string;
begin
  Result := FPrepayId;
end;

function TwxBrandWCPayRequest.GetSignType: TwxSignType;
begin
  Result := FSignType;
end;

function TwxBrandWCPayRequest.GetTimeStamp: TwxDateTime;
begin
  Result := FTimeStamp;
end;

procedure TwxBrandWCPayRequest.SetAppId(const Value: string);
begin
  FAppId := Value;
end;

procedure TwxBrandWCPayRequest.SetKey(const Value: string);
begin
  FKey := Value;
end;

procedure TwxBrandWCPayRequest.SetNonceStr(const Value: string);
begin
  FNonceStr := Value;
end;

procedure TwxBrandWCPayRequest.SetPrepayId(const Value: string);
begin
  FPrepayId := Value;
end;

procedure TwxBrandWCPayRequest.SetSignType(const Value: TwxSignType);
begin
  FSignType := Value;
end;

procedure TwxBrandWCPayRequest.SetTimeStamp(const Value: TwxDateTime);
begin
  FTimeStamp := Value;
end;

function TwxBrandWCPayRequest.ToJSON: string;
var
  XMLDocument: IXMLDocument;
  RootNode: IXMLNode;
  paySign: string;
  jo: TJDOJsonObject;
begin
  XMLDocument := TXMLDocument.Create(nil);
  TXMLDocument(XMLDocument).DOMVendor := GetDOMVendor(sOmniXmlVendor);
  RootNode := XMLDocument.AddChild('xml');
  RootNode.ChildValues['appId'] := AppId;
  RootNode.ChildValues['timeStamp'] := Timestamp;
  RootNode.ChildValues['nonceStr'] := NonceStr;
  RootNode.ChildValues['package'] := Format('prepay_id=%s', [PrepayId]);
  RootNode.ChildValues['signType'] := SignType.ToString;
  paySign := TWxHelper.GetSign(XMLDocument, Key, SignType);
  jo := TJDOJsonObject.Create;
  try
    jo.S['appId'] := AppId;
    jo.S['timeStamp'] := Timestamp.ToString;
    jo.S['nonceStr'] := NonceStr;
    jo.S['package'] := Format('prepay_id=%s', [PrepayId]);
    jo.S['signType'] := SignType.ToString;
    jo.S['paySign'] := paySign;
    Result := jo.ToJSON;
  finally
    jo.Free;
  end;
end;

{ TwxQueryRefundRequest }

procedure TwxQueryRefundRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  //四选一，如果同时存在优先级：refund_id > out_refund_no > transaction_id > out_trade_no
  if not OutTradeNo.IsEmpty    then AddCDATA(RootNode, 'out_trade_no', OutTradeNo);
  if not TransactionId.IsEmpty then AddCDATA(RootNode, 'transaction_id', TransactionId);
  if not OutRefundNo.IsEmpty   then AddCDATA(RootNode, 'out_refund_no', OutRefundNo);
  if not RefundId.IsEmpty      then AddCDATA(RootNode, 'refund_id', RefundId);
  //选填
  if 0 < offset then RootNode.ChildValues['offset'] := Offset;
end;

function TwxQueryRefundRequest.GetOffset: Integer;
begin
  Result := FOffset;
end;

function TwxQueryRefundRequest.GetOutRefundNo: string;
begin
  Result := FOutRefundNo;
end;

function TwxQueryRefundRequest.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxQueryRefundRequest.GetRefundId: string;
begin
  Result := FRefundId;
end;

function TwxQueryRefundRequest.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

procedure TwxQueryRefundRequest.SetOffset(const Value: Integer);
begin
  FOffset := Value;
end;

procedure TwxQueryRefundRequest.SetOutRefundNo(const Value: string);
begin
  FOutRefundNo := Value;
end;

procedure TwxQueryRefundRequest.SetOutTradeNo(const Value: string);
begin
  FOutTradeNo := Value;
end;

procedure TwxQueryRefundRequest.SetRefundId(const Value: string);
begin
  FRefundId := Value;
end;

procedure TwxQueryRefundRequest.SetTransactionId(const Value: string);
begin
  FTransactionId := Value;
end;

{ TwxQueryRefundReponse }

procedure TwxQueryRefundReponse.DoInitFromXMLOther(RootNode: IXMLNode);
var
  I: Integer;
  K: Integer;
begin
  inherited;
  FTransactionId      := VarToStr(RootNode.ChildValues['transaction_id']);
  FOutTradeNo         := VarToStr(RootNode.ChildValues['out_trade_no']);
  FTotalFee           := TWxHelper.VarToInt(RootNode.ChildValues['total_fee']);
  FCashFee            := TWxHelper.VarToInt(RootNode.ChildValues['cash_fee']);
  FSettlementTotalFee := TWxHelper.VarToInt(RootNode.ChildValues['settlement_total_fee']);
  FTotalRefundCount   := TWxHelper.VarToInt(RootNode.ChildValues['total_refund_count']);
  FFeeType            := VarToStr(RootNode.ChildValues['fee_type']);
  FRefundCount        := TWxHelper.VarToInt(RootNode.ChildValues['refund_count']);
  SetLength(FRefunds, FRefundCount);
  for I := 0 to FRefundCount - 1 do begin
    FRefunds[I].OutTradeNo          := VarToStr(RootNode.ChildValues[Format('out_refund_no_$%d', [I])]);
    FRefunds[I].RefundId            := VarToStr(RootNode.ChildValues[Format('refund_id_$%d', [I])]);
    FRefunds[I].RefundChannel       := VarToStr(RootNode.ChildValues[Format('refund_channel_$%d', [I])]);
    FRefunds[I].RefundFee           := TWxHelper.VarToInt(RootNode.ChildValues[Format('refund_fee_$%d', [I])]);
    FRefunds[I].SettlementRefundFee := TWxHelper.VarToInt(RootNode.ChildValues[Format('settlement_refund_fee_$%d', [I])]);
    FRefunds[I].CouponRefundFee     := TWxHelper.VarToInt(RootNode.ChildValues[Format('coupon_refund_fee_$%d', [I])]);
    FRefunds[I].RefundStatus        := VarToStr(RootNode.ChildValues[Format('refund_status_$%d', [I])]);
    FRefunds[I].RefundAccount       := VarToStr(RootNode.ChildValues[Format('refund_account_$%d', [I])]);
    FRefunds[I].RefundRecvAccout    := VarToStr(RootNode.ChildValues[Format('refund_recv_accout_$%d', [I])]);
    FRefunds[I].RefundSuccessTime   := VarToStr(RootNode.ChildValues[Format('refund_success_time_$%d', [I])]);
    FRefunds[I].CouponRefundCount   := TWxHelper.VarToInt(RootNode.ChildValues[Format('coupon_refund_count_$%d', [I])]);
    SetLength(FRefunds[I].CouponRefunds, FRefunds[I].CouponRefundCount);
    for K := 0 to FRefunds[I].CouponRefundCount - 1 do begin
      FRefunds[I].CouponRefunds[K]._Type := VarToStr(RootNode.ChildValues[Format('coupon_type_$%d_$%d', [I, K])]);
      FRefunds[I].CouponRefunds[K].Id    := VarToStr(RootNode.ChildValues[Format('coupon_refund_id_$%d_$%d', [I, K])]);
      FRefunds[I].CouponRefunds[K].Fee   := TWxHelper.VarToInt(RootNode.ChildValues[Format('coupon_refund_fee_$%d_$%d', [I, K])]);
    end;
  end;
end;

function TwxQueryRefundReponse.GetCashFee: Integer;
begin
  Result := FCashFee;
end;

function TwxQueryRefundReponse.GetFeeType: string;
begin
  Result := FFeeType;
end;

function TwxQueryRefundReponse.GetOutTradeNo: string;
begin
  Result := FOutTradeNo;
end;

function TwxQueryRefundReponse.GetRefundCount: Integer;
begin
  Result := FRefundCount;
end;

function TwxQueryRefundReponse.GetRefunds: TwxRefunds;
begin
  Result := FRefunds;
end;

function TwxQueryRefundReponse.GetSettlementTotalFee: Integer;
begin
  Result := FSettlementTotalFee;
end;

function TwxQueryRefundReponse.GetTotalFee: Integer;
begin
  Result := FTotalFee;
end;

function TwxQueryRefundReponse.GetTotalRefundCount: Integer;
begin
  Result := FTotalRefundCount;
end;

function TwxQueryRefundReponse.GetTransactionId: string;
begin
  Result := FTransactionId;
end;

{ TwxRefundNotification }

procedure TwxRefundNotification.DoInitFromXML(RootNode: IXMLNode);
begin
  inherited;
  FReturnCode   := TwxPayReturnCode.ParseStr(VarToStr(RootNode.ChildValues['return_code']));
  FReturnMsg    := VarToStr(RootNode.ChildValues['return_msg']);
  if FReturnCode = prcSuccess then begin
    FAppId      := VarToStr(RootNode.ChildValues['appid']);
    FMchId      := VarToStr(RootNode.ChildValues['mch_id']);
    FNonceStr   := VarToStr(RootNode.ChildValues['nonce_str']);
    FReqInfo    := VarToStr(RootNode.ChildValues['req_info']);
  end;
end;

function TwxRefundNotification.DecryptReqInfo(const Key: string): TwxRefundNotificationReqDetail;

  function GetXMLDoc(const XML: string): IXMLDocument;
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
  s: string;
begin
  s := TNetEncoding.Base64.Decode(ReqInfo);
  s := DecryptString(s, THashMD5.GetHashString(Key).ToLower, kb256);
  XMLDocument := GetXMLDoc(s);
  Result.TransactionId       := VarToStr(XMLDocument.DocumentElement.ChildValues['transaction_id']);
  Result.OutTradeNo          := VarToStr(XMLDocument.DocumentElement.ChildValues['out_trade_no']);;
  Result.RefundId            := VarToStr(XMLDocument.DocumentElement.ChildValues['refund_id']);;
  Result.OutRefundNo         := VarToStr(XMLDocument.DocumentElement.ChildValues['out_refund_no']);;
  Result.TotalFee            := TWxHelper.VarToInt(XMLDocument.DocumentElement.ChildValues['total_fee']);;
  Result.SettlementTotalFee  := TWxHelper.VarToInt(XMLDocument.DocumentElement.ChildValues['settlement_total_fee']);;
  Result.RefundFee           := TWxHelper.VarToInt(XMLDocument.DocumentElement.ChildValues['refund_fee']);;
  Result.SettlementRefundFee := TWxHelper.VarToInt(XMLDocument.DocumentElement.ChildValues['settlement_refund_fee']);;
  Result.RefundStatus        := VarToStr(XMLDocument.DocumentElement.ChildValues['refund_status']);;
  Result.SuccessTime         := VarToStr(XMLDocument.DocumentElement.ChildValues['success_time']);;
  Result.RefundRecvAccout    := VarToStr(XMLDocument.DocumentElement.ChildValues['refund_recv_accout']);;
  Result.RefundAccount       := VarToStr(XMLDocument.DocumentElement.ChildValues['refund_account']);;
  Result.RefundRequestSource := VarToStr(XMLDocument.DocumentElement.ChildValues['refund_request_source']);;
end;

function TwxRefundNotification.GetAppId: string;
begin
  Result := FAppId;
end;

function TwxRefundNotification.GetMchId: string;
begin
  Result := FMchId;
end;

function TwxRefundNotification.GetNonceStr: string;
begin
  Result := FNonceStr;
end;

function TwxRefundNotification.GetReqInfo: string;
begin
  Result := FReqInfo;
end;

function TwxRefundNotification.GetReturnCode: TwxPayReturnCode;
begin
  Result := FReturnCode;
end;

function TwxRefundNotification.GetReturnMsg: string;
begin
  Result := FReturnMsg;
end;

{ TwxAuthCodeToOpenIdRequest }

procedure TwxAuthCodeToOpenIdRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'auth_code', AuthCode);
end;

function TwxAuthCodeToOpenIdRequest.GetAuthCode: string;
begin
  Result := FAuthCode
end;

procedure TwxAuthCodeToOpenIdRequest.SetAuthCode(const Value: string);
begin
  FAuthCode := Value;
end;

{ TwxAuthCodeToOpenIdReponse }

procedure TwxAuthCodeToOpenIdReponse.DoInitFromXMLOther(RootNode: IXMLNode);
begin
  inherited;
  FOpenId := VarToStr(RootNode.ChildValues['openid']);
end;

function TwxAuthCodeToOpenIdReponse.GetOpenId: string;
begin
  Result := FOpenId;
end;

{ TwxLongUrlToShortUrlRequest }

procedure TwxLongUrlToShortUrlRequest.DoBuildXML(RootNode: IXMLNode);
begin
  inherited;
  AddCDATA(RootNode, 'long_url', LongUrl);
end;

function TwxLongUrlToShortUrlRequest.GetLongUrl: string;
begin
  Result := FLongUrl;
end;

procedure TwxLongUrlToShortUrlRequest.SetLongUrl(const Value: string);
begin
  FLongUrl := Value;
end;

{ TwxLongUrlToShortUrlReponse }

procedure TwxLongUrlToShortUrlReponse.DoInitFromXMLOther(RootNode: IXMLNode);
begin
  inherited;
  FShortUrl := VarToStr(RootNode.ChildValues['short_url']);
end;

function TwxLongUrlToShortUrlReponse.GetShortUrl: string;
begin
  Result := FShortUrl;
end;

end.
