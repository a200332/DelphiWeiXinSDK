(**************************************************)
(*     Advanced Encryption Standard (AES)         *)
(*     Interface Unit v1.3                        *)
(*说明：                                          *)
(*   基于 ElASE.pas 单元封装                      *)
(*   这是一个 AES 加密算法的标准接口。            *)
(*   支持 128 / 192 / 256 位的密匙                *)
(*   默认情况下按照 128 位密匙操作                *)
(**************************************************)

unit AES; // 申明文件名称

interface

uses
  SysUtils, Classes, Math, ElAES;

type
  TKeyBit = (kb128, kb192, kb256);
  TPaddingType = (PKCS5Padding, PKCS7Padding);
function StrToHex(Value: AnsiString): AnsiString;
function HexToStr(Value: AnsiString): AnsiString;
function EncryptString(Value: AnsiString; Key: AnsiString;
  KeyBit: TKeyBit = kb128): AnsiString;
function DecryptString(Value: AnsiString; Key: AnsiString;
  KeyBit: TKeyBit = kb128): AnsiString;
function EncryptStream(Stream: TStream; Key: AnsiString;
  KeyBit: TKeyBit = kb128): TMemoryStream; overload;
procedure EncryptStream(InStream, OutStream: TStream; Key: AnsiString;
  KeyBit: TKeyBit = kb128); overload;
function DecryptStream(Stream: TStream; Key: AnsiString;
  KeyBit: TKeyBit = kb128): TMemoryStream; overload;
procedure DecryptStream(InStream, OutStream: TStream; Key: AnsiString;
  KeyBit: TKeyBit = kb128); overload;
procedure EncryptFile(SourceFile, DestFile: AnsiString;
  Key: AnsiString; KeyBit: TKeyBit = kb128);
procedure DecryptFile(SourceFile, DestFile: AnsiString;
  Key: AnsiString; KeyBit: TKeyBit = kb128);

//by kunlun122 2014-06-07
function StrPadding(SourceStr: AnsiString; paddingType: TPaddingType = PKCS5Padding): AnsiString;
function StrDelPadding(SourceStr: AnsiString; paddingType: TPaddingType = PKCS5Padding): AnsiString;

implementation

uses Dialogs, EncdDecd;

function StrToHex(Value: AnsiString): AnsiString;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
    Result := Result + IntToHex(Ord(Value[I]), 2);
end;

function HexToStr(Value: AnsiString): AnsiString;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
  begin
    if ((I mod 2) = 1) then
      Result := Result + Chr(StrToInt('0x' + Copy(Value, I, 2)));
  end;
end;

{  --  字符串加密函数 默认按照 128 位密匙加密 --  }

function EncryptString(Value: AnsiString; Key: AnsiString;
  KeyBit: TKeyBit = kb128): AnsiString;
var
  SS, DS, base: TStringStream;
  //Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
//  s: AnsiString;
begin
  Value := StrPadding(Value, PKCS5Padding);
  SS := TStringStream.Create(Value);
  DS := TStringStream.Create('');
  base := TStringStream.Create('');
  try
    //Size := SS.Size;
    //DS.WriteBuffer(Size, SizeOf(Size));
    {  --  128 位密匙最大长度为 16 个字符 --  }
    if KeyBit = kb128 then
    begin
      FillChar(AESKey128, SizeOf(AESKey128), 0);
      Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
      EncryptAESStreamECB(SS, 0, AESKey128, DS);
    end
    else if KeyBit = kb192 then {  --  192 位密匙最大长度为 24 个字符 --  }
    begin
      FillChar(AESKey192, SizeOf(AESKey192), 0);
      Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
      EncryptAESStreamECB(SS, 0, AESKey192, DS);
    end
    else if KeyBit = kb256 then {  --  256 位密匙最大长度为 32 个字符 --  }
    begin
      FillChar(AESKey256, SizeOf(AESKey256), 0);
      Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
      EncryptAESStreamECB(SS, 0, AESKey256, DS);
    end;
    DS.Position := 0;
    EncodeStream(DS, base);
    Result := base.DataString;
  finally
    SS.Free;
    DS.Free;
    base.Free;
  end;
end;

