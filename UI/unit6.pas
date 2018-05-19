unit Unit6;

{$mode objfpc}{$H+}

interface

uses
  Classes,LConvEncoding, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm6 }

  TForm6 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form6: TForm6;

implementation
uses Unit3;
{$R *.lfm}

{ TForm6 }

procedure TForm6.FormCreate(Sender: TObject);
begin
  Memo1.Text := CP1251ToUTF8(ReadFileToString('materials.txt'));
end;

procedure TForm6.FormShow(Sender: TObject);
var str:string;
  f:textfile;
begin
  AssignFile(f,'settings_color.txt');
  ReSet(f);
  Readln(f,str);
  CloseFile(f);

  Form6.Color:=StrToInt(str);

end;

procedure TForm6.Button1Click(Sender: TObject);
begin
  Form6.Hide;
  Form3.Show;
end;

end.

