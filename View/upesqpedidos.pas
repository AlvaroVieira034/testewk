unit upesqpedidos;

interface

{$REGION 'Uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, pedido.model,
  pedido.controller, pedido.repository, iPedido.repository, pedido.service, ipedido.service,
  FireDAC.Comp.Client, Vcl.Buttons, Vcl.ExtCtrls;

{$ENDREGION}

type
  TFrmPesquisaPedidos = class(TForm)
    PnlPesquisar: TPanel;
    Label4: TLabel;
    BtnPesquisar: TSpeedButton;
    BtnSelecionar: TSpeedButton;
    BtnSair: TSpeedButton;
    EdtPesquisar: TEdit;
    CbxFiltro: TComboBox;
    GroupBox1: TGroupBox;
    DbGridPedidos: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DbGridPedidosDblClick(Sender: TObject);
    procedure DbGridPedidosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CbxFiltroClick(Sender: TObject);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure BtnSelecionarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);

  private
    TblPedidos: TFDQuery;
    DsPedidos: TDataSource;
    FPedido: TPedido;
    PedidoController: TPedidoController;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PreencherGrid(TblPedidos: TFDQuery; APesquisa, ACampo: string);
    procedure CriarTabelas;
    procedure CriarCamposTabelas;
  end;

var
  FrmPesquisaPedidos: TFrmPesquisaPedidos;

implementation

{$R *.dfm}

uses conexao, ucadpedido;

{ TFrmPesqPedidos }

constructor TFrmPesquisaPedidos.Create(AOwner: TComponent);
begin
  inherited;
  DsPedidos := TDataSource.Create(nil);
  TblPedidos := TFDQuery.Create(nil);
end;

destructor TFrmPesquisaPedidos.Destroy;
begin
  DsPedidos.Free;
  TblPedidos.Free;
  FPedido.Free;
  PedidoController.Free;
  inherited;
end;

procedure TFrmPesquisaPedidos.FormCreate(Sender: TObject);
var sCampo: string;
begin
  inherited;
  if TConexao.GetInstance.Connection.TestarConexao then
  begin
    CriarTabelas();
    CriarCamposTabelas();
    sCampo := 'vda.dta_Pedido';
    FPedido := TPedido.Create;
    PedidoController := TPedidoController.Create(TPedidoRepository.Create, TPedidoService.Create);
  end
  else
  begin
    ShowMessage('Não foi possível conectar ao banco de dados!');
    Close;
  end;
end;

procedure TFrmPesquisaPedidos.FormShow(Sender: TObject);
begin
  DbGridPedidos.Columns[0].Width := 90;
  DbGridPedidos.Columns[1].Width := 90;
  DbGridPedidos.Columns[2].Width := 325;
  DbGridPedidos.Columns[3].Width := 110;
  PreencherGrid(TblPedidos, Trim(EdtPesquisar.Text) + '%', CbxFiltro.Text);
end;

procedure TFrmPesquisaPedidos.PreencherGrid(TblPedidos: TFDQuery; APesquisa, ACampo: string);
begin
  PedidoController.PreencherGrid(TblPedidos, APesquisa + '%', ACampo);
end;

procedure TFrmPesquisaPedidos.CriarTabelas;
begin
  TblPedidos := TConexao.GetInstance.Connection.CriarQuery;
  DsPedidos := TConexao.GetInstance.Connection.CriarDataSource;
  DsPedidos.DataSet := TblPedidos;
  DbGridPedidos.DataSource := DsPedidos;
end;

procedure TFrmPesquisaPedidos.CriarCamposTabelas;
var
  FloatField: TFloatField;
  StringField: TStringField;
  DateField: TDateField;
  IntegerField: TIntegerField;
begin
  // Criando o campo COD_Pedido
  IntegerField := TIntegerField.Create(TblPedidos);
  IntegerField.FieldName := 'COD_Pedido';
  IntegerField.DataSet := TblPedidos;
  IntegerField.Name := 'TblPedidosCOD_Pedido';

  // Criando o campo DTA_Pedido
  DateField := TDateField.Create(TblPedidos);
  DateField.FieldName := 'DTA_Pedido';
  DateField.DataSet := TblPedidos;
  DateField.Name := 'TblPedidosDTA_Pedido';
  DateField.DisplayFormat := 'dd/mm/yyyy';

  // Criando o campo NOME_CLIENTE
  StringField := TStringField.Create(TblPedidos);
  StringField.FieldName := 'NOMECLIENTE';
  StringField.Size := 100;
  StringField.DataSet := TblPedidos;
  StringField.Name := 'TblPedidosNOMECLIENTE';

  // Criando o campo VAL_PRECO
  FloatField := TFloatField.Create(TblPedidos);
  FloatField.FieldName := 'VAL_Pedido';
  FloatField.DataSet := TblPedidos;
  FloatField.Name := 'TblPedidosVAL_Pedido';
  FloatField.DisplayFormat := '#,###,##0.00';

end;

procedure TFrmPesquisaPedidos.DbGridPedidosDblClick(Sender: TObject);
begin
  FrmCadPedido.codigoPedido := DsPedidos.DataSet.FieldByName('COD_Pedido').AsInteger;
  FrmCadPedido.pesqPedido := True;
  FrmCadPedido.FOperacao := opNavegar;
  BtnSair.Click;
end;

procedure TFrmPesquisaPedidos.DbGridPedidosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    FrmCadPedido.codigoPedido := DsPedidos.DataSet.FieldByName('COD_Pedido').AsInteger;
    FrmCadPedido.pesqPedido := True;
    FrmCadPedido.FOperacao := opEditar;
    BtnSair.Click;
    Key := 0;
  end;
end;

procedure TFrmPesquisaPedidos.CbxFiltroClick(Sender: TObject);
begin
  BtnPesquisar.Click;
end;

procedure TFrmPesquisaPedidos.BtnSelecionarClick(Sender: TObject);
begin
  FrmCadPedido.codigoPedido := DsPedidos.DataSet.FieldByName('COD_Pedido').AsInteger;
  FrmCadPedido.pesqPedido := True;
  FrmCadPedido.FOperacao := opNavegar;
  BtnSair.Click;
end;

procedure TFrmPesquisaPedidos.BtnPesquisarClick(Sender: TObject);
begin
  PreencherGrid(TblPedidos, Trim(EdtPesquisar.Text) + '%', CbxFiltro.Text)
end;

procedure TFrmPesquisaPedidos.BtnSairClick(Sender: TObject);
begin
  Close;
end;








end.
