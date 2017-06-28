unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, SpkToolbar, uCmdBox;

type

  { TForm1 }

  TForm1 = class(TForm)
    Area: TAreaSeries;
    AreaColorA: TAreaSeries;
    AreaColorB: TAreaSeries;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CbSetCaret: TComboBox;
    cbWordWrap: TCheckBox;
    chrGrafica: TChart;
    HistoryList: TListBox;
    Label1: TLabel;
    LineaComando: TCmdBox;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    Funcion: TFuncSeries;
    FuncionIntegrar: TFuncSeries;
    Plotear: TLineSeries;
    RightPanel: TPanel;
    SpkToolbar1: TSpkToolbar;
    procedure Button4Click(Sender: TObject);
    procedure LineaComandoClick(Sender: TObject);
    procedure LineaComandoInput(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { private declarations }
      {public}
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
DoubleBuffered := True;
    LineaComando.Writeln('Hola ');
    LineaComando.TextColors(clWhite,clBlue); 
    LineaComando.Writeln('Hola');
    ShowMessage('Construido');
    LineaComando.StartRead(clSilver,clBlack,'MiniLab/>',clWhite,clBlack);
    {LineaComando.StartRead(clSilver,clNavy,'/example/prompt/>',clYellow,clNavy);
 LineaComando.TextColors(clWhite,clNavy);
 LineaComando.Writeln(#27#218#27#10#191);
 LineaComando.Writeln(#27#179'Type "help" to see a short list of available commands.'#27#10#179);
 LineaComando.Writeln(#27#217#27#10#217);  }
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
end;

procedure TForm1.LineaComandoClick(Sender: TObject);
begin

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    LineaComando.Writeln('Hola');
    LineaComando.StartRead(clSilver,clBlack,'MiniLab/>',clYellow,clBlack);
end;

procedure TForm1.LineaComandoInput(ACmdBox: TCmdBox; Input: string);
begin
    if Input='hola' then
    begin
        LineaComando.Writeln('Hola');
    end
    else if Input='biseccion' then
    begin
        LineaComando.Writeln('biseccion');
    end
    else if Input='falsaposicion' then
    begin
        LineaComando.Writeln('falsaposicion');
    end
    else if Input='secante' then
    begin
        LineaComando.Writeln('secante');
    end
    else if Input='puntofijo' then
    begin
        LineaComando.Writeln('puntofijo');
    end
    else if Input='newton' then
    begin
        LineaComando.Writeln('newton');
    end
    else if Input='lagrange' then
    begin
        LineaComando.Writeln('lagrange');
    end
    else if Input='trapecio' then
    begin
        LineaComando.Writeln('trapecio');
    end
    else if Input='simpson1/3' then
    begin
        LineaComando.Writeln('simpson1/3');
    end
    else if Input='simpson3/8' then
    begin
        LineaComando.Writeln('simpson3/8');
    end
    else if Input='euler' then
    begin
        LineaComando.Writeln('euler');
    end
    else if Input='heun' then
    begin
        LineaComando.Writeln('heun');
    end
    else if Input='rungekutta' then
    begin
        LineaComando.Writeln('rungekutta');
    end
    else if Input='dormandprince' then
    begin
        LineaComando.Writeln('dormandprince');
    end
    else if Input='newtongeneralizado' then
    begin
        LineaComando.Writeln('newtongeneralizado');
    end
    else
    begin
        LineaComando.Writeln('Error');
    end;
    LineaComando.StartRead(clSilver,clBlack,'MiniLab/>',clYellow,clBlack);
end;

end.

