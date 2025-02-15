inherited FrmCadProduto: TFrmCadProduto
  BorderIcons = [biSystemMenu]
  Caption = 'Cadastro de Produtos'
  ClientHeight = 489
  ClientWidth = 710
  KeyPreview = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  ExplicitWidth = 726
  ExplicitHeight = 528
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTopo: TPanel
    Width = 710
    ExplicitLeft = -1
    ExplicitWidth = 710
    inherited BtnInserir: TSpeedButton
      Left = 7
      OnClick = BtnInserirClick
      ExplicitLeft = 7
    end
    inherited BtnAlterar: TSpeedButton
      Left = 123
      OnClick = BtnAlterarClick
      ExplicitLeft = 123
    end
    inherited BtnExcluir: TSpeedButton
      Left = 239
      OnClick = BtnExcluirClick
      ExplicitLeft = 239
    end
    inherited BtnGravar: TSpeedButton
      Left = 354
      OnClick = BtnGravarClick
      ExplicitLeft = 354
    end
    inherited BtnCancelar: TSpeedButton
      Left = 469
      OnClick = BtnCancelarClick
      ExplicitLeft = 469
    end
    inherited BtnSair: TSpeedButton
      Left = 584
      OnClick = BtnSairClick
      ExplicitLeft = 584
    end
  end
  inherited PnlDados: TPanel
    Left = 0
    Top = 65
    Width = 710
    Height = 145
    Align = alTop
    ExplicitLeft = 0
    ExplicitTop = 65
    ExplicitWidth = 684
    ExplicitHeight = 145
    inherited GrbDados: TGroupBox
      Left = 7
      Top = 6
      Width = 693
      Height = 130
      Anchors = [akLeft, akTop, akRight]
      Caption = ' Dados do  Produto '
      ExplicitLeft = 7
      ExplicitTop = 6
      ExplicitWidth = 693
      ExplicitHeight = 130
      object Label1: TLabel
        Left = 69
        Top = 33
        Width = 37
        Height = 13
        Caption = '&C'#243'digo:'
      end
      object Label2: TLabel
        Left = 35
        Top = 92
        Width = 71
        Height = 13
        Caption = '&Pre'#231'o Unit'#225'rio:'
      end
      object Label6: TLabel
        Left = 56
        Top = 60
        Width = 50
        Height = 13
        Caption = '&Descri'#231#227'o:'
      end
      object EdtPrecoUnitario: TEdit
        Left = 115
        Top = 85
        Width = 76
        Height = 21
        Alignment = taRightJustify
        CharCase = ecUpperCase
        MaxLength = 12
        TabOrder = 2
        Text = '0.00'
        OnExit = EdtPrecoUnitarioExit
        OnKeyPress = EdtPrecoUnitarioKeyPress
      end
      object EdtCodProduto: TEdit
        Left = 115
        Top = 29
        Width = 76
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object EdtDescricao: TEdit
        Left = 115
        Top = 57
        Width = 331
        Height = 21
        CharCase = ecUpperCase
        MaxLength = 100
        TabOrder = 1
      end
    end
  end
  inherited PnlGrid: TPanel
    Left = 0
    Top = 210
    Width = 710
    Height = 242
    Align = alClient
    ExplicitWidth = 761
    ExplicitHeight = 225
    inherited LblTotRegistros: TLabel
      Left = 612
      Top = 222
      Anchors = [akRight, akBottom]
      ExplicitLeft = 754
      ExplicitTop = 238
    end
    inherited GrbGrid: TGroupBox
      Left = 7
      Width = 693
      Height = 208
      Anchors = [akLeft, akTop, akRight]
      Caption = ' Produtos cadastrados '
      ExplicitLeft = 7
      ExplicitWidth = 667
      ExplicitHeight = 208
      object DBGridProdutos: TDBGrid
        Left = 9
        Top = 19
        Width = 674
        Height = 178
        Anchors = [akLeft, akTop, akRight]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = DBGridProdutosCellClick
        OnDblClick = DBGridProdutosDblClick
        OnKeyDown = DBGridProdutosKeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'cod_produto'
            Title.Alignment = taCenter
            Title.Caption = 'C'#243'digo'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'des_descricao'
            Title.Caption = 'Descri'#231#227'o do Produto'
            Width = 292
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'val_preco'
            Title.Alignment = taCenter
            Title.Caption = 'Valor Unit'#225'rio'
            Width = 95
            Visible = True
          end>
      end
    end
  end
  object PnlPesquisar: TPanel
    Left = 0
    Top = 452
    Width = 710
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 3
    OnClick = PnlPesquisarClick
    ExplicitLeft = 1
    ExplicitTop = 230
    ExplicitWidth = 648
    DesignSize = (
      710
      37)
    object Label4: TLabel
      Left = 7
      Top = 11
      Width = 43
      Height = 11
      Caption = 'Filtrar por:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object BtnPesquisar: TSpeedButton
      Left = 618
      Top = 3
      Width = 86
      Height = 27
      Anchors = [akTop, akRight]
      Caption = '&Pesquisar'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFCCCCCCCCCCCCF5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCCCC497FAA4980ACB1BDC6CFCFCFCCCCCC
        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC407F
        AF1EAAFF5AC8FF4593C7BB8825B67E0EB57B09B67E0DB88113BB8211B6831B90
        7E5B7A7A7C7B79787B79788F816B72A1C558C8FFBAF2FF4193CCB67E0EFFFFFF
        FFFFFFFFFFFFB47800F0EEF481848DB6B9BEE4E8ECE2E5EAE4E6EAB8B7B7827A
        76CFE3ED3290D4FFFFFFB47B09FFFFFFFFFFFFFFFFFFC99A3B928267B9BBBFE8
        DDCEEEC57DF6D789FCE49AECE7D8BBBABC9B9084FFFFFFFFFFFFB47A07FFFFFF
        FFFFFFFFFFFFFFFFFF7B7A7CF0F3F8E7B572F0CF92F6DC94FFEFA4FBE499F0F2
        F8818288FFFFFFFFFFFFB47A08FFFFFFFFFFFFFFFFFFE1CAB07F7F81F5F9FEEB
        C696F5E1BEF3DAA0F6DB94F4D587F5F9FF868587FFFFFFFFFFFFB47B08FFFFFF
        D5BB9DDAC3A8B65A0084888CFEFFFFE3B076FAF2E4F4E1BDEFCE91ECC37CFEFF
        FF8A898BFFFFFFFFFFFFB47B08FFFFFFFFFFF7FFFFFFB65E06A9A39BCED2D5F6
        E3CFE2B074E9C494E5B571F8EBD7CFD1D79C8A67FFFFFFFFFFFFB47B09FFFFFF
        D6B892DBC1A1B5600ACBA2748F9093D3D7DCFFFFFFFFFFFFFFFFFFD1D3D79293
        9CB7821AFFFFFFFFFFFFB47B08FFFFFFFFFBE4FFFFF2B5600BE2B580D7AC7A9F
        8A7491959B9194988F9195B5B1ABFFFFFFB87E09FFFFFFFFFFFFB57B08FFFFFF
        DDB382E1BB8EB95D04BD6108BE6106BD6106C06003C06001BB5B00E2BA8BFFFF
        FFB67C09FFFFFFFFFFFFB57C09FFFFFF44C4FF46C8FFE5BB8649CEFF4ACFFFE7
        BD894ACFFF4ACEFFE5BA8542C7FFFFFFFFB67C09FFFFFFFFFFFFB67E0EFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFB67E0EFFFFFFFFFFFFBD8C27B67E0EB67C09B67B08B57B08B67B08B67B08B5
        7B08B67B08B67B08B57B08B67C09B67E0EBD8C27FFFFFFFFFFFF}
      OnClick = BtnPesquisarClick
      ExplicitLeft = 556
    end
    object EdtPesquisar: TEdit
      Left = 142
      Top = 6
      Width = 471
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      CharCase = ecUpperCase
      TabOrder = 1
      OnChange = EdtPesquisarChange
      ExplicitWidth = 409
    end
    object CbxFiltro: TComboBox
      Left = 55
      Top = 6
      Width = 84
      Height = 21
      TabOrder = 0
      Text = 'Descri'#231#227'o'
      Items.Strings = (
        'C'#243'digo'
        'Descri'#231#227'o')
    end
  end
end
