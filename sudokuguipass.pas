unit sudokuguipass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, DBGrids;

type

  { TSudoku }
   board = array[1..10000,1..9,1..9] of integer;
   ArrFit2 = array[1..10000] of integer;
   ArrInd = array[1..9,1..9] of integer;
  TSudoku = class(TForm)
    Board: TLabel;
    Label2: TLabel;
    sudokuhasil: TMemo;
    runfitness: TButton;
    Clear: TButton;
    populasitext: TEdit;
    mutasitext: TEdit;
    Fitness: TLabel;
    Generate: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    boardmemo: TMemo;
    PageControl1: TPageControl;
    RUN: TButton;
    Board_sudoku: TLabel;
    SUDOKU: TLabel;
    F: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    procedure boardmemoChange(Sender: TObject);
    procedure sudokuhasilChange(Sender: TObject);
    procedure runfitnessClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure populasitextChange(Sender: TObject);
    procedure mutasi2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GenerateClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FitnessClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end;

var
  Sudoku: TSudoku;
  populasi1 : board;
  libFitness,libProb : ArrFit2;
  i1,i2,x1,x2,f : ArrInd;
  zs,VS:string;
  iterasi,rate_mutasi,a,b,i,j,k,l,m,r1,r2,n1,n2,x,y,z,max,vo: integer;
  selesai: boolean;
implementation

{$R *.lfm}

{ TSudoku }

procedure generateSudoku();
var
  p1,p2,c : integer;
begin
     Randomize;
     for i:=1 to max do
         begin
              for j:=1 to 9 do
                  begin
                       for k:=1 to 9 do
                           begin
                                populasi1[i,j,k]:=k;
                           end;
                  end;
         end;
     for i:=1 to max do
         begin
              for j:=1 to 9 do
                  begin
                       for k:=1 to 9 do
                           begin
                                p1:=random(9)+1;
                                p2:=random(9)+1;
                                c:=populasi1[i,j,p1];
                                populasi1[i,j,p1]:=populasi1[i,j,p2];
                                populasi1[i,j,p2]:=c;
                           end;
                  end;
         end;
end;

function fitnessSudoku(p:ArrInd):integer;
var

   tot:integer;
begin
     tot := 0;
     for j:=1 to 9 do
         begin
             for k:= 1 to 9 do
                 begin
                      f[j,k]:=0;
                 end;
         end;
     for j:=1 to 9 do
         begin
              for k:=1 to 9 do
                  begin
                       for l:=1 to 9 do
                           begin
                                //cek baris
                                //if((p[j,k]=p[j,l])and(k<>l)) then
                                //begin
                                //     f[j,k]:=1;
                                //end;
                                if((p[j,k]=p[l,k])and(j<>l)) then
                                begin
                                     f[j,k]:=1;
                                end;
                           end;
                       //cek region
                       //x:=trunc(j/3);
                       //y:=trunc(k/3);
                       //for l:=x-2 to x do
                       //    begin
                       //         for m:=y-2 to y do
                       //             begin
                       //                  if((p[j,k]=p[l,m])and(j<>l)and(k<>m)) then
                       //                  begin
                       //                       f[j,k]:=1;
                       //                  end;
                       //             end;
                       //    end;
                  end;
         end;
     for j:=1 to 9 do
         begin
              for k:=1 to 9 do
                  begin
                       tot:=tot+f[j,k];
                  end;
         end;
     fitnessSudoku:=tot;
end;

function probFitness(f:ArrFit2): ArrFit2 ;
var
   tot2 : integer;
   pb : ArrFit2;
begin
     tot2 :=0;
     for i:=1 to max do
         begin
              tot2:=tot2+f[i];
              pb[i]:=tot2;
         end;
     probFitness:=pb;
end;

function rouletewheel(n:integer; pb : ArrFit2): integer;
var
   rv : integer;
