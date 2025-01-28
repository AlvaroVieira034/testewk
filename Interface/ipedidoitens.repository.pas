unit ipedidoitens.repository;

interface

uses pedidoitens.model, Data.DB, FireDAC.Comp.Client, System.SysUtils, System.Classes,
     System.Generics.Collections;

type
  IPedidoItensRepository = interface
    ['{9CC5F96D-A765-41A5-A670-1241895E5CF4}']
    function CarregarItensPedido(ACodPedido: Integer): TList<TPedidoItens>;
    function Inserir(FPedidoItens: TPedidoItens; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro: string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
    procedure CriarTabelas;
  end;

implementation

end.
