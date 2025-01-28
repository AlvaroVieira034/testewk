unit ipedido.repository;

interface

uses pedido.model, Data.DB, FireDAC.Comp.Client, System.SysUtils;

type
  IPedidoRepository = interface
    ['{FCCF6A21-906B-4C4F-BD47-46F4FFD88AB8}']
    function Inserir(FPedido: TPedido; Transacao: TFDTransaction; out sErro: string): Boolean;
    function Alterar(FPedido: TPedido; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro : string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;
    procedure CriarTabelas;

  end;

implementation

end.
