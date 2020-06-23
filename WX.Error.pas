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
  FCodeMsgMap.Add(-1,	    '系统繁忙，此时请开发者稍候再试');
  FCodeMsgMap.Add(0,	    '请求成功');
  FCodeMsgMap.Add(40001,	'获取 access_token 时 AppSecret 错误，或者 access_token 无效。请开发者认真比对 AppSecret 的正确性，或查看是否正在为恰当的公众号调用接口');
  FCodeMsgMap.Add(40002,	'不合法的凭证类型');
  FCodeMsgMap.Add(40003,	'不合法的 OpenID ，请开发者确认 OpenID （该用户）是否已关注公众号，或是否是其他公众号的 OpenID');
  FCodeMsgMap.Add(40004,	'不合法的媒体文件类型');
  FCodeMsgMap.Add(40005,	'不合法的文件类型 ');
  FCodeMsgMap.Add(40006,	'不合法的文件大小 ');
  FCodeMsgMap.Add(40007,	'不合法的媒体文件 id ');
  FCodeMsgMap.Add(40008,	'不合法的消息类型');
  FCodeMsgMap.Add(40009,	'不合法的图片文件大小');
  FCodeMsgMap.Add(40010,	'不合法的语音文件大小');
  FCodeMsgMap.Add(40011,	'不合法的视频文件大小');
  FCodeMsgMap.Add(40012,	'不合法的缩略图文件大小');
  FCodeMsgMap.Add(40013,	'不合法的 AppID ，请开发者检查 AppID 的正确性，避免异常字符，注意大小写');
  FCodeMsgMap.Add(40014,	'不合法的 access_token ，请开发者认真比对 access_token 的有效性（如是否过期），或查看是否正在为恰当的公众号调用接口');
  FCodeMsgMap.Add(40015,	'不合法的菜单类型');
  FCodeMsgMap.Add(40016,	'不合法的按钮个数');
  FCodeMsgMap.Add(40017,	'不合法的按钮个数');
  FCodeMsgMap.Add(40018,	'不合法的按钮名字长度');
  FCodeMsgMap.Add(40019,	'不合法的按钮 KEY 长度');
  FCodeMsgMap.Add(40020,	'不合法的按钮 URL 长度');
  FCodeMsgMap.Add(40021,	'不合法的菜单版本号');
  FCodeMsgMap.Add(40022,	'不合法的子菜单级数');
  FCodeMsgMap.Add(40023,	'不合法的子菜单按钮个数');
  FCodeMsgMap.Add(40024,	'不合法的子菜单按钮类型');
  FCodeMsgMap.Add(40025,	'不合法的子菜单按钮名字长度');
  FCodeMsgMap.Add(40026,	'不合法的子菜单按钮 KEY 长度');
  FCodeMsgMap.Add(40027,	'不合法的子菜单按钮 URL 长度');
  FCodeMsgMap.Add(40028,	'不合法的自定义菜单使用用户');
  FCodeMsgMap.Add(40029,	'不合法的 oauth_code');
  FCodeMsgMap.Add(40030,	'不合法的 refresh_token');
  FCodeMsgMap.Add(40031,	'不合法的 openid 列表');
  FCodeMsgMap.Add(40032,	'不合法的 openid 列表长度');
  FCodeMsgMap.Add(40033,	'不合法的请求字符，不能包含 \uxxxx 格式的字符');
  FCodeMsgMap.Add(40035,	'不合法的参数');
  FCodeMsgMap.Add(40038,	'不合法的请求格式');
  FCodeMsgMap.Add(40039,	'不合法的 URL 长度');
  FCodeMsgMap.Add(40050,	'不合法的分组 id');
  FCodeMsgMap.Add(40051,	'分组名字不合法');
  FCodeMsgMap.Add(40060,	'删除单篇图文时，指定的 article_idx 不合法');
  FCodeMsgMap.Add(40117,	'分组名字不合法');
  FCodeMsgMap.Add(40118,	'media_id 大小不合法');
  FCodeMsgMap.Add(40119,	'button 类型错误');
  FCodeMsgMap.Add(40120,	'button 类型错误');
  FCodeMsgMap.Add(40121,	'不合法的 media_id 类型');
  FCodeMsgMap.Add(40132,	'微信号不合法');
  FCodeMsgMap.Add(40137,	'不支持的图片格式');
  FCodeMsgMap.Add(40155,	'请勿添加其他公众号的主页链接');
  FCodeMsgMap.Add(41001,	'缺少 access_token 参数');
  FCodeMsgMap.Add(41002,	'缺少 appid 参数');
  FCodeMsgMap.Add(41003,	'缺少 refresh_token 参数');
  FCodeMsgMap.Add(41004,	'缺少 secret 参数');
  FCodeMsgMap.Add(41005,	'缺少多媒体文件数据');
  FCodeMsgMap.Add(41006,	'缺少 media_id 参数');
  FCodeMsgMap.Add(41007,	'缺少子菜单数据');
  FCodeMsgMap.Add(41008,	'缺少 oauth code');
  FCodeMsgMap.Add(41009,	'缺少 openid');
  FCodeMsgMap.Add(42001,	'access_token 超时，请检查 access_token 的有效期，请参考基础支持 - 获取 access_token 中，对 access_token 的详细机制说明');
  FCodeMsgMap.Add(42002,	'refresh_token 超时');
  FCodeMsgMap.Add(42003,	'oauth_code 超时');
  FCodeMsgMap.Add(42007,	'用户修改微信密码， accesstoken 和 refreshtoken 失效，需要重新授权');
  FCodeMsgMap.Add(43001,	'需要 GET 请求');
  FCodeMsgMap.Add(43002,	'需要 POST 请求');
  FCodeMsgMap.Add(43003,	'需要 HTTPS 请求');
  FCodeMsgMap.Add(43004,	'需要接收者关注');
  FCodeMsgMap.Add(43005,	'需要好友关系');
  FCodeMsgMap.Add(43019,	'需要将接收者从黑名单中移除');
  FCodeMsgMap.Add(44001,	'多媒体文件为空');
  FCodeMsgMap.Add(44002,	'POST 的数据包为空');
  FCodeMsgMap.Add(44003,	'图文消息内容为空');
  FCodeMsgMap.Add(44004,	'文本消息内容为空');
  FCodeMsgMap.Add(45001,	'多媒体文件大小超过限制');
  FCodeMsgMap.Add(45002,	'消息内容超过限制');
  FCodeMsgMap.Add(45003,	'标题字段超过限制');
  FCodeMsgMap.Add(45004,	'描述字段超过限制');
  FCodeMsgMap.Add(45005,	'链接字段超过限制');
  FCodeMsgMap.Add(45006,	'图片链接字段超过限制');
  FCodeMsgMap.Add(45007,	'语音播放时间超过限制');
  FCodeMsgMap.Add(45008,	'图文消息超过限制');
  FCodeMsgMap.Add(45009,	'接口调用超过限制');
  FCodeMsgMap.Add(45010,	'创建菜单个数超过限制');
  FCodeMsgMap.Add(45011,	'API 调用太频繁，请稍候再试');
  FCodeMsgMap.Add(45015,	'回复时间超过限制');
  FCodeMsgMap.Add(45016,	'系统分组，不允许修改');
  FCodeMsgMap.Add(45017,	'分组名字过长');
  FCodeMsgMap.Add(45018,	'分组数量超过上限');
  FCodeMsgMap.Add(45047,	'客服接口下行条数超过上限');
  FCodeMsgMap.Add(45157,	'标签名非法，请注意不能和其他标签重名');
  FCodeMsgMap.Add(45158,	'标签名长度超过30个字节');
  FCodeMsgMap.Add(45159,	'非法的tag_id');
  FCodeMsgMap.Add(45056,	'创建的标签数过多，请注意不能超过100个');
  FCodeMsgMap.Add(45058,	'不能修改0/1/2这三个系统默认保留的标签');
  FCodeMsgMap.Add(45059,	'有粉丝身上的标签数已经超过限制，即超过20个');
  FCodeMsgMap.Add(49003,	'传入的openid不属于此AppID');
  FCodeMsgMap.Add(46001,	'不存在媒体数据');
  FCodeMsgMap.Add(46002,	'不存在的菜单版本');
  FCodeMsgMap.Add(46003,	'不存在的菜单数据');
  FCodeMsgMap.Add(46004,	'不存在的用户');
  FCodeMsgMap.Add(47001,	'解析 JSON/XML 内容错误');
  FCodeMsgMap.Add(48001,	'api 功能未授权，请确认公众号已获得该接口，可以在公众平台官网 - 开发者中心页中查看接口权限');
  FCodeMsgMap.Add(48002,	'粉丝拒收消息（粉丝在公众号选项中，关闭了 “ 接收消息 ” ）');
  FCodeMsgMap.Add(48004,	'api 接口被封禁，请登录 mp.weixin.qq.com 查看详情');
  FCodeMsgMap.Add(48005,	'api 禁止删除被自动回复和自定义菜单引用的素材');
  FCodeMsgMap.Add(48006,	'api 禁止清零调用次数，因为清零次数达到上限');
  FCodeMsgMap.Add(48008,	'没有该类型消息的发送权限');
  FCodeMsgMap.Add(50001,	'用户未授权该 api');
  FCodeMsgMap.Add(50002,	'用户受限，可能是违规后接口被封禁');
  FCodeMsgMap.Add(50005,	'用户未关注公众号');
  FCodeMsgMap.Add(61451,	'参数错误 (invalid parameter)');
  FCodeMsgMap.Add(61452,	'无效客服账号 (invalid kf_account)');
  FCodeMsgMap.Add(61453,	'客服帐号已存在 (kf_account exsited)');
  FCodeMsgMap.Add(61454,	'客服帐号名长度超过限制 ( 仅允许 10 个英文字符，不包括 @ 及 @ 后的公众号的微信号 )(invalid kf_acount length)');
  FCodeMsgMap.Add(61455,	'客服帐号名包含非法字符 ( 仅允许英文 + 数字 )(illegal character in kf_account)');
  FCodeMsgMap.Add(61456,	'客服帐号个数超过限制 (10 个客服账号 )(kf_account count exceeded)');
  FCodeMsgMap.Add(61457,	'无效头像文件类型 (invalid file type)');
  FCodeMsgMap.Add(61450,	'系统错误 (system error)');
  FCodeMsgMap.Add(61500,	'日期格式错误');
  FCodeMsgMap.Add(65301,	'不存在此 menuid 对应的个性化菜单');
  FCodeMsgMap.Add(65302,	'没有相应的用户');
  FCodeMsgMap.Add(65303,	'没有默认菜单，不能创建个性化菜单');
  FCodeMsgMap.Add(65304,	'MatchRule 信息为空');
  FCodeMsgMap.Add(65305,	'个性化菜单数量受限');
  FCodeMsgMap.Add(65306,	'不支持个性化菜单的帐号');
  FCodeMsgMap.Add(65307,	'个性化菜单信息为空');
  FCodeMsgMap.Add(65308,	'包含没有响应类型的 button');
  FCodeMsgMap.Add(65309,	'个性化菜单开关处于关闭状态');
  FCodeMsgMap.Add(65310,	'填写了省份或城市信息，国家信息不能为空');
  FCodeMsgMap.Add(65311,	'填写了城市信息，省份信息不能为空');
  FCodeMsgMap.Add(65312,	'不合法的国家信息');
  FCodeMsgMap.Add(65313,	'不合法的省份信息');
  FCodeMsgMap.Add(65314,	'不合法的城市信息');
  FCodeMsgMap.Add(65316,	'该公众号的菜单设置了过多的域名外跳（最多跳转到 3 个域名的链接）');
  FCodeMsgMap.Add(65317,	'不合法的 URL');
  FCodeMsgMap.Add(65400,	'API不可用，即没有开通/升级到新客服功能');
  FCodeMsgMap.Add(65401,	'无效客服帐号');
  FCodeMsgMap.Add(65403,	'客服昵称不合法');
  FCodeMsgMap.Add(65404,	'客服帐号不合法');
  FCodeMsgMap.Add(65405,	'帐号数目已达到上限，不能继续添加');
  FCodeMsgMap.Add(65406,	'已经存在的客服帐号');
  FCodeMsgMap.Add(65407,	'邀请对象已经是本公众号客服');
  FCodeMsgMap.Add(65408,	'本公众号已发送邀请给该微信号');
  FCodeMsgMap.Add(65409,	'无效的微信号');
  FCodeMsgMap.Add(65410,	'邀请对象绑定公众号客服数量达到上限（目前每个微信号最多可以绑定5个公众号客服帐号）');
  FCodeMsgMap.Add(65411,	'该帐号已经有一个等待确认的邀请，不能重复邀请');
  FCodeMsgMap.Add(65412,	'该帐号已经绑定微信号，不能进行邀请');
  FCodeMsgMap.Add(9001001,	'POST 数据参数不合法');
  FCodeMsgMap.Add(9001002,	'远端服务不可用');
  FCodeMsgMap.Add(9001003,	'Ticket 不合法');
  FCodeMsgMap.Add(9001004,	'获取摇周边用户信息失败');
  FCodeMsgMap.Add(9001005,	'获取商户信息失败');
  FCodeMsgMap.Add(9001006,	'获取 OpenID 失败');
  FCodeMsgMap.Add(9001007,  '上传文件缺失');
  FCodeMsgMap.Add(9001008,	'上传素材的文件类型不合法');
  FCodeMsgMap.Add(9001009,	'上传素材的文件尺寸不合法');
  FCodeMsgMap.Add(9001010,	'上传失败');
  FCodeMsgMap.Add(9001020,	'帐号不合法');
  FCodeMsgMap.Add(9001021,	'已有设备激活率低于 50% ，不能新增设备');
  FCodeMsgMap.Add(9001022,	'设备申请数不合法，必须为大于 0 的数字');
  FCodeMsgMap.Add(9001023,	'已存在审核中的设备 ID 申请');
  FCodeMsgMap.Add(9001024,	'一次查询设备 ID 数量不能超过 50');
  FCodeMsgMap.Add(9001025,	'设备 ID 不合法');
  FCodeMsgMap.Add(9001026,	'页面 ID 不合法');
  FCodeMsgMap.Add(9001027,	'页面参数不合法');
  FCodeMsgMap.Add(9001028,	'一次删除页面 ID 数量不能超过 10');
  FCodeMsgMap.Add(9001029,	'页面已应用在设备中，请先解除应用关系再删除');
  FCodeMsgMap.Add(9001030,	'一次查询页面 ID 数量不能超过 50');
  FCodeMsgMap.Add(9001031,	'时间区间不合法');
  FCodeMsgMap.Add(9001032,	'保存设备与页面的绑定关系参数错误');
  FCodeMsgMap.Add(9001033,	'门店 ID 不合法');
  FCodeMsgMap.Add(9001034,	'设备备注信息过长');
  FCodeMsgMap.Add(9001035,	'设备申请参数不合法');
  FCodeMsgMap.Add(9001036,	'查询起始值 begin 不合法');
  FCodeMsgMap.Add(40202,	  '不正确的action');
  FCodeMsgMap.Add(40203,	  '不正确的check_operato');
  FCodeMsgMap.Add(40201,	  '不正确的URL，一般是开发者未设置回调URL');
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
        raise TWXException.Create(ErrCode, Format('%s发生错误[%d]:'#13#10'%s', [Description, ErrCode, ErrMsg]))
      else
        raise TWXException.Create(ErrCode, Format('[%d] - %s', [ErrCode, ErrMsg]));
    end;
  finally
    jo.Free;
  end;
end;

end.
