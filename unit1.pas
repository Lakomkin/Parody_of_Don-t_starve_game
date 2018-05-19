unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TreeInteraction(Sender: TObject);
    procedure LogTaking(Sender: TObject);
    procedure FlintTaking(Sender: TObject);
    procedure GrassTaking(Sender: TObject);
    procedure SaplingLooting(Sender: TObject);
    procedure BushLooting(Sender: TObject);
    procedure Craft_Details_Enter(Sender: TObject);
    procedure Craft_Details_Leave(Sender: TObject);
    procedure CraftAxe(Sender: TObject);
    procedure CraftPickaxe(Sender: TObject);
    procedure AttackTheSpider(Sender: TObject);
    procedure EatBerries(Sender: TObject);
    procedure Gold_vein_picking(Sender: TObject);
    procedure SaveTheGame(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Spider:array[1..100]of TImage;
  GroundBlock:array [1..10000,1..10000] of TImage;
  Tree:array[1..10000] of TImage;
  Gold_vein:array[1..10000] of TImage;
  Tools:array[1..100]of TImage;
  log:array[1..100]of TImage;
  Sapling:array[1..1000]of TImage;
  Grass_tuft:array[1..1000]of TImage;
  Bush:array[1..1000]of TImage;
  UI:array[1..100]of TImage;
  Items:array[1..100]of TImage;
  Items_label:array[1..100]of TLabel;
  Flint:array[1..10000] of TImage;
  vein_count,l,GroundIndex,total_fps,last_item_count,speed,spider_total_fps,spider_fps2,time,spider_spawn_marker,sapling_count,spider_count,grass_tuft_count,flint_count,tools_count,last_tools_count,Tree_index,TreeCount,frame,log_count,tree_fps,fall_fps,
  bush_count,chop_fps,spider_fps,item_count,tree_id,spider_speed,LastBtn:integer;
  moving,jumper,tree_state:string;

implementation
uses Unit2,Unit3;
{$R *.lfm}

{ TForm1 }
function distance (x:TImage):real;
var x1,y1,x2,y2:real;
begin
  x1:=x.Left+(x.Width div 2);
  y1:=x.Top+(x.Height div 2);

  x2:=Form1.Image1.Left+(Form1.Image1.Width div 2 );
  y2:=Form1.Image1.Top+(Form1.Image1.Height div 2);

  distance:=sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));

end;

procedure TForm1.SaveTheGame(Sender: TObject);
var i:integer;
  f:textfile;
begin
  {______Flints______}
  AssignFile(f,'saves\Flint.Left.txt');
  ReWrite(f);
  for i:=1 to flint_count do begin
    writeln(f,IntToStr(Flint[i].Left));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Flint.Top.txt');
  ReWrite(f);
  for i:=1 to flint_count do begin
    writeln(f,IntToStr(Flint[i].Top));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Flint.Visible.txt');
  ReWrite(f);
  for i:=1 to flint_count do begin
    writeln(f,BoolToStr(Flint[i].Visible));
  end;
  CloseFile(f);

  {______Trees______}
  AssignFile(f,'saves\Tree.Left.txt');
  ReWrite(f);
  for i:=1 to TreeCount do begin
    writeln(f,IntToStr(Tree[i].Left));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tree.Top.txt');
  ReWrite(f);
  for i:=1 to TreeCount do begin
    writeln(f,IntToStr(Tree[i].Top));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tree.Visible.txt');
  ReWrite(f);
  for i:=1 to TreeCount do begin
    writeln(f,BoolToStr(Tree[i].Visible));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tree.Tag.txt');
  ReWrite(f);
  for i:=1 to TreeCount do begin
    writeln(f,IntToStr(Tree[i].Tag));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tree.HelpContext.txt');
  ReWrite(f);
  for i:=1 to TreeCount do begin
    writeln(f,IntToStr(Tree[i].HelpContext));
  end;
  CloseFile(f);
  {______Sapling______}

  AssignFile(f,'saves\Sapling.Left.txt');
  ReWrite(f);
  for i:=1 to sapling_count  do begin
    writeln(f,IntToStr(Sapling[i].Left));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Sapling.Top.txt');
  ReWrite(f);
  for i:=1 to sapling_count  do begin
    writeln(f,IntToStr(Sapling[i].Top));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Sapling.Visible.txt');
  ReWrite(f);
  for i:=1 to sapling_count  do begin
    writeln(f,BoolToStr(Sapling[i].Visible));
  end;
  CloseFile(f);
  {_______Tuft________}
  AssignFile(f,'saves\Tuft.Left.txt');
  ReWrite(f);
  for i:=1 to grass_tuft_count  do begin
    writeln(f,IntToStr(Grass_tuft[i].Left));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tuft.Top.txt');
  ReWrite(f);
  for i:=1 to grass_tuft_count  do begin
    writeln(f,IntToStr(Grass_tuft[i].Top));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tuft.Visible.txt');
  ReWrite(f);
  for i:=1 to grass_tuft_count  do begin
    writeln(f,BoolToStr(Grass_tuft[i].Visible));
  end;
  CloseFile(f);
  {_______Bush________}
  AssignFile(f,'saves\Bush.Left.txt');
  ReWrite(f);
  for i:=1 to bush_count  do begin
    writeln(f,IntToStr(Bush[i].Left));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Bush.Top.txt');
  ReWrite(f);
  for i:=1 to bush_count  do begin
    writeln(f,IntToStr(Bush[i].Top));
  end;
  CloseFile(f);

  AssignFile(f,'saves\Bush.Tag.txt');
  ReWrite(f);
  for i:=1 to bush_count  do begin
    writeln(f,IntToStr(Bush[i].Tag));
  end;
  CloseFile(f);
  {_______Vein________}

    AssignFile(f,'saves\Vein.Left.txt');
    ReWrite(f);
    for i:=1 to vein_count  do begin
      writeln(f,IntToStr(Gold_Vein[i].Left));
    end;
    CloseFile(f);

    AssignFile(f,'saves\Vein.Top.txt');
    ReWrite(f);
    for i:=1 to vein_count  do begin
      writeln(f,IntToStr(Gold_Vein[i].Top));
    end;
    CloseFile(f);

    AssignFile(f,'saves\Vein.Visible.txt');
    ReWrite(f);
    for i:=1 to vein_count  do begin
      writeln(f,BoolToStr(Gold_Vein[i].Visible));
    end;
    CloseFile(f);

    AssignFile(f,'saves\Vein.Tag.txt');
    ReWrite(f);
    for i:=1 to vein_count  do begin
      writeln(f,IntToStr(Gold_Vein[i].Tag));
    end;
    CloseFile(f);
    {_____INVENTORY_____}

    AssignFile(f,'saves\Items.Tag.txt');
    ReWrite(f);
    for i:=1 to item_count  do begin
      writeln(f,IntToStr(Items[i].Tag));
    end;
    CloseFile(f);

    AssignFile(f,'saves\Items.HelpContext.txt');
    ReWrite(f);
    for i:=1 to item_count  do begin
      writeln(f,IntToStr(Items[i].HelpContext));
    end;
    CloseFile(f);

    AssignFile(f,'saves\Items.Left.txt');
    ReWrite(f);
    for i:=1 to item_count  do begin
      writeln(f,IntToStr(Items[i].Left));
    end;
    CloseFile(f);

    AssignFile(f,'saves\Items.Top.txt');
    ReWrite(f);
    for i:=1 to item_count  do begin
      writeln(f,IntToStr(Items[i].Top));
    end;
    CloseFile(f);
    Form1.Close;
end;

procedure TForm1.AttackTheSpider(Sender: TObject);
var i:integer;
begin
  for i:=1 to spider_count do begin
    if (Sender = Spider[i])and(Spider[i].HelpContext<>6) then begin
      if (distance(Spider[i]) < 200) and (Spider[i].Tag > 0) then begin
        Spider[i].Tag:=Spider[i].Tag-1;
      end else if (Spider[i].Tag < 1) then begin
        Spider[i].HelpContext:=6;
        spider_fps:=1;
      end;
    end;
  end;
end;


procedure TForm1.TreeInteraction(Sender: TObject);
var axe_checker,i:integer;
begin
  axe_checker:=0;
  for i:=1 to tools_count do if Tools[i].Tag =  1 then axe_checker:=1;

  for i:=1 to TreeCount do begin
    if (Tree[i] = Sender) and (axe_checker = 1) then begin
        if (distance(Tree[i])<40)and(Form1.Image1.Left > (Tree[i].Left-40))and(tree_state<>'chopping')and(tree_state<>'falling') then begin
          moving:='left_chopping';
          tree_id:=i;
          chop_fps:=1;
          frame:=0;
          tree_state:='chopping';
          if(Tree[i].Tag > 0)then Tree[i].Tag:=Tree[i].Tag-1 else if(tree_state<>'falling')then begin
            fall_fps:=1;
            tree_state:='falling';
            tree_id:=i;
          end;
        end else
        if (distance(Tree[i])<140)and(Form1.Image1.Left < (Tree[i].Left-40))and(tree_state<>'chopping')and(tree_state<>'falling') then begin
          moving:='right_chopping';
          tree_id:=i;
          chop_fps:=1;
          frame:=0;
          tree_state:='chopping';

          if(Tree[i].Tag > 0)then Tree[i].Tag:=Tree[i].Tag-1 else if(tree_state<>'falling')then begin
            fall_fps:=1;
            tree_state:='falling';
            tree_id:=i;
          end;
        end else tree_state:='idle';

      end;
    end;
  end;
