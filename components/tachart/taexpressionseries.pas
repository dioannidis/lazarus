{

 Function series with expression parser for TAChart.

 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

 AUTHOR: Werner Pamler

 NOTE:
 Set/unset the define MATH_EXPRESSIONS to get/remove design-time access to
 functions declared in the unit Math. For runtime-only access call
 "ExtendExprBuiltIns()".

}

unit TAExpressionSeries;

{$H+}

interface

uses
  Classes, Graphics, SysUtils, fpexprpars,
  TAChartUtils, TADrawUtils, TAFuncSeries;

type
  TExpressionSeries = class;

  TChartExprParam = class(TCollectionItem)
  private
    FName: String;
    FValue: Double;
    procedure ParamChanged(ASender: TObject);
    procedure SetName(const AValue: String);
    procedure SetValue(const AValue: Double);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Name: String read FName write SetName;
    property Value: Double read FValue write SetValue;
  end;

  TChartExprParams = class(TCollection)
  private
    FParser: TFpExpressionParser;
    FSeries: TExpressionSeries;
    function GetP(AIndex: Integer): TChartExprParam;
    function GetValByName(AName: String): Double;
    procedure SetP(AIndex: Integer; AValue: TChartExprParam);
    procedure SetValByName(AName: String; AValue: Double);
  protected
    procedure Changed;
  public
    constructor Create(ASeries: TExpressionSeries);
    function AddParam(const AName: String; const AValue: Double): TChartExprParam;
    function FindParamByName(AName: String): TChartExprParam;
    property Params[AIndex: Integer]: TChartExprParam read GetP write SetP; default;
    property ValueByName[AName: String]: Double read GetValByName write SetValByName;
  end;

  TDomainParts = array[0..4] of String;
  // parts of a domain expression
  // e.g. '1>= x >0' has the parts '1', '>=', 'x', '>', '0'

  TChartDomainScanner = class
  private
    FSeries: TExpressionSeries;
    FParser: TFpExpressionParser;
    FExpression: String;
    FEpsilon: Double;
    function GetVariable: String;
  protected
    procedure Analyze(AList, ADomain: TIntervalList; const AParts: TDomainParts);
    procedure ConvertToExclusions(AList, ADomain: TIntervalList);
    procedure ExpressionError;
    procedure ParseExpression(AList, ADomain: TIntervalList);
  public
    constructor Create(ASeries: TExpressionSeries);
    procedure ExtractDomainExclusions(AList: TIntervalList);
    property Epsilon: Double read FEpsilon write FEpsilon;
    property Expression: String read FExpression write FExpression;
    property Variable: String read GetVariable;
  end;

  TExpressionSeries = class(TCustomFuncSeries)
  private
    FDomain: String;
    FDomainEpsilon: Double;
    FDomainScanner: TChartDomainScanner;
    FExpression: String;
    FParams: TChartExprParams;
    FParser: TFpExpressionParser;
    FVariable: String;
    FX: TFPExprIdentifierDef;
    FDirty: Boolean;
    procedure SetDomain(const AValue: String);
    procedure SetDomainEpsilon(const AValue: Double);
    procedure SetExpression(const AValue: string);
    procedure SetParams(const AValue: TChartExprParams);
    procedure SetVariable(const AValue: String);
  protected
    function DoCalculate(AX: Double): Double; override;
    procedure GetBounds(var ABounds: TDoubleRect); override;
    procedure SetupParser;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure Draw(ADrawer: IChartDrawer); override;
    function IsEmpty: Boolean; override;
    procedure RequestParserUpdate; inline;
  published
    property DomainEpsilon: Double read FDomainEpsilon write SetDomainEpsilon;
    property Params: TChartExprParams read FParams write SetParams;
    property Variable: String read FVariable write SetVariable;
    property Domain: String read FDomain write SetDomain;
    property Expression: String read FExpression write SetExpression;
  end;

procedure ExtendExprBuiltins;


implementation

uses
  Math,
  TAGraph, TAChartStrConsts;


{ TChartExprParam }

procedure TChartExprParam.Assign(Source: TPersistent);
begin
  if Source is TChartExprParam then begin
    FName := TChartExprParam(Source).Name;
    FValue := TChartExprParam(Source).Value;
  end;
  inherited Assign(Source);
end;

procedure TChartExprParam.ParamChanged(ASender: TObject);
begin
  Unused(ASender);
  TChartExprParams(Collection).Changed;
end;