begin
     i:=1;
     while(i<=max)do
     begin
          if((n<=pb[i])) then
             begin
                  rv:=i;
                  break;
             end;
          i:=i+1;
     end;
     rouletewheel:=rv;
end;

function crossover(i1 : ArrInd; i2 : ArrInd):ArrInd;
var
   temp:ArrInd;
   go,go2: boolean;
   limit: integer;
begin
     for i:=1 to 9 do
         begin
         for j:=1 to 9 do
             begin
             if((j<4)or(j>6))then
                begin
                     temp[i,j]:=i1[i,j]
                end
             else
                 begin
                 temp[i,j]:=i2[i,j];
                 end;
             end;
         end;
     for i:=1 to 9 do
     begin
         for j:=1 to 9 do
         begin
             if((j<4)or(j>6))then
             begin
                  go2:=false; limit:=0;
                  while((limit<7)and(go2=false))do
                  begin
                       go:=true;
                       k:=1;
                       while((k<=9)and(go=true)) do
                       begin
                            if((temp[i,j]=temp[i,l])and(k<>j)) then
                            begin
                               go:= false;
                            end;
                            k:=k+1;
                       end;
                       if(go=false)then
                       begin
                            go2:=true
                       end
                       else
                           begin
                                limit:=limit+1;
                                temp[i,j]:=limit;
                          end;
                  end;
             end;
         end;
     end;
     crossover := temp;
end;

function mutasi(ind : ArrInd):ArrInd;
var
   temp,rand1 : integer;
   point,hasil : array[1..9] of integer;
   hasil2 : ArrInd;
   c: integer;
begin
     Randomize;
     n1:=random(9)+1;
     for j:=1 to 9 do
     begin
        c:=0;
        for i:=1 to 9 do
        begin
             hasil[i]:=ind[j,i];
        end;
        for i:=1 to 9 do
        begin
             point[i]:=0;
        end;

        for i:=1 to 9 do
        begin
          rand1:=random(100)+1;
          if(rand1<rate_mutasi)then
          begin
             c:=c+1;
             point[c]:=i;
          end;
        end;
        i:=1;
        while((point[i]<>0) and (i<=9)) do
        begin
             x:=hasil[point[i]];
             if((point[i+1]=0)or(i=9))then
             begin
                 hasil[point[i]]:=hasil[point[1]];
                 hasil[point[1]]:=x;
             end
             else
             begin
                  hasil[point[i]]:=hasil[point[i+1]];
                  hasil[point[i]]:=x;
             end;
             i:=i+1;
        end;
        for i:=1 to 9 do
        begin
             hasil2[j,i]:=hasil[i];
        end;
   end;
     mutasi:=hasil2;
end;

procedure showGenerateSudoku(s : board);
begin
     for i:=1 to 9 do
         begin
              for j:=1 to 9 do
                  begin
                       for k:=1 to 9 do
                           begin

                           end;
                  end;
         end;
end;

procedure TSudoku.Memo1Change(Sender: TObject);
begin

end;

procedure TSudoku.PageControl1Change(Sender: TObject);
begin

end;

procedure TSudoku.GenerateClick(Sender: TObject);
begin
     boardmemo.Clear;
     max:=StrToInt(populasitext.Text);
     rate_mutasi:=StrToInt(mutasitext.Text);
     generateSudoku();
     for i:=1 to max do
         begin
              for j:=1 to 9 do
                  begin
                       for k:=1 to 9 do
                           begin
                                i1[j,k]:=populasi1[i,j,k];
                           end;
                  end;
              libFitness[i]:= fitnessSudoku(i1);
         end;
     libProb:=probFitness(libFitness);

end;