procedure TForm1.Gold_vein_picking(Sender: TObject);
var pickaxe_checker,i:integer;
begin
  pickaxe_checker:=0;
  for i:=1 to tools_count do if Tools[i].Tag =  2 then pickaxe_checker:=1;
  for i:=1 to vein_count do begin
    if (Sender = Gold_vein[i])and (Gold_vein[i].Tag > 0)and(moving<>'left_pick')and(moving<>'right_pick')and(pickaxe_checker = 1)and(distance(Gold_vein[i])<200)then begin
      Gold_vein[i].Tag:=Gold_vein[i].Tag-1;

      if (Image1.Left + (Image1.Width div 2) > Gold_vein[i].Left + (Gold_vein[i].Width div 2))then begin
        frame:=1;
        moving:='left_pick';
      end else begin
        frame:=1;
        moving:='right_pick';
      end;
    end;
  end;
end;
procedure TForm1.LogTaking(Sender: TObject);
var i,j,found:integer;
begin
  found:=0;
  for i:=1 to log_count do begin
    if (Sender = log[i])and(distance(log[i])<120)then begin
      if Image1.Left+(Image1.Width div 2) < log[i].Left + (log[i].Width div 2) then begin
        moving:='right_taking';
        frame:=1;
        log[i].Visible:=false;
        if item_count <> 0 then begin
          for j:=1 to item_count do begin
            if Items[j].Tag = 1 then begin
              Items[j].HelpContext:=Items[j].HelpContext+1;
              if Items[j].HelpContext = 10 then Items_label[j].Left:=Items_label[j].Left-10;
              Items_label[j].Caption:=IntToStr(Items[j].HelpContext);
              found:=1;
            end;
          end;
          if found <> 1 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=1;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
          end;
        end else if item_count = 0 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=1;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
        end;
      end else
      if Image1.Left+(Image1.Width div 2) >= log[i].Left + (log[i].Width div 2) then begin
        moving:='left_taking';
        frame:=1;
        log[i].Visible:=false;
        if item_count <> 0 then begin
          for j:=1 to item_count do begin
            if Items[j].Tag = 1 then begin
              Items[j].HelpContext:=Items[j].HelpContext+1;
              if Items[j].HelpContext = 10 then Items_label[j].Left:=Items_label[j].Left-10;
              Items_label[j].Caption:=IntToStr(Items[j].HelpContext);
              found:=1;
            end;
          end;
          if found <> 1 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=1;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
          end;
        end else if item_count = 0 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=1;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
        end;
      end;
    end;
  end;
end;
procedure TForm1.SaplingLooting(Sender: TObject);
var i,j,found:integer;
begin
  found:=0;
  for i:=1 to sapling_count do begin
    if (Sender = Sapling[i])and(distance(Sapling[i])<120)then begin

        moving:='looting';
        frame:=1;
        Sapling[i].Visible:=false;
        if item_count <> 0 then begin
          for j:=1 to item_count do begin
            if Items[j].Tag = 3 then begin
              Items[j].HelpContext:=Items[j].HelpContext+1;
              if Items[j].HelpContext = 10 then Items_label[j].Left:=Items_label[j].Left-10;
              Items_label[j].Caption:=IntToStr(Items[j].HelpContext);
              found:=1;
            end;
          end;
          if found <> 1 then begin
          item_count:=item_count+1;
          Items[item_count]:=TImage.Create(Form1);
          Items[item_count].Parent:=Form1;
          Items[item_count].Tag:=3;
          Items[item_count].HelpContext:=1;

          Items_label[item_count]:=TLabel.Create(Form1);
          Items_label[item_count].Parent:=Form1;
          Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
          Items_label[item_count].Top:=Form1.Height-60;
          Items_label[item_count].Font.Name:='Segoe Script';
          Items_label[item_count].Font.Color:=clWhite;
          Items_label[item_count].Font.Size:=20;
          Items_label[item_count].Caption:='';
          end;
        end else if item_count = 0 then begin
          item_count:=item_count+1;
          Items[item_count]:=TImage.Create(Form1);
          Items[item_count].Parent:=Form1;
          Items[item_count].Tag:=3;
          Items[item_count].HelpContext:=1;

          Items_label[item_count]:=TLabel.Create(Form1);
          Items_label[item_count].Parent:=Form1;
          Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
          Items_label[item_count].Top:=Form1.Height-60;
          Items_label[item_count].Font.Name:='Segoe Script';
          Items_label[item_count].Font.Color:=clWhite;
          Items_label[item_count].Font.Size:=20;
          Items_label[item_count].Caption:='';
      end;
    end;
  end;
end;
procedure TForm1.GrassTaking(Sender: TObject);
var i,j,found:integer;
begin
  found:=0;
  for i:=1 to grass_tuft_count do begin
    if (Sender = Grass_tuft[i])and(distance(Grass_tuft[i])<200)then begin
      if Image1.Left+(Image1.Width div 2) < Grass_tuft[i].Left + (Grass_tuft[i].Width div 2) then begin
        moving:='right_taking';
        frame:=1;
        Grass_tuft[i].Visible:=false;
        if item_count <> 0 then begin
          for j:=1 to item_count do begin
            if Items[j].Tag = 4 then begin
              Items[j].HelpContext:=Items[j].HelpContext+1;
              if Items[j].HelpContext = 10 then Items_label[j].Left:=Items_label[j].Left-10;
              Items_label[j].Caption:=IntToStr(Items[j].HelpContext);
              found:=1;
            end;
          end;
          if found <> 1 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=4;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
          end;
        end else if item_count = 0 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=4;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
        end;
      end else
      if Image1.Left+(Image1.Width div 2) >= Grass_tuft[i].Left + (Grass_tuft[i].Width div 2) then begin
        moving:='left_taking';
        frame:=1;
        Grass_tuft[i].Visible:=false;
        if item_count <> 0 then begin
          for j:=1 to item_count do begin
            if Items[j].Tag = 4 then begin
              Items[j].HelpContext:=Items[j].HelpContext+1;
              if Items[j].HelpContext = 10 then Items_label[j].Left:=Items_label[j].Left-10;
              Items_label[j].Caption:=IntToStr(Items[j].HelpContext);
              found:=1;
            end;
          end;
          if found <> 1 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=4;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
          end;
        end else if item_count = 0 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=4;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
        end;
      end;
    end;
  end;
end;
procedure TForm1.FlintTaking(Sender: TObject);
var i,j,found:integer;
begin
  found:=0;
  for i:=1 to flint_count do begin
    if (Sender = Flint[i])and(distance(Flint[i])<200)then begin
      if Image1.Left+(Image1.Width div 2) < Flint[i].Left + (Flint[i].Width div 2) then begin
        moving:='right_taking';
        frame:=1;
        Flint[i].Visible:=false;
        if item_count <> 0 then begin
          for j:=1 to item_count do begin
            if Items[j].Tag = 2 then begin
              Items[j].HelpContext:=Items[j].HelpContext+1;
              if Items[j].HelpContext = 10 then Items_label[j].Left:=Items_label[j].Left-10;
              Items_label[j].Caption:=IntToStr(Items[j].HelpContext);
              found:=1;
            end;
          end;
          if found <> 1 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=2;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
          end;
        end else if item_count = 0 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=2;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
        end;
      end else
      if Image1.Left+(Image1.Width div 2) >= Flint[i].Left + (Flint[i].Width div 2) then begin
        moving:='left_taking';
        frame:=1;
        Flint[i].Visible:=false;
        if item_count <> 0 then begin
          for j:=1 to item_count do begin
            if Items[j].Tag = 2 then begin
              Items[j].HelpContext:=Items[j].HelpContext+1;
              if Items[j].HelpContext = 10 then Items_label[j].Left:=Items_label[j].Left-10;
              Items_label[j].Caption:=IntToStr(Items[j].HelpContext);
              found:=1;
            end;
          end;
          if found <> 1 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=2;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
          end;
        end else if item_count = 0 then begin
            item_count:=item_count+1;
            Items[item_count]:=TImage.Create(Form1);
            Items[item_count].Parent:=Form1;
            Items[item_count].Tag:=2;
            Items[item_count].HelpContext:=1;

            Items_label[item_count]:=TLabel.Create(Form1);
            Items_label[item_count].Parent:=Form1;
            Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
            Items_label[item_count].Top:=Form1.Height-60;
            Items_label[item_count].Font.Name:='Segoe Script';
            Items_label[item_count].Font.Color:=clWhite;
            Items_label[item_count].Font.Size:=20;
            Items_label[item_count].Caption:='';
        end;
      end;
    end;
  end;
