unit GridHandler;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, Matrix, Dialogs;

type
  TGridHandler = class
    private
      mGrid: TStringGrid;
      function getHeaders(method: String): TStringList;
    public
      constructor create(grid: TStringGrid);
      destructor destroy(); override;
      procedure fillGrid(answer: TNumericMatrix; method: String);
      procedure cleanGrid();
  end;

implementation

  constructor TGridHandler.create(grid: TStringGrid);
    begin
      mGrid := grid;
    end;

  destructor TGridHandler.Destroy();
    begin
    end;

  function TGridHandler.getHeaders(method: String): TStringList;
    begin
      result := TStringList.Create();
      case method of
        'bisection':
          result.AddStrings(['n', 'a', 'b', 'Xn', 'Signo','EAA', 'ERA', 'ERPA']);
        'false-position':
          result.AddStrings(['n', 'a', 'b', 'Xn', 'Signo','EAA', 'ERA', 'ERPA']);
        'fixed-point':
          result.AddStrings(['n', 'x', 'Xn','EAA', 'ERA', 'ERPA']);
        'newton':
          result.AddStrings(['n', 'x', 'Xn','EAA', 'ERA', 'ERPA']);
        'riemann':
          result.AddStrings(['Result']);
        'simpson13':
          result.AddStrings(['Integral']);
        'simpson38':
          result.AddStrings(['Integral', 'Area']);
        'secant':
          result.AddStrings(['n', 'x', 'Xn','EAA', 'ERA', 'ERPA']);
        'euler':
          result.AddStrings(['n', 'Xn', 'Yn']);
        'heun':
          result.AddStrings(['n', 'Xn', 'Yn', 'E. Approx']);
        'runge-kutta':
          result.AddStrings(['n', 'Xn', 'Yn', 'k1', 'k2', 'k3', 'k4', 'm']);
        'dormand-prince':
          result.AddStrings(['n', 'Xn', 'Yn', 'k1', 'k2', 'k3', 'k4', 'k5', 'k6', 'k7', 'h']);
        'gen-newton':
          result.AddStrings(['n', 'Xn', 'Yn', 'Xn+1', 'Yn+1', 'Error']);
        'ejercicio1':
          result.AddStrings(['Z', '.00', '.01', '.02', '.03', '.04', '.05', '.06', '.07', '.08', '.09']);
      end;
    end;

  procedure TGridHandler.fillGrid(answer: TNumericMatrix; method: String);
    var
      m: Integer;
      n: Integer;
      headers: TStringList;
      i: Integer;
      j: Integer;
    begin
      m := Length(answer) + 1;
      n := Length(answer[0]);
      ShowMessage(IntToStr(m));
      headers := getHeaders(method);
      mGrid.RowCount := m;
      mGrid.ColCount := headers.Count;
      mGrid.FixedRows := 1;
      mGrid.FixedCols := 1;
      for i := 0 to n-1 do
        begin
          mGrid.Cells[i, 0] := headers[i];
          for j := 1 to m-1 do
            begin
              mGrid.Cells[i, j] := FloatToStr(answer[j-1][i]);
            end;
        end;
    end;

  procedure TGridHandler.cleanGrid();
    begin
      mGrid.Clear();
    end;

end.

