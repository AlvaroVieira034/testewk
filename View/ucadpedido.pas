unit ucadpedido;

interface

{$REGION 'Uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.Dialogs, UCadastroPadrao, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.Controls, conexao, produto.model, produto.controller, produto.repository, produto.service,
  cliente.model, cliente.controller, pedido.model, pedidoitens.model, pedido.controller, pedido.repository,
  ipedido.repository, pedido.service, ipedido.service, pedidoitens.controller, cliente.repository,
  iinterface.repository, cliente.service, iinterface.service, untFormat, upesqpedidos, System.Generics.Collections;

{$ENDREGION}

type
  TOperacao = (opInicio, opNovo, opEditar, opNavegar, opErro);
  TFrmCadPedido = class(TFrmCadastroPadrao)

{$REGION 'Componentes'}
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EdtCodPedido: TEdit;
    EdtDataPedido: TEdit;
    EdtTotalPedido: TEdit;
    EdtQuantidade: TEdit;
    EdtPrecoUnit: TEdit;
    EdtPrecoTotal: TEdit;
    LCbxProdutos: TDBLookupComboBox;
    BtnAddItemGrid: TButton;
    BtnDelItemGrid: TButton;
    DbGridItensPedido: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    BtnPesquisar: TSpeedButton;
    EdtCodCliente: TEdit;
    LcbxNomeCliente: TDBLookupComboBox;
    BtnInserirItens: TButton;
    BtnLimpaCampos: TSpeedButton;
    MTblPedidoItem: TFDMemTable;
    MTblPedidoItemID_PEDIDO: TIntegerField;
    MTblPedidoItemCOD_PEDIDO: TIntegerField;
    MTblPedidoItemCOD_PRODUTO: TIntegerField;
    MTblPedidoItemDES_DESCRICAO: TStringField;
    MTblPedidoItemVAL_QUANTIDADE: TIntegerField;
    MTblPedidoItemVAL_PRECOUNITARIO: TFloatField;
    MTblPedidoItemVAL_TOTALITEM: TFloatField;
    DsPedidoItem: TDataSource;

{$ENDREGION}

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure EdtCodClienteExit(Sender: TObject);
    procedure EdtCodClienteChange(Sender: TObject);
    procedure EdtCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnInserirItensClick(Sender: TObject);
    procedure BtnLimpaCamposClick(Sender: TObject);
    procedure BtnAddItemGridClick(Sender: TObject);
    procedure BtnDelItemGridClick(Sender: TObject);
    procedure LcbxNomeClienteClick(Sender: TObject);
    procedure EdtDataPedidoChange(Sender: TObject);
    procedure LCbxProdutosClick(Sender: TObject);
    procedure EdtQuantidadeExit(Sender: TObject);
    procedure EdtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPrecoUnitKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPrecoUnitExit(Sender: TObject);
    procedure EdtPrecoTotalKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPrecoTotalExit(Sender: TObject);
    procedure EdtCodPedidoKeyPress(Sender: TObject; var Key: Char);
    procedure DbGridItensPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    ValoresOriginais: array of string;
    TblProdutos: TFDQuery;
    TblClientes: TFDQuery;
    DsProdutos: TDataSource;
    DsClientes: TDataSource;
    FProdutoController: TProdutoController;
    FClienteController: TClienteController;
    FPedido: TPedido;
    FPedidoController: TPedidoController;
    FPedidoItens: TPedidoItens;
    FPedidoItensController: TPedidoItensController;
    TransacaoPedidos : TFDTransaction;

    procedure CarregarPedidos(ACodPedido: Integer);
    procedure InserirPedidoItens;
    function GravarDados: Boolean;
    procedure ExcluirPedidos;
    function ValidarDados(ATipoDados: string): Boolean;
    procedure LimpaCamposPedido;
    procedure LimpaCamposItens;
    procedure PreencheCdsPedidoItem;
    procedure VerificaBotoes(AOperacao: TOperacao);
    procedure HabilitarBotaoIncluirItens;

