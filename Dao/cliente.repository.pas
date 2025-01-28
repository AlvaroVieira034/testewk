unit cliente.repository;

interface

uses iinterface.repository, cliente.model, conexao, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
     Data.DB;

type
  TClienteRepository = class(TInterfacedObject, IInterfaceRepository<TCliente>)

  private
    QryClientes: TFDQuery;
    Transacao: TFDTransaction;

  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(AEntity: TCliente; out sErro: string): Boolean;
    function Alterar(AEntity: TCliente; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro: string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;

  end;

implementation

{ TProdutoRepository }

constructor TClienteRepository.Create;
begin
  inherited Create;
  Transacao := TConexao.GetInstance.Connection.CriarTransaction;
  QryClientes := TConexao.GetInstance.Connection.CriarQuery;
  QryClientes.Transaction := Transacao;
end;

destructor TClienteRepository.Destroy;
begin
  QryClientes.Free;
  inherited;
end;

function TClienteRepository.Inserir(AEntity: TCliente; out sErro: string): Boolean;
begin
  Result := ExecutarTransacao(
    procedure
    begin
      with QryClientes, AEntity do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into tab_cliente(');
        SQL.Add('des_nomecliente, ');
        SQL.Add('des_cep, ');
        SQL.Add('des_cidade, ');
        SQL.Add('des_uf) ');
        SQL.Add('values (:des_nomecliente, ');
        SQL.Add(':des_cep, ');
        SQL.Add(':des_cidade, ');
        SQL.Add(':des_uf)');

        ParamByName('DES_NOMECLIENTE').AsString := Des_NomeCliente;
        ParamByName('DES_CEP').AsString := Des_Cep;
        ParamByName('DES_CIDADE').AsString := Des_Cidade;
        ParamByName('DES_UF').AsString := Des_UF;

        ExecSQL;
      end;
    end, sErro);
end;

function TClienteRepository.Alterar(AEntity: TCliente; ACodigo: Integer; out sErro: string): Boolean;
begin
  Result := ExecutarTransacao(
    procedure
    begin
      with QryClientes, AEntity do
      begin
        Close;
        SQL.Clear;
        SQL.Add('update tab_cliente set ');
        SQL.Add('des_nomecliente = :des_nomecliente, ');
        SQL.Add('des_cep = :des_cep, ');
        SQL.Add('des_cidade = :des_cidade, ');
        SQL.Add('des_uf = :des_uf ');
        SQL.Add('where cod_cliente = :cod_cliente');

        ParamByName('DES_NOMECLIENTE').AsString := Des_NomeCliente;
        ParamByName('DES_CEP').AsString := Des_Cep;
        ParamByName('DES_CIDADE').AsString := Des_Cidade;
        ParamByName('DES_UF').AsString := Des_UF;
        ParamByName('COD_CLIENTE').AsInteger := ACodigo;

        ExecSQL;
      end;
    end, sErro);
end;

function TClienteRepository.Excluir(ACodigo: Integer; out sErro: string): Boolean;
begin
  Result := ExecutarTransacao(
    procedure
    begin
      with QryClientes do
      begin
        Close;
        SQL.Clear;
        SQL.Text := 'delete from tab_cliente where cod_cliente = :cod_cliente';
        ParamByName('COD_CLIENTE').AsInteger := ACodigo;

        ExecSQL;
      end;
    end, sErro);
end;

function TClienteRepository.ExecutarTransacao(AOperacao: TProc;  var sErro: string): Boolean;
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
        sErro := 'Ocorreu um erro ao excluir o cliente!' + sLineBreak + E.Message;
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
