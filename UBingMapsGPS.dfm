object FBingMapsGPS: TFBingMapsGPS
  Left = 198
  Top = 114
  Width = 709
  Height = 495
  Caption = 'Bing Maps - GPS'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  DesignSize = (
    701
    461)
  PixelsPerInch = 96
  TextHeight = 13
  object BV_Barre: TBevel
    Left = 432
    Top = 4
    Width = 9
    Height = 453
    Anchors = [akTop, akRight, akBottom]
    Shape = bsLeftLine
  end
  object IMG_Carte: TImage
    Left = 4
    Top = 4
    Width = 401
    Height = 453
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object PNL_GPS: TPanel
    Left = 436
    Top = 4
    Width = 261
    Height = 453
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 0
    object GPSSatellitesReception1: TGPSSatellitesReception
      Left = 4
      Top = 32
      Width = 97
      Height = 157
      GPS = GPS1
      BackColor = clBtnFace
    end
    object GPSSpeed1: TGPSSpeed
      Left = 8
      Top = 192
      Width = 97
      Height = 21
      GPS = GPS1
    end
    object GPSSatellitesPosition1: TGPSSatellitesPosition
      Left = 104
      Top = 32
      Width = 153
      Height = 153
      GPS = GPS1
      CardFont.Charset = DEFAULT_CHARSET
      CardFont.Color = 13408614
      CardFont.Height = -12
      CardFont.Name = 'Tahoma'
      CardFont.Style = [fsBold]
      SatFont.Charset = DEFAULT_CHARSET
      SatFont.Color = clBlue
      SatFont.Height = -11
      SatFont.Name = 'Tahoma'
      SatFont.Style = []
      Pen.Color = 13408614
      Pen.Width = 2
      BackgroundColor = clBtnFace
    end
    object GPSCompass1: TGPSCompass
      Left = 192
      Top = 216
      Width = 61
      Height = 61
      GPS = GPS1
      CardFont.Charset = DEFAULT_CHARSET
      CardFont.Color = clRed
      CardFont.Height = -12
      CardFont.Name = 'Tahoma'
      CardFont.Style = [fsBold]
      Pen.Color = 13408614
      Pen.Width = 2
      Brush.Color = 16764057
      BackgroundColor = clBtnFace
    end
    object LBL_Port: TLabel
      Left = 8
      Top = 4
      Width = 93
      Height = 21
      AutoSize = False
      Caption = '&Port '#224' utiliser'#160':'
      FocusControl = CCMB_Port
      Layout = tlCenter
    end
    object BTN_DemarrerGPS: TSpeedButton
      Left = 112
      Top = 192
      Width = 141
      Height = 21
      AllowAllUp = True
      GroupIndex = 1
      Caption = '&D'#233'marrer le GPS'
      OnClick = BTN_DemarrerGPSClick
    end
    object LBL_Latitude: TLabel
      Left = 12
      Top = 220
      Width = 46
      Height = 13
      Caption = 'Latitude'#160':'
    end
    object LBL_Longitude: TLabel
      Left = 12
      Top = 236
      Width = 54
      Height = 13
      Caption = 'Longitude'#160':'
    end
    object LBL_Altitude: TLabel
      Left = 12
      Top = 252
      Width = 44
      Height = 13
      Caption = 'Altitude'#160':'
    end
    object CCMB_Port: TComComboBox
      Left = 104
      Top = 4
      Width = 153
      Height = 21
      ComProperty = cpPort
      Text = 'COM1'
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      OnChange = CCMB_PortChange
    end
    object CHK_Valide: TCheckBox
      Left = 12
      Top = 268
      Width = 237
      Height = 17
      Caption = 'Position valide'
      TabOrder = 1
      OnClick = CHK_ValideClick
    end
  end
  object CHK_Satellite: TCheckBox
    Left = 8
    Top = 8
    Width = 81
    Height = 17
    Caption = 'Vue &satellite'
    TabOrder = 1
    OnClick = CHK_SatelliteClick
  end
  object TB_Zoom: TTrackBar
    Left = 404
    Top = 4
    Width = 25
    Height = 453
    Cursor = crVSplit
    Anchors = [akTop, akRight, akBottom]
    Max = 22
    Min = 1
    Orientation = trVertical
    Position = 15
    TabOrder = 2
    TickMarks = tmTopLeft
    OnChange = TB_ZoomChange
  end
  object GPS1: TGPS
    BaudRate = br9600
    DataBits = dbEight
    StopBits = sbOneStopBit
    Parity.Bits = prNone
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    OnGPSDatasChange = GPS1GPSDatasChange
    Left = 456
    Top = 296
  end
  object HTTP_BingMaps: TIdHTTP
    MaxLineAction = maException
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 456
    Top = 344
  end
  object XPManifest1: TXPManifest
    Left = 456
    Top = 392
  end
  object TIM_BingMaps: TTimer
    Enabled = False
    OnTimer = TIM_BingMapsTimer
    Left = 32
    Top = 32
  end
end
