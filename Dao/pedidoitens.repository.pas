unit pedidoitens.repository;

interface

uses pedidoitens.model, iPedidoitens.repository,  conexao, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
     System.Classes, System.Generics.Collections, Data.DB;

type
  TPedidoItensRepository = class(TInterfacedObject, IPedidoItensRepository)

  private
    QryPedidoItens: TFDQuery;
    TransacaoItens: TFDTransaction;

  public
    constructor Create;
    destructor Destroy; override;
    function CarregarItensPedido(ACodPedido: Integer): TList<TPedidoItens>;
    function Inserir(FPedidoItens: TPedidoItens; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro: string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
    procedure CriarTabelas;

  end;

implementation

{ TPedidosItensRepository }

constructor TPedidoItensRepository.Create;
begin
  CriarTabelas()
end;

destructor TPedidoItensRepository.Destroy;
begin
  TransacaoItens.Free;
  QryPedidoItens.Free;
  inherited;
end;

procedure TPedidoItensRepository.CriarTabelas;
begin
  TransacaoItens := TConexao.GetInstance.Connection.CriarTransaction;
  QryPedidoItens := TConexao.GetInstance.Connection.CriarQuery;
  QryPedidoItens.Transaction := TransacaoItens;
end;

function TPedidoItensRepository.CarregarItensPedido(ACodPedido: Integer): TList<TPedidoItens>;
var Item: TPedidoItens;
begin
  Result := TList<TPedidoItens>.Create;

  with QryPedidoItens do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select vdi.id_Pedido, ');
    SQL.Add('vdi.cod_Pedido, ');
    SQL.Add('vdi.cod_produto, ');
    SQL.Add('prd.des_descricao as descricao, ');
    SQL.Add('vdi.val_quantidade,');
    SQL.Add('vdi.val_precounitario, ');
    SQL.Add('vdi.val_totalitem');
    SQL.Add('from tab_Pedido_item vdi');
    SQL.Add('join tab_produto prd on vdi.cod_produto = prd.cod_produto');
    SQL.Add('where vdi.cod_Pedido = :cod_Pedido');
    SQL.Add('order by vdi.id_Pedido');
    ParamByName('COD_Pedido').AsInteger := ACodPedido;
    Open;
  end;

  while not QryPedidoItens.Eof do
  begin
    Item := TPedidoItens.Create;
    Item.Id_Pedido := QryPedidoItens.FieldByName('ID_Pedido').AsInteger;
    Item.Cod_Pedido := QryPedidoItens.FieldByName('COD_Pedido').AsInteger;
    Item.Cod_Produto := QryPedidoItens.FieldByName('COD_PRODUTO').AsInteger;
    Item.Des_Descricao := QryPedidoItens.FieldByName('DESCRICAO').AsString;
    Item.Val_Quantidade := QryPedidoItens.FieldByName('VAL_QUANTIDADE').AsInteger;
    Item.Val_PrecoUnitario := QryPedidoItens.FieldByName('VAL_PRECOUNITARIO').AsFloat;
    Item.Val_TotalItem := QryPedidoItens.FieldByName('VAL_TOTALITEM').AsFloat;
    Result.Add(Item);
    QryPedidoItens.Next;
  end;
  QryPedidoItens.Close;
end;

function TPedidoItensRepository.Inserir(FPedidoItens: TPedidoItens; out sErro: string): Boolean;
begin
  with QryPedidoItens, FPedidoItens do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into tab_Pedido_item( ');
    SQL.Add('cod_Pedido, ');
    SQL.Add('cod_produto, ');
    SQL.Add('val_precounitario, ');
    SQL.Add('val_quantidade, ');
    SQL.Add('val_totalitem) ');
    SQL.Add('values (:cod_Pedido, ');
    SQL.Add(':cod_produto, ');
    SQL.Add(':val_precounitario, ');
    SQL.Add(':val_quantidade, ');
    SQL.Add(':val_totalitem) ');

    ParamByName('COD_Pedido').AsInteger := Cod_Pedido;
    ParamByName('COD_PRODUTO').AsInteger := Cod_Produto;
    ParamByName('VAL_PRECOUNITARIO').AsFloat := Val_PrecoUnitario;
    ParamByName('VAL_QUANTIDADE').AsInteger := Val_Quantidade;
    ParamByName('VAL_TOTALITEM').AsFloat := Val_TotalItem;

    try
      Prepared := True;
      ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        sErro := 'Ocorreu um erro ao inserir um item da Pedido!' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;

function TPedidoItensRepository.Excluir(ACodigo: Integer; out sErro: string): Boolean;
begin
  with QryPedidoItens do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'delete from tab_Pedido_item where cod_Pedido = :cod_Pedido';
    ParamByName('COD_Pedido').AsInteger := ACodigo;

    // Inicia Transação
    if not TransacaoItens.Connection.Connected then
      TransacaoItens.Connection.Open();

    try
      Prepared := True;
      TransacaoItens.StartTransaction;
      ExecSQL;
      TransacaoItens.Commit;
      Result := True;
    except on E: Exception do
      begin
        TransacaoItens.Rollback;
        sErro := 'Ocorreu um erro ao excluir os itens da Pedido !' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;

function TPedidoItensRepository.ExecutarTransacao(AOperacao: TProc;  var sErro: string): Boolean;
begin
  Result := False;
  if not TransacaoItens.Connection.Connected then
    TransacaoItens.Connection.Open();

  try
    TransacaoItens.StartTransaction;
    try
      AOperacao;
      TransacaoItens.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        TransacaoItens.Rollback;
        sErro := 'Ocorreu um erro ao excluir o produto !' + sLineBreak + E.Message;
        raise;
      end;
    end;
  except
    on E: Exception do
    begin
      sErro := 'Erro na conexão com o banco de dados: ' + sLineBreak + E.Message;
      Result := False;
    end;
  end;

  if TransacaoItens.Connection.Connected then
    TransacaoItens.Connection.Close();
end;

end.