procedure TChartExprParam.SetName(const AValue: String);
begin
  if AValue = FName then exit;
  FName := AValue;
  ParamChanged(self);
end;

procedure TChartExprParam.SetValue(const AValue: Double);
begin
  if AValue = FValue then exit;
  FValue := AValue;
  ParamChanged(self);
end;


{ TChartExprParams }

constructor TChartExprParams.Create(ASeries: TExpressionSeries);
begin
  inherited Create(TChartExprParam);
  FSeries := ASeries;
  FParser := ASeries.FParser;
end;

function TChartExprParams.AddParam(const AName: String;
  const AValue: Double): TChartExprParam;
begin
  Result := Add as TChartExprParam;
  Result.FName := AName;
  Result.FValue := AValue;
  FSeries.RequestParserUpdate;
end;

procedure TChartExprParams.Changed;
begin
  FSeries.RequestParserUpdate;
  FSeries.UpdateParentChart;
end;

function TChartExprParams.FindParamByName(AName: String): TChartExprParam;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Result := Params[i];
    if Result.Name = AName then
      exit;
  end;
  Result := nil;
end;

function TChartExprParams.GetP(AIndex: Integer): TChartExprParam;
begin
  Result := TChartExprParam(Items[AIndex]);
end;

function TChartExprParams.GetValByName(AName: String): Double;
var
  P : TChartExprParam;
begin
  P := FindParamByName(AName);
  if P = nil then
    raise Exception.CreateFmt('Parameter "%s" not found.', [AName]);
  Result := P.Value;
end;

procedure TChartExprParams.SetP(AIndex: Integer;
  AValue: TChartExprParam);
begin
  Items[AIndex] := AValue;
end;

procedure TChartExprParams.SetValByName(AName: String; AValue: Double);
var
  P: TChartExprParam;
begin
  P := FindParamByName(AName);
  if P = nil then
    raise Exception.CreateFmt('Parameter "%s" not found.', [AName]);
  P.Value := AValue;
  Changed;
end;


{ TChartDomainScanner }

constructor TChartDomainScanner.Create(ASeries: TExpressionSeries);
begin
  FSeries := ASeries;
  FParser := ASeries.FParser;
end;

{ Analyzes the parts of the domain expression and extract the intervals on
  which the function is defined (--> ADomain).
  NOTE: Although supported by the scanner the method does not distinguish
  between cases < and <=, as well as between > and >=. }
procedure TChartDomainScanner.Analyze(AList, ADomain: TIntervalList;
  const AParts: TDomainParts);
var
  a, b: Double;
begin
  // two-sided interval, e.g. "0 < x <= 1", or "2 > x >= 1"
  if (AParts[2] = Variable) and (AParts[3] <> '') and (AParts[4] <> '') then
  begin
    FParser.Expression := AParts[0];
    a := ArgToFloat(FParser.Evaluate);
    FParser.Expression := AParts[4];
    b := ArgToFloat(FParser.Evaluate);
    if (AParts[1][1] = '<') and (AParts[3][1] = '<') and (a < b) then
      ADomain.AddRange(a, b)
    else
    if (AParts[1][1] = '>') and (AParts[3][1] = '>') and (a > b) then
      ADomain.AddRange(b, a);
  end else
  // one-sided interval, variable is at left
  if (AParts[0] = Variable) and (AParts[3] = '') and (AParts[4] = '') then
  begin
    FParser.Expression := AParts[2];
    a := ArgToFloat(FParser.Evaluate);
    case AParts[1] of
      '<>'      : AList.AddPoint(a);                    //  x <> a
      '<', '<=' : ADomain.AddRange(-Infinity, a);       //  x < a, x <= a
      '>', '>=' : ADomain.AddRange(a, Infinity);        //  x > a, x >= a
      else  Expressionerror;
    end;
  end else
  // one-sided interval, variable is at right
  if (AParts[2] = Variable) and (AParts[3] = '') and (AParts[4] = '') then
  begin
    FParser.Expression := AParts[0];
    a := ArgToFloat(FParser.Evaluate);
    case AParts[1] of
      '<>'      : AList.AddPoint(a);                    //  a <> x
      '<', '<=' : ADomain.AddRange(a, Infinity);        //  a < x, a <= x
      '>', '>=' : ADomain.AddRange(-Infinity, a);       //  a > x, a >= x
      else   ExpressionError;
    end;
  end else
    ExpressionError;
end;