  public
    FOperacao: TOperacao;
    pesqPedido: Boolean;
    codigoPedido: Integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FrmCadPedido: TFrmCadPedido;
  totPedido, totPedidoAnt: Double;
  idItem: Integer;
  alterouGrid: Boolean;
  sErro: string;

implementation

{$R *.dfm}

{ TFrmCadPedido }

constructor TFrmCadPedido.Create(AOwner: TComponent);
begin
  inherited;
  TblProdutos := TFDQuery.Create(nil);
  TblClientes := TFDQuery.Create(nil);
  DsProdutos := TDataSource.Create(nil);
  DsClientes := TDataSource.Create(nil);
  TransacaoPedidos := TFDTransaction.Create(nil);
end;

procedure TFrmCadPedido.DbGridItensPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    LCbxProdutos.KeyValue := MTblPedidoItemCOD_PRODUTO.AsInteger;
    EdtQuantidade.Text := IntToStr(MTblPedidoItemVAL_QUANTIDADE.AsInteger);
    EdtPrecoUnit.Text := FloatToStr(MTblPedidoItemVAL_PRECOUNITARIO.AsFloat);
    EdtPrecoTotal.Text := FloatToStr(MTblPedidoItemVAL_TOTALITEM.AsFloat);
    alterouGrid := True;
    idItem := MTblPedidoItemID_Pedido.AsInteger;
    totPedidoAnt := MTblPedidoItemVAL_TOTALITEM.AsFloat;
    Key := 0;
  end;

  if Key = VK_DELETE then
  begin
   BtnDelItemGridClick(Sender);
  end;
end;

destructor TFrmCadPedido.Destroy;
begin
  TblProdutos.Free;
  TblClientes.Free;
  DsProdutos.Free;
  DsClientes.Free;
  TransacaoPedidos.Free;
  inherited Destroy;
end;

procedure TFrmCadPedido.FormCreate(Sender: TObject);
var sCampo: string;
begin
  inherited;
  if TConexao.GetInstance.Connection.TestarConexao then
  begin
    // Define Transacao pra Pedidos
    TConexao.GetInstance.Connection.InciarTransacao;
    TransacaoPedidos := TConexao.GetInstance.Connection.CriarTransaction;

    // Cria Tabelas
    TblProdutos := TConexao.GetInstance.Connection.CriarQuery;
    TblClientes := TConexao.GetInstance.Connection.CriarQuery;

    // Cria DataSource
    DsClientes := TConexao.GetInstance.Connection.CriarDataSource;
    DsProdutos := TConexao.GetInstance.Connection.CriarDataSource;

    // Atribui DataSet às tabelas
    DsClientes.DataSet := TblClientes;
    DsProdutos.DataSet := TblProdutos;

    //Instancias Classes
    FProdutoController := TProdutoController.Create(TProdutoRepository.Create, TProdutoService.Create);
    FClienteController := TClienteController.Create(TClienteRepository.Create, TClienteService.Create);
    FPedido := TPedido.Create;
    FPedidoController := TPedidoController.Create(TPedidoRepository.Create, TPedidoService.Create);
    FPedidoItens := TPedidoItens.Create;
    FPedidoItensController := TPedidoItensController.Create;

    // Variáveis locais
    sCampo := 'vda.dta_pedido';
    totPedido := 0;
    pesqPedido := False;
    SetLength(ValoresOriginais, 4);
    FOperacao := opInicio;
    MTblPedidoItem.CreateDataSet;

    // Define configuração DbLookupComboBox
    LcbxNomeCliente.KeyField := 'cod_cliente';
    LcbxNomeCliente.ListField := 'des_nomecliente';
    LcbxNomeCliente.ListSource := DsClientes;

