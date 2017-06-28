unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, SpkToolbar, uCmdBox,
  Functions, Matrix, Bisection, FalsePosition, Secant, FixedPoint, Newton, Lagrange, RiemannSum, Simpson,
  Euler, Heun, RungeKutta, DormandPrince;

type

  { TForm1 }

  TMatriz = Array of Array of Real;
  TArray = Array of Real;
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
    procedure MostrarAyuda(comando: string);

  private
      f: TFunctions;
      biseccion: TBisection;
      falsaposicion: TFalsePosition;
      secante: TSecant;
      puntofijo: TFixedPoint;
      newton: TNewton;
      lagrange: TLagrange;
      trapecio: TRiemannSum;
      simpson: TSimpson;
      euler: TEuler;
      heun: THeun;
      rungekutta: TRungeKutta;
      dormandprince: TDormandPrince
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
    LineaComando.Writeln('Hola');
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
var entrada: TStringList;
var puntos: TMatriz;
var resul: TNumericMatrix;
var resultado: TArray;
var i: integer;
var res: real;
begin
    entrada:=TStringList.Create;
    entrada.Delimiter := ' ';
    entrada.DelimitedText:=Input;
    {i:=0; 
    while i < entrada.Count do
    begin
        LineaComando.Writeln(entrada[i]);
        i := i+1;
    end;}
    if entrada[0]='hola' then
    begin
        LineaComando.Writeln('Hola');
        i:=1; 
        while i < entrada.Count do
        begin
            LineaComando.Writeln(entrada[i]);
            i := i+1;
        end;
    end
    else if entrada[0]='biseccion' then
    begin
        {ecuacion, a, b, error}
        biseccion:= TBisection.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]));
        resul:= biseccion.execute;
        LineaComando.Writeln('biseccion');
        biseccion.Destroy;
    end
    else if entrada[0]='falsaposicion' then
    begin
        {ecuacion, a, b, error}
        falsaposicion:= TFalsePosition.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]));
        resul:= falsaposicion.execute;
        LineaComando.Writeln('falsaposicion');
        falsaposicion.Destroy;
    end
    else if entrada[0]='secante' then
    begin
        {ecuacion, x, error}
        secante:= TSecant.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]));
        resul:= secante.execute;
        LineaComando.Writeln('secante');
        secante.Destroy;
    end
    else if entrada[0]='puntofijo' then
    begin
        {ecuacion, ecuacionderivada, x, error}
        puntofijo := TFixedPoint.Create(entrada[1], entrada[2], StrToFloat(entrada[3]), StrToFloat(entrada[4]));
        resul:= puntofijo.execute;
        LineaComando.Writeln('puntofijo');
        puntofijo.Destroy;
    end
    else if entrada[0]='newton' then
    begin
        {ecuacion, ecuacionderivada, x, error}
        newton := TNewton.Create(entrada[1], entrada[2], StrToFloat(entrada[3]), StrToFloat(entrada[4]));
        resul:= newton.execute;
        LineaComando.Writeln('newton');
        newton.Destroy;
    end
    else if entrada[0]='lagrange' then
    begin
        {numeropuntos, x0, y0, x1, y1, ... ,xn, yn, xevaluar}
        SetLength(puntos, 2, StrToInt(entrada[1]));
        i:=0; 
        while i < StrToInt(entrada[1])*2 do
        begin
            puntos[i mod 2, i div 2] := StrToFloat(entrada[2+i]);
            i := i+1;
        end;
        lagrange := TLagrange.Create();
        lagrange.IngresarValores(puntos);
        LineaComando.Writeln(FloatToStr(f.evaluate(lagrange.Ejecutar, StrToFloat(entrada[entrada.Count-1]))));
        {evaluar la ultima entrada en el polinomio que devuelve execute}
        lagrange.Destroy;
    end
    else if entrada[0]='newtongeneralizado' then
    begin
        LineaComando.Writeln('newtongeneralizado');
    end
    else if entrada[0]='trapecio' then
    begin
        {ecuacion, a, b, n}
        trapecio := TRiemannSum.Create();
        res:= trapecio.execute(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));
        LineaComando.Writeln(FloatToStr(res));
        trapecio.Destroy;
    end
    else if entrada[0]='simpson1/3' then
    begin
        {ecuacion, a, b, n}
        LineaComando.Writeln('simpson3/8');
        simpson := TSimpson.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));
        res:= simpson.simpson13();
        LineaComando.Writeln(FloatToStr(res));
        simpson.Destroy;
    end
    else if entrada[0]='simpson3/8' then
    begin
        {ecuacion, a, b, n}
        simpson := TSimpson.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));
        resultado:= simpson.simpson38();
        {LineaComando.Writeln(FloatToStr(res));}
        simpson.Destroy;
        LineaComando.Writeln('simpson3/8');
    end
    else if entrada[0]='euler' then
    begin
        {ecuacion, objetivo, x, y, il}
        euler := TEuler.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]), StrToFloat(entrada[5]));
        resul:= euler.execute();
        {LineaComando.Writeln(FloatToStr(res));}
        euler.Destroy;
        LineaComando.Writeln('euler');
    end
    else if entrada[0]='heun' then
    begin
        {ecuacion, objetivo, x, y, il}
        heun := THeun.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]), StrToFloat(entrada[5]));
        resul:= heun.execute();
        {LineaComando.Writeln(FloatToStr(res));}
        heun.Destroy;
        LineaComando.Writeln('heun');
    end
    else if entrada[0]='rungekutta' then
    begin
        {ecuacion, objetivo, x, y, il}
        rungekutta := TRungeKutta.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]), StrToFloat(entrada[5]));
        resul:= rungekutta.execute4();
        {LineaComando.Writeln(FloatToStr(res));}
        rungekutta.Destroy;
        LineaComando.Writeln('rungekutta');
    end
    else if entrada[0]='dormandprince' then
    begin
        {ecuacion, objetivo, x, y, il}
        dormandprince := TDormandPrince.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]), StrToFloat(entrada[5]));
        resul:= dormandprince.execute();
        {LineaComando.Writeln(FloatToStr(res));}
        dormandprince.Destroy;
        LineaComando.Writeln('dormandprince');
    end
    else if entrada[0]='clear' then
    begin
        LineaComando.Clear;
    end
    else
    begin
        LineaComando.Writeln('Error');
    end;
    LineaComando.StartRead(clSilver,clBlack,'MiniLab/>',clYellow,clBlack);
end;

procedure TForm1.MostrarAyuda(comando: string);
begin
end;

end.

