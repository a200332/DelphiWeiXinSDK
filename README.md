微信公众平台 Delphi SDK

使用方法
used
  WX.App, WX.Common;
  
var
  App: IwxApp;
begin
  App := TwxAppBuilder.AppId('编号').Secret('密码').Build;
  App.GetMenuInfo;
  App.GetUserList;
  App.DownloadMedia; 
  //...
  // ...
end;

有疑问联系qq：724464297
