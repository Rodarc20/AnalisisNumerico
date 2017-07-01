unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Grids, SpkToolbar, spkt_Tab, spkt_Pane,
  spkt_Buttons, uCmdBox, GridHandler,ChartHandler,
  Functions, Matrix, Bisection, FalsePosition, Secant,
  FixedPoint, Newton, Lagrange, RiemannSum, Simpson, Euler, Heun, RungeKutta,
  DormandPrince, GeneralizedNewton;

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
    Plotear2: TLineSeries;
    HistoryList: TListBox;
    Label1: TLabel;
    LineaComando: TCmdBox;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    Funcion: TFuncSeries;
    FuncionIntegrar: TFuncSeries;
    Plotear: TLineSeries;
    RightPanel: TPanel;
    chartButton: TSpkLargeButton;
    resultTable: TStringGrid;
    tableButton: TSpkLargeButton;
    SpkPane1: TSpkPane;
    SpkTab1: TSpkTab;
    SpkToolbar1: TSpkToolbar;
    procedure Button4Click(Sender: TObject);
    procedure chartButtonClick(Sender: TObject);
    procedure FuncionCalculate(const AX: Double; out AY: Double);
    procedure FuncionIntegrarCalculate(const AX: Double; out AY: Double);
    procedure LineaComandoClick(Sender: TObject);
    procedure LineaComandoInput(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MostrarAyuda(comando: string);
    procedure tableButtonClick(Sender: TObject);
    function CrearPuntosParaGraficar(func: string; a: double; b: double; n: double): TNumericMatrix;

  private
      funcionString: string;
      funcionintegrarString: string;
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
      dormandprince: TDormandPrince;
      generalizednewton: TGeneralizedNewton;
      gridhandler: TGridHandler;
      charthandler: TChartHandler;
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
    gridhandler:= TGridHandler.Create(resultTable);
    charthandler:= TChartHandler.Create(chrGrafica, Area, Plotear, Plotear2);
    LineaComando.Writeln('Hola');
    LineaComando.StartRead(clSilver,clBlack,'MiniLab/>',clYellow,clBlack);
end;

procedure TForm1.chartButtonClick(Sender: TObject);
begin
    resultTable.visible := false ;
    chrGrafica.visible := true;
end;

procedure TForm1.FuncionCalculate(const AX: Double; out AY: Double);
begin
    AY:= f.evaluate(funcionString, AX);

end;

procedure TForm1.FuncionIntegrarCalculate(const AX: Double; out AY: Double);
begin
    AY:= f.evaluate(funcionintegrarString, AX);

end;

function TForm1.CrearPuntosParaGraficar(func: string; a: double; b: double; n: double): TNumericMatrix;
var resul: TNumericMatrix;
var h: double;
var x: double;
var i: integer;
var intervalos: double;
var nintervalos: integer;
begin
    {h:= abs( ( Max - Min )/( 100 * Max ) );}
    intervalos:= abs(b-a)/n;
    nintervalos:= trunc(intervalos)+1;
    resul:= TNumericMatrix.Create;
    SetLength(resul, nintervalos, 3);
    {resul[0][0]:=res;}
    i:= 0;
    x:= a;
    while (x <= b) do
    begin
        resul[i][0]:=i;
        resul[i][1]:=x;
        resul[i][2]:=f.evaluate(func, x);
        {ShowMessage(FloatToStr(resul[i][1])+','+FloatToStr(resul[i][2]));}
        x:= x + n;
        i:=i+1;
    end;
    {al finalizar i deberia tener el tamaño de niintervalos}
    Result:= resul;
end;

procedure TForm1.LineaComandoInput(ACmdBox: TCmdBox; Input: string);
var entrada: TStringList;
var equations: TEquationsList;
var puntos: TMatriz;
var values: TNumericMatrix;
var resul: TNumericMatrix;
var resultado: TArray;
var i: integer;
var j: integer;
var id: double;
var jd: double;
var res: real;
var polinomio: string;
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
    Funcion.Active:=false;
    FuncionIntegrar.Active:=false;
    Plotear.Active:=false;
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
        LineaComando.Writeln(FloatToStr(resul[Length(resul)-1][3]));
        biseccion.Destroy;

        funcionString := entrada[1];
        with Funcion do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          Funcion.Pen.Color:=  clBlue;

          Active:= True;
        end;
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'bisection');
        gridhandler.destroy();
        {charthandler.fillchart(resul);}
    end
    else if entrada[0]='falsaposicion' then
    begin
        {ecuacion, a, b, error}
        falsaposicion:= TFalsePosition.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]));
        resul:= falsaposicion.execute;
        LineaComando.Writeln('falsaposicion');
        falsaposicion.Destroy;

        funcionString := entrada[1];
        with Funcion do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          Funcion.Pen.Color:=  clBlue;
          Active:= True;
        end;
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'false-position');
    end
    else if entrada[0]='secante' then
    begin
        {ecuacion, x, error}
        secante:= TSecant.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]));
        resul:= secante.execute;
        LineaComando.Writeln('secante');
        secante.Destroy;
        funcionString := entrada[1];
        with Funcion do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          Funcion.Pen.Color:=  clBlue;

          Active:= True;
        end;
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'secant');
    end
    else if entrada[0]='puntofijo' then
    begin
        {ecuacion, ecuacionderivada, x, error}
        puntofijo := TFixedPoint.Create(entrada[1], entrada[2], StrToFloat(entrada[3]), StrToFloat(entrada[4]));
        resul:= puntofijo.execute;
        LineaComando.Writeln('puntofijo');
        puntofijo.Destroy;
        funcionString := entrada[1];

    end
    else if entrada[0]='newton' then
    begin
        {ecuacion, ecuacionderivada, x, error}
        newton := TNewton.Create(entrada[1], entrada[2], StrToFloat(entrada[3]), StrToFloat(entrada[4]));
        resul:= newton.execute;
        LineaComando.Writeln('newton');
        newton.Destroy;
        funcionString := entrada[1];
        with Funcion do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          Funcion.Pen.Color:=  clBlue;

          Active:= True;
        end;
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'newton');
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
        polinomio:=lagrange.Ejecutar;
        LineaComando.Writeln(FloatToStr(f.evaluate(polinomio, StrToFloat(entrada[entrada.Count-1]))));
        {evaluar la ultima entrada en el polinomio que devuelve execute}
        lagrange.Destroy;
        funcionString := polinomio;
        with Funcion do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          Funcion.Pen.Color:=  clBlue;

          Active:= True;
        end;
    end
    else if entrada[0]='newtongeneralizado' then
    begin
        LineaComando.Writeln('newtongeneralizado');
        SetLength(equations, 2);
        SetLength(values, 2, 1);
        equations[0] := entrada[1];
        equations[1] := entrada[2];
        values[0][0] := StrToFloat(entrada[3]);
        values[1][0] := StrToFloat(entrada[4]);
        generalizednewton := TGeneralizedNewton.Create(equations, values, StrToFloat(entrada[5]));
        resul := generalizednewton.execute();
        generalizednewton.destroy;
        {gridhandler:= TGridHandler.Create(resultTable);}
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'gen-newton');
        {gridhandler.destroy();}
    end
    else if entrada[0]='trapecio' then
    begin
        {ecuacion, a, b, n}
        funcionintegrarString:=entrada[1];
        trapecio := TRiemannSum.Create();
        res:= trapecio.execute(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));
        LineaComando.Writeln(FloatToStr(res));
        {with FuncionIntegrar do begin
          Active:= False;

          Extent.XMax:= StrToFloat(entrada[3]);
          Extent.XMin:= StrToFloat(entrada[2]);

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          FuncionIntegrar.Pen.Color:=  clBlue;

          Active:= True;
        end;}

        charthandler.fillChart(CrearPuntosParaGraficar(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), 0.1));

        resul:= TNumericMatrix.Create;
        SetLength(resul, 1, 1);
        resul[0][0]:=res;
        trapecio.Destroy;
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'riemann');
    end
    else if entrada[0]='simpson1/3' then
    begin
        {ecuacion, a, b, n}
        LineaComando.Writeln('simpson1/3');
        simpson := TSimpson.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));
        res:= simpson.simpson13();
        LineaComando.Writeln(FloatToStr(res));
        simpson.Destroy;
        funcionintegrarString:=entrada[1];
        charthandler.fillChart(CrearPuntosParaGraficar(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), 0.01));
        resul:= TNumericMatrix.Create;
        SetLength(resul, 1, 1);
        resul[0][0]:=res;
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'simpson13');
    end
    else if entrada[0]='simpson3/8' then
    begin
        {ecuacion, a, b, n}
        simpson := TSimpson.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));
        resultado:= simpson.simpson38();
        LineaComando.Writeln('simpson3/8');
        LineaComando.Writeln(FloatToStr(resultado[0]));
        simpson.Destroy;
        funcionintegrarString:=entrada[1];
        with FuncionIntegrar do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          FuncionIntegrar.Pen.Color:=  clBlue;

          Active:= True;
        end;
        SetLength(resul, 1, 2);
        resul[0][0]:=resultado[0];
        resul[0][1]:=resultado[1];
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'simpson38');
        charthandler.fillChart(resul, true);
    end
    else if entrada[0]='euler' then
    begin
        {ecuacion, objetivo, x, y, il}
        euler := TEuler.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]), StrToFloat(entrada[5]));
        resul:= euler.execute();
        {LineaComando.Writeln(FloatToStr(res));}
        euler.Destroy;
        LineaComando.Writeln('euler');
        LineaComando.Writeln(FloatToStr(resul[Length(resul)-1][2]));
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'euler');
    end
    else if entrada[0]='heun' then
    begin
        {ecuacion, objetivo, x, y, il}
        heun := THeun.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]), StrToFloat(entrada[5]));
        resul:= heun.execute();
        {LineaComando.Writeln(FloatToStr(res));}
        heun.Destroy;
        LineaComando.Writeln('heun');
        LineaComando.Writeln(FloatToStr(resul[Length(resul)-1][2]));
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'heun');
    end
    else if entrada[0]='rungekutta' then
    begin
        {ecuacion, objetivo, x, y, il}
        rungekutta := TRungeKutta.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]), StrToFloat(entrada[5]));
        resul:= rungekutta.execute4();
        {LineaComando.Writeln(FloatToStr(res));}
        rungekutta.Destroy;
        LineaComando.Writeln('rungekutta');
        LineaComando.Writeln(FloatToStr(resul[Length(resul)-1][2]));
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'runge-kutta');
    end
    else if entrada[0]='dormandprince' then
    begin
        {ecuacion, objetivo, x, y, il}
        dormandprince := TDormandPrince.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToFloat(entrada[4]), StrToFloat(entrada[5]));
        resul:= dormandprince.execute();
        {LineaComando.Writeln(FloatToStr(res));}
        dormandprince.Destroy;
        LineaComando.Writeln('dormandprince');
        LineaComando.Writeln(FloatToStr(resul[Length(resul)-1][2]));
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'dormand-prince');
    end
    else if entrada[0]='clear' then
    begin
        LineaComando.Clear;
    end
    else if entrada[0]='ejercicio1' then
    begin
        LineaComando.Writeln('tabla z');
        resul:= TNumericMatrix.Create;
        SetLength(resul, 40, 11);
        i:=0;
        id := 0;{avanza en 0.1}
        while(id <= 4) do
        begin
            resul[i][0]:=id;
            j:=1;
            jd := 0;{avanza como 0.01}
            while(jd < 0.1) do 
            begin
                simpson := TSimpson.Create('1/power(2*pi,0.5)*power(exp(1),-1/2*power(x,2))', -10, id+jd, 1000);
                resul[i][j] := simpson.simpson13();
                simpson.Destroy;
                j:= j+ 1;
                jd:= jd+0.01;
            end;
            i:= i + 1;
            id:= id+0.1;
        end;
        {simpson := TSimpson.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));}
        charthandler.fillChart(CrearPuntosParaGraficar('1/power(2*pi,0.5)*power(exp(1),-1/2*power(x,2))', -10, 10, 0.01));
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'ejercicio1');
    end
    else if entrada[0]='ejercicio2a' then
    begin
        LineaComando.Writeln('comportamiento de 1/power(2*pi,0.5)*power(exp(1),-power(x,2)/2)');
        funcionintegrarString:='1/power(2*pi,0.5)*power(exp(1),-power(x,2)/2)';
        with FuncionIntegrar do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          FuncionIntegrar.Pen.Color:=  clBlue;

          Active:= True;
        end;
        {charthandler.fillChart(CrearPuntosParaGraficar('1/power(2*pi,0.5)*power(exp(1),-1/2*power(x,2))', -10, 10, 0.01));}
    end
    else if entrada[0]='ejercicio2b' then
    begin
        LineaComando.Writeln('comportamiento de -x/power(2*pi,0.5)*power(exp(1),-power(x,2)/2)');
        funcionintegrarString:='-x/power(2*pi,0.5)*power(exp(1),-power(x,2)/2)';
        with FuncionIntegrar do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          FuncionIntegrar.Pen.Color:=  clBlue;

          Active:= True;
        end;
        {charthandler.fillChart(CrearPuntosParaGraficar('1/power(2*pi,0.5)*power(exp(1),-1/2*power(x,2))', -10, 10, 0.01));}
    end
    else if entrada[0]='ejercicio3' then
    begin
        LineaComando.Writeln('ln(ln(x)) no existe en x = 1 por lo tanto se esta tomando <1;2]');
        simpson := TSimpson.Create('power(exp(1),x)*ln(x)-ln(ln(x))', 1.0001, 2, 1800);
        res:= simpson.simpson13();
        simpson.Destroy;
        LineaComando.Writeln(FloatToStr(res));
        gridhandler.cleanGrid();
        charthandler.fillChart2(CrearPuntosParaGraficar('power(exp(1),x)*ln(x)', 1.0001, 2, 0.01), CrearPuntosParaGraficar('ln(ln(x))', 1.0001, 2, 0.01), true);
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

procedure TForm1.tableButtonClick(Sender: TObject);
begin
    resultTable.visible:= true;
    chrGrafica.visible:= false;

end;

end.