    LCbxProdutos.KeyField := 'cod_produto';
    LCbxProdutos.ListField := 'des_descricao';
    LCbxProdutos.ListSource := DsProdutos;
  end
  else
  begin
    ShowMessage('Não foi possível conectar ao banco de dados!');
    Close;
  end;
end;

procedure TFrmCadPedido.FormShow(Sender: TObject);
begin
  inherited;
  totPedido := 0;
  FClienteController.PreencherComboClientes(TblClientes);
  FProdutoController.PreencherComboProdutos(TblProdutos);

  DbGridItensPedido.Columns[0].Width := 320;
  DbGridItensPedido.Columns[1].Width := 90;
  DbGridItensPedido.Columns[2].Width := 115;
  DbGridItensPedido.Columns[3].Width := 115;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadPedido.CarregarPedidos(ACodPedido: Integer);
var Item: TPedidoItens;
    ItensPedido: TList<TPedidoItens>;
begin
  MTblPedidoItem.Close;
  MTblPedidoItem.CreateDataSet;

  if ACodPedido > 0 then
    codigoPedido := ACodPedido;

  if not FPedidoController.CarregarCampos(FPedido, codigoPedido) then
  begin
    MessageDlg('Pedido não encontado!', mtInformation, [mbOK], 0);
    LimpaCamposPedido();
    EdtCodPedido.SetFocus;
    Exit;
  end;

  with FPedido do
  begin
    EdtCodPedido.Text := IntToStr(Cod_Pedido);
    EdtDataPedido.Text := DateToStr(Dta_Pedido);
    EdtCodCliente.Text := IntToStr(Cod_Cliente);
    EdtTotalPedido.Text := FormatFloat('######0.00', Val_Pedido);
  end;

  // Carregar os itens do Pedido usando a controller
  ItensPedido := FPedidoItensController.CarregarItensPedido(codigoPedido);
  try
    for Item in ItensPedido do
    begin
      MTblPedidoItem.Append;
      MTblPedidoItemID_PEDIDO.AsInteger := Item.Id_Pedido;
      MTblPedidoItemCOD_PEDIDO.AsInteger := Item.Cod_Pedido;
      MTblPedidoItemCOD_PRODUTO.AsInteger := Item.Cod_Produto;
      MTblPedidoItemDES_DESCRICAO.AsString := Item.Des_Descricao;
      MTblPedidoItemVAL_QUANTIDADE.AsInteger := Item.Val_Quantidade;
      MTblPedidoItemVAL_PRECOUNITARIO.AsFloat := Item.Val_PrecoUnitario;
      MTblPedidoItemVAL_TOTALITEM.AsFloat := Item.Val_TotalItem;
      MTblPedidoItem.Post;
    end;
  finally
    ItensPedido.Free;
  end;
end;

procedure TFrmCadPedido.InserirPedidoItens;
begin
  MTblPedidoItem.First;
  while not MTblPedidoItem.eof do
  begin
    with FPedidoItens do
    begin
      Cod_Pedido := FPedido.Cod_Pedido;
      Cod_Produto := MTblPedidoItemCOD_PRODUTO.AsInteger;
      Des_Descricao := MTblPedidoItemDES_DESCRICAO.AsString;
      Val_PrecoUnitario := MTblPedidoItemVAL_PRECOUNITARIO.AsFloat;
      Val_Quantidade := MTblPedidoItemVAL_QUANTIDADE.AsInteger;
      Val_TotalItem := MTblPedidoItemVAL_TOTALITEM.AsFloat;

      if FPedidoItensController.Inserir(FPedidoItens, sErro) = false then
        raise Exception.Create(sErro);
    end;
    MTblPedidoItem.Next;
  end;
end;

function TFrmCadPedido.GravarDados: Boolean;
begin
  Result := False;
  if not ValidarDados('Pedido') then
    Exit;

  if MTblPedidoItem.RecordCount = 0 then
  begin
    MessageDlg('Não existe itens cadastrados para o pedido!', mtWarning, [mbOK],0);
    BtnInserirItens.SetFocus;
    Exit;
  end;

