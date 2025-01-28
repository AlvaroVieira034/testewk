unit produto.repository;

interface

uses iinterface.repository, produto.model, conexao, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
     Data.DB;

type
  TProdutoRepository = class(TInterfacedObject, IInterfaceRepository<TProduto>)

  private
    QryProdutos: TFDQuery;
    Transacao: TFDTransaction;

  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(AEntity: TProduto; out sErro: string): Boolean;
    function Alterar(AEntity: TProduto; iCodigo: Integer; out sErro: string): Boolean;
    function Excluir(iCodigo: Integer; out sErro : string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;

  end;

implementation

{ TProdutoRepository }

constructor TProdutoRepository.Create;
begin
  inherited Create;
  Transacao := TConexao.GetInstance.Connection.CriarTransaction;
  QryProdutos := TConexao.GetInstance.Connection.CriarQuery;
  QryProdutos.Transaction := Transacao;
end;

destructor TProdutoRepository.Destroy;
begin
  QryProdutos.Free;
  inherited Destroy;
end;

function TProdutoRepository.Inserir(AEntity: TProduto; out sErro: string): Boolean;
begin
  Result := ExecutarTransacao(
    procedure
    begin
      with QryProdutos, AEntity do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into tab_produto(');
        SQL.Add('des_descricao, ');
        SQL.Add('val_preco) ');
        SQL.Add('values (:des_descricao, ');
        SQL.Add(':val_preco)');

        ParamByName('DES_DESCRICAO').AsString := Des_Descricao;
        ParamByName('VAL_PRECO').AsFloat := Val_Preco;

        ExecSQL;
      end;
    end, sErro);
end;

function TProdutoRepository.Alterar(AEntity: TProduto; iCodigo: Integer; out sErro: string): Boolean;
begin
  Result := ExecutarTransacao(
  procedure
  begin
    with QryProdutos, AEntity do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update tab_produto set ');
      SQL.Add('des_descricao = :des_descricao, ');
      SQL.Add('val_preco = :val_preco');
      SQL.Add('where cod_produto = :cod_produto');

      ParamByName('DES_DESCRICAO').AsString := Des_Descricao;
      ParamByName('VAL_PRECO').AsFloat := Val_Preco;
      ParamByName('COD_PRODUTO').AsInteger := iCodigo;

      ExecSQL;
    end;
  end, sErro);
end;

function TProdutoRepository.Excluir(iCodigo: Integer; out sErro: string): Boolean;
begin
  Result := ExecutarTransacao(
  procedure
  begin
    with QryProdutos do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'delete from tab_produto where cod_produto = :cod_produto';
      ParamByName('COD_PRODUTO').AsInteger := iCodigo;

      ExecSQL;
    end;
  end, sErro);
end;

function TProdutoRepository.ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
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

end.