{ Converts the intervals in ADomain on which the function is defined to
  intervals in AList in which the function is NOT defined (= DomainExclusion) }
procedure TChartDomainScanner.ConvertToExclusions(AList, ADomain: TIntervalList);

  function IsPoint(i: Integer): Boolean;
  begin
    Result := (i >= 0) and (i < ADomain.IntervalCount) and
      (ADomain.Interval[i].FStart = ADomain.Interval[i].FEnd);
  end;

type
  TIntervalPoint = record
    Value: Double;
    Contained: Boolean;
  end;

var
  a, b: Double;
  i, j: Integer;
  points: array of TIntervalPoint;
begin
  if ADomain.IntervalCount = 0 then
    exit;

  j := 0;
  SetLength(points, ADomain.IntervalCount*2);

  for i:=0 to ADomain.IntervalCount-1 do begin
    if IsPoint(i) then
      Continue;
    if ADomain.Interval[i].FStart <> -Infinity then begin
      points[j].Value := ADomain.Interval[i].FStart;
      points[j].Contained := IsPoint(i-1);
      inc(j);
    end;
    if ADomain.Interval[i].FEnd <> +Infinity then begin
      points[j].Value := ADomain.Interval[i].FEnd;
      points[j].Contained := IsPoint(i+1);
      inc(j);
    end;
  end;
  SetLength(points, j);

  // Case 1: domain extends to neg infinity
  // -INF <---------|xxxxxxxx|------|xxxx> INF     with - = allowed, x = forbidden
  //                0        1      2
  if ADomain.Interval[0].FStart = -Infinity then
    j := 0
  else
  // Case 2: domain begins at finite value
  // -INF <xxxxxxxxx|--------|xxxxxx|------>INF
  //                0        1      2
  begin
    a := -Infinity;
    b := points[0].Value;
    AList.AddRange(a, b);
    if not points[0].Contained then
      AList.AddPoint(b);
    j := 1;
  end;
  while j < Length(points) do begin
    a := points[j].Value;
    if not points[j].Contained then
      AList.AddPoint(a);
    if j = High(points) then begin
      AList.AddRange(a, Infinity);
    end else
    begin
      b := points[j+1].Value;
      AList.AddRange(a, b);
      if not points[j+1].Contained then
        AList.AddPoint(b);
    end;
    inc(j, 2);
  end;
end;

procedure TChartDomainScanner.ExpressionError;
begin
  raise Exception.Create('Incorrect domain expression in "' + FExpression + '"');
end;

procedure TChartDomainScanner.ExtractDomainExclusions(AList: TIntervalList);
var
  domains: TIntervalList;
  savedExpr: String;
begin
  Assert(AList <> nil);

  AList.Clear;
  if FExpression = '' then
    exit;

  savedExpr := FParser.Expression;
  domains := TIntervalList.Create;
  try
    AList.Epsilon := FEpsilon;
    domains.Epsilon := FEpsilon;
    ParseExpression(AList, domains);
    ConvertToExclusions(AList, domains);
  finally
    domains.Free;
    FParser.Expression := savedExpr;
  end;
end;

function TChartDomainScanner.GetVariable: String;
begin
  Result := FSeries.Variable;
end;

{ Parses the expression string and creates an interval list with the
  domain of the function, i.e. the intervals in which the function is DEFINED. }
procedure TChartDomainScanner.ParseExpression(AList, ADomain: TIntervalList);
var
  i: Integer;
  s: String;
  parts: TDomainParts;
  p: Integer;  // 0=left, 1=operator left , 2=middle, 3=operator right, 4=right
               //   0          <=               x           <              1
begin
  for p := 0 to Length(parts)-1 do
    parts[p] := '';
  p := 0;
  i := 1;
  s := FExpression + ';';  // Simplify parsing...
  while i <= Length(s) do begin
    case s[i] of
      ' ': ;
      ';': begin
             Analyze(AList, ADomain, parts);
             for p := 0 to Length(parts)-1 do parts[p] := '';
               p := 0;
           end;
      '<': if (i < Length(FExpression)) then begin
             inc(p);
             case s[i+1] of
               '=': begin parts[p] := '<='; inc(i); end;
               '>': begin parts[p] := '<>'; inc(i); end;
               else parts[p] := '<';
             end;
             inc(p);
           end else
             ExpressionError;
      '>': if (i < Length(FExpression)) then begin
             inc(p);
             if s[i+1] = '=' then begin
               parts[p] := '>=';
               inc(i);
             end else
               parts[p] := '>';
             inc(p);
           end else
             ExpressionError;
      '=': ExpressionError;
    else
      parts[p] := Parts[p] + s[i];
    end;
    inc(i);
  end;
