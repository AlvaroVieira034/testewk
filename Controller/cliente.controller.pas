unit cliente.controller;

interface

uses cliente.model, cliente.repository, iinterface.repository, cliente.service, iinterface.service, conexao,
     System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB;

type
  TCampoInvalido = (ciNome, ciCidade, ciUF);
  TClienteController = class

  private
    FCliente: TCliente;
    FClienteRepository : TClienteRepository;
    FClienteService : TClienteService;

  public
    constructor Create(AClienteRepository: IInterfaceRepository<TCliente>; AClienteService: IInterfaceService<TCliente>);
    destructor Destroy; override;
    procedure PreencherGridClientes(APesquisa, ACampo: string);
    procedure PreencherCamposForm(FCliente: TCliente; ACodigo: Integer);
    procedure PreencherComboClientes(TblComboClientes: TFDQuery);
    function Inserir(FCliente: TCliente; out sErro: string): Boolean;
    function Alterar(FCliente: TCliente; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro : string): Boolean;
    function ValidarDados(const ANomeCliente, ACidade, AUF: string; out AErro: TCampoInvalido): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
    function GetDataSource: TDataSource;

  end;

implementation

{ TClienteController }

constructor TClienteController.Create(AClienteRepository: IInterfaceRepository<TCliente>; AClienteService: IInterfaceService<TCliente>);
begin
  FCliente := TCliente.Create();
  FClienteRepository := TClienteRepository.Create;
  FClienteService := TClienteService.Create;
end;

destructor TClienteController.Destroy;
begin
  FCliente.Free;
  FClienteRepository.Free;
  FClienteService.Free;
  inherited Destroy;
end;

function TClienteController.Inserir(FCliente: TCliente; out sErro: string): Boolean;
begin
  Result := FClienteRepository.Inserir(FCliente, sErro);
end;

function TClienteController.Alterar(FCliente: TCliente; ACodigo: Integer; out sErro: string): Boolean;
begin
  Result := FClienteRepository.Alterar(FCliente, ACodigo, sErro);
end;

function TClienteController.Excluir(ACodigo: Integer; out sErro: string): Boolean;
begin
  Result := FClienteRepository.Excluir(ACodigo, sErro);
end;

procedure TClienteController.PreencherGridClientes(APesquisa, ACampo: string);
var LCampo, SErro: string;
begin
  try
    if ACampo = 'Código' then
      LCampo := 'cli.cd_cliente';

    if ACampo = 'Nome' then
      LCampo := 'cli.des_nomecliente';

    if ACampo = 'Cidade' then
      LCampo := 'cli.des_cidade';

    if ACampo = '' then
      LCampo := 'cli.des_nomecliente';

    FClienteService.PreencherGridForm(APesquisa, LCampo);
  except on E: Exception do
    begin
      SErro := 'Ocorreu um erro ao pesquisar o cliente!' + sLineBreak + E.Message;
      raise;
    end;
  end;

end;

procedure TClienteController.PreencherCamposForm(FCliente: TCliente; ACodigo: Integer);
var sErro: string;
begin
  try
    FClienteService.PreencherCamposForm(FCliente, ACodigo);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao carregar o cliente!' + sLineBreak + E.Message;
      raise;
    end;
  end;

end;

procedure TClienteController.PreencherComboClientes(TblComboClientes: TFDQuery);
begin
  FClienteService.PreencherComboBox(TblComboClientes);
end;

function TClienteController.ValidarDados(const ANomeCliente, ACidade, AUF: string; out AErro: TCampoInvalido): Boolean;
var LCpf, LCnpj: string;
begin
  if ANomeCliente = EmptyStr then
  begin
    AErro := ciNome;
    Exit;
  end;

  if ACidade = EmptyStr then
  begin
    AErro := ciCidade;
    Exit;
  end;

  if AUF = EmptyStr then
  begin
    AErro := ciUF;
    Exit;
  end;

  Result := True;
end;

function TClienteController.ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
begin
  Result := FClienteRepository.ExecutarTransacao(AOperacao, sErro);
end;

function TClienteController.GetDataSource: TDataSource;
begin
  Result := FClienteService.GetDataSource;
end;

end.
