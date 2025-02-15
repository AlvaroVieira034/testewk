unit ucadproduto;

interface

{$REGION 'Uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCadastroPadrao, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  conexao, produto.model, produto.controller, produto.repository, produto.service;

{$ENDREGION}

type
  TOperacao = (opInicio, opNovo, opEditar, opNavegar);
  TFrmCadProduto = class(TFrmCadastroPadrao)

    PnlPesquisar: TPanel;
    Label4: TLabel;
    BtnPesquisar: TSpeedButton;
    EdtPesquisar: TEdit;
    CbxFiltro: TComboBox;
    DBGridProdutos: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    EdtPrecoUnitario: TEdit;
    EdtCodProduto: TEdit;
    EdtDescricao: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure DBGridProdutosDblClick(Sender: TObject);
    procedure DBGridProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridProdutosCellClick(Column: TColumn);
    procedure BtnSairClick(Sender: TObject);
    procedure EdtPrecoUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPrecoUnitarioExit(Sender: TObject);
    procedure PnlPesquisarClick(Sender: TObject);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtPesquisarChange(Sender: TObject);
  private
    ValoresOriginais: array of string;
    FProduto: TProduto;
    FProdutoController: TProdutoController;

    procedure PreencherGridProdutos;
    procedure PreencherCamposForm;
    procedure LimpaCamposForm(AOperacao: TOperacao);
    function GravarDados: Boolean;
    function ValidarDados: Boolean;
    procedure MostrarMensagemErro(AErro: TCampoInvalido);
    procedure VerificaBotoes(AOperacao: TOperacao);
    function GetDataSource: TDataSource;


  public
    FOperacao: TOperacao;
    DsProdutos: TDataSource;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  FrmCadProduto: TFrmCadProduto;
  sErro: string;

implementation

{$R *.dfm}

uses untFormat;

{ TFrmCadProduto }


constructor TFrmCadProduto.Create(AOwner: TComponent);
begin
  inherited;
  DsProdutos := TDataSource.Create(nil);
end;

destructor TFrmCadProduto.Destroy;
begin
  if Assigned(DsProdutos) then
    DsProdutos.Free;

  inherited Destroy;
end;

procedure TFrmCadProduto.FormCreate(Sender: TObject);
begin
  inherited;
  if TConexao.GetInstance.Connection.TestarConexao then
  begin
    FProduto := TProduto.Create;
    FProdutoController := TProdutoController.Create(TProdutoRepository.Create, TProdutoService.Create);
    GetDataSource();
    FOperacao := opInicio;
    SetLength(ValoresOriginais, 3);
  end
  else
  begin
    ShowMessage('N�o foi poss�vel conectar ao banco de dados!');
    Close;
  end;
end;

procedure TFrmCadProduto.FormShow(Sender: TObject);
begin
  inherited;
  PreencherGridProdutos();
  DsProdutos := FProdutoController.GetDataSource();
  VerificaBotoes(FOperacao);
  if EdtPesquisar.CanFocus then
    EdtPesquisar.SetFocus;
end;

procedure TFrmCadProduto.PreencherGridProdutos;
begin
  FProdutoController.PreencherGridProdutos(Trim(EdtPesquisar.Text) + '%', CbxFiltro.Text);
  LblTotRegistros.Caption := 'Produtos: ' + InttoStr(DBGridProdutos.DataSource.DataSet.RecordCount);
end;

procedure TFrmCadProduto.PnlPesquisarClick(Sender: TObject);
begin
  inherited;
  BtnPesquisar.Click;
end;

procedure TFrmCadProduto.PreencherCamposForm;
begin
  DsProdutos := FProdutoController.GetDataSource();
  FProdutoController.PreencherCamposForm(FProduto, DsProdutos.DataSet.FieldByName('COD_PRODUTO').AsInteger);
  with FProduto do
  begin
    EdtCodProduto.Text := IntToStr(Cod_Produto);
    EdtDescricao.Text := Des_Descricao;
    EdtPrecoUnitario.Text := FormatFloat('######0.00', Val_Preco);
  end;
  ValoresOriginais[0] := EdtCodProduto.Text;
  ValoresOriginais[1] := EdtDescricao.Text;
  ValoresOriginais[2] := EdtPrecoUnitario.Text;
  BtnPesquisar.Click;
end;

procedure TFrmCadProduto.LimpaCamposForm(AOperacao: TOperacao);
begin
  EdtCodProduto.Text := '';
  EdtDescricao.Text := '';
  EdtPrecoUnitario.Text := '0.00';
  GrbDados.Enabled := AOperacao in [opNovo, opEditar];
  DBGridProdutos.Enabled := AOperacao in [opInicio, opNavegar];
end;

function TFrmCadProduto.GravarDados: Boolean;
begin
  Result := False;
  if not ValidarDados then
    Exit;

