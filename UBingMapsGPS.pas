unit UBingMapsGPS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Math, JPEG, ExtCtrls, XPMan, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, GPS, ComCtrls,
  CPortCtl, Buttons;

type
  TFBingMapsGPS = class(TForm)
    IMG_Carte: TImage;
    GPS1: TGPS;
    BV_Barre: TBevel;
    GPSSpeed1: TGPSSpeed;
    GPSSatellitesPosition1: TGPSSatellitesPosition;
    GPSSatellitesReception1: TGPSSatellitesReception;
    GPSCompass1: TGPSCompass;
    PNL_GPS: TPanel;
    LBL_Port: TLabel;
    CCMB_Port: TComComboBox;
    BTN_DemarrerGPS: TSpeedButton;
    HTTP_BingMaps: TIdHTTP;
    LBL_Latitude: TLabel;
    LBL_Longitude: TLabel;
    LBL_Altitude: TLabel;
    CHK_Valide: TCheckBox;
    XPManifest1: TXPManifest;
    CHK_Satellite: TCheckBox;
    TIM_BingMaps: TTimer;
    TB_Zoom: TTrackBar;
    procedure FormDestroy(Sender: TObject);
    procedure CCMB_PortChange(Sender: TObject);
    procedure BTN_DemarrerGPSClick(Sender: TObject);
    procedure GPS1GPSDatasChange(Sender: TObject; GPSDatas: TGPSDatas);
    procedure TIM_BingMapsTimer(Sender: TObject);
    procedure CHK_ValideClick(Sender: TObject);
    procedure CHK_SatelliteClick(Sender: TObject);
    procedure TB_ZoomChange(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

const
  // Placez ici la cl� r�cup�r�e sur le site Bing Maps Account Center
  Clef = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
  Serveur = 'http://dev.virtualearth.net/REST/v1/';
  Imagerie = Serveur + 'Imagery/Map/%s/%s,%s/%d?ms=%d,%d&pp=%s,%s;6&key='
    + Clef;

var
  FBingMapsGPS: TFBingMapsGPS;
  Latitude, Longitude: Double;

implementation

{$R *.dfm}

procedure TFBingMapsGPS.FormDestroy(Sender: TObject);
begin
  // Arr�te le GPS � la fermeture de l'application
  GPS1.Close();
end;


procedure TFBingMapsGPS.CCMB_PortChange(Sender: TObject);
begin
  // Change le port utilis� par le GPS
  GPS1.Port := CCMB_Port.Text;
end;

procedure TFBingMapsGPS.BTN_DemarrerGPSClick(Sender: TObject);
begin
  try
    // D�marre le GPS si le bouton est enfonc�
    GPS1.Connected := BTN_DemarrerGPS.Down;

    // D�marre le rafra�chisement automatique de la carte
    TIM_BingMaps.Enabled := BTN_DemarrerGPS.Down;
  except 
    on E: Exception do
    begin
      // Remonte le bouton
      BTN_DemarrerGPS.Down := False;

      // Affiche un message d'erreur
      MessageDlg('Erreur lors du d�marrage du GPS.'#13#10
        + E.ClassName + ' : ' + E.Message, mtError, [mbOk], 0);
    end;
  end;

  // Change le texte du bouton
  case BTN_DemarrerGPS.Down of
    True :
      BTN_DemarrerGPS.Caption := '&D�marrer le GPS';
    False :
      BTN_DemarrerGPS.Caption := '&Arr�ter le GPS';
  end;
end;

procedure TFBingMapsGPS.GPS1GPSDatasChange(Sender: TObject;
  GPSDatas: TGPSDatas);
begin
  with GPSDatas do
  begin
    // Change le contenu des TLabel pour avoir la position GPS
    LBL_Latitude.Caption  := Format('Latitude : %2.6f�', [Latitude]);
    LBL_Longitude.Caption := Format('Longitude : %2.6f�', [Longitude]);
    LBL_Altitude.Caption  := Format('Altitude : %f m', [HeightAboveSea]);

    // Coche la case si la position capt�e est valide
    CHK_Valide.Checked    := Valid;
  end;
end;

procedure TFBingMapsGPS.TIM_BingMapsTimer(Sender: TObject);

  // Retourne le r�pertoire temporaire de Windows
  function RepertoireTemporaire(): String;
  var
    lpBuffer: array[0..255] of Char;
  begin
    GetTempPath(SizeOf(lpBuffer), lpBuffer);
    Result := lpBuffer;
  end;

  // Transforme un nombre r�el en cha�ne
  function ReelVersStr(Nombre: Double): String;
  var
    FrmNmb: TFormatSettings;
  begin
    try
      // -> http://msdn.microsoft.com/library/0h88fahh
      GetLocaleFormatSettings($0409, FrmNmb);
      Result := FloatToStr(Nombre, FrmNmb);
    except
      Result := '0';
    end;
  end;

var
  Adresse, Carte, LatStr, LongStr, TypeVue: String;
  Reponse: TFileStream;
begin
  // Si le GPS est connect�
  if GPS1.Connected then
  begin
    // Si la position a chang�e (attention : utilise l'unit� Math)
    if not SameValue(GPS1.GPSDatas.Latitude, Latitude, 0.0001) and
      not SameValue(GPS1.GPSDatas.Longitude, Longitude, 0.0001) then
    begin
      // R�cup�re la position
      Latitude  := GPS1.GPSDatas.Latitude;
      Longitude := GPS1.GPSDatas.Longitude;

      // Converti la position en texte
      LatStr    := ReelVersStr(Latitude);
      LongStr   := ReelVersStr(Longitude);

      // Si la vue satellite est coch�e
      if CHK_Satellite.Checked then
      begin
        TypeVue := 'AerialWithLabels';
      end
      else
      begin
        TypeVue := 'Road';
      end;

      // Ne pas oublier d'ajouter l'unit� JPEG
      Carte   := RepertoireTemporaire() + 'Carte.jpeg';

      // Pr�pare l'adresse de l'image � charger
      Adresse := Format(Imagerie, [TypeVue, LatStr, LongStr,
        TB_Zoom.Position, IMG_Carte.Width, IMG_Carte.Height, LatStr, LongStr]);

      // Charge l'image � partir de Bing Maps
      Reponse := TFileStream.Create(Carte, fmCreate);
      try
        HTTP_BingMaps.Get(Adresse, Reponse);
      finally
        Reponse.Free();
      end;
      IMG_Carte.Picture.LoadFromFile(Carte);
    end;
  end;
end;

procedure TFBingMapsGPS.CHK_ValideClick(Sender: TObject);
begin
  // Coche la case uniquement si le signal est valide
  CHK_Valide.Checked := GPS1.GPSDatas.Valid;
end;

procedure TFBingMapsGPS.CHK_SatelliteClick(Sender: TObject);
begin
  // Force le rafra�chissement de la carte
  Latitude  := 0;
  Longitude := 0;
  TIM_BingMapsTimer(TIM_BingMaps);
end;

procedure TFBingMapsGPS.TB_ZoomChange(Sender: TObject);
begin
  // Force le rafra�chissement de la carte
  Latitude  := 0;
  Longitude := 0;
  TIM_BingMapsTimer(TIM_BingMaps);
end;

end.
