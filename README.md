微信公众平台 Delphi SDK  

使用方法  
used
  WX.App, WX.Common;  
  
var  
  App: IwxApp;  
begin  
&nbsp;&nbsp;App := TwxAppBuilder.AppId('编号').Secret('密码').Build;  
&nbsp;&nbsp;App.GetMenuInfo;  
&nbsp;&nbsp;App.GetUserList;  
&nbsp;&nbsp;App.DownloadMedia;   
&nbsp;&nbsp;//...  
&nbsp;&nbsp;// ...  
end;  
  
有疑问联系qq：724464297