procedure TSudoku.runfitnessClick(Sender: TObject);
begin
     Memo1.Clear;
     for i:=1 to max do
         begin
              for j:=1 to 9 do
                  begin
                       for k:=1 to 9 do
                           begin
                                i1[j,k]:=populasi1[i,j,k];
                           end;

                  end;
              libFitness[i]:= fitnessSudoku(i1);
         end;
     libProb:=probFitness(libFitness);
      x:=libProb[max];
      Memo1.Lines.Add('nilai x: '+IntToStr(x));
      r1:=0;
      r2:=0;
      selesai:=false;
      while(selesai=false)do
      begin
           n1:=random(libProb[max])+1;
           n2:=random(libProb[max])+1;
           r1:= rouletewheel(n1, libProb);
           r2:= rouletewheel(n2, libProb);
           for i:=1 to 9 do
               begin
                    for j:=1 to 9 do
                        begin
                             i1[i,j]:=populasi1[r1,i,j];
                        end;
               end;
           for i:=1 to 9 do
               begin
                    for j:=1 to 9 do
                        begin
                             i2[i,j]:=populasi1[r2,i,j];
                        end;
               end;
           x1:=crossover(i1,i2);
           x2:=crossover(i2,i1);
           x1:=mutasi(x1);
           x2:=mutasi(x2);
           a:=1;
           for i:=1 to max do
               begin
                    if(libFitness[a]<libFitness[i]) then
                    begin
                         a:=i;
                    end;
               end;
           b:=fitnessSudoku(x1);
           if(a>b)then
           begin
                for i:=1 to 9 do
                    begin
                         for j:=1 to 9 do
                             begin
                                  populasi1[a,i,j]:=x1[i,j];
                             end;
                    end;
           end;
           libFitness[a]:=b;
           a:=1;
           for i:=1 to max do
               begin
                    if(libFitness[a]<libFitness[i]) then
                    begin
                         a:=i;
                    end;
               end;
           b:=fitnessSudoku(x2);
           if(a>b)then
           begin
                for i:=1 to 9 do
                    begin
                         for j:=1 to 9 do
                             begin
                                  populasi1[a,i,j]:=x2[i,j];
                             end;
                    end;
           end;
           libFitness[a]:=b;
           libProb:=probFitness(libFitness);
           x:=libProb[max];
           for i:=1 to max do
               begin
                    if(libFitness[i]=0)then
                    begin
                         selesai:=true;
                    end;
               end;
           z:=1;
           for i:=1 to max do
               begin
                    if (libFitness[i]<libFitness[z]) then
                       begin
                            z:=i;
                       end;
               end;
            zs := FloatToStr(libFitness[z]/81);
            Memo1.Text := Memo1.Text+'Total Fitness : '+zs  ;
           iterasi:=iterasi+1;
         Memo1.Lines.Add('Iterasi ke-'+IntToStr(iterasi));
      end;
     sudokuhasil.Clear;
      a:=0;
      for i:=1 to max do
          begin
               if(libFitness[i]=0) then
               begin
                    a:=i;
               end;
          end;
      for i:=1 to 9 do
          begin
               for j:=1 to 9 do
                   begin
                        zs := IntToStr(populasi1[a,i,j]);
                        Memo1.Text := Memo1.Text+' '+zs  ;
                   end;
               Memo1.Lines.Add('');
          end;
     Memo1.Lines.Add('Text');
end;

procedure TSudoku.boardmemoChange(Sender: TObject);
begin

end;

procedure TSudoku.sudokuhasilChange(Sender: TObject);
begin

end;

procedure TSudoku.ClearClick(Sender: TObject);
begin
     Memo1.Clear;
end;

procedure TSudoku.populasitextChange(Sender: TObject);
begin

end;

procedure TSudoku.mutasi2Change(Sender: TObject);
begin

end;

procedure TSudoku.FormCreate(Sender: TObject);
begin

end;

procedure TSudoku.Image1Click(Sender: TObject);
begin

end;

procedure TSudoku.FitnessClick(Sender: TObject);
begin

end;

procedure TSudoku.Label1Click(Sender: TObject);
begin

end;

end.

