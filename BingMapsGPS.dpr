program BingMapsGPS;

uses
  Forms,
  UBingMapsGPS in 'UBingMapsGPS.pas' {FBingMapsGPS};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Bing Maps GPS';
  Application.CreateForm(TFBingMapsGPS, FBingMapsGPS);
  Application.Run;
end.
