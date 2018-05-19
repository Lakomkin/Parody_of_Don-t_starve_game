unit Unit7;

{$mode objfpc}{$H+}

interface

uses
  Classes,LConvEncoding, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm7 }

  TForm7 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form7: TForm7;

implementation
uses Unit3;
{$R *.lfm}

{ TForm7 }

procedure TForm7.FormCreate(Sender: TObject);
begin
  Memo1.Text := CP1251ToUTF8(ReadFileToString('reference.txt'));
end;

procedure TForm7.FormShow(Sender: TObject);
var str:string;
  f:textfile;
begin
  AssignFile(f,'settings_color.txt');
  ReSet(f);
  Readln(f,str);
  CloseFile(f);

  Form7.Color:=StrToInt(str);

end;

procedure TForm7.Button1Click(Sender: TObject);
begin
  Form7.Hide;
  Form3.Show;
end;

end.

