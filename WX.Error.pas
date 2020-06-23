unit WX.Error;

interface

uses
  SysUtils, Classes, Variants, System.Generics.Collections, DB, JsonDataObjects,
  System.Net.HttpClient;

type
  TWXException = class(Exception)
  private
    FErrCode: Integer;
    class var FCodeMsgMap: TDictionary<Integer, string>;
    class procedure InitCodeMsgMap;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure ParseJsonStr(const JsonStr, Description: string); overload;
    class procedure ParseJsonStr(const JsonStr: string); overload;
    constructor Create(ErrCode: Integer; const Msg: string); overload;
    constructor Create(const Msg: string); overload;
    property ErrCode: Integer read FErrCode;
  end;

procedure ParseResponseJsonError(Response: IHTTPResponse; const Description: string);

implementation

uses REST.Types;

procedure ParseResponseJsonError(Response: IHTTPResponse; const Description: string);
begin
  if Response.MimeType.ToLower.StartsWith(CONTENTTYPE_APPLICATION_JSON.ToLower) then
    TWXException.ParseJsonStr(Response.ContentAsString, Description);
end;

{ TWXException }

class constructor TWXException.Create;
begin
  FCodeMsgMap := TDictionary<Integer, string>.Create;
  InitCodeMsgMap;
end;

constructor TWXException.Create(ErrCode: Integer; const Msg: string);
begin
  inherited Create(Msg);
  FErrCode := ErrCode;
end;

constructor TWXException.Create(const Msg: string);
begin
  inherited Create(Msg);
end;

class destructor TWXException.Destroy;
begin
  FCodeMsgMap.Free;
end;

