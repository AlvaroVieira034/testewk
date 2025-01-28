unit pedidoitens.controller;

interface

uses umain, pedidoitens.model, pedidoitens.repository, system.SysUtils, Vcl.Forms, FireDAC.Comp.Client,
     System.Generics.Collections;

type
  TCampoInvalido = (ciData, ciDescricao, ciCliente, ciValor, ciValorZero);
  TPedidoItensController = class

  private
    FPedidoItens: TPedidoItens;
    FPedidoItensRepository: TPedidoItensRepository;

  public
    constructor Create();
    destructor Destroy; override;
    function CarregarItensPedido(ACodPedido: Integer): TList<TPedidoItens>;
    function Inserir(FPedidoItens: TPedidoItens; var sErro: string): Boolean;
    function Excluir(ACodigo: Integer; var sErro: string): Boolean;

  end;

implementation

{ TPedidoItensController }

constructor TPedidoItensController.Create;
begin
  FPedidoItens := TPedidoItens.Create;
  FPedidoItensRepository := TPedidoItensRepository.Create;
end;

destructor TPedidoItensController.Destroy;
begin
  FPedidoItens.Free;
  FPedidoItensRepository.Free;
  inherited;
end;

function TPedidoItensController.CarregarItensPedido(ACodPedido: Integer): TList<TPedidoItens>;
begin
  Result := FPedidoItensRepository.CarregarItensPedido(ACodPedido);
end;

function TPedidoItensController.Inserir(FPedidoItens: TPedidoItens; var sErro: string): Boolean;
begin
  Result := FPedidoItensRepository.Inserir(FPedidoItens, sErro);
end;

function TPedidoItensController.Excluir(ACodigo: Integer; var sErro: string): Boolean;
begin
  Result := FPedidoItensRepository.Excluir(ACodigo,  sErro);
end;

end.
