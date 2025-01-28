unit pedido.repository;

interface

uses pedido.model, iPedido.repository, conexao, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
     Data.DB;

type
  TPedidoRepository = class(TInterfacedObject, IPedidoRepository)

  private
    QryPedidos: TFDQuery;
    Transacao: TFDTransaction;

  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(FPedido: TPedido; Transacao: TFDTransaction; out sErro: string): Boolean;
    function Alterar(FPedido: TPedido; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro : string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
    procedure CriarTabelas;

  end;

implementation

{ TPedidoRepository }

constructor TPedidoRepository.Create;
begin
  CriarTabelas()
end;

destructor TPedidoRepository.Destroy;
begin
  QryPedidos.Free;
  inherited;

end;

function TPedidoRepository.Inserir(FPedido: TPedido; Transacao: TFDTransaction; out sErro: string): Boolean;
begin
  QryPedidos.Transaction := Transacao;
  with QryPedidos, FPedido do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into tab_Pedido(');
    SQL.Add('dta_Pedido, ');
    SQL.Add('cod_cliente, ');
    SQL.Add('val_Pedido) ');
    SQL.Add('values (:dta_Pedido, ');
    SQL.Add(':cod_cliente, ');
    SQL.Add(':val_Pedido)');

    ParamByName('DTA_Pedido').AsDateTime := Dta_Pedido;
    ParamByName('COD_CLIENTE').AsInteger := Cod_Cliente;
    ParamByName('VAL_Pedido').AsFloat := Val_Pedido;

    try
      Prepared := True;
      ExecSQL;
      Result := True;

      QryPedidos.Close;
      QryPedidos.SQL.Text := 'SELECT MAX(COD_Pedido) AS ULTIMOID FROM TAB_Pedido ';
      QryPedidos.Open;
      FPedido.Cod_Pedido := QryPedidos.FieldByName('ULTIMOID').AsInteger;

    except
      on E: Exception do
      begin
        sErro := 'Ocorreu um erro ao inserir uma nova Pedido!' + sLineBreak + E.Message;
        raise;
      end;
    end;
  end;
end;

function TPedidoRepository.Alterar(FPedido: TPedido; ACodigo: Integer; out sErro: string): Boolean;
begin
  with QryPedidos, FPedido do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update tab_Pedido set ');
    SQL.Add('dta_Pedido = :dta_Pedido, ');
    SQL.Add('cod_cliente = :cod_cliente, ');
    SQL.Add('val_Pedido = :val_Pedido');
    SQL.Add('where cod_Pedido = :cod_Pedido');

    ParamByName('DTA_Pedido').AsDateTime := Dta_Pedido;
    ParamByName('COD_CLIENTE').AsInteger := Cod_Cliente;
    ParamByName('VAL_Pedido').AsFloat := Val_Pedido;
    ParamByName('COD_Pedido').AsInteger := ACodigo;

    try
      ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
      sErro := 'Ocorreu um erro ao alterar uma Pedido!' + sLineBreak + E.Message;
      raise;
      end;
    end
  end;
end;

function TPedidoRepository.Excluir(ACodigo: Integer; out sErro: string): Boolean;
begin
  with QryPedidos do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'delete from tab_Pedido where cod_Pedido = :cod_Pedido';
    ParamByName('COD_Pedido').AsInteger := ACodigo;

    try
      ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
      sErro := 'Ocorreu um erro ao excluir uma Pedido!' + sLineBreak + E.Message;
      raise;
      end;
    end
  end;
end;

function TPedidoRepository.ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
begin
  Result := False;
  if not Transacao.Connection.Connected then
    Transacao.Connection.Open();

  try
    Transacao.StartTransaction;
    try
      AOperacao;
      Transacao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
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
end;

procedure TPedidoRepository.CriarTabelas;
begin
  Transacao := TConexao.GetInstance.Connection.CriarTransaction;
  QryPedidos := TConexao.GetInstance.Connection.CriarQuery;
end;

end.