  // Preenche Objeto
  with FPedido do
  begin
    Dta_Pedido := StrToDate(EdtDataPedido.Text);
    Cod_Cliente := StrToInt(EdtCodCliente.Text);
    Val_Pedido := StrToFloat(
    StringReplace(StringReplace(EdtTotalPedido.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
  end;

  if not TransacaoPedidos.Connection.Connected then
    TransacaoPedidos.Connection.Open();

  case FOperacao of
    opNovo:
    begin
      TransacaoPedidos.StartTransaction;
      try
        FPedidoController.Inserir(FPedido, TransacaoPedidos, sErro);
        InserirPedidoItens();
        TransacaoPedidos.Commit;
        codigoPedido := FPedido.Cod_Pedido;
        EdtCodPedido.Text := IntToStr(codigoPedido);
        MessageDlg('Pedido inserido com sucesso!', mtInformation, [mbOK],0);
        Result := True;
      except
        on E: Exception do
        begin
          TransacaoPedidos.Rollback;
          LimpaCamposItens();
          LimpaCamposPedido();
          MTblPedidoItem.Close;
          BtnInserirItens.Enabled := False;
          FOperacao := opErro;
          VerificaBotoes(FOperacao);
          raise Exception.Create(sErro + #13 + E.Message);
        end;
      end;
    end;

    opEditar:
    begin
      TransacaoPedidos.StartTransaction;
      try
        // deleta todos os itens do Pedido
        FPedidoItensController.Excluir(StrToInt(EdtCodPedido.Text),  sErro);

        // Insere todos os itens contidos no grid
        InserirPedidoItens();

        // ALtera os dados do Pedido
        FPedidoController.Alterar(FPedido, StrToInt(EdtCodPedido.Text), sErro);

        MessageDlg('Pedido alterado com sucesso!', mtInformation, [mbOk], 0);
        TransacaoPedidos.Commit;
        EdtCodPedido.Text := IntToStr(codigoPedido);
        Result := True;
      except
        on E: Exception do
        begin
          TransacaoPedidos.Rollback;
          LimpaCamposItens();
          LimpaCamposPedido();
          MTblPedidoItem.Close;
          BtnInserirItens.Enabled := False;
          FOperacao := opErro;
          VerificaBotoes(FOperacao);
          raise Exception.Create(sErro + #13 + E.Message);
        end;
       end;
    end;
  end;

  if TransacaoPedidos.Connection.Connected then
    TransacaoPedidos.Connection.Close;
end;

procedure TFrmCadPedido.ExcluirPedidos;
var sErro: string;
begin
  if MessageDlg('Deseja realmente excluir o pedido selecionado ?',mtConfirmation, [mbYes, mbNo],0) = IDYES then
  begin
    if FPedidoController.ExecutarTransacao(
      procedure
      begin
        FPedidoItensController.Excluir(StrToInt(EdtCodPedido.Text), sErro);
        FPedidoController.Excluir(StrToInt(EdtCodPedido.Text), sErro)
      end, sErro) then
      MessageDlg('Pedido excluído com sucesso!', mtInformation, [mbOk], 0)
    else
      raise Exception.Create(sErro);
  end;
end;

function TFrmCadPedido.ValidarDados(ATipoDados: string): Boolean;
var AErro: TCampoInvalido;
    LPrecoUnitario, LPrecoTotal: Double;
begin
  Result := False;
  if ATipoDados = 'Pedido' then
  begin
    if EdtDataPedido.Text = EmptyStr then
    begin
      MessageDlg('A data do pedido deve ser preenchida!', mtInformation, [mbOK], 0);
      EdtDataPedido.SetFocus;
      Exit;
    end;

    if EdtCodCliente.Text = EmptyStr then
    begin
      MessageDlg('O código do cliente deve ser preenchido!', mtInformation, [mbOK], 0);
      EdtCodCliente.SetFocus;
      Exit;
    end;
  end;

  if ATipoDados = 'Item' then
  begin
    if LCbxProdutos.KeyValue = Null then
    begin
      MessageDlg('O produto precisa ser informado!', mtInformation, [mbOK], 0);
      LCbxProdutos.SetFocus;
      Exit;
    end;

    if EdtQuantidade.Text = '' then
    begin
      MessageDlg('A quantidade deve ser preenchida!', mtInformation, [mbOK], 0);
      EdtQuantidade.SetFocus;
      Exit;
    end;

    if StrToFloat(EdtQuantidade.Text) = 0 then
    begin
      MessageDlg('A quantidade não pode ser igual a 0!', mtInformation, [mbOK], 0);
      EdtQuantidade.SetFocus;
      Exit;
    end;

    if EdtPrecoUnit.Text = '' then
    begin
      MessageDlg('o preço unitário deve ser preenchido!', mtInformation, [mbOK], 0);
      EdtPrecoUnit.SetFocus;
      Exit;
    end;

    LPrecoUnitario := StrToFloat(
    StringReplace(StringReplace(EdtPrecoUnit.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));

    if LPrecoUnitario = 0 then
    begin
      MessageDlg('O preço unitário não pode ser igual a 0!', mtInformation, [mbOK], 0);
      EdtPrecoUnit.SetFocus;
      Exit;
    end;

    if EdtPrecoTotal.Text = '' then
    begin
      MessageDlg('o preço total deve ser preenchido!', mtInformation, [mbOK], 0);
      EdtPrecoTotal.SetFocus;
      Exit;
    end;

    LPrecoTotal := StrToFloat(
    StringReplace(StringReplace(EdtPrecoTotal.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));

    if LPrecoTotal = 0 then
    begin
      MessageDlg('O preço total não pode ser igual a 0!', mtInformation, [mbOK], 0);
      EdtPrecoTotal.SetFocus;
      Exit;
    end;
  end;
  Result := True;
end;

procedure TFrmCadPedido.LimpaCamposPedido;
begin
  EdtCodPedido.Text := EmptyStr;
  EdtDataPedido.Text := EmptyStr;
  EdtCodCliente.Text := EmptyStr;
  LcbxNomeCliente.KeyValue := 0;
  EdtTotalPedido.Text := '0.00';
end;

procedure TFrmCadPedido.LimpaCamposItens;
begin
  LCbxProdutos.KeyValue := 0;
  EdtQuantidade.Text := EmptyStr;
  EdtPrecoUnit.Text := EmptyStr;
  EdtPrecoTotal.Text := EmptyStr;
end;

procedure TFrmCadPedido.PreencheCdsPedidoItem;
begin
  if not MTblPedidoItem.Active then
    MTblPedidoItem.Open;

  if alterouGrid then
  begin
    with MTblPedidoItem do
    begin
      totPedido := totPedido - totPedidoAnt;
      MTblPedidoItem.Locate('ID_Pedido', idItem, []);
      MTblPedidoItem.Edit;
      try
        MTblPedidoItemCOD_PRODUTO.AsInteger := LCbxProdutos.KeyValue;
        MTblPedidoItemDES_DESCRICAO.AsString := LCbxProdutos.Text;
        MTblPedidoItemVAL_QUANTIDADE.AsInteger := StrToInt(EdtQuantidade.Text);
        MTblPedidoItemVAL_PRECOUNITARIO.AsFloat := StrToFloat(StringReplace(StringReplace(EdtPrecoUnit.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
        MTblPedidoItemVAL_TOTALITEM.AsFloat := StrToFloat(StringReplace(StringReplace(EdtPrecoTotal.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
        MTblPedidoItem.Post;
        totPedido := totPedido + MTblPedidoItemVAL_TOTALITEM.AsFloat;
        EdtTotalPedido.Text := FormatFloat('######0.00', totPedido);
      except
        MTblPedidoItem.Cancel;
        raise;
      end;
    end;
  end
  else
  begin
    with MTblPedidoItem do
    begin
      MTblPedidoItem.Append;
      try
        MTblPedidoItemCOD_PRODUTO.AsInteger := LCbxProdutos.KeyValue;
        MTblPedidoItemDES_DESCRICAO.AsString := LCbxProdutos.Text;
        MTblPedidoItemVAL_QUANTIDADE.AsInteger := StrToInt(EdtQuantidade.Text);
        MTblPedidoItemVAL_PRECOUNITARIO.AsFloat := StrToFloat(StringReplace(StringReplace(EdtPrecoUnit.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
        MTblPedidoItemVAL_TOTALITEM.AsFloat := StrToFloat(StringReplace(StringReplace(EdtPrecoTotal.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
        MTblPedidoItem.Post;
        totPedido := totPedido + MTblPedidoItemVAL_TOTALITEM.AsFloat;
        EdtTotalPedido.Text := FormatFloat('######0.00', totPedido);
      except
        MTblPedidoItem.Cancel;
        raise;
      end;
    end;
  end;
end;

procedure TFrmCadPedido.VerificaBotoes(AOperacao: TOperacao);
begin
  BtnInserir.Enabled := AOperacao in [opInicio, opNavegar];
  BtnAlterar.Enabled := AOperacao = opNavegar;
  BtnExcluir.Enabled := AOperacao = opNavegar;
  BtnSair.Enabled := AOperacao in [opInicio, opNavegar, opErro];

  BtnGravar.Enabled := AOperacao in [opNovo, opEditar];
  BtnCancelar.Enabled := AOperacao in [opNovo, opEditar];

  BtnPesquisar.Enabled := AOperacao in [opInicio, opNavegar];
  BtnLimpaCampos.Enabled := EdtCodPedido.Enabled;

  EdtCodPedido.Enabled := AOperacao in [opInicio, opNavegar];
  EdtDataPedido.Enabled := AOperacao in [opNovo, opEditar];
  EdtCodCliente.Enabled := AOperacao in [opNovo, opEditar];
  LcbxNomeCliente.Enabled := AOperacao in [opNovo, opEditar];
  GrbGrid.Enabled := AOperacao in [opNovo, opEditar];
end;

procedure TFrmCadPedido.HabilitarBotaoIncluirItens;
begin
  if (FOperacao = opNovo) then
    BtnInserirItens.Enabled := (EdtDataPedido.Text <> '') and (EdtCodCliente.Text <> '');
end;

procedure TFrmCadPedido.BtnInserirClick(Sender: TObject);
begin
  inherited;
  MTblPedidoItem.Active := False;
  GrbDados.Enabled := True;
  FOperacao := opNovo;
  VerificaBotoes(opNovo);
  LimpaCamposPedido();
  EdtDataPedido.Text := DateToStr(Date);
  EdtDataPedido.SetFocus;
end;

procedure TFrmCadPedido.BtnAlterarClick(Sender: TObject);
begin
  inherited;
  FOperacao := opEditar;
  BtnInserirItens.Caption := 'Alterar Itens';
  BtnInserirItens.Enabled := True;
  GrbDados.Enabled := True;
  EdtDataPedido.Enabled := True;
  EdtCodCliente.Enabled := True;
  LcbxNomeCliente.Enabled := True;
  totPedido := StrToFloat(EdtTotalPedido.Text);
  VerificaBotoes(FOperacao);
  EdtDataPedido.SetFocus;
end;

procedure TFrmCadPedido.BtnExcluirClick(Sender: TObject);
begin
  inherited;
  ExcluirPedidos();
  LimpaCamposPedido();
  MessageDlg('Pedido excluído com sucesso!', mtInformation, [mbOK],0);
  MTblPedidoItem.Close;
  FOperacao := opInicio;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadPedido.BtnGravarClick(Sender: TObject);
begin
  inherited;
  if GravarDados() then
  begin
    FOperacao := opNavegar;
    VerificaBotoes(FOperacao);
    GrbDados.Enabled := True;
    GrbGrid.Enabled:= False;
    BtnInserirItens.Enabled := False;
    FClienteController.PreencherComboClientes(TblClientes);
    EdtCodClienteExit(Sender);
  end;
end;

procedure TFrmCadPedido.BtnCancelarClick(Sender: TObject);
begin
  inherited;
  if FOperacao = opNovo then
  begin
    FOperacao := opInicio;
    LimpaCamposPedido();
    LimpaCamposItens();
    GrbDados.Enabled := True;
    VerificaBotoes(opInicio);
    BtnInserirItens.Enabled := False;
    if MTblPedidoItem.Active then
      MTblPedidoItem.Close;
  end;

  if FOperacao = opEditar then
  begin
    FOperacao := opNavegar;
    GrbDados.Enabled := True;
    EdtDataPedido.Text := ValoresOriginais[1];
    EdtCodCliente.Text := ValoresOriginais[2];
    EdtTotalPedido.Text := ValoresOriginais[3];
    EdtCodClienteExit(Sender);
    CarregarPedidos(0);
  end;
  VerificaBotoes(FOperacao);
  BtnInserirItens.Enabled := False;
end;

procedure TFrmCadPedido.BtnInserirItensClick(Sender: TObject);
begin
  inherited;
  if not ValidarDados('Pedido') then
  begin
    Exit;
  end;

  GrbDados.Enabled := False;
  GrbGrid.Enabled := True;
  BtnCancelar.Enabled := True;
  LCbxProdutos.SetFocus;
end;

procedure TFrmCadPedido.BtnLimpaCamposClick(Sender: TObject);
begin
  inherited;
  LimpaCamposPedido();
  MTblPedidoItem.Close;
end;

procedure TFrmCadPedido.BtnAddItemGridClick(Sender: TObject);
begin
  inherited;
  if not ValidarDados('Item') then
  begin
    Exit;
  end
  else
  begin
    PreencheCdsPedidoItem();
    LimpaCamposItens;
    LCbxProdutos.SetFocus;
  end;
end;

procedure TFrmCadPedido.BtnDelItemGridClick(Sender: TObject);
begin
  inherited;
  if MessageDlg('Deseja excluir o registro selecionado?', mtConfirmation, [mbYes, mbNo], mrNo) = mrNo then
    Exit
  else
  begin
    totPedido := totPedido - MTblPedidoItemVAL_TOTALITEM.AsFloat;
    MTblPedidoItem.Locate('ID_PEDIDO', MTblPedidoItemID_Pedido.AsInteger, []);
    MTblPedidoItem.Delete;
    MTblPedidoItem.ApplyUpdates(0);
    if totPedido < 0 then
      totPedido := 0;

    EdtTotalPedido.Text := FormatFloat('######0.00', totPedido);
  end;
end;

procedure TFrmCadPedido.BtnPesquisarClick(Sender: TObject);
var LCodPedido: Integer;
begin
  inherited;
  pesqPedido := False;

  if TryStrToInt(EdtCodPedido.Text, LCodPedido) then
    LCodPedido := StrToInt(EdtCodPedido.Text)
  else
    LCodPedido := 0;

  if EdtCodPedido.Text = EmptyStr then // Pesquisa através da janela de pesquisa.
  begin
    if not Assigned(FrmPesquisaPedidos) then
      FrmPesquisaPedidos := TFrmPesquisaPedidos.Create(Self);

    FrmPesquisaPedidos.ShowModal;
    FrmPesquisaPedidos.Free;
    FrmPesquisaPedidos := nil;

    if pesqPedido then
    begin
      CarregarPedidos(0);
      ValoresOriginais[0] := EdtCodPedido.Text;
      ValoresOriginais[1] := EdtDataPedido.Text;
      ValoresOriginais[2] := EdtCodCliente.Text;
      ValoresOriginais[3] := EdtTotalPedido.Text;
      EdtCodClienteExit(Sender);

      if FOperacao = opEditar then
        BtnAlterar.Click;

      VerificaBotoes(FOperacao);
    end;
  end;

  if LCodPedido > 0 then  // Pesquisa informando o codigo da Pedido.
  begin
    CarregarPedidos(LCodPedido);
    EdtCodClienteExit(Sender);
    FOperacao := opNavegar;
    VerificaBotoes(FOperacao);
  end;

end;

procedure TFrmCadPedido.EdtDataPedidoChange(Sender: TObject);
begin
  inherited;
  Formatar(EdtDataPedido, TFormato.Dt);
  HabilitarBotaoIncluirItens();
end;

procedure TFrmCadPedido.EdtCodClienteExit(Sender: TObject);
begin
  inherited;
  if EdtCodCliente.Text <> '' then
    LCbxNomeCliente.KeyValue := StrToInt(EdtCodCliente.Text);
end;

procedure TFrmCadPedido.LcbxNomeClienteClick(Sender: TObject);
begin
  inherited;
   if LCbxNomeCliente.KeyValue > 0 then
    EdtCodCliente.Text := IntToStr(LcbxNomeCliente.KeyValue)
end;

procedure TFrmCadPedido.EdtCodClienteChange(Sender: TObject);
begin
  inherited;
  HabilitarBotaoIncluirItens();
end;

procedure TFrmCadPedido.LCbxProdutosClick(Sender: TObject);
var LPrecoUnitario: Double;
begin
  inherited;
  LPrecoUnitario := FProdutoController.GetValorUnitario(LCbxProdutos.KeyValue);
  EdtPrecoUnit.Text := FormatFloat('######0.00', LPrecoUnitario);
  EdtQuantidade.Text := '1';
  EdtQuantidade.SetFocus;
end;

procedure TFrmCadPedido.EdtQuantidadeExit(Sender: TObject);
var LValorItem, LPrecoUnit: Double;
    LQuantidade: Integer;
begin
  inherited;
  if (EdtQuantidade.Text = EmptyStr) or (StrToInt(EdtQuantidade.Text) = 0) then
  begin
    MessageDlg('Informe um valor válido para Quantidade!', mtInformation, [mbOK], 0);
    if EdtQuantidade.CanFocus then
      EdtQuantidade.SetFocus;

    Exit;
  end;

  if not TryStrToFloat(EdtPrecoUnit.Text, LPrecoUnit) then
    LPrecoUnit := 0;

  EdtPrecoUnit.Text := FormatFloat('######0.00', LPrecoUnit);

  if not TryStrToInt(EdtQuantidade.Text, LQuantidade) then
  begin
    LQuantidade := 1;
    EdtQuantidade.Text := '1';
  end;

  LValorItem := (StrToInt(EdtQuantidade.Text) * StrToFloat(EdtPrecoUnit.Text));
  EdtPrecoTotal.Text := FormatFloat('#0.00', LValorItem);
end;

procedure TFrmCadPedido.EdtPrecoUnitExit(Sender: TObject);
var LValor: Double;
begin
  inherited;
  if TryStrToFloat(EdtPrecoUnit.Text, LValor) then
    EdtPrecoUnit.Text := FormatFloat('######0.00', LValor)
end;

procedure TFrmCadPedido.EdtPrecoTotalExit(Sender: TObject);
var LValor: Double;
begin
  inherited;
  if TryStrToFloat(EdtPrecoTotal.Text, LValor) then
    EdtPrecoTotal.Text := FormatFloat('######0.00', LValor)
end;

procedure TFrmCadPedido.EdtCodPedidoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not( key in['0'..'9',#08] ) then
    key:=#0;
end;

procedure TFrmCadPedido.EdtCodClienteKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not( key in['0'..'9',#08] ) then
    key:=#0;
end;

procedure TFrmCadPedido.EdtQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not( key in['0'..'9',#08] ) then
    key:=#0;
end;

procedure TFrmCadPedido.EdtPrecoUnitKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not( key in['0'..'9',#08] ) then
    key:=#0;
end;

procedure TFrmCadPedido.EdtPrecoTotalKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not( key in['0'..'9',#08] ) then
    key:=#0;
end;

procedure TFrmCadPedido.BtnSairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmCadPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TFrmCadPedido.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    perform(WM_NEXTDLGCTL,0,0)
end;


end.