end;


{ TExpressionSeries }

constructor TExpressionSeries.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDirty := true;

  FVariable := 'x';
  FExpression := 'x';

  FParser := TFpExpressionParser.Create(self);
  FParser.BuiltIns := [bcMath];
  FX := FParser.Identifiers.AddFloatVariable(FVariable, 0.0);

  FDomainScanner := TChartDomainScanner.Create(self);
  FDomainEpsilon := DEFAULT_EPSILON;

  FParams := TChartExprParams.Create(self);
  FParams.FParser := FParser;
end;

destructor TExpressionSeries.Destroy;
begin
  FX := nil;
  FParams.Free;
  FDomainScanner.Free;
  inherited;
end;

procedure TExpressionSeries.Assign(ASource: TPersistent);
begin
  if ASource is TExpressionSeries then begin
    Domain := TExpressionSeries(ASource).Domain;
    Expression := TExpressionSeries(ASource).Expression;
    Params := TExpressionSeries(ASource).Params;
    Variable := TExpressionSeries(ASource).Variable;
  end;
  inherited Assign(ASource);
end;

function TExpressionSeries.DoCalculate(AX: Double): Double;
var
  res: TFPExpressionResult;
begin
  Result := 0.0;
  FX.AsFloat := AX;
  try
    res := FParser.Evaluate;
    if res.ResultType=rtFloat then
      Result := res.ResFloat
    else
    if res.ResultType=rtInteger then
      Result := res.ResInteger;
  except
  end;
end;

procedure TExpressionSeries.Draw(ADrawer: IChartDrawer);
begin
  SetupParser;
  inherited;
end;

procedure TExpressionSeries.GetBounds(var ABounds: TDoubleRect);
begin
  SetupParser;
  inherited;
end;

function TExpressionSeries.IsEmpty: Boolean;
begin
  Result := FParser.Expression <> '';
end;

procedure TExpressionSeries.RequestParserUpdate;
begin
  FDirty := true;
end;

procedure TExpressionSeries.SetDomain(const AValue: String);
begin
  if FDomain = AValue then exit;
  FDomain := AValue;
  RequestParserUpdate;
  UpdateParentChart;
end;

procedure TExpressionSeries.SetDomainEpsilon(const AValue: Double);
begin
  FDomainScanner.Epsilon := AValue;
end;

procedure TExpressionSeries.SetExpression(const AValue: String);
begin
  if FParser.Expression = AValue then
    exit;
  FExpression := AValue;
  RequestParserUpdate;
  UpdateParentChart;
end;

procedure TExpressionSeries.SetParams(const AValue: TChartExprParams);
begin
  RequestParserUpdate;
  FParams.Assign(AValue);
  UpdateParentChart;
end;

procedure TExpressionSeries.SetupParser;
var
  i: Integer;
  p: TChartExprParam;
begin
  if (not FDirty) then
    exit;

  FParser.Identifiers.Clear;
  FX := FParser.Identifiers.AddFloatVariable(FVariable, 0.0);
  for i:=0 to FParams.Count-1 do begin
    p := FParams[i];
    FParser.Identifiers.AddFloatVariable(p.Name, p.Value);
  end;

  FDomainScanner.Epsilon := FDomainEpsilon;
  FDomainScanner.Expression := FDomain;
  FDomainScanner.ExtractDomainExclusions(DomainExclusions);

  FParser.Expression := FExpression;
  if not (FParser.ResultType in [rtInteger, rtFLoat]) then
    raise EExprParser.CreateFmt(rsErrInvalidResultType, [ResultTypeName(FParser.ResultType)]);

  FDirty := false;
end;

procedure TExpressionSeries.SetVariable(const AValue: String);
begin
  if FVariable = AValue then exit;
  FVariable := AValue;
  RequestParserUpdate;
  UpdateParentChart;
end;


{ Additional functions for the parser }

