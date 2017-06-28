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
    LineaComando.Writeln('Hola');
    LineaComando.TextColors(clWhite,clBlue); 
    LineaComando.Writeln('Hola');
    ShowMessage('Construido');
    LineaComando.StartRead(clSilver,clBlack,'MiniLab/>',clWhite,clBlack);
    charthandler:= TChartHandler.Create(chrGrafica, Area, Plotear);
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

procedure TForm1.LineaComandoInput(ACmdBox: TCmdBox; Input: string);
var entrada: TStringList;
var equations: TEquationsList;
var puntos: TMatriz;
var values: TNumericMatrix;
var resul: TNumericMatrix;
var resultado: TArray;
var i: integer;
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
        gridhandler:= TGridHandler.Create(resultTable);
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
        gridhandler:= TGridHandler.Create(resultTable);
        gridhandler.cleanGrid();
        gridhandler.fillGrid(resul, 'gen-newton');
        gridhandler.destroy();
    end
    else if entrada[0]='trapecio' then
    begin
        {ecuacion, a, b, n}
        funcionintegrarString:=entrada[1];
        trapecio := TRiemannSum.Create();
        res:= trapecio.execute(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));
        LineaComando.Writeln(FloatToStr(res));
        with FuncionIntegrar do begin
          Active:= False;

          Extent.XMax:= 10;
          Extent.XMin:= -10;

          Extent.UseXMax:= true;
          Extent.UseXMin:= true;
          FuncionIntegrar.Pen.Color:=  clBlue;

          Active:= True;
        end;
        trapecio.Destroy;
    end
    else if entrada[0]='simpson1/3' then
    begin
        {ecuacion, a, b, n}
        LineaComando.Writeln('simpson1/8');
        simpson := TSimpson.Create(entrada[1], StrToFloat(entrada[2]), StrToFloat(entrada[3]), StrToInt(entrada[4]));
        res:= simpson.simpson13();
        LineaComando.Writeln(FloatToStr(res));
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

