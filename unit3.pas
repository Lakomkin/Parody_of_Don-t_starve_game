unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus;

type

  { TForm3 }

  TForm3 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;
  LoadSavedGameMarcker:integer;

implementation
uses Unit1,Unit4,Unit2,Unit5,Unit6,Unit7;
{$R *.lfm}

{ TForm3 }

procedure TForm3.Image2Click(Sender: TObject);
begin
  Form1.Show;
  Form3.Hide;
  Form1.Timer1.Enabled:=true;
  LoadSavedGameMarcker:=1;
end;

procedure TForm3.Image3Click(Sender: TObject);
begin
  Form4.Show;
  Form3.Hide;
end;

procedure TForm3.Image4Click(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.Image5Click(Sender: TObject);
begin
  Form5.Show;
  Form3.Hide;
end;

procedure TForm3.Image6Click(Sender: TObject);
begin
  Form1.Show;
  Form3.Hide;
  Form1.Timer1.Enabled:=true;
  LoadSavedGameMarcker:=1;
end;

procedure TForm3.MenuItem3Click(Sender: TObject);
begin
  Form4.Show;
  Form3.Hide;
end;

procedure TForm3.MenuItem4Click(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.MenuItem5Click(Sender: TObject);
begin
  Form7.Show;
  Form3.Hide;
end;

procedure TForm3.MenuItem6Click(Sender: TObject);
begin
  Form6.Show;
  Form3.Hide;
end;

procedure TForm3.MenuItem7Click(Sender: TObject);
begin
  Form5.Show;
  Form3.Hide;
end;

procedure TForm3.FormShow(Sender: TObject);
var str:string;
  f:textfile;
begin
  Form1.Timer1.Enabled:=false;
  AssignFile(f,'settings_color.txt');
  ReSet(f);
  Readln(f,str);
  CloseFile(f);
  LoadSavedGameMarcker:=1;
  Form3.Color:=StrToInt(str);

end;


end.

