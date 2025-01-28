unit upesqvendas;

interface

{$REGION 'Uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, venda.model,
  venda.controller, venda.repository, ivenda.repository, venda.service, ivenda.service,
  FireDAC.Comp.Client, Vcl.Buttons, Vcl.ExtCtrls;

{$ENDREGION}

type
  TFrmPesquisaVendas = class(TForm)
    GroupBox1: TGroupBox;
    DbGridPedidos: TDBGrid;
    PnlPesquisar: TPanel;
    Label4: TLabel;
    BtnPesquisar: TSpeedButton;
    EdtPesquisar: TEdit;
    CbxFiltro: TComboBox;
    BtnSelecionar: TSpeedButton;
    BtnSair: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure DbGridPedidosDblClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnSelecionarClick(Sender: TObject);
    procedure CbxFiltroClick(Sender: TObject);
    procedure DbGridPedidosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    TblVendas: TFDQuery;
    DsVendas: TDataSource;
    FVenda: TVenda;
    VendaController: TVendaController;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PreencherGrid(TblVendas: TFDQuery; APesquisa, ACampo: string);
    procedure CriarTabelas;
    procedure CriarCamposTabelas;

  end;

var
  FrmPesquisaVendas: TFrmPesquisaVendas;

implementation

{$R *.dfm}

uses conexao.service, ucadvenda;

constructor TFrmPesquisaVendas.Create(AOwner: TComponent);
begin
  inherited;
  DsVendas := TDataSource.Create(nil);
  TblVendas := TFDQuery.Create(nil);
end;

destructor TFrmPesquisaVendas.Destroy;
begin
  DsVendas.Free;
  TblVendas.Free;
  FVenda.Free;
  VendaController.Free;
  inherited;
end;

procedure TFrmPesquisaVendas.FormCreate(Sender: TObject);
var sCampo: string;
begin
  inherited;
  if TConexao.GetInstance.Connection.TestarConexao then
  begin
    CriarTabelas();
    CriarCamposTabelas();
    sCampo := 'vda.dta_venda';
    FVenda := TVenda.Create;
    VendaController := TVendaController.Create(TVendaRepository.Create, TVendaService.Create);
  end
  else
  begin
    ShowMessage('Não foi possível conectar ao banco de dados!');
    Close;
  end;
end;

procedure TFrmPesquisaVendas.FormShow(Sender: TObject);
begin
  DbGridPedidos.Columns[0].Width := 105;
  DbGridPedidos.Columns[1].Width := 105;
  DbGridPedidos.Columns[2].Width := 435;
  DbGridPedidos.Columns[3].Width := 110;
  PreencherGrid(TblVendas, Trim(EdtPesquisar.Text) + '%', CbxFiltro.Text);
end;

procedure TFrmPesquisaVendas.DbGridPedidosDblClick(Sender: TObject);
begin
  FrmCadVenda.codigoVenda := DsVendas.DataSet.FieldByName('COD_VENDA').AsInteger;
  FrmCadVenda.pesqVenda := True;
  FrmCadVenda.FOperacao := opNavegar;
  BtnSair.Click;
end;

procedure TFrmPesquisaVendas.DbGridPedidosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    FrmCadVenda.codigoVenda := DsVendas.DataSet.FieldByName('COD_VENDA').AsInteger;
    FrmCadVenda.pesqVenda := True;
    FrmCadVenda.FOperacao := opEditar;
    BtnSair.Click;
    Key := 0;
  end;
end;

procedure TFrmPesquisaVendas.CbxFiltroClick(Sender: TObject);
begin
  BtnPesquisar.Click;
end;

procedure TFrmPesquisaVendas.BtnPesquisarClick(Sender: TObject);
begin
  PreencherGrid(TblVendas, Trim(EdtPesquisar.Text) + '%', CbxFiltro.Text)
end;

procedure TFrmPesquisaVendas.PreencherGrid(TblVendas: TFDQuery; APesquisa, ACampo: string);
begin
  VendaController.PreencherGrid(TblVendas, APesquisa + '%', ACampo);
end;

procedure TFrmPesquisaVendas.CriarTabelas;
begin
  TblVendas := TConexao.GetInstance.Connection.CriarQuery;
  DsVendas := TConexao.GetInstance.Connection.CriarDataSource;
  DsVendas.DataSet := TblVendas;
  DbGridPedidos.DataSource := DsVendas;
end;

procedure TFrmPesquisaVendas.CriarCamposTabelas;
var
  FloatField: TFloatField;
  StringField: TStringField;
  DateField: TDateField;
  IntegerField: TIntegerField;
begin
  // Criando o campo COD_VENDA
  IntegerField := TIntegerField.Create(TblVendas);
  IntegerField.FieldName := 'COD_VENDA';
  IntegerField.DataSet := TblVendas;
  IntegerField.Name := 'TblVendasCOD_VENDA';

  // Criando o campo DTA_VENDA
  DateField := TDateField.Create(TblVendas);
  DateField.FieldName := 'DTA_VENDA';
  DateField.DataSet := TblVendas;
  DateField.Name := 'TblVendasDTA_VENDA';
  DateField.DisplayFormat := 'dd/mm/yyyy';

  // Criando o campo NOME_CLIENTE
  StringField := TStringField.Create(TblVendas);
  StringField.FieldName := 'NOMECLIENTE';
  StringField.Size := 100;
  StringField.DataSet := TblVendas;
  StringField.Name := 'TblVendasNOMECLIENTE';

  // Criando o campo VAL_PRECO
  FloatField := TFloatField.Create(TblVendas);
  FloatField.FieldName := 'VAL_VENDA';
  FloatField.DataSet := TblVendas;
  FloatField.Name := 'TblVendasVAL_VENDA';
  FloatField.DisplayFormat := '#,###,##0.00';
end;

procedure TFrmPesquisaVendas.BtnSelecionarClick(Sender: TObject);
begin
  FrmCadVenda.codigoVenda := DsVendas.DataSet.FieldByName('COD_VENDA').AsInteger;
  FrmCadVenda.pesqVenda := True;
  FrmCadVenda.FOperacao := opNavegar;
  BtnSair.Click;
end;

procedure TFrmPesquisaVendas.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