{  --  字符串解密函数 默认按照 128 位密匙解密 --  }

function DecryptString(Value: AnsiString; Key: AnsiString;
  KeyBit: TKeyBit = kb128): AnsiString;
var
  SS, DS, base: TStringStream;
  //Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  DS := TStringStream.Create('');
  SS := TStringStream.Create('');
  base := TStringStream.Create(Value);
  try
    DecodeStream(base, SS);
    SS.Position := 0;
    //Size := SS.Size;
    //SS.ReadBuffer(Size, SizeOf(Size));
    {  --  128 位密匙最大长度为 16 个字符 --  }
    if KeyBit = kb128 then
    begin
      FillChar(AESKey128, SizeOf(AESKey128), 0);
      Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
      DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey128, DS);
    end;
    {  --  192 位密匙最大长度为 24 个字符 --  }
    if KeyBit = kb192 then
    begin
      FillChar(AESKey192, SizeOf(AESKey192), 0);
      Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
      DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey192, DS);
    end;
    {  --  256 位密匙最大长度为 32 个字符 --  }
    if KeyBit = kb256 then
    begin
      FillChar(AESKey256, SizeOf(AESKey256), 0);
      Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
      DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey256, DS);
    end;
    Result := StrDelPadding(DS.DataString);
  finally
    SS.Free;
    DS.Free;
    base.Free;
  end;
end;

{  --  流加密函数 默认按照 128 位密匙解密 --  }

function EncryptStream(Stream: TStream; Key: AnsiString;
  KeyBit: TKeyBit = kb128): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  EncryptStream(Stream, Result, Key, KeyBit);
end;

procedure EncryptStream(InStream, OutStream: TStream; Key: AnsiString;
  KeyBit: TKeyBit = kb128);
var
  Count: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  OutStream.Size := 0;
  InStream.Position := 0;
  Count := InStream.Size;
  OutStream.Write(Count, SizeOf(Count));
  {  --  128 位密匙最大长度为 16 个字符 --  }
  if KeyBit = kb128 then
  begin
    FillChar(AESKey128, SizeOf(AESKey128), 0);
    Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
    EncryptAESStreamECB(InStream, 0, AESKey128, OutStream);
  end;
  {  --  192 位密匙最大长度为 24 个字符 --  }
  if KeyBit = kb192 then
  begin
    FillChar(AESKey192, SizeOf(AESKey192), 0);
    Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
    EncryptAESStreamECB(InStream, 0, AESKey192, OutStream);
  end;
  {  --  256 位密匙最大长度为 32 个字符 --  }
  if KeyBit = kb256 then
  begin
    FillChar(AESKey256, SizeOf(AESKey256), 0);
    Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
    EncryptAESStreamECB(InStream, 0, AESKey256, OutStream);
  end;
end;

{  --  流解密函数 默认按照 128 位密匙解密 --  }

function DecryptStream(Stream: TStream; Key: AnsiString;
  KeyBit: TKeyBit = kb128): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  DecryptStream(Stream, Result, Key, KeyBit);
end;

procedure DecryptStream(InStream, OutStream: TStream; Key: AnsiString;
  KeyBit: TKeyBit = kb128); overload;
var
  Count, OutPos: Int64;
//  OutStrm: TMemoryStream;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  OutStream.Size := 0;
  InStream.Position := 0;
  OutPos := OutStream.Position;
  InStream.ReadBuffer(Count, SizeOf(Count));
  {  --  128 位密匙最大长度为 16 个字符 --  }
  if KeyBit = kb128 then
  begin
    FillChar(AESKey128, SizeOf(AESKey128), 0);
    Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
    DecryptAESStreamECB(InStream, InStream.Size - InStream.Position,
      AESKey128, OutStream);
  end;
  {  --  192 位密匙最大长度为 24 个字符 --  }
  if KeyBit = kb192 then
  begin
    FillChar(AESKey192, SizeOf(AESKey192), 0);
    Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
    DecryptAESStreamECB(InStream, InStream.Size - InStream.Position,
      AESKey192, OutStream);
  end;
  {  --  256 位密匙最大长度为 32 个字符 --  }
  if KeyBit = kb256 then
  begin
    FillChar(AESKey256, SizeOf(AESKey256), 0);
    Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
    DecryptAESStreamECB(InStream, InStream.Size - InStream.Position,
      AESKey256, OutStream);
  end;
  OutStream.Size := OutPos + Count;
  OutStream.Position := OutPos;