procedure ExprDegToRad(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := degtorad(x);
end;

procedure ExprRadToDeg(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := radtodeg(x);
end;

procedure ExprTan(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := tan(x);
end;

procedure ExprCot(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := cot(x);
end;

procedure ExprArcsin(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := arcsin(x);
end;

procedure ExprArccos(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := arccos(x);
end;

procedure ExprArccot(Var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := pi/2 - arctan(x);
end;

procedure ExprCosh(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := cosh(x);
end;

{ Hyperbolic cotangent coth(x); x <> 0 }
procedure ExprCoth(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := 1/tanh(x);
end;

procedure ExprSinh(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := sinh(x);
end;

procedure ExprTanh(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := tanh(x);
end;

procedure ExprArcosh(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := arcosh(x);
end;

procedure ExprArsinh(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgtoFloat(Args[0]);
  Result.resFloat := arsinh(x);
end;

procedure ExprArtanh(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := artanh(x);
end;

procedure ExprArcoth(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := artanh(1.0/x);
end;

procedure ExprSinc(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  if x = 0 then
    Result.ResFloat := 1.0
  else
    Result.resFloat := sin(x)/x;
end;

procedure ExprPower(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x,y: Double;
begin
  x := ArgToFloat(Args[0]);
  y := ArgToFloat(Args[1]);
  Result.resFloat := Power(x, y);
end;

procedure ExprHypot(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x,y: Double;
begin
  x := ArgToFloat(Args[0]);
  y := ArgToFloat(Args[1]);
  Result.resFloat := Hypot(x,y);
end;

procedure ExprLg(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := log10(x);
end;

procedure ExprLog10(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := log10(x);
end;

procedure ExprLog2(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x: Double;
begin
  x := ArgToFloat(Args[0]);
  Result.resFloat := log2(x);
end;

procedure ExprMax(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x1, x2: Double;
begin
  x1 := ArgToFloat(Args[0]);
  x2 := ArgToFloat(Args[1]);
  Result.resFloat := Max(x1, x2);
end;

procedure ExprMin(var Result: TFPExpressionResult; const Args: TExprParameterArray);
var
  x1, x2: Double;
begin
  x1 := ArgToFloat(Args[0]);
  x2 := ArgToFloat(Args[1]);
  Result.resFloat := Min(x1, x2);
end;

procedure ExtendExprBuiltins;
var
  i: Integer;
begin
  with BuiltinIdentifiers do begin
    // Trigonometric and related
    AddFunction(bcMath, 'degtorad', 'F', 'F', @ExprDegtorad);
    AddFunction(bcMath, 'radtodeg', 'F', 'F', @ExprRadtodeg);
    AddFunction(bcMath, 'tan', 'F', 'F', @ExprTan);
    AddFunction(bcMath, 'cot', 'F', 'F', @ExprCot);
    AddFunction(bcMath, 'arcsin', 'F', 'F', @ExprArcSin);
    AddFunction(bcMath, 'arccos', 'F', 'F', @ExprArcCos);
    AddFunction(bcMath, 'arccot', 'F', 'F', @ExprArcCot);
    AddFunction(bcMath, 'cosh', 'F', 'F', @ExprCosh);
    AddFunction(bcMath, 'coth', 'F', 'F', @ExprCoth);
    AddFunction(bcMath, 'sinh', 'F', 'F', @ExprSinh);
    AddFunction(bcMath, 'tanh', 'F', 'F', @ExprTanh);
    AddFunction(bcMath, 'arcosh', 'F', 'F', @ExprArcosh);
    AddFunction(bcMath, 'arsinh', 'F', 'F', @ExprArsinh);
    AddFunction(bcMath, 'artanh', 'F', 'F', @ExprArtanh);
    AddFunction(bcMath, 'arcoth', 'F', 'F', @ExprArcoth);
    AddFunction(bcMath, 'sinc', 'F', 'F', @ExprSinc);

    // Power
    AddFunction(bcMath, 'power', 'F', 'FF', @ExprPower);
    AddFunction(bcMath, 'hypot', 'F', 'FF', @ExprHypot);

    // Logarithm
    AddFunction(bcMath, 'lg', 'F', 'F', @ExprLog10);
    AddFunction(bcMath, 'log10', 'F', 'F', @ExprLog10);
    AddFunction(bcMath, 'log2', 'F', 'F', @ExprLog2);

    // Max/min
    //AddFunction(bcMath, 'max', 'F', 'FF', @ExprMax);
    //AddFunction(bcMath, 'min', 'F', 'FF', @ExprMin);
  end;
end;

initialization
  {$IFDEF MATH_EXPRESSIONS}
  ExtendExprBuiltins;
  {$ENDIF}

  RegisterSeriesClass(TExpressionSeries, @rsExpressionSeries);

end.
