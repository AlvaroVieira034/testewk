unit ipedido.service;

interface

uses pedido.model, Data.DB, FireDAC.Comp.Client;

type
  IPedidoService = interface
    ['{5DD9E2B4-ACD0-4DBD-AEE2-1E6CA9F33D43}']
    procedure PreencherGridPedidos(TblPedidos: TFDQuery; APesquisa, ACampo: string);
    procedure PreencherCamposForm(FPedido: TPedido; ACodigo: Integer);

  end;

implementation


end.