  with FProduto do
  begin
    Des_Descricao := EdtDescricao.Text;
    Val_Preco := StrToFloat(
    StringReplace(StringReplace(EdtPrecoUnitario.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
  end;

  case FOperacao of
    opNovo:
    begin
      if FProdutoController.ExecutarTransacao(
        procedure
        begin
          FProdutoController.Inserir(FProduto, sErro);
        end, sErro) then
        MessageDlg('Produto inclu�do com sucesso!', mtInformation, [mbOk], 0)
      else
        raise Exception.Create(sErro);
    end;

    opEditar:
    begin
      if FProdutoController.ExecutarTransacao(
        procedure
        begin
          FProdutoController.Alterar(FProduto, StrToInt(EdtCodProduto.Text), sErro);
        end, sErro) then
        MessageDlg('Produto alterado com sucesso!', mtInformation, [mbOk], 0)
      else
        raise Exception.Create(sErro);
    end;
  end;

  Result := True;
  DsProdutos.DataSet.Refresh;
  FOperacao := opNavegar;
end;

function TFrmCadProduto.ValidarDados: Boolean;
var LErro: TCampoInvalido;
begin
  Result := FProdutoController.ValidarDados(EdtDescricao.Text, EdtPrecoUnitario.Text, LErro);
  if not Result then
  begin
    MostrarMensagemErro(LErro);
    Exit(False);
  end;

  Result := True;
end;

procedure TFrmCadProduto.MostrarMensagemErro(AErro: TCampoInvalido);
begin
  case AErro of
    ciDescricao:
    begin
      MessageDlg('A descri��o do produto deve ser informada!', mtInformation, [mbOK], 0);
      EdtDescricao.SetFocus;
    end;

    ciPreco, ciPrecoZero:
    begin
      MessageDlg('O pre�o unit�rio deve ser maior que 0!', mtInformation, [mbOK], 0);
      EdtPrecoUnitario.SetFocus;
    end;
  end;
end;

procedure TFrmCadProduto.VerificaBotoes(AOperacao: TOperacao);
begin
  BtnInserir.Enabled := AOperacao in [opInicio, opNavegar];
  BtnAlterar.Enabled := AOperacao = opNavegar;
  BtnExcluir.Enabled := AOperacao = opNavegar;
  BtnSair.Enabled := AOperacao in [opInicio, opNavegar];
  BtnGravar.Enabled := AOperacao in [opNovo, opEditar];
  BtnCancelar.Enabled := AOperacao in [opNovo, opEditar];
  GrbDados.Enabled := AOperacao in [opNovo, opEditar];
  DBGridProdutos.Enabled := AOperacao in [opInicio, opNavegar];
  PnlPesquisar.Enabled := AOperacao in [opInicio, opNavegar];
end;

function TFrmCadProduto.GetDataSource: TDataSource;
begin
  DBGridProdutos.DataSource := FProdutoController.GetDataSource();
end;

procedure TFrmCadProduto.BtnInserirClick(Sender: TObject);
begin
  inherited;
  FOperacao := opNovo;
  VerificaBotoes(FOperacao);
  LimpaCamposForm(FOperacao);
end;

procedure TFrmCadProduto.BtnAlterarClick(Sender: TObject);
begin
  inherited;
  FOperacao := opEditar;
  VerificaBotoes(FOperacao);
  EdtDescricao.SetFocus;
end;

procedure TFrmCadProduto.BtnExcluirClick(Sender: TObject);
begin
  inherited;
  if MessageDlg('Deseja realmente excluir o produto selecionado ?',mtConfirmation, [mbYes, mbNo],0) = IDYES then
  begin
    if FProdutoController.ExecutarTransacao(
      procedure
      begin
        FProdutoController.Excluir(DsProdutos.DataSet.FieldByName('COD_PRODUTO').AsInteger, sErro);
      end, sErro) then
      MessageDlg('Produto exclu�do com sucesso!', mtInformation, [mbOk], 0)
    else
      raise Exception.Create(sErro);

    DsProdutos.DataSet.Refresh;
  end;
end;

procedure TFrmCadProduto.BtnGravarClick(Sender: TObject);
begin
  inherited;
  if GravarDados() then
  begin
    FOperacao := opNavegar;
    VerificaBotoes(FOperacao);
    LimpaCamposForm(FOperacao);
  end;
end;

procedure TFrmCadProduto.BtnCancelarClick(Sender: TObject);
begin
  inherited;
  if FOperacao = opNovo then
  begin
    FOperacao := opInicio;
    LimpaCamposForm(FOperacao);
  end;

  if FOperacao = opEditar then
  begin
    FOperacao := opNavegar;
    EdtCodProduto.Text := ValoresOriginais[0];
    EdtDescricao.Text := ValoresOriginais[1];
    EdtPrecoUnitario.Text := ValoresOriginais[2];
  end;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadProduto.DBGridProdutosDblClick(Sender: TObject);
begin
  inherited;
  FOperacao := opNavegar;
  PreencherCamposForm;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadProduto.DBGridProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    PreencherCamposForm();
    VerificaBotoes(FOperacao);
    FOperacao := opEditar;
    BtnAlterar.Click;
    EdtDescricao.SetFocus;
    Key := 0;
  end;
end;

procedure TFrmCadProduto.DBGridProdutosCellClick(Column: TColumn);
begin
  inherited;
  FOperacao := opNavegar;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadProduto.EdtPesquisarChange(Sender: TObject);
begin
  inherited;
  PreencherGridProdutos();
end;

procedure TFrmCadProduto.BtnPesquisarClick(Sender: TObject);
begin
  inherited;
  PreencherGridProdutos();
end;

procedure TFrmCadProduto.EdtPrecoUnitarioExit(Sender: TObject);
var LValor: Double;
begin
  inherited;
  if TryStrToFloat(EdtPrecoUnitario.Text, LValor) then
    EdtPrecoUnitario.Text := FormatFloat('#,###,##0.00', LValor)

end;

procedure TFrmCadProduto.EdtPrecoUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not (key in ['0'..'9', ',', #08]) then
    key := #0;

end;

procedure TFrmCadProduto.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    perform(WM_NEXTDLGCTL,0,0)
end;


procedure TFrmCadProduto.BtnSairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
