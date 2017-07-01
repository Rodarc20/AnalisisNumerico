unit ChartHandler;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Matrix, Dialogs, TAGraph, TASeries, Graphics;

type
  TChartHandler = class
    private
      mChart: TChart;
      mAreaSeries: TAreaSeries;
      mLineSeries: TLineSeries;
      mLineSeries2: TLineSeries;
    public
      constructor create(chart: TChart; area: TAreaSeries; line: TLineSeries);
      constructor create(chart: TChart; area: TAreaSeries; line: TLineSeries; line2: TLineSeries);
      destructor destroy(); override;
      procedure fillChart(answer: TNumericMatrix; area: Boolean = false);
      procedure fillChart2(answer: TNumericMatrix; answer2: TNumericMatrix; area: Boolean = false);
      procedure cleanPlot();
  end;

implementation

  constructor TChartHandler.create(chart: TChart; area: TAreaSeries; line: TLineSeries);
    begin
      mChart := chart;
      mAreaSeries := area;
      mLineSeries := line;
    end;

  constructor TChartHandler.create(chart: TChart; area: TAreaSeries; line: TLineSeries; line2: TLineSeries);
    begin
      mChart := chart;
      mAreaSeries := area;
      mLineSeries := line;
      mLineSeries2 := line2;
    end;

  destructor TChartHandler.Destroy();
    begin
    end;

  procedure TChartHandler.fillChart(answer: TNumericMatrix; area: Boolean = false);
    var
      m: Integer;
      i: Integer;
    begin
        mLineSeries.Clear;
        mLineSeries.Active:=true;
      m := Length(answer);
      for i := 0 to m-1 do
        begin
          mLineSeries.AddXY(answer[i][1], answer[i][2]);
        end;
      if (area = true) then
        begin
          mLineSeries.SeriesColor := TColor($00FF00);
          (*mLineSeries.LinePen.Width := 2;*)
          mAreaSeries.AreaBrush.Color := TColor($F0CAA6);
          mAreaSeries.AreaLinesPen.Style := psClear;
          mAreaSeries.UseZeroLevel := true;
          for i := 0 to m-1 do
            begin
              mAreaSeries.AddXY(answer[i][1], answer[i][2]);
            end;
        end;
    end;

  procedure TChartHandler.fillChart2(answer: TNumericMatrix; answer2: TNumericMatrix; area: Boolean = false);
  {funcion para graficar el area entre dos funciones}
    var
      m: Integer;
      i: Integer;
    begin
        mLineSeries.Clear;
        mLineSeries.Active:=true;
      m := Length(answer);
      for i := 0 to m-1 do
        begin
          mLineSeries.AddXY(answer[i][1], answer[i][2]);
        end;
        mLineSeries2.Clear;
        mLineSeries2.Active:=true;
      m := Length(answer2);
      for i := 0 to m-1 do
        begin
          mLineSeries2.AddXY(answer2[i][1], answer2[i][2]);
        end;

        {para el area}
      if (area = true) then
          mAreaSeries.Clear;
          mAreaSeries.Active:=true;
        begin
          mAreaSeries.AreaBrush.Color:=  clBlue;
          mAreaSeries.AreaContourPen.Color:=  clBlue;
          for i := 0 to m-1 do
            begin
              mAreaSeries.AddXY(answer[i][1], answer[i][2]);
            end;
        i:= m-1;
        while(i >= 0) do
            begin
              mAreaSeries.AddXY(answer2[i][1], answer2[i][2]);
              i:=i-1;
            end;
        end;
    end;

  procedure TChartHandler.cleanPlot();
    begin
      mChart.ClearSeries();
    end;

end.

