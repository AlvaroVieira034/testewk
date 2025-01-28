unit pedido.controller;

interface

uses umain, Pedido.model, Pedido.service, iPedido.service, Pedido.repository, iPedido.repository,
     system.SysUtils, Vcl.Forms, FireDAC.Comp.Client;

type
  TPedidoController = class

  private
    FPedido: TPedido;
    FPedidoRepository : TPedidoRepository;
    FPedidoService : TPedidoService;

  public
    constructor Create(APedidoRepository: IPedidoRepository; APedidoService: IPedidoService);
    destructor Destroy; override;
    procedure PreencherGrid(TblPedidos: TFDQuery; APesquisa, ACampo: string);
    function CarregarCampos(FPedido: TPedido; ACodigo: Integer): Boolean;
    function Inserir(FPedido: TPedido; Transacao: TFDTransaction; var sErro: string): Boolean;
    function Alterar(FPedido: TPedido; ACodigo: Integer; sErro: string): Boolean;
    function Excluir(ACodigo: Integer; var sErro: string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;

  end;

implementation

{ TPedidoController }

constructor TPedidoController.Create(APedidoRepository: IPedidoRepository; APedidoService: IPedidoService);
begin
  FPedido := TPedido.Create();
  FPedidoRepository := TPedidoRepository.Create();
  FPedidoService := TPedidoService.Create();
end;

destructor TPedidoController.Destroy;
begin
  FPedido.Free;
  FPedidoRepository.Free;
  FPedidoService.Free;
  inherited;
end;

procedure TPedidoController.PreencherGrid(TblPedidos: TFDQuery; APesquisa, ACampo: string);
var LCampo, sErro: string;
begin
  try
    if ACampo = 'Data' then
      LCampo := 'vda.dta_Pedido';

    if ACampo = 'Cliente' then
      LCampo := 'cli.des_nomecliente';

    if ACampo = '' then
      LCampo := 'vda.dta_Pedido';

    FPedidoService.PreencherGridPedidos(TblPedidos, APesquisa, LCampo);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao pesquisar o pedido!' + sLineBreak + E.Message;
      raise;
    end;
  end;
end;

function TPedidoController.CarregarCampos(FPedido: TPedido; ACodigo: Integer): Boolean;
var sErro: string;
begin
  try
    FPedidoService.PreencherCamposForm(FPedido, ACodigo);
    Result := True;
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao carregar o pedido!' + sLineBreak + E.Message;
      Result := False;
      raise;
    end;
  end;
end;

function TPedidoController.Inserir(FPedido: TPedido; Transacao: TFDTransaction; var sErro: string): Boolean;
begin
  Result := FPedidoRepository.Inserir(FPedido, Transacao, sErro);
end;

function TPedidoController.Alterar(FPedido: TPedido; ACodigo: Integer; sErro: string): Boolean;
begin
  Result := FPedidoRepository.Alterar(FPedido, ACodigo, sErro);
end;

function TPedidoController.Excluir(ACodigo: Integer; var sErro: string): Boolean;
begin
  Result := FPedidoRepository.Excluir(ACodigo, sErro);
end;

function TPedidoController.ExecutarTransacao(AOperacao: TProc;  var sErro: string): Boolean;
begin
  Result := FPedidoRepository.ExecutarTransacao(AOperacao, sErro);
end;

end.
