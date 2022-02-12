unit UrlBuilder;

interface

uses
  System.Classes, System.Generics.Collections, System.SysUtils;

type
  TUrlBuilder = class(TObject)
  private
    FUrl: String;
    FParamValues: TDictionary<String, String>;
    FQueryParams: TStringList;
    function InternalSetParamValues: String;
    function GetQueryParams: String;
  public
    constructor Create(url: String);
    destructor Destroy; override;

    function ToString: String; override;

    procedure AddQueryParam(name, value: String);
    procedure SetParam(name, value: String);

    function ParamCount: Integer;
  end;

implementation

uses
  System.RegularExpressions;

{ TUrlBuilder }

procedure TUrlBuilder.AddQueryParam(name, value: String);
begin
  FQueryParams.Add(Format('%s=%s', [name, value]));
end;

constructor TUrlBuilder.Create(url: String);
begin
  FParamValues := TDictionary<String, String>.Create;
  FQueryParams := TStringList.Create;
  FUrl := url;
end;

destructor TUrlBuilder.Destroy;
begin
  FParamValues.Free;
  FQueryParams.Free;
  inherited;
end;

function TUrlBuilder.GetQueryParams: String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to FQueryParams.Count-1 do
  begin
    if not Result.IsEmpty then Result := Result + '&';
    Result := Result + FQueryParams[i];
  end;

  if not Result.IsEmpty then Result := '?' + Result;
end;

function TUrlBuilder.InternalSetParamValues: String;
var
  key: string;
  match: TMatch;
  matchCollection: TMatchCollection;
  regEx: TRegEx;
  value: string;
begin
  Result := FUrl;

  Result := Result + GetQueryParams;

  regEx := TRegEx.Create(':\w+');
  matchCollection := regEx.Matches(FUrl);

  for match in matchCollection do
  begin
    key := match.Value;
    if not FParamValues.TryGetValue(key, value) then value := '';

    Result := Result.Replace(key, value);
  end;
end;

function TUrlBuilder.ParamCount: Integer;
var
  regEx: TRegEx;
begin
  regEx := TRegEx.Create(':\w+');
  Result := regEx.Matches(FUrl).Count;
end;

procedure TUrlBuilder.SetParam(name, value: String);
begin
  if not name.StartsWith(':') then name := ':'+name;
  FParamValues.AddOrSetValue(name, value);
end;

function TUrlBuilder.ToString: String;
begin
  Result := InternalSetParamValues;
end;

end.
