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
    public
      constructor create(chart: TChart; area: TAreaSeries; line: TLineSeries);
      destructor destroy(); override;
      procedure fillChart(answer: TNumericMatrix; area: Boolean = false);
      procedure cleanPlot();
  end;

implementation

  constructor TChartHandler.create(chart: TChart; area: TAreaSeries; line: TLineSeries);
    begin
      mChart := chart;
      mAreaSeries := area;
      mLineSeries := line;
    end;

  destructor TChartHandler.Destroy();
    begin
    end;

  procedure TChartHandler.fillChart(answer: TNumericMatrix; area: Boolean = false);
    var
      m: Integer;
      i: Integer;
    begin
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

  procedure TChartHandler.cleanPlot();
    begin
      mChart.ClearSeries();
    end;

end.

