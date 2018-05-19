unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Image1: TImage;
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation
uses Unit1;
{$R *.lfm}

{ TForm2 }

procedure TForm2.FormShow(Sender: TObject);
var str:string;
  f:textfile;
begin
  AssignFile(f,'settings_color.txt');
  ReSet(f);
  Readln(f,str);
  CloseFile(f);

  Form2.Color:=StrToInt(str);

end;

end.