end;

{  --  文件加密函数 默认按照 128 位密匙解密 --  }

procedure EncryptFile(SourceFile, DestFile: AnsiString;
  Key: AnsiString; KeyBit: TKeyBit = kb128);
var
  SFS, DFS: TFileStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  SFS := TFileStream.Create(SourceFile, fmOpenRead);
  try
    DFS := TFileStream.Create(DestFile, fmCreate);
    try
      Size := SFS.Size;
      DFS.WriteBuffer(Size, SizeOf(Size));
      {  --  128 位密匙最大长度为 16 个字符 --  }
      if KeyBit = kb128 then
      begin
        FillChar(AESKey128, SizeOf(AESKey128), 0);
        Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
        EncryptAESStreamECB(SFS, 0, AESKey128, DFS);
      end;
      {  --  192 位密匙最大长度为 24 个字符 --  }
      if KeyBit = kb192 then
      begin
        FillChar(AESKey192, SizeOf(AESKey192), 0);
        Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
        EncryptAESStreamECB(SFS, 0, AESKey192, DFS);
      end;
      {  --  256 位密匙最大长度为 32 个字符 --  }
      if KeyBit = kb256 then
      begin
        FillChar(AESKey256, SizeOf(AESKey256), 0);
        Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
        EncryptAESStreamECB(SFS, 0, AESKey256, DFS);
      end;
    finally
      DFS.Free;
    end;
  finally
    SFS.Free;
  end;
end;

{  --  文件解密函数 默认按照 128 位密匙解密 --  }

procedure DecryptFile(SourceFile, DestFile: AnsiString;
  Key: AnsiString; KeyBit: TKeyBit = kb128);
var
  SFS, DFS: TFileStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  SFS := TFileStream.Create(SourceFile, fmOpenRead);
  try
    SFS.ReadBuffer(Size, SizeOf(Size));
    DFS := TFileStream.Create(DestFile, fmCreate);
    try
      {  --  128 位密匙最大长度为 16 个字符 --  }
      if KeyBit = kb128 then
      begin
        FillChar(AESKey128, SizeOf(AESKey128), 0);
        Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
        DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey128, DFS);
      end;
      {  --  192 位密匙最大长度为 24 个字符 --  }
      if KeyBit = kb192 then
      begin
        FillChar(AESKey192, SizeOf(AESKey192), 0);
        Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
        DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey192, DFS);
      end;
      {  --  256 位密匙最大长度为 32 个字符 --  }
      if KeyBit = kb256 then
      begin
        FillChar(AESKey256, SizeOf(AESKey256), 0);
        Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
        DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey256, DFS);
      end;
      DFS.Size := Size;
    finally
      DFS.Free;
    end;
  finally
    SFS.Free;
  end;
end;

//by kunlun122 2014-06-07
{  --  字符串填充方式 默认按照 PKCS5Padding 填充 --  }

function StrPadding(SourceStr: AnsiString; paddingType: TPaddingType = PKCS5Padding): AnsiString;
var
  DestStr: AnsiString;
  strRemainder, i: Integer;
begin
  DestStr := SourceStr;
  if paddingType = PKCS5Padding then
  begin
    strRemainder := Length(DestStr) mod 16;
    strRemainder := 16 - strRemainder;
    for i := 1 to strRemainder do
    begin
      DestStr := DestStr + Chr(strRemainder);
    end;
  end;
  Result := DestStr;
end;

function StrDelPadding(SourceStr: AnsiString; paddingType: TPaddingType = PKCS5Padding): AnsiString;
var
  DestStr: AnsiString;
  PaddingLen: Integer;
begin
  DestStr := SourceStr;
  if paddingType = PKCS5Padding then
  begin
    PaddingLen := Ord(DestStr[Length(DestStr)]);
    DestStr := Copy(DestStr, 1, Length(DestStr) - PaddingLen);
  end;
  Result := DestStr;
end;
end.