end;
procedure TForm1.BushLooting(Sender: TObject);
var i,j,found:integer;
begin
  found:=0;
  for i:=1 to bush_count do begin
    if (Sender = Bush[i])and(distance(Bush[i])<120)and(Bush[i].Tag<>1)then begin

        moving:='looting';
        frame:=1;
        Bush[i].Picture.LoadFromFile('nature\plants\empty_berry_bush.png');
        Bush[i].Tag:=1;
        if item_count <> 0 then begin
          for j:=1 to item_count do begin
            if Items[j].Tag = 5 then begin
              Items[j].HelpContext:=Items[j].HelpContext+1;
              if Items[j].HelpContext = 10 then Items_label[j].Left:=Items_label[j].Left-10;
              Items_label[j].Caption:=IntToStr(Items[j].HelpContext);
              found:=1;
            end;
          end;
          if found <> 1 then begin
          item_count:=item_count+1;
          Items[item_count]:=TImage.Create(Form1);
          Items[item_count].Parent:=Form1;
          Items[item_count].Tag:=5;
          Items[item_count].HelpContext:=1;
          Items[item_count].Onclick:=@EatBerries;

          Items_label[item_count]:=TLabel.Create(Form1);
          Items_label[item_count].Parent:=Form1;
          Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
          Items_label[item_count].Top:=Form1.Height-60;
          Items_label[item_count].Font.Name:='Segoe Script';
          Items_label[item_count].Font.Color:=clWhite;
          Items_label[item_count].Font.Size:=20;
          Items_label[item_count].Caption:='';
          end;
        end else if item_count = 0 then begin
          item_count:=item_count+1;
          Items[item_count]:=TImage.Create(Form1);
          Items[item_count].Parent:=Form1;
          Items[item_count].Tag:=5;
          Items[item_count].HelpContext:=1;
          Items[item_count].Onclick:=@EatBerries;

          Items_label[item_count]:=TLabel.Create(Form1);
          Items_label[item_count].Parent:=Form1;
          Items_label[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+44+(item_count-1)*56;
          Items_label[item_count].Top:=Form1.Height-60;
          Items_label[item_count].Font.Name:='Segoe Script';
          Items_label[item_count].Font.Color:=clWhite;
          Items_label[item_count].Font.Size:=20;
          Items_label[item_count].Caption:='';
      end;
    end;
  end;
end;

procedure TForm1.Craft_Details_Leave(Sender: TObject);
begin
  if UI[5] = Sender then UI[7].Visible:=false;
  if UI[4] = Sender then UI[6].Visible:=false;
end;
procedure TForm1.Craft_Details_Enter(Sender: TObject);
begin
  if UI[5] = Sender then UI[7].Visible:=true;
  if UI[4] = Sender then UI[6].Visible:=true;
end;

procedure TForm1.CraftAxe(Sender: TObject);
var i,j:integer;
begin
  for i:=1 to item_count do begin
    if (Items[i].Tag = 3) and (Items[i].HelpContext >= 1)then begin
      for j:=1 to item_count do begin
        if (Items[j].Tag = 2) and (Items[j].HelpContext >= 1)then begin

          tools_count:=tools_count+1;

          Tools[tools_count]:=TImage.Create(Form1);
          Tools[tools_count].Parent:=Form1;
          Tools[tools_count].Tag:=1;
          Tools[tools_count].HelpContext:=100;

          Items[i].HelpContext:=Items[i].HelpContext-1;
          Items[j].HelpContext:=Items[j].HelpContext-1;

          if Items_label[j].Caption = '' then Items_label[j].Caption:='1';
          if Items_label[i].Caption = '' then Items_label[i].Caption:='1';

          Items_label[j].Caption:=IntToStr(StrToInt(Items_label[j].Caption) - 1);
          Items_label[i].Caption:=IntToStr(StrToInt(Items_label[i].Caption) - 1);
        end;
      end;
    end;
  end;
end;
procedure TForm1.CraftPickaxe(Sender: TObject);
var i,j:integer;
begin
  for i:=1 to item_count do begin
    if (Items[i].Tag = 3) and (Items[i].HelpContext >= 2)then begin
      for j:=1 to item_count do begin
        if (Items[j].Tag = 2) and (Items[j].HelpContext >= 2)then begin

          tools_count:=tools_count+1;

          Tools[tools_count]:=TImage.Create(Form1);
          Tools[tools_count].Parent:=Form1;
          Tools[tools_count].Tag:=2;
          Tools[tools_count].HelpContext:=100;

          Items[i].HelpContext:=Items[i].HelpContext-2;
          Items[j].HelpContext:=Items[j].HelpContext-2;
          Items_label[j].Caption:=IntToStr(StrToInt(Items_label[j].Caption) - 2);
          Items_label[i].Caption:=IntToStr(StrToInt(Items_label[i].Caption) - 2);
        end;
      end;
    end;
  end;
end;

procedure TForm1.EatBerries(Sender: TObject);
var i:integer;
begin
  for i:=1 to item_count do begin
    if (Items[i] = Sender)and(Items[i].HelpContext > 0) then begin
      Items[i].HelpContext:=Items[i].HelpContext-1;
      Items_label[i].Caption:=IntToStr(Items[i].HelpContext);
      Image1.Tag:=Image1.Tag+10;
    end;
  end;
end;
procedure TForm1.FormCreate(Sender: TObject);
var x,y,j,i,tree_type:integer;
  f:textfile;
  info:string;
begin

  {__________level_rendering_________}
  TreeCount:=40;
  flint_count:=30;
  sapling_count:=30;
  grass_tuft_count:=15;
  bush_count:=15;
  vein_count:=10;
  //Ground
  j:=1;
  x:=4*-512;
  y:=4*-512;
  while j <=10 do begin
    GroundIndex:=1;
    i:=1;
    while GroundIndex <=10 do begin
      GroundBlock[j,GroundIndex]:=TImage.Create(Form1);
      GroundBlock[j,GroundIndex].Parent:=Form1;
      GroundBlock[j,GroundIndex].Width:=512;
      GroundBlock[j,GroundIndex].Height:=512;
      GroundBlock[j,GroundIndex].Left:=x;
      GroundBlock[j,GroundIndex].Top:=y;
      GroundBlock[j,GroundIndex].Picture.LoadFromFile('nature\turfs\1.png');
      GroundBlock[j,GroundIndex].SendToBack;
      GroundIndex:=GroundIndex+1;
      x:=x+512;
      i:=i+1;
    end;
    x:=4*-512;
    y:=y+512;
    j:=j+1;
  end;
  //Trees

  for i:=1 to TreeCount do begin
    x:=random(10*512)-4*512;
    y:=random(10*512)-4*512;
    tree_type:=random(3);
    Tree[i]:=TImage.Create(Form1);
    Tree[i].Parent:=Form1;
    Tree[i].OnClick:=@TreeInteraction;

    if tree_type = 0 then begin
      Tree[i].Width:=205;
      Tree[i].Height:=181;
      Tree[i].Left:=x;
      Tree[i].Top:=y;
      Tree[i].Tag:=random(2)+4;
      Tree[i].HelpContext:=1;
      Tree[i].Picture.LoadFromFile('animations\tree_1\1_001.png');
    end else
    if tree_type = 1 then begin
      Tree[i].Width:=205;
      Tree[i].Height:=160;
      Tree[i].Left:=x;
      Tree[i].Top:=y;
      Tree[i].Tag:=random(2)+4;
      Tree[i].HelpContext:=2;
      Tree[i].Picture.LoadFromFile('animations\tree_2\1_001.png');
    end else
    if tree_type = 2 then begin
      Tree[i].Width:=205;
      Tree[i].Height:=200;
      Tree[i].Left:=x;
      Tree[i].Top:=y;
      Tree[i].Tag:=random(2)+4;
      Tree[i].HelpContext:=3;
      Tree[i].Picture.LoadFromFile('animations\tree_3\1_001.png');
    end;
  end;
  //Flints
  for i:=1 to flint_count do begin
    x:=random(10*512)-4*512;
    y:=random(10*512)-4*512;
    Flint[i]:=TImage.Create(Form1);
    Flint[i].Parent:=Form1;
    Flint[i].OnClick:=@FlintTaking;
    Flint[i].Width:=41;
    Flint[i].Height:=41;
    Flint[i].Left:=x;
    Flint[i].Top:=y;
    Flint[i].Picture.LoadFromFile('nature\item_icons\flint.png');

  end;
  //Gold_Vein
  for i:=1 to vein_count do begin
    x:=random(10*512)-4*512;
    y:=random(10*512)-4*512;
    Gold_vein[i]:=TImage.Create(Form1);
    Gold_vein[i].Parent:=Form1;
    Gold_vein[i].OnClick:=@Gold_vein_picking;
    Gold_vein[i].Width:=90;
    Gold_vein[i].Height:=95;
    Gold_vein[i].Left:=x;
    Gold_vein[i].Top:=y;
    Gold_vein[i].Tag:=random(2)+2;
    Gold_vein[i].Picture.LoadFromFile('nature\vein\gold_vein.png');
  end;
  //Grass_tuft
  for i:=1 to grass_tuft_count do begin
    x:=random(10*512)-4*512;
    y:=random(10*512)-4*512;
    Grass_tuft[i]:=TImage.Create(Form1);
    Grass_tuft[i].Parent:=Form1;
    Grass_tuft[i].OnClick:=@GrassTaking;
    Grass_tuft[i].Width:=38;
    Grass_tuft[i].Height:=75;
    Grass_tuft[i].Left:=x;
    Grass_tuft[i].Top:=y;
    Grass_tuft[i].Picture.LoadFromFile('nature\plants\grass_tuft.png');

  end;
 //Saplings
  for i:=1 to sapling_count do begin
    x:=random(10*512)-4*512;
    y:=random(10*512)-4*512;
    Sapling[i]:=TImage.Create(Form1);
    Sapling[i].Parent:=Form1;
    Sapling[i].OnClick:=@SaplingLooting;
    Sapling[i].Width:=56;
    Sapling[i].Height:=77;
    Sapling[i].Left:=x;
    Sapling[i].Top:=y;
    Sapling[i].Picture.LoadFromFile('nature\plants\sapling.png');

  end;
  //Bushes
  for i:=1 to bush_count do begin
    x:=random(10*512)-4*512;
    y:=random(10*512)-4*512;
    Bush[i]:=TImage.Create(Form1);
    Bush[i].Parent:=Form1;
    Bush[i].OnClick:=@BushLooting;
    Bush[i].Width:=85;
    Bush[i].Height:=85;
    Bush[i].Left:=x;
    Bush[i].Top:=y;
    Bush[i].Tag:=0;
    Bush[i].Picture.LoadFromFile('nature\plants\berry_bush.png');

  end;

  for i:=1 to TreeCount do begin
    for  j:=1 to flint_count do begin
      if (Flint[j].Top+Flint[j].Height>Tree[i].Top+Tree[i].Height)and(Flint[j].Left>Tree[i].Left)and(Flint[j].Left<Tree[i].Left+Tree[i].Width)then begin
        Tree[i].BringToFront;
      end;
    end;
  end;

  for i:=1 to TreeCount do begin
    for  j:=1 to sapling_count do begin
      if (Sapling[j].Top+Sapling[j].Height>Tree[i].Top+Tree[i].Height)and(Sapling[j].Left>Tree[i].Left)and(Sapling[j].Left<Tree[i].Left+Tree[i].Width)then begin
        Tree[i].BringToFront;
      end;
    end;
  end;

  for i:=1 to bush_count do begin
    for  j:=1 to grass_tuft_count do begin
      if (Grass_tuft[j].Top+Grass_tuft[j].Height>Bush[i].Top+Bush[i].Height)and(Grass_tuft[j].Left>Tree[i].Left)and(Grass_tuft[j].Left<Bush[i].Left+Bush[i].Width)then begin
        Bush[i].BringToFront;
      end;
    end;
  end;

  for i:=1 to vein_count do begin
    for  j:=1 to bush_count do begin
      if Gold_vein[i].Top+Gold_vein[i].Top+Gold_vein[i].Height < Bush[j].Top then begin
        Bush[i].BringToFront;
      end;
    end;
  end;
  {__________preperations____________}
  Image1.Left:=(Form1.Width div 2 )-(Image1.Width div 2)-15;
  Image1.Top:=(Form1.Height div 2 )-(Image1.Height div 2);
  Image1.Tag:=100;
  moving:='idle';
  jumper:='idle';
  frame:=0;
  spider_fps2:=0;
  Tree_index:=1;
  tree_state:='idle';
  log_count:=0;
  l:=1;
  last_item_count:=0;
  item_count:=0;
  last_tools_count:=0;
  tools_count:=0;
  speed:=5;
  spider_total_fps:=0;
  spider_count:=0;
  total_fps:=0;
  spider_speed:=0;
  spider_fps:=0;
  spider_spawn_marker:=0;
  Image1.Picture.LoadFromFile('animations\idle\1_000.png');
  {__________UI____________}

  UI[1]:=TImage.Create(Form1);
  UI[1].Parent:=Form1;
  UI[1].Width:=725;
  UI[1].Height:=70;
  UI[1].Left:=(Form1.Width-UI[1].Width) div 2;
  UI[1].Top:=Form1.Height-UI[1].Height+23;
  UI[1].Picture.LoadFromFile('UI\inventory_bar.png');

  UI[2]:=TImage.Create(Form1);
  UI[2].Parent:=Form1;
  UI[2].Width:=190;
  UI[2].Height:=71;
  UI[2].Left:=((Form1.Width-UI[1].Width) div 2+UI[1].Width)+(Form1.Width-UI[1].Width-UI[1].Width)div 2;
  UI[2].Top:=Form1.Height-UI[2].Height+23;
  UI[2].Picture.LoadFromFile('UI\tools_bar.png');

  UI[3]:=TImage.Create(Form1);
  UI[3].Parent:=Form1;
  UI[3].Width:=70;
  UI[3].Height:=450;
  UI[3].Left:=0;
  UI[3].Top:=(Form1.Height-UI[3].Height)div 2 ;
  UI[3].Picture.LoadFromFile('UI\craft_book.png');

  UI[4]:=TImage.Create(Form1);
  UI[4].Parent:=Form1;
  UI[4].Width:=53;
  UI[4].Height:=74;
  UI[4].Left:=3;
  UI[4].OnMouseEnter:=@Craft_Details_Enter;
  UI[4].OnMouseLeave:=@Craft_Details_Leave;
  UI[4].OnClick:=@CraftAxe;
  UI[4].Top:=(Form1.Height-UI[3].Height)div 2 +20;
  UI[4].Picture.LoadFromFile('UI\filters\axe_craft.png');

  UI[5]:=TImage.Create(Form1);
  UI[5].Parent:=Form1;
  UI[5].Width:=53;
  UI[5].Height:=74;
  UI[5].Left:=3;
  UI[5].OnMouseEnter:=@Craft_Details_Enter;
  UI[5].OnMouseLeave:=@Craft_Details_Leave;
  UI[5].OnClick:=@CraftPickaxe;
  UI[5].Top:=(Form1.Height-UI[3].Height)div 2 + 60 ;
  UI[5].Picture.LoadFromFile('UI\filters\pickaxe_craft.png');

  UI[6]:=TImage.Create(Form1);
  UI[6].Parent:=Form1;
  UI[6].Width:=204;
  UI[6].Height:=240;
  UI[6].Left:=75;
  UI[6].Visible:=false;
  UI[6].Top:=UI[4].Top-UI[6].Height div 2+20;
  UI[6].Picture.LoadFromFile('UI\filters\axe_craft_card.png');

  UI[7]:=TImage.Create(Form1);
  UI[7].Parent:=Form1;
  UI[7].Width:=204;
  UI[7].Height:=240;
  UI[7].Left:=75;
  UI[7].Visible:=false;
  UI[7].Top:=UI[5].Top-UI[7].Height div 2+20;
  UI[7].Picture.LoadFromFile('UI\filters\pickaxe_craft_card.png');

  UI[8]:=TImage.Create(Form1);
  UI[8].Parent:=Form1;
  UI[8].Width:=77;
  UI[8].Height:=77;
  UI[8].Left:=Form1.Width-100;
  UI[8].Top:=30;
  UI[8].Picture.LoadFromFile('UI\health_bar.png');

  UI[9]:=TImage.Create(Form1);
  UI[9].Parent:=Form1;
  UI[9].Width:=77;
  UI[9].Height:=77;
  UI[9].Left:=Form1.Width-100;
  UI[9].Top:=30;
  UI[9].Picture.LoadFromFile('UI\health_mask.png');

  UI[10]:=TImage.Create(Form1);
  UI[10].Parent:=Form1;
  UI[10].Width:=80;
  UI[10].Height:=30;
  UI[10].Left:=Form1.Width-100;
  UI[10].Top:=120;
  UI[10].OnClick:=@SaveTheGame;
  UI[10].Picture.LoadFromFile('UI\save_and_quit_btn.png');




end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if key = 68 then begin moving:='right';end;
  if key = 65 then begin moving:='left';end;
  if key = 87 then begin moving:='forward';end;
  if key = 83 then begin moving:='back';end;
  jumper:=moving;
  LastBtn:=key;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if LastBtn <> key then begin moving:=jumper; end else moving:='idle';

  {if key = 68 then begin moving:='idle';end;
  if key = 65 then begin moving:='idle';end; }
end;

procedure TForm1.FormShow(Sender: TObject);
var i:integer;
  info,path:string;
  f:textfile;
begin
  {________________________SAVE_REALIZATION________________________}
  {_________Flint_________}

  AssignFile(f,'saves\Flint.Left.txt');
  ReSet(f);
  for i:=1 to flint_count do begin
    readln(f,info);
    Flint[i].Left:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Flint.Top.txt');
  ReSet(f);
  for i:=1 to flint_count do begin
    readln(f,info);
    Flint[i].Top:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Flint.Visible.txt');
  ReSet(f);
  for i:=1 to flint_count do begin
    readln(f,info);
    Flint[i].Visible:=StrToBool(info);
  end;
  CloseFile(f);
  {_________Trees_________}
  AssignFile(f,'saves\Tree.Left.txt');
  ReSet(f);
  for i:=1 to TreeCount do begin
    readln(f,info);
    Tree[i].Left:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tree.Top.txt');
  ReSet(f);
  for i:=1 to TreeCount do begin
    readln(f,info);
    Tree[i].Top:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tree.Visible.txt');
  ReSet(f);
  for i:=1 to TreeCount do begin
    readln(f,info);
    Tree[i].Visible:=StrToBool(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tree.Tag.txt');
  ReSet(f);
  for i:=1 to TreeCount do begin
    readln(f,info);
    Tree[i].Tag:=StrToInt(info);
  end;
  CloseFile(f);
  AssignFile(f,'saves\Tree.HelpContext.txt');
  ReSet(f);
  for i:=1 to TreeCount do begin
    readln(f,info);
    Tree[i].HelpContext:=StrToInt(info);
    if Tree[i].HelpContext = 1 then Tree[i].Picture.LoadFromFile('animations\tree_1\1_001.png');
    if Tree[i].HelpContext = 2 then Tree[i].Picture.LoadFromFile('animations\tree_2\1_001.png');
    if Tree[i].HelpContext = 3 then Tree[i].Picture.LoadFromFile('animations\tree_3\1_001.png');
  end;
  CloseFile(f);
  {_________Sapling_______}
  AssignFile(f,'saves\Sapling.Left.txt');
  ReSet(f);
  for i:=1 to sapling_count do begin
    readln(f,info);
    Sapling[i].Left:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Sapling.Top.txt');
  ReSet(f);
  for i:=1 to sapling_count do begin
    readln(f,info);
    Sapling[i].Top:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Sapling.Visible.txt');
  ReSet(f);
  for i:=1 to sapling_count do begin
    readln(f,info);
    Sapling[i].Visible:=StrToBool(info);
  end;
  CloseFile(f);
  {_________Tuft__________}
  AssignFile(f,'saves\Tuft.Left.txt');
  ReSet(f);
  for i:=1 to grass_tuft_count do begin
    readln(f,info);
    Grass_tuft[i].Left:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tuft.Top.txt');
  ReSet(f);
  for i:=1 to grass_tuft_count do begin
    readln(f,info);
    Grass_tuft[i].Top:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Tuft.Visible.txt');
  ReSet(f);
  for i:=1 to grass_tuft_count do begin
    readln(f,info);
    Grass_tuft[i].Visible:=StrToBool(info);
  end;
  CloseFile(f);
  {_________Bush__________}
  AssignFile(f,'saves\Bush.Left.txt');
  ReSet(f);
  for i:=1 to bush_count do begin
    readln(f,info);
    Bush[i].Left:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Bush.Top.txt');
  ReSet(f);
  for i:=1 to bush_count do begin
    readln(f,info);
    Bush[i].Top:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Bush.Tag.txt');
  ReSet(f);
  for i:=1 to bush_count do begin
    readln(f,info);
    Bush[i].Tag:=StrToInt(info);

    if Bush[i].Tag = 0 then Bush[i].Picture.LoadFromFile('nature\plants\berry_bush.png');
    if Bush[i].Tag = 1 then Bush[i].Picture.LoadFromFile('nature\plants\empty_berry_bush.png');
  end;
  CloseFile(f);
  {_________Vein__________}
  AssignFile(f,'saves\Vein.Left.txt');
  ReSet(f);
  for i:=1 to vein_count do begin
    readln(f,info);
    Gold_vein[i].Left:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Vein.Top.txt');
  ReSet(f);
  for i:=1 to vein_count do begin
    readln(f,info);
    Gold_vein[i].Top:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Vein.Visible.txt');
  ReSet(f);
  for i:=1 to vein_count do begin
    readln(f,info);
    Gold_vein[i].Visible:=StrToBool(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Vein.Tag.txt');
  ReSet(f);
  for i:=1 to vein_count do begin
    readln(f,info);
    Gold_vein[i].Tag:=StrToInt(info);
  end;
  CloseFile(f);

  {_____INVENTORY_____}
  item_count:=0;

  AssignFile(f,'saves\Items.Left.txt');
  ReSet(f);
  while not Eof(f) do begin
    readln(f, info);
    item_count:=item_count+1;
  end;
  CloseFile(f);

  AssignFile(f,'saves\Items.Left.txt');
  ReSet(f);
  for i:=1 to item_count do begin

    Items[i]:=TImage.Create(Form1);
    Items[i].Parent:=Form1;

    Items_label[i]:=TLabel.Create(Form1);
    Items_label[i].Parent:=Form1;
    Items_label[i].Font.Name:='Segoe Script';
    Items_label[i].Font.Color:=clWhite;
    Items_label[i].Font.Size:=20;
    Items_label[i].Top:=Form1.Height-30;


    readln(f,info);
    Items[i].Left:=StrToInt(info);
    Items_label[i].Left:=Items[i].Left+10;
  end;
  CloseFile(f);

  AssignFile(f,'saves\Items.Top.txt');
  ReSet(f);
  for i:=1 to item_count do begin
    readln(f,info);
    Items[i].Top:=StrToInt(info);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Items.Tag.txt');
  ReSet(f);
  for i:=1 to item_count do begin
    readln(f,info);
    Items[i].Tag:=StrToInt(info);
    if Items[i].Tag = 1 then path:= 'nature\item_icons\log.png';       {_______________log_____}
    if Items[i].Tag = 2 then path:= 'nature\item_icons\flint.png';     {_______________flint___}
    if Items[i].Tag = 3 then path:= 'nature\item_icons\twings.png';    {_______________sapling_}
    if Items[i].Tag = 4 then path:= 'nature\item_icons\cut_grass.png'; {_______________grass___}
    if Items[i].Tag = 5 then path:= 'nature\item_icons\berries.png';   {_______________berry___}
    Items[i].Picture.LoadFromFile(path);
  end;
  CloseFile(f);

  AssignFile(f,'saves\Items.HelpContext.txt');
  ReSet(f);
  for i:=1 to item_count do begin
    readln(f,info);
    Items[i].HelpContext:=StrToInt(info);
    Items_label[i].Caption:=IntToStr(Items[i].HelpContext);
    Items_label[i].BringToFront;
  end;
  CloseFile(f);

end;



procedure TForm1.Timer1Timer(Sender: TObject);
var path:string;
  j,i,layer:integer;
  dist:real;
begin
  {___________________________________________INVENTORY________________________________________}


  if last_item_count <> item_count then begin
      Items[item_count].Width:=41;
      Items[item_count].Height:=41;
      Items[item_count].Left:=((Form1.Width-UI[1].Width) div 2)+40+(item_count-1)*56;
      Items[item_count].Top:=Form1.Height-46;

      if Items[item_count].Tag = 1 then path:= 'nature\item_icons\log.png';       {_______________log_____}
      if Items[item_count].Tag = 2 then path:= 'nature\item_icons\flint.png';     {_______________flint___}
      if Items[item_count].Tag = 3 then path:= 'nature\item_icons\twings.png';    {_______________sapling_}
      if Items[item_count].Tag = 4 then path:= 'nature\item_icons\cut_grass.png'; {_______________grass___}
      if Items[item_count].Tag = 5 then path:= 'nature\item_icons\berries.png';   {_______________berry___}
      Items[item_count].Picture.LoadFromFile(path);
  end;


  if last_tools_count <> tools_count then begin
      Tools[tools_count].Width:=41;
      Tools[tools_count].Height:=41;
      Tools[tools_count].Left:=UI[2].Left+18+(tools_count-1)*56;
      Tools[tools_count].Top:=Form1.Height-46;

      if Tools[tools_count].Tag = 1 then path:= 'nature\item_icons\axe_icon.png';     {_______________axe_____}
      if Tools[tools_count].Tag = 2 then path:= 'nature\item_icons\pickaxe_icon.png'; {_______________pickaxe_}
      Tools[tools_count].Picture.LoadFromFile(path);
  end;
{________________________________________SPIDERS_____________________________________________}

  Label1.Caption:=IntToStr(total_fps)+' '+IntToStr(spider_spawn_marker);

  if spider_spawn_marker <= total_fps then begin

    spider_count:=spider_count+1;

    Spider[spider_count]:=TImage.Create(Form1);
    Spider[spider_count].Parent:=Form1;
    Spider[spider_count].Width:=133;
    Spider[spider_count].Height:=81;
    Spider[spider_count].Tag:=3;
    Spider[spider_count].OnClick:=@AttackTheSpider;
    Spider[spider_count].HelpContext:=1;//_______1-idle____2-walk____3-fury_____4-back_bite_____5-front_bite____6-death_____\\
    Spider[spider_count].Left:=Form1.Width-400+random(100);
    Spider[spider_count].Top:=Form1.Height-400+random(100);
    Spider[spider_count].Picture.LoadFromFile('animations\spider_idle\1_000.png');

    spider_spawn_marker:=total_fps+2000+random(700);
  end;

  for i:=1 to spider_count do begin

    {if (Spider[i].Tag < 1) and (Spider[i].Visible<>false) then begin
      Spider[i].Visible:=false;
    end;  }

    if (Spider[i].HelpContext = 1) and (Spider[i].Tag>0) then begin  {_______1-idle______}
      if spider_fps > 88 then spider_fps:=0;

      if (spider_fps<10) then path:='animations\spider_idle\1_00'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<100)and(spider_fps >9) then path:='animations\spider_idle\1_0'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<1000)and(spider_fps>99) then path:='animations\spider_idle\1_'+IntToStr(spider_fps)+'.png';

      Spider[i].Picture.LoadFromFile(path);
      Spider[i].BringToFront;
    end else
    if (Spider[i].HelpContext = 2) and (Spider[i].Tag>0) then begin  {_______2-walk______}
      spider_fps2:=spider_fps2+1;

      if spider_fps > 25 then spider_fps:=0;

      if spider_fps2 > 30+random(20) then spider_speed:=0;

      if (spider_fps<10) then path:='animations\spider_walk\1_00'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<100)and(spider_fps >9) then path:='animations\spider_walk\1_0'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<1000)and(spider_fps>99) then path:='animations\spider_walk\1_'+IntToStr(spider_fps)+'.png';

      Spider[i].Left:=Spider[i].Left+spider_speed;

      Spider[i].Picture.LoadFromFile(path);
      Spider[i].BringToFront;
    end else
    if (Spider[i].HelpContext = 3) and (Spider[i].Tag>0) then begin  {_______3-fury______}
      if spider_fps > 16 then begin Spider[i].HelpContext:=2;end;

      if (spider_fps<10) then path:='animations\spider_fury\1_00'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<100)and(spider_fps >9) then path:='animations\spider_fury\1_0'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<1000)and(spider_fps>99) then path:='animations\spider_fury\1_'+IntToStr(spider_fps)+'.png';

      Spider[i].Picture.LoadFromFile(path);
      Spider[i].BringToFront;
    end else
    if (Spider[i].HelpContext = 4) and (Spider[i].Tag>0) then begin  {_______4-back_bite______}

      if spider_fps > 23 then begin
        spider_fps:=0;
        Image1.Tag:=Image1.Tag-10;
        Spider[i].HelpContext:=2;
      end;

      if (spider_fps<10) then path:='animations\spider_back_bite\1_00'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<100)and(spider_fps >9) then path:='animations\spider_back_bite\1_0'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<1000)and(spider_fps>99) then path:='animations\spider_back_bite\1_'+IntToStr(spider_fps)+'.png';

      Spider[i].Picture.LoadFromFile(path);
      Spider[i].BringToFront;
    end else
    if (Spider[i].HelpContext = 5) and (Spider[i].Tag>0) then begin  {_______5-front_bite______}

      if spider_fps > 23 then begin
        Image1.Tag:=Image1.Tag-10;
        Spider[i].HelpContext:=2;
      end;

      if (spider_fps<10) then path:='animations\spider_front_bite\1_00'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<100)and(spider_fps >9) then path:='animations\spider_front_bite\1_0'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<1000)and(spider_fps>99) then path:='animations\spider_front_bite\1_'+IntToStr(spider_fps)+'.png';

      Spider[i].Picture.LoadFromFile(path);
      Spider[i].BringToFront;
    end else
    if (Spider[i].HelpContext = 6) and (Spider[i].Visible<>false) then begin  {_______6-death______}

      if spider_fps > 43 then begin
        Spider[i].Visible:=false;
        Spider[i].Width:=0;
        Spider[i].Height:=0;
      end;

      if (spider_fps<10) then path:='animations\spider_death\1_00'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<100)and(spider_fps >9) then path:='animations\spider_death\1_0'+IntToStr(spider_fps)+'.png' else
      if (spider_fps<1000)and(spider_fps>99) then path:='animations\spider_death\1_'+IntToStr(spider_fps)+'.png';

      Spider[i].Picture.LoadFromFile(path);
      Spider[i].BringToFront;
    end;



    if (distance(Spider[i]) < 300) and (distance(Spider[i]) > 50) and (Spider[i].Tag>0)and(Spider[i].HelpContext <> 6) then begin
      if Spider[i].HelpContext = 2 then begin


        if Spider[i].Left + Spider[i].Width div 2 >= Image1.Left + Image1.Width div 2  then Spider[i].Left:=Spider[i].Left-3;
        if Spider[i].Left + Spider[i].Width div 2 <  Image1.Left + Image1.Width div 2  then Spider[i].Left:=Spider[i].Left+3;

        if Spider[i].Top + Spider[i].Height div 2 >= Image1.Top + Image1.Height div 2 + 20 then Spider[i].Top:=Spider[i].Top-3;
        if Spider[i].Top + Spider[i].Height div 2 <  Image1.Top + Image1.Height div 2 + 20 then Spider[i].Top:=Spider[i].Top+3;

      end else if (Spider[i].HelpContext <> 3) and (Spider[i].HelpContext <> 4) then begin
        Spider[i].HelpContext:= 3;
        spider_fps:=0;
      end;
    end else
    if (distance(Spider[i]) <= 50)and (Image1.Tag <> 0) and (Spider[i].HelpContext <> 4)and (Spider[i].HelpContext <> 5)and (Spider[i].Tag>0)and(Spider[i].HelpContext <> 6)  then begin
      spider_fps:=0;
      Spider[i].HelpContext:= 4;
    end else
    if (Spider[i].HelpContext = 1)and(Spider[i].HelpContext<> 2)and (Spider[i].Tag>0)and(Spider[i].HelpContext <> 6) then begin
      if spider_total_fps mod 150 =  0 then begin
        Spider[i].HelpContext:= 2;
        spider_fps2:=0;
        if random(2) = 1 then spider_speed:=3 else spider_speed:=-3;

      end;
    end else if (Spider[i].HelpContext <> 4)and(spider_speed<>3)and(spider_speed<>-3)and (Spider[i].Tag>0) and(Spider[i].HelpContext <> 6) then Spider[i].HelpContext:=1;
  end;


      total_fps:=total_fps+1;
      spider_total_fps:=spider_total_fps+1;
      spider_fps:=spider_fps+1;
{___________________________________________CHARACTER________________________________________}
  if moving = 'left_pick' then begin

    if (frame<10) then path:='animations\left_pick\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\left_pick\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\left_pick\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;
    if frame > 25 then moving:='idle';
  end else
  if moving = 'right_pick' then begin

    if (frame<10) then path:='animations\right_pick\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\right_pick\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\right_pick\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;
    if frame > 25 then moving:='idle';
  end else
  if moving = 'death' then begin

    if (frame<10) then path:='animations\death\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\death\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\death\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;
    if frame > 43 then begin
      Form1.Hide;
      Timer1.Enabled:=false;
      Form2.Show;
    end;
  end else
  if moving = 'left_taking' then begin

    if (frame<10) then path:='animations\left_take\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\left_take\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\left_take\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;
    if frame = 29 then moving:='idle';
  end else
  if moving = 'right_taking' then begin

    if (frame<10) then path:='animations\right_take\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\right_take\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\right_take\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;
    if frame = 29 then moving:='idle';
  end else
  if moving = 'left_chopping' then begin

    if (frame<10) then path:='animations\left_chop\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\left_chop\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\left_chop\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;
    if frame = 27 then moving:='idle';
  end else
  if moving = 'right_chopping' then begin

    if (frame<10) then path:='animations\right_chop\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\right_chop\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\right_chop\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;
    if frame = 27 then moving:='idle';
  end else
  if moving = 'left_chopping' then begin

    if (frame<10) then path:='animations\left_chop\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\left_chop\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\left_chop\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;
    if frame = 27 then moving:='idle';
  end else
  if moving = 'idle' then begin
    if frame > 284 then frame:=0;

    if (frame<10) then path:='animations\idle\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\idle\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\idle\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;

  end else
  if moving = 'right' then begin
    if frame > 30 then frame:=0;

    if (frame<10) then path:='animations\right\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\right\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\right\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;

    for i:=1 to 10 do begin
      for j:=1 to 10 do begin
        GroundBlock[j,i].Left:=GroundBlock[j,i].Left-speed;
      end;
    end;
    for i:=1 to TreeCount do begin
      Tree[i].Left:=Tree[i].Left-speed;
    end;
    for i:=1 to log_count do begin
      log[i].Left:=log[i].Left-speed;
    end;
    for i:=1 to flint_count do begin
      Flint[i].Left:=Flint[i].Left-speed;
    end;
    for i:=1 to sapling_count do begin
      Sapling[i].Left:=Sapling[i].Left-speed;
    end;
    for i:=1 to grass_tuft_count do begin
      Grass_tuft[i].Left:=Grass_tuft[i].Left-speed;
    end;
    for i:=1 to bush_count do begin
      Bush[i].Left:=Bush[i].Left-speed;
    end;
    for i:=1 to spider_count do begin
      Spider[i].Left:=Spider[i].Left-speed;
    end;
    for i:=1 to vein_count do begin
      Gold_vein[i].Left:=Gold_vein[i].Left-speed;
    end;
  end else
  if moving = 'left' then begin
    if frame > 30 then frame:=0;

    if (frame<10) then path:='animations\left\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\left\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\left\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;

    for i:=1 to 10 do begin
      for j:=1 to 10 do begin
        GroundBlock[j,i].Left:=GroundBlock[j,i].Left+speed;
      end;
    end;
    for i:=1 to TreeCount do begin
      Tree[i].Left:=Tree[i].Left+speed;
    end;
    for i:=1 to log_count do begin
      log[i].Left:=log[i].Left+speed;
    end;
    for i:=1 to flint_count do begin
      Flint[i].Left:=Flint[i].Left+speed;
    end;
    for i:=1 to sapling_count do begin
      Sapling[i].Left:=Sapling[i].Left+speed;
    end;
    for i:=1 to grass_tuft_count do begin
      Grass_tuft[i].Left:=Grass_tuft[i].Left+speed;
    end;
    for i:=1 to bush_count do begin
      Bush[i].Left:=Bush[i].Left+speed;
    end;
    for i:=1 to spider_count do begin
      Spider[i].Left:=Spider[i].Left+speed;
    end;
    for i:=1 to vein_count do begin
      Gold_vein[i].Left:=Gold_vein[i].Left+speed;
    end;
  end else
  if moving = 'forward' then begin
    if frame > 32 then frame:=0;

    if (frame<10) then path:='animations\forward\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\forward\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\forward\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;

    for i:=1 to 10 do begin
      for j:=1 to 10 do begin
        GroundBlock[j,i].Top:=GroundBlock[j,i].Top+speed;
      end;
    end;
    for i:=1 to TreeCount do begin
      Tree[i].Top:=Tree[i].Top+speed;
    end;
    for i:=1 to log_count do begin
      log[i].Top:=log[i].Top+speed;
    end;
    for i:=1 to flint_count do begin
      Flint[i].Top:=Flint[i].Top+speed;
    end;
    for i:=1 to sapling_count do begin
      Sapling[i].Top:=Sapling[i].Top+speed;
    end;
    for i:=1 to grass_tuft_count do begin
      Grass_tuft[i].Top:=Grass_tuft[i].Top+speed;
    end;
    for i:=1 to bush_count do begin
      Bush[i].Top:=Bush[i].Top+speed;
    end;
    for i:=1 to spider_count do begin
      Spider[i].Top:=Spider[i].Top+speed;
    end;
    for i:=1 to vein_count do begin
      Gold_vein[i].Top:=Gold_vein[i].Top+speed;
    end;
  end else
  if moving = 'back' then begin
    if frame > 30 then frame:=0;

    if (frame<10) then path:='animations\back\1_00'+IntToStr(frame)+'.png' else
    if (frame<100)and(frame >9) then path:='animations\back\1_0'+IntToStr(frame)+'.png' else
    if (frame<1000)and(frame>99) then path:='animations\back\1_'+IntToStr(frame)+'.png';

    Image1.Picture.LoadFromFile(path);
    Image1.BringToFront ;
    frame:=frame+1;

    for i:=1 to 10 do begin
      for j:=1 to 10 do begin
        GroundBlock[j,i].Top:=GroundBlock[j,i].Top-speed;
      end;
    end;
    for i:=1 to TreeCount do begin
      Tree[i].Top:=Tree[i].Top-speed;
    end;
    for i:=1 to log_count do begin
      log[i].Top:=log[i].Top-speed;
    end;
    for i:=1 to flint_count do begin
      Flint[i].Top:=Flint[i].Top-speed;
    end;
    for i:=1 to sapling_count do begin
      Sapling[i].Top:=Sapling[i].Top-speed;
    end;
    for i:=1 to grass_tuft_count do begin
      Grass_tuft[i].Top:=Grass_tuft[i].Top-speed;
    end;
    for i:=1 to bush_count do begin
      Bush[i].Top:=Bush[i].Top-speed;
    end;
    for i:=1 to spider_count do begin
      Spider[i].Top:=Spider[i].Top-speed;
    end;
    for i:=1 to vein_count do begin
      Gold_vein[i].Top:=Gold_vein[i].Top-speed;
    end;
  end;

 // Label1.Caption:=IntToStr(Image1.Tag);
  UI[8].Height:=trunc(Image1.Tag*0.77);
  if (Image1.Tag = 0)and(moving<>'death') then begin
    frame:=1;
    moving:='death';
  end;
  {_______________________________________ORE_CONTROLLER_______________________________________}

  for i:=1 to vein_count do begin

    if Gold_vein[i].Tag < 1 then begin
      Gold_vein[i].Visible:=false;
    end;

  end;


  {_______________________________________TREE_CHOPPING________________________________________}
  if tree_state = 'chopping' then begin
    if Tree[tree_id].HelpContext = 1 then begin
      if (chop_fps<10) then path:='animations\tree_1_chopping\1_00'+IntToStr(chop_fps)+'.png' else
      if (chop_fps<100)and(chop_fps >9) then path:='animations\tree_1_chopping\1_0'+IntToStr(chop_fps)+'.png' else
      if (chop_fps<1000)and(chop_fps>99) then path:='animations\tree_1_chopping\1_'+IntToStr(chop_fps)+'.png';

      Tree[tree_id].Picture.LoadFromFile(path);
      if chop_fps > 25 then begin tree_id:=0;tree_state := 'idle';end;

    end else
    if Tree[tree_id].HelpContext = 2 then begin
      if (chop_fps<10) then path:='animations\tree_2_chopping\1_00'+IntToStr(chop_fps)+'.png' else
      if (chop_fps<100)and(chop_fps >9) then path:='animations\tree_2_chopping\1_0'+IntToStr(chop_fps)+'.png' else
      if (chop_fps<1000)and(chop_fps>99) then path:='animations\tree_2_chopping\1_'+IntToStr(chop_fps)+'.png';

      Tree[tree_id].Picture.LoadFromFile(path);
      if chop_fps > 25 then begin tree_id:=0;tree_state := 'idle';end;

    end else
    if Tree[tree_id].HelpContext = 3 then begin
      if (chop_fps<10) then path:='animations\tree_3_chopping\1_00'+IntToStr(chop_fps)+'.png' else
      if (chop_fps<100)and(chop_fps >9) then path:='animations\tree_3_chopping\1_0'+IntToStr(chop_fps)+'.png' else
      if (chop_fps<1000)and(chop_fps>99) then path:='animations\tree_3_chopping\1_'+IntToStr(chop_fps)+'.png';

      Tree[tree_id].Picture.LoadFromFile(path);
      if chop_fps > 25 then begin tree_id:=0;tree_state := 'idle';end;
    end;
  end;

  if tree_state = 'chopping' then chop_fps:=chop_fps+1;

  {_______________________________________TREE_FALLING_________________________________________}
  if tree_state = 'falling' then begin
    if Tree[tree_id].HelpContext = 1 then begin
      if (fall_fps<10) then path:='animations\tree_1_falling\1_00'+IntToStr(fall_fps)+'.png' else
      if (fall_fps<100)and(fall_fps >9) then path:='animations\tree_1_falling\1_0'+IntToStr(fall_fps)+'.png' else
      if (fall_fps<1000)and(fall_fps>99) then path:='animations\tree_1_falling\1_'+IntToStr(fall_fps)+'.png';

      Tree[tree_id].Picture.LoadFromFile(path);
      if fall_fps > 43 then begin
        log_count:=log_count+random(2)+3;
        while l<=log_count do begin
          log[l]:=TImage.Create(Form1);
          log[l].Parent:=Form1;
          log[l].Width:=60;
          log[l].Height:=24;
          log[l].Left:=Tree[tree_id].Left+20+random(50);
          log[l].Top:=Tree[tree_id].Top+120+random(50);
          log[l].OnClick:=@LogTaking;
          log[l].Picture.LoadFromFile('nature\sourses\log.png');
          l:=l+1;
        end;
        tree_state:='idle';
        Tree[tree_id].Visible:=false;
        tree_id:=0;
      end;

    end else
    if Tree[tree_id].HelpContext = 2 then begin
      if (fall_fps<10) then path:='animations\tree_2_falling\1_00'+IntToStr(fall_fps)+'.png' else
      if (fall_fps<100)and(fall_fps >9) then path:='animations\tree_2_falling\1_0'+IntToStr(fall_fps)+'.png' else
      if (fall_fps<1000)and(fall_fps>99) then path:='animations\tree_2_falling\1_'+IntToStr(fall_fps)+'.png';

      Tree[tree_id].Picture.LoadFromFile(path);
      if fall_fps > 43 then begin
        log_count:=log_count+random(1)+3;
        while l<=log_count do begin
          log[l]:=TImage.Create(Form1);
          log[l].Parent:=Form1;
          log[l].Width:=60;
          log[l].Height:=24;
          log[l].Left:=Tree[tree_id].Left+20+random(50);
          log[l].Top:=Tree[tree_id].Top+120+random(50);
          log[l].OnClick:=@LogTaking;
          log[l].Picture.LoadFromFile('nature\sourses\log.png');
          l:=l+1;
        end;
        tree_state:='idle';
        Tree[tree_id].Visible:=false;
        tree_id:=0;
      end;

    end else
    if Tree[tree_id].HelpContext = 3 then begin
      if (fall_fps<10) then path:='animations\tree_3_falling\1_00'+IntToStr(fall_fps)+'.png' else
      if (fall_fps<100)and(fall_fps >9) then path:='animations\tree_3_falling\1_0'+IntToStr(fall_fps)+'.png' else
      if (fall_fps<1000)and(fall_fps>99) then path:='animations\tree_3_falling\1_'+IntToStr(fall_fps)+'.png';

      Tree[tree_id].Picture.LoadFromFile(path);
      if fall_fps > 43 then begin
        log_count:=log_count+random(1)+3;
        while l<=log_count do begin
          log[l]:=TImage.Create(Form1);
          log[l].Parent:=Form1;
          log[l].Width:=60;
          log[l].Height:=24;
          log[l].Left:=Tree[tree_id].Left+20+random(50);
          log[l].Top:=Tree[tree_id].Top+120+random(50);
          log[l].OnClick:=@LogTaking;
          log[l].Picture.LoadFromFile('nature\sourses\log.png');
          l:=l+1;
        end;
        tree_state:='idle';
        Tree[tree_id].Visible:=false;
        tree_id:=0;
      end;

    end;
  end;

  if tree_state = 'falling' then fall_fps:=fall_fps+1;

  {________________________________________TREE_IDLING_________________________________________}
  for i:=1 to TreeCount do begin
    if (Tree[i].HelpContext = 1)and(distance(Tree[i])<1000)and(tree_id <> i)and(Tree[i].Visible<>false) then begin
      if tree_fps > 134 then tree_fps:=0;

      if (tree_fps<10) then path:='animations\tree_1\1_00'+IntToStr(tree_fps)+'.png' else
      if (tree_fps<100)and(tree_fps >9) then path:='animations\tree_1\1_0'+IntToStr(tree_fps)+'.png' else
      if (tree_fps<1000)and(tree_fps>99) then path:='animations\tree_1\1_'+IntToStr(tree_fps)+'.png';

      Tree[i].Picture.LoadFromFile(path);
    end else
    if (Tree[i].HelpContext = 2) and(distance(Tree[i])<1000)and(tree_id <> i)and(Tree[i].Visible<>false)then begin
      if tree_fps > 134 then tree_fps:=0;

      if (tree_fps<10) then path:='animations\tree_2\1_00'+IntToStr(tree_fps)+'.png' else
      if (tree_fps<100)and(tree_fps >9) then path:='animations\tree_2\1_0'+IntToStr(tree_fps)+'.png' else
      if (tree_fps<1000)and(tree_fps>99) then path:='animations\tree_2\1_'+IntToStr(tree_fps)+'.png';

      Tree[i].Picture.LoadFromFile(path);
    end else
    if (Tree[i].HelpContext = 3) and(distance(Tree[i])<1000)and(tree_id <> i)and(Tree[i].Visible<>false)then begin
      if tree_fps > 134 then tree_fps:=0;

      if (tree_fps<10) then path:='animations\tree_3\1_00'+IntToStr(tree_fps)+'.png' else
      if (tree_fps<100)and(tree_fps >9) then path:='animations\tree_3\1_0'+IntToStr(tree_fps)+'.png' else
      if (tree_fps<1000)and(tree_fps>99) then path:='animations\tree_3\1_'+IntToStr(tree_fps)+'.png';

      Tree[i].Picture.LoadFromFile(path);
    end;
  end;

  tree_fps:=tree_fps+1;


  {________________________________________LAYER_CONTROLLER_________________________________________}

   {______Trees______}
  dist:=3000;
  layer:=1;
  for i:=1 to TreeCount do begin
    if distance(Tree[i]) < dist then begin layer:=i;dist:=distance(Tree[i]);end;

  end;
    Tree_index:=layer;


  if distance(Tree[Tree_index])<500 then begin
    if (Image1.Top + Image1.Height < Tree[Tree_index].Top + Tree[Tree_index].Height - 5)and(Tree[Tree_index].HelpContext = 1) then
    begin
      Tree[Tree_index].BringToFront;
      UI[1].BringToFront;
      for i:=1 to item_count do Items[i].BringToFront;
      for i:=1 to item_count do Items_label[i].BringToFront;
      for i:=1 to tools_count do Tools[i].BringToFront;
    end else
    if (Image1.Top + Image1.Height < Tree[Tree_index].Top + Tree[Tree_index].Height + 5)and(Tree[Tree_index].HelpContext = 2) then begin
      Tree[Tree_index].BringToFront;
      UI[1].BringToFront;
      UI[2].BringToFront;
      for i:=1 to item_count do Items[i].BringToFront;
      for i:=1 to item_count do Items_label[i].BringToFront;
    end else
    if (Image1.Top + Image1.Height < Tree[Tree_index].Top + Tree[Tree_index].Height - 40)and(Tree[Tree_index].HelpContext = 3) then begin
      Tree[Tree_index].BringToFront;
      UI[1].BringToFront;
      UI[2].BringToFront;
      for i:=1 to item_count do Items[i].BringToFront;
      for i:=1 to item_count do Items_label[i].BringToFront;
      for i:=1 to tools_count do Tools[i].BringToFront;
    end;
  end;
  {______Saplings ______}
  dist:=3000;
  layer:=1;

  for i:=1 to flint_count do begin
    if distance(Sapling[i]) < dist then begin layer:=i;dist:=distance(Sapling[i]);end;
  end;
  Tree_index:=layer;


  if distance(Sapling[Tree_index])<500 then begin
    if (Image1.Top + Image1.Height < Sapling[Tree_index].Top + Sapling[Tree_index].Height+5) then
    begin
      Sapling[Tree_index].BringToFront;
      UI[1].BringToFront;
      UI[2].BringToFront;
      UI[3].BringToFront;
      UI[4].BringToFront;
      UI[5].BringToFront;
      UI[6].BringToFront;
      UI[7].BringToFront;
      for i:=1 to tools_count do Tools[i].BringToFront;
      for i:=1 to item_count do Items[i].BringToFront;
      for i:=1 to item_count do Items_label[i].BringToFront;
    end;
  end;
  {______Grass_tuft______}
  dist:=3000;
  layer:=1;

  for i:=1 to grass_tuft_count do begin
    if distance(Grass_tuft[i]) < dist then begin layer:=i;dist:=distance(Grass_tuft[i]);end;
  end;
  Tree_index:=layer;


  if distance(Grass_tuft[Tree_index])<500 then begin
    if (Image1.Top + Image1.Height < Grass_tuft[Tree_index].Top + Grass_tuft[Tree_index].Height+5) then
    begin
      Grass_tuft[Tree_index].BringToFront;
      UI[1].BringToFront;
      UI[2].BringToFront;
      UI[3].BringToFront;
      UI[4].BringToFront;
      UI[5].BringToFront;
      UI[6].BringToFront;
      UI[7].BringToFront;
      for i:=1 to tools_count do Tools[i].BringToFront;
      for i:=1 to item_count do Items[i].BringToFront;
      for i:=1 to item_count do Items_label[i].BringToFront;
    end;
  end;

   {______Bush_____}
 
  dist:=3000;
  layer:=1;

  for i:=1 to bush_count do begin
    if distance(Bush[i]) < dist then begin layer:=i;dist:=distance(Bush[i]);end;
  end;
  Tree_index:=layer;


  if distance(Bush[Tree_index])<500 then begin
    if (Image1.Top + Image1.Height < Bush[Tree_index].Top + Bush[Tree_index].Height+5) then
    begin
      Bush[Tree_index].BringToFront;
      UI[1].BringToFront;
      UI[2].BringToFront;
      UI[3].BringToFront;
      UI[4].BringToFront;
      UI[5].BringToFront;
      UI[6].BringToFront;
      UI[7].BringToFront;
      for i:=1 to item_count do Items[i].BringToFront;
      for i:=1 to item_count do Items_label[i].BringToFront;
      for i:=1 to tools_count do Tools[i].BringToFront;
    end;
  end;
  {______Spiders_____}
  dist:=3000;
  layer:=1;

  for i:=1 to spider_count do begin
    if distance(Spider[i]) < dist then begin layer:=i;dist:=distance(Spider[i]);end;
  end;
  Tree_index:=layer;


  if distance(Spider[Tree_index])<500 then begin
    if (Image1.Top + Image1.Height +25 < Spider[Tree_index].Top + Spider[Tree_index].Height+5) then
    begin
      Spider[Tree_index].BringToFront;
      UI[1].BringToFront;
      UI[2].BringToFront;
      UI[3].BringToFront;
      UI[4].BringToFront;
      UI[5].BringToFront;
      UI[6].BringToFront;
      UI[7].BringToFront;
      for i:=1 to tools_count do Tools[i].BringToFront;
      for i:=1 to item_count do Items[i].BringToFront;
      for i:=1 to item_count do Items_label[i].BringToFront;
    end;
  end;

  {____Gold_Vein______}
  dist:=3000;
  layer:=1;

  for i:=1 to vein_count do begin
    if distance(Gold_vein[i]) < dist then begin layer:=i;dist:=distance(Gold_vein[i]);end;
  end;
  Tree_index:=layer;


  if distance(Gold_vein[Tree_index])<500 then begin
    if (Image1.Top + Image1.Height < Gold_vein[Tree_index].Top + Gold_vein[Tree_index].Height+5) then
    begin
      Gold_vein[Tree_index].BringToFront;
      UI[1].BringToFront;
      UI[2].BringToFront;
      UI[3].BringToFront;
      UI[4].BringToFront;
      UI[5].BringToFront;
      UI[6].BringToFront;
      UI[7].BringToFront;
      for i:=1 to item_count do Items[i].BringToFront;
      for i:=1 to item_count do Items_label[i].BringToFront;
      for i:=1 to tools_count do Tools[i].BringToFront;
    end;
  end;
  {________________________________________OPTIMIZATION_________________________________________}

  for i:=1 to 10 do begin
    for j:=1 to 10 do begin
      if distance(GroundBlock[j,i])>Form1.Width then GroundBlock[j,i].Visible:=false
      else GroundBlock[j,i].Visible:=true;
    end;
  end;

  for i:=1 to TreeCount do begin
      if (distance(Tree[i])>Form1.Width div 2+500) and (Tree[i].Tag > 0) then Tree[i].Visible:=false
      else if Tree[i].Tag > 0 then Tree[i].Visible:=true;
  end;

  for i:=1 to spider_count do begin
    if distance(Spider[i]) > Form1.Width div 2 + 600 then begin
      Spider[i].Visible:=false;
      Spider[i].Width:=0;
      Spider[i].Height:=0;
      Spider[i].Tag:=0;
    end;
  end;
end;



end.