class procedure TWXException.InitCodeMsgMap;
begin
  FCodeMsgMap.Add(-1,	    'ϵͳ��æ����ʱ�뿪�����Ժ�����');
  FCodeMsgMap.Add(0,	    '����ɹ�');
  FCodeMsgMap.Add(40001,	'��ȡ access_token ʱ AppSecret ���󣬻��� access_token ��Ч���뿪��������ȶ� AppSecret ����ȷ�ԣ���鿴�Ƿ�����Ϊǡ���Ĺ��ںŵ��ýӿ�');
  FCodeMsgMap.Add(40002,	'���Ϸ���ƾ֤����');
  FCodeMsgMap.Add(40003,	'���Ϸ��� OpenID ���뿪����ȷ�� OpenID �����û����Ƿ��ѹ�ע���ںţ����Ƿ����������ںŵ� OpenID');
  FCodeMsgMap.Add(40004,	'���Ϸ���ý���ļ�����');
  FCodeMsgMap.Add(40005,	'���Ϸ����ļ����� ');
  FCodeMsgMap.Add(40006,	'���Ϸ����ļ���С ');
  FCodeMsgMap.Add(40007,	'���Ϸ���ý���ļ� id ');
  FCodeMsgMap.Add(40008,	'���Ϸ�����Ϣ����');
  FCodeMsgMap.Add(40009,	'���Ϸ���ͼƬ�ļ���С');
  FCodeMsgMap.Add(40010,	'���Ϸ��������ļ���С');
  FCodeMsgMap.Add(40011,	'���Ϸ�����Ƶ�ļ���С');
  FCodeMsgMap.Add(40012,	'���Ϸ�������ͼ�ļ���С');
  FCodeMsgMap.Add(40013,	'���Ϸ��� AppID ���뿪���߼�� AppID ����ȷ�ԣ������쳣�ַ���ע���Сд');
  FCodeMsgMap.Add(40014,	'���Ϸ��� access_token ���뿪��������ȶ� access_token ����Ч�ԣ����Ƿ���ڣ�����鿴�Ƿ�����Ϊǡ���Ĺ��ںŵ��ýӿ�');
  FCodeMsgMap.Add(40015,	'���Ϸ��Ĳ˵�����');
  FCodeMsgMap.Add(40016,	'���Ϸ��İ�ť����');
  FCodeMsgMap.Add(40017,	'���Ϸ��İ�ť����');
  FCodeMsgMap.Add(40018,	'���Ϸ��İ�ť���ֳ���');
  FCodeMsgMap.Add(40019,	'���Ϸ��İ�ť KEY ����');
  FCodeMsgMap.Add(40020,	'���Ϸ��İ�ť URL ����');
  FCodeMsgMap.Add(40021,	'���Ϸ��Ĳ˵��汾��');
  FCodeMsgMap.Add(40022,	'���Ϸ����Ӳ˵�����');
  FCodeMsgMap.Add(40023,	'���Ϸ����Ӳ˵���ť����');
  FCodeMsgMap.Add(40024,	'���Ϸ����Ӳ˵���ť����');
  FCodeMsgMap.Add(40025,	'���Ϸ����Ӳ˵���ť���ֳ���');
  FCodeMsgMap.Add(40026,	'���Ϸ����Ӳ˵���ť KEY ����');
  FCodeMsgMap.Add(40027,	'���Ϸ����Ӳ˵���ť URL ����');
  FCodeMsgMap.Add(40028,	'���Ϸ����Զ���˵�ʹ���û�');
  FCodeMsgMap.Add(40029,	'���Ϸ��� oauth_code');
  FCodeMsgMap.Add(40030,	'���Ϸ��� refresh_token');
  FCodeMsgMap.Add(40031,	'���Ϸ��� openid �б�');
  FCodeMsgMap.Add(40032,	'���Ϸ��� openid �б���');
  FCodeMsgMap.Add(40033,	'���Ϸ��������ַ������ܰ��� \uxxxx ��ʽ���ַ�');
  FCodeMsgMap.Add(40035,	'���Ϸ��Ĳ���');
  FCodeMsgMap.Add(40038,	'���Ϸ��������ʽ');
  FCodeMsgMap.Add(40039,	'���Ϸ��� URL ����');
  FCodeMsgMap.Add(40050,	'���Ϸ��ķ��� id');
  FCodeMsgMap.Add(40051,	'�������ֲ��Ϸ�');
  FCodeMsgMap.Add(40060,	'ɾ����ƪͼ��ʱ��ָ���� article_idx ���Ϸ�');
  FCodeMsgMap.Add(40117,	'�������ֲ��Ϸ�');
  FCodeMsgMap.Add(40118,	'media_id ��С���Ϸ�');
  FCodeMsgMap.Add(40119,	'button ���ʹ���');
  FCodeMsgMap.Add(40120,	'button ���ʹ���');
  FCodeMsgMap.Add(40121,	'���Ϸ��� media_id ����');
  FCodeMsgMap.Add(40132,	'΢�źŲ��Ϸ�');
  FCodeMsgMap.Add(40137,	'��֧�ֵ�ͼƬ��ʽ');
  FCodeMsgMap.Add(40155,	'��������������ںŵ���ҳ����');
  FCodeMsgMap.Add(41001,	'ȱ�� access_token ����');
  FCodeMsgMap.Add(41002,	'ȱ�� appid ����');
  FCodeMsgMap.Add(41003,	'ȱ�� refresh_token ����');
  FCodeMsgMap.Add(41004,	'ȱ�� secret ����');
  FCodeMsgMap.Add(41005,	'ȱ�ٶ�ý���ļ�����');
  FCodeMsgMap.Add(41006,	'ȱ�� media_id ����');
  FCodeMsgMap.Add(41007,	'ȱ���Ӳ˵�����');
  FCodeMsgMap.Add(41008,	'ȱ�� oauth code');
  FCodeMsgMap.Add(41009,	'ȱ�� openid');
  FCodeMsgMap.Add(42001,	'access_token ��ʱ������ access_token ����Ч�ڣ���ο�����֧�� - ��ȡ access_token �У��� access_token ����ϸ����˵��');
  FCodeMsgMap.Add(42002,	'refresh_token ��ʱ');
  FCodeMsgMap.Add(42003,	'oauth_code ��ʱ');
  FCodeMsgMap.Add(42007,	'�û��޸�΢�����룬 accesstoken �� refreshtoken ʧЧ����Ҫ������Ȩ');
  FCodeMsgMap.Add(43001,	'��Ҫ GET ����');
  FCodeMsgMap.Add(43002,	'��Ҫ POST ����');
  FCodeMsgMap.Add(43003,	'��Ҫ HTTPS ����');
  FCodeMsgMap.Add(43004,	'��Ҫ�����߹�ע');
  FCodeMsgMap.Add(43005,	'��Ҫ���ѹ�ϵ');
  FCodeMsgMap.Add(43019,	'��Ҫ�������ߴӺ��������Ƴ�');
  FCodeMsgMap.Add(44001,	'��ý���ļ�Ϊ��');
  FCodeMsgMap.Add(44002,	'POST �����ݰ�Ϊ��');
  FCodeMsgMap.Add(44003,	'ͼ����Ϣ����Ϊ��');
  FCodeMsgMap.Add(44004,	'�ı���Ϣ����Ϊ��');
  FCodeMsgMap.Add(45001,	'��ý���ļ���С��������');
  FCodeMsgMap.Add(45002,	'��Ϣ���ݳ�������');
  FCodeMsgMap.Add(45003,	'�����ֶγ�������');
  FCodeMsgMap.Add(45004,	'�����ֶγ�������');
  FCodeMsgMap.Add(45005,	'�����ֶγ�������');
  FCodeMsgMap.Add(45006,	'ͼƬ�����ֶγ�������');
  FCodeMsgMap.Add(45007,	'��������ʱ�䳬������');
  FCodeMsgMap.Add(45008,	'ͼ����Ϣ��������');
  FCodeMsgMap.Add(45009,	'�ӿڵ��ó�������');
  FCodeMsgMap.Add(45010,	'�����˵�������������');
  FCodeMsgMap.Add(45011,	'API ����̫Ƶ�������Ժ�����');
  FCodeMsgMap.Add(45015,	'�ظ�ʱ�䳬������');
  FCodeMsgMap.Add(45016,	'ϵͳ���飬�������޸�');
  FCodeMsgMap.Add(45017,	'�������ֹ���');
  FCodeMsgMap.Add(45018,	'����������������');
  FCodeMsgMap.Add(45047,	'�ͷ��ӿ�����������������');
  FCodeMsgMap.Add(45157,	'��ǩ���Ƿ�����ע�ⲻ�ܺ�������ǩ����');
  FCodeMsgMap.Add(45158,	'��ǩ�����ȳ���30���ֽ�');
  FCodeMsgMap.Add(45159,	'�Ƿ���tag_id');
  FCodeMsgMap.Add(45056,	'�����ı�ǩ�����࣬��ע�ⲻ�ܳ���100��');
  FCodeMsgMap.Add(45058,	'�����޸�0/1/2������ϵͳĬ�ϱ����ı�ǩ');
  FCodeMsgMap.Add(45059,	'�з�˿���ϵı�ǩ���Ѿ��������ƣ�������20��');
  FCodeMsgMap.Add(49003,	'�����openid�����ڴ�AppID');
  FCodeMsgMap.Add(46001,	'������ý������');
  FCodeMsgMap.Add(46002,	'�����ڵĲ˵��汾');
  FCodeMsgMap.Add(46003,	'�����ڵĲ˵�����');
  FCodeMsgMap.Add(46004,	'�����ڵ��û�');
  FCodeMsgMap.Add(47001,	'���� JSON/XML ���ݴ���');
  FCodeMsgMap.Add(48001,	'api ����δ��Ȩ����ȷ�Ϲ��ں��ѻ�øýӿڣ������ڹ���ƽ̨���� - ����������ҳ�в鿴�ӿ�Ȩ��');
  FCodeMsgMap.Add(48002,	'��˿������Ϣ����˿�ڹ��ں�ѡ���У��ر��� �� ������Ϣ �� ��');
  FCodeMsgMap.Add(48004,	'api �ӿڱ���������¼ mp.weixin.qq.com �鿴����');
  FCodeMsgMap.Add(48005,	'api ��ֹɾ�����Զ��ظ����Զ���˵����õ��ز�');
  FCodeMsgMap.Add(48006,	'api ��ֹ������ô�������Ϊ��������ﵽ����');
  FCodeMsgMap.Add(48008,	'û�и�������Ϣ�ķ���Ȩ��');
  FCodeMsgMap.Add(50001,	'�û�δ��Ȩ�� api');
  FCodeMsgMap.Add(50002,	'�û����ޣ�������Υ���ӿڱ����');
  FCodeMsgMap.Add(50005,	'�û�δ��ע���ں�');
  FCodeMsgMap.Add(61451,	'�������� (invalid parameter)');
  FCodeMsgMap.Add(61452,	'��Ч�ͷ��˺� (invalid kf_account)');
  FCodeMsgMap.Add(61453,	'�ͷ��ʺ��Ѵ��� (kf_account exsited)');
  FCodeMsgMap.Add(61454,	'�ͷ��ʺ������ȳ������� ( ������ 10 ��Ӣ���ַ��������� @ �� @ ��Ĺ��ںŵ�΢�ź� )(invalid kf_acount length)');
  FCodeMsgMap.Add(61455,	'�ͷ��ʺ��������Ƿ��ַ� ( ������Ӣ�� + ���� )(illegal character in kf_account)');
  FCodeMsgMap.Add(61456,	'�ͷ��ʺŸ����������� (10 ���ͷ��˺� )(kf_account count exceeded)');
  FCodeMsgMap.Add(61457,	'��Чͷ���ļ����� (invalid file type)');
  FCodeMsgMap.Add(61450,	'ϵͳ���� (system error)');
  FCodeMsgMap.Add(61500,	'���ڸ�ʽ����');
  FCodeMsgMap.Add(65301,	'�����ڴ� menuid ��Ӧ�ĸ��Ի��˵�');
  FCodeMsgMap.Add(65302,	'û����Ӧ���û�');
  FCodeMsgMap.Add(65303,	'û��Ĭ�ϲ˵������ܴ������Ի��˵�');
  FCodeMsgMap.Add(65304,	'MatchRule ��ϢΪ��');
  FCodeMsgMap.Add(65305,	'���Ի��˵���������');
  FCodeMsgMap.Add(65306,	'��֧�ָ��Ի��˵����ʺ�');
  FCodeMsgMap.Add(65307,	'���Ի��˵���ϢΪ��');
  FCodeMsgMap.Add(65308,	'����û����Ӧ���͵� button');
  FCodeMsgMap.Add(65309,	'���Ի��˵����ش��ڹر�״̬');
  FCodeMsgMap.Add(65310,	'��д��ʡ�ݻ������Ϣ��������Ϣ����Ϊ��');
  FCodeMsgMap.Add(65311,	'��д�˳�����Ϣ��ʡ����Ϣ����Ϊ��');
  FCodeMsgMap.Add(65312,	'���Ϸ��Ĺ�����Ϣ');
  FCodeMsgMap.Add(65313,	'���Ϸ���ʡ����Ϣ');
  FCodeMsgMap.Add(65314,	'���Ϸ��ĳ�����Ϣ');
  FCodeMsgMap.Add(65316,	'�ù��ںŵĲ˵������˹�������������������ת�� 3 �����������ӣ�');
  FCodeMsgMap.Add(65317,	'���Ϸ��� URL');
  FCodeMsgMap.Add(65400,	'API�����ã���û�п�ͨ/�������¿ͷ�����');
  FCodeMsgMap.Add(65401,	'��Ч�ͷ��ʺ�');
  FCodeMsgMap.Add(65403,	'�ͷ��ǳƲ��Ϸ�');
  FCodeMsgMap.Add(65404,	'�ͷ��ʺŲ��Ϸ�');
  FCodeMsgMap.Add(65405,	'�ʺ���Ŀ�Ѵﵽ���ޣ����ܼ������');
  FCodeMsgMap.Add(65406,	'�Ѿ����ڵĿͷ��ʺ�');
  FCodeMsgMap.Add(65407,	'��������Ѿ��Ǳ����ںſͷ�');
  FCodeMsgMap.Add(65408,	'�����ں��ѷ����������΢�ź�');
  FCodeMsgMap.Add(65409,	'��Ч��΢�ź�');
  FCodeMsgMap.Add(65410,	'�������󶨹��ںſͷ������ﵽ���ޣ�Ŀǰÿ��΢�ź������԰�5�����ںſͷ��ʺţ�');
  FCodeMsgMap.Add(65411,	'���ʺ��Ѿ���һ���ȴ�ȷ�ϵ����룬�����ظ�����');
  FCodeMsgMap.Add(65412,	'���ʺ��Ѿ���΢�źţ����ܽ�������');
  FCodeMsgMap.Add(9001001,	'POST ���ݲ������Ϸ�');
  FCodeMsgMap.Add(9001002,	'Զ�˷��񲻿���');
  FCodeMsgMap.Add(9001003,	'Ticket ���Ϸ�');
  FCodeMsgMap.Add(9001004,	'��ȡҡ�ܱ��û���Ϣʧ��');
  FCodeMsgMap.Add(9001005,	'��ȡ�̻���Ϣʧ��');
  FCodeMsgMap.Add(9001006,	'��ȡ OpenID ʧ��');
  FCodeMsgMap.Add(9001007,  '�ϴ��ļ�ȱʧ');
  FCodeMsgMap.Add(9001008,	'�ϴ��زĵ��ļ����Ͳ��Ϸ�');
  FCodeMsgMap.Add(9001009,	'�ϴ��زĵ��ļ��ߴ粻�Ϸ�');
  FCodeMsgMap.Add(9001010,	'�ϴ�ʧ��');
  FCodeMsgMap.Add(9001020,	'�ʺŲ��Ϸ�');
  FCodeMsgMap.Add(9001021,	'�����豸�����ʵ��� 50% �����������豸');
  FCodeMsgMap.Add(9001022,	'�豸���������Ϸ�������Ϊ���� 0 ������');
  FCodeMsgMap.Add(9001023,	'�Ѵ�������е��豸 ID ����');
  FCodeMsgMap.Add(9001024,	'һ�β�ѯ�豸 ID �������ܳ��� 50');
  FCodeMsgMap.Add(9001025,	'�豸 ID ���Ϸ�');
  FCodeMsgMap.Add(9001026,	'ҳ�� ID ���Ϸ�');
  FCodeMsgMap.Add(9001027,	'ҳ��������Ϸ�');
  FCodeMsgMap.Add(9001028,	'һ��ɾ��ҳ�� ID �������ܳ��� 10');
  FCodeMsgMap.Add(9001029,	'ҳ����Ӧ�����豸�У����Ƚ��Ӧ�ù�ϵ��ɾ��');
  FCodeMsgMap.Add(9001030,	'һ�β�ѯҳ�� ID �������ܳ��� 50');
  FCodeMsgMap.Add(9001031,	'ʱ�����䲻�Ϸ�');
  FCodeMsgMap.Add(9001032,	'�����豸��ҳ��İ󶨹�ϵ��������');
  FCodeMsgMap.Add(9001033,	'�ŵ� ID ���Ϸ�');
  FCodeMsgMap.Add(9001034,	'�豸��ע��Ϣ����');
  FCodeMsgMap.Add(9001035,	'�豸����������Ϸ�');
  FCodeMsgMap.Add(9001036,	'��ѯ��ʼֵ begin ���Ϸ�');
  FCodeMsgMap.Add(40202,	  '����ȷ��action');
  FCodeMsgMap.Add(40203,	  '����ȷ��check_operato');
  FCodeMsgMap.Add(40201,	  '����ȷ��URL��һ���ǿ�����δ���ûص�URL');
end;

class procedure TWXException.ParseJsonStr(const JsonStr: string);
begin
  ParseJsonStr(JsonStr, '')
end;

class procedure TWXException.ParseJsonStr(const JsonStr, Description: string);
var
  jo: TJSONObject;
  ErrMsg: string;
  ErrCode: Integer;
begin
  if JsonStr.Trim.Length = 0 then
    Exit;
  jo := nil;
  try
    jo := TJSONObject.ParseUtf8(JsonStr) as TJSONObject;
    if not Assigned(jo) or not jo.Contains('errcode') then
      Exit;
    ErrCode := jo.I['errcode'];
    if ErrCode <> 0 then begin
      if not FCodeMsgMap.TryGetValue(ErrCode, ErrMsg) then
        ErrMsg := jo.S['errmsg'];
      if Description.Trim.Length > 0 then
        raise TWXException.Create(ErrCode, Format('%s��������[%d]:'#13#10'%s', [Description, ErrCode, ErrMsg]))
      else
        raise TWXException.Create(ErrCode, Format('[%d] - %s', [ErrCode, ErrMsg]));
    end;
  finally
    jo.Free;
  end;
end;

end.
