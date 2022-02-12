unit UrlBuilderTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TUrlBuilderTest = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [TestCase]
    procedure TestUrlParams;
    [TestCase]
    procedure TestUrlParamsAndQuery;
    [TestCase]
    procedure TestRegEx;
  end;

implementation

uses
  UrlBuilder, System.RegularExpressions;

procedure TUrlBuilderTest.Setup;
begin
end;

procedure TUrlBuilderTest.TearDown;
begin
end;

procedure TUrlBuilderTest.TestRegEx;
var
  match: TMatch;
  regex: TRegEx;
begin
  regex := TRegEx.Create(':\w+');
  match := regex.Match('http://localhost/:param1/:param2');

  Assert.IsTrue(match.Success);

  Assert.AreEqual(':param1', match.Value);

  match := match.NextMatch;
  Assert.AreEqual(':param2', match.Value);
end;

procedure TUrlBuilderTest.TestUrlParams;
var
  url: TUrlBuilder;
begin
  url := TUrlBuilder.Create('http://localhost/:param1/:param2');
  try
    Assert.AreEqual(2, url.ParamCount);

    url.SetParam('param1', 'value1');
    url.SetParam('param2', 'value2');

    Assert.AreEqual('http://localhost/value1/value2', url.ToString);
  finally
    url.Free;
  end;
end;

procedure TUrlBuilderTest.TestUrlParamsAndQuery;
var
  url: TUrlBuilder;
begin
  url := TUrlBuilder.Create('http://localhost/:param1/:param2');
  try
    Assert.AreEqual(2, url.ParamCount);

    url.AddQueryParam('query1', 'queryValue1');
    url.AddQueryParam('query2', 'param3');

    url.SetParam('param1', 'value1');
    url.SetParam('param2', 'value2');

    Assert.AreEqual('http://localhost/value1/value2?query1=queryValue1&query2=param3', url.ToString);
  finally
    url.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TUrlBuilderTest);

end.
