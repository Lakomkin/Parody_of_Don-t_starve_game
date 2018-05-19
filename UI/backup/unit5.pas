unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes,LConvEncoding, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm5 }

  TForm5 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form5: TForm5;

implementation
uses Unit3;
{$R *.lfm}

{ TForm5 }

procedure TForm5.FormCreate(Sender: TObject);
begin
   Memo1.Text := CP1251ToUTF8(ReadFileToString('author.txt'));
end;

procedure TForm5.FormShow(Sender: TObject);
var str:string;
  f:textfile;
begin
  Form1.Timer1.Enabled:=false;
  AssignFile(f,'settings_color.txt');
  ReSet(f);
  Readln(f,str);
  CloseFile(f);

  Form5.Color:=StrToInt(str);

end;

procedure TForm5.Button1Click(Sender: TObject);
begin
   Form5.Hide;
   Form3.Show;
end;

end.

