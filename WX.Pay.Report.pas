unit WX.Pay.Report;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  System.SyncObjs, System.Net.HttpClient;

type
  TwxPayReport = class
  private
    class var FInstance: TwxPayReport;
    class destructor Destroy;
  private
    FTerminate: Boolean;
    FEnent: TEvent;
    FQueue: TQueue<string>;
    FThread: TThread;
    FHTTPClient: THTTPClient;
    procedure DoReport;
  public
    procedure Enqueue(Info: string);
    class function Instance: TwxPayReport;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  WX.Common;

{ TwxPayReport }

class destructor TwxPayReport.Destroy;
begin
  FInstance.Free;
end;

class function TwxPayReport.Instance: TwxPayReport;
var
  temp: TwxPayReport;
begin
  if FInstance = nil then begin
    temp := TwxPayReport.Create;
    if TInterlocked.CompareExchange<TwxPayReport>(FInstance, temp, nil) <> nil then
      temp.Free;
  end;
  Result := FInstance;
end;

constructor TwxPayReport.Create;
begin
  FQueue := TQueue<string>.Create;
  FEnent := TEvent.Create;
  FEnent.ResetEvent;
  FHTTPClient := THTTPClient.Create;
  FHTTPClient.ContentType := 'text/xml';
  FHTTPClient.UserAgent := WX_PAYSDK_VERSION;
  FHTTPClient.ConnectionTimeout := 6000;
  FHTTPClient.ResponseTimeout := 8000;
  FThread := TThread.CreateAnonymousThread(
    procedure
    begin
      while not FTerminate do begin
        FEnent.WaitFor;
        if FTerminate then
          Break;
        try
          DoReport;
        except
        end
      end;
    end);
  FThread.FreeOnTerminate := False;
  FThread.Start;
end;

destructor TwxPayReport.Destroy;
begin
  FTerminate := True;
  FEnent.SetEvent;
  FThread.WaitFor;
  FThread.Free;
  FEnent.Free;
  FQueue.Free;
  Inherited;
end;

procedure TwxPayReport.Enqueue(Info: string);
begin
  System.TMonitor.Enter(FQueue);
  try
    FQueue.Enqueue(Info);
    FEnent.SetEvent;
  finally
    System.TMonitor.Exit(FQueue);
  end;
end;

procedure TwxPayReport.DoReport;
var
  Info: string;
  ss: TStringStream;
begin
  System.TMonitor.Enter(FQueue);
  try
    if FQueue.Count = 0 then begin
      FEnent.ResetEvent;
      Exit;
    end;
    Info := FQueue.Dequeue;
    if FQueue.Count = 0 then
      FEnent.ResetEvent;
  finally
    System.TMonitor.Exit(FQueue);
  end;
  ss := TStringStream.Create(Info, TEncoding.UTF8);
  try
    FHTTPClient.Post('https://api.mch.weixin.qq.com/payitil/report', ss);
  finally
    ss.Free;
  end;
end;

end.
