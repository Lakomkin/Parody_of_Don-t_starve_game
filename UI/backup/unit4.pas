unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes,LConvEncoding, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ColorDialog1: TColorDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form4: TForm4;

implementation
uses Unit3;
{$R *.lfm}

{ TForm4 }



procedure TForm4.Button2Click(Sender: TObject);
begin
  Form4.Hide;
  Form3.Show;
end;

procedure TForm4.Button1Click(Sender: TObject);
var f:textfile;
begin
  if ColorDialog1.Execute then begin

    Form4.Color := ColorDialog1.Color;
    AssignFile(f,'settings_color.txt');
    Rewrite(f);

    Writeln(f,IntToStr(ColorDialog1.Color));
    CloseFile(f);

  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin

end;

procedure TForm4.FormShow(Sender: TObject);
var f:textfile;
  str:string;
begin
  AssignFile(f,'settings_color.txt');
  ReSet(f);
  Readln(f,str);
  CloseFile(f);

  Form4.Color:=StrToInt(str);

end;

end.

