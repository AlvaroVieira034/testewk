unit produto.controller;

interface

uses produto.model, produto.repository, iinterface.repository, produto.service, iinterface.service, system.SysUtils,
     Vcl.Forms, FireDAC.Comp.Client, Data.DB;

type
  TCampoInvalido = (ciNome, ciDescricao, ciPreco, ciPrecoZero);
  TProdutoController = class

  private
    FProduto: TProduto;
    FProdutoRepository: TProdutoRepository;
    FProdutoService: TProdutoService;
    FDataSource: TDataSource;

  public
    constructor Create(AProdutoRepository: IInterfaceRepository<TProduto>; AProdutoService: IInterfaceService<TProduto>);
    destructor Destroy; override;
    procedure PreencherGridProdutos(APesquisa, ACampo: string);
    procedure PreencherComboProdutos(TblProdutos: TFDQuery);
    function PreencherCamposForm(FProduto: TProduto; iCodigo: Integer): Boolean;
    function Inserir(FProduto: TProduto; var sErro: string): Boolean;
    function Alterar(FProduto: TProduto; iCodigo: Integer; sErro: string): Boolean;
    function Excluir(iCodigo: Integer; var sErro: string): Boolean;
    function GetValorUnitario(ACodigo: Integer): Double;
    function GetDataSource: TDataSource;
    function ValidarDados(const ADescricao, APreco: string; out AErro: TCampoInvalido): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;

  end;

implementation

{ TProdutoController }


constructor TProdutoController.Create(AProdutoRepository: IInterfaceRepository<TProduto>; AProdutoService: IInterfaceService<TProduto>);
begin
  FProduto := TProduto.Create();
  FProdutoRepository := TProdutoRepository.Create;
  FProdutoService := TProdutoService.Create;
end;

destructor TProdutoController.Destroy;
begin
  FProduto.Free;
  inherited;
end;

procedure TProdutoController.PreencherGridProdutos(APesquisa, ACampo: string);
var LCampo, sErro: string;
begin
  if ACampo = 'Código' then
    LCampo := 'prd.cod_produto';

  if ACampo = 'Descrição' then
    LCampo := 'prd.des_descricao';

  if ACampo = '' then
    LCampo := 'prd.des_descricao';

  FProdutoService.PreencherGridForm(APesquisa, LCampo);
end;

procedure TProdutoController.PreencherComboProdutos(TblProdutos: TFDQuery);
begin
  FProdutoService.PreencherComboBox(TblProdutos);
end;

function TProdutoController.PreencherCamposForm(FProduto: TProduto; iCodigo: Integer): Boolean;
var sErro: string;
begin
  try
    FProdutoService.PreencherCamposForm(FProduto, iCodigo);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao carregar o produto!' + sLineBreak + E.Message;
      Result := False;
      raise;
    end;
  end;
end;

function TProdutoController.Inserir(FProduto: TProduto; var sErro: string): Boolean;
begin
  Result := FProdutoRepository.Inserir(FProduto, sErro);
end;

function TProdutoController.Alterar(FProduto: TProduto; iCodigo: Integer; sErro: string): Boolean;
begin
  Result := FProdutoRepository.Alterar(FProduto, iCodigo, sErro);
end;

function TProdutoController.Excluir(iCodigo: Integer; var sErro: String): Boolean;
begin
  Result := FProdutoRepository.Excluir(iCodigo, sErro);
end;

function TProdutoController.GetValorUnitario(ACodigo: Integer): Double;
begin
  Result := FProdutoService.GetValorUnitario(ACodigo);
end;

function TProdutoController.GetDataSource: TDataSource;
begin
  Result := FProdutoService.GetDataSource;
end;

function TProdutoController.ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
begin
  Result := FProdutoRepository.ExecutarTransacao(AOperacao, sErro);
end;

function TProdutoController.ValidarDados(const ADescricao, APreco: string; out AErro: TCampoInvalido): Boolean;
begin
  Result := True;
  if ADescricao = EmptyStr then
  begin
    AErro := ciDescricao;
    Result := False;
    Exit;
  end;

  if APreco = EmptyStr then
  begin
    AErro := ciPreco;
    Result := False;
    Exit;
  end;

  if APreco = '0.00' then
  begin
    AErro := ciPrecoZero;
    Result := False;
    Exit;
  end;
end;

end.
