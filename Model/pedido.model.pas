unit pedido.model;

interface

uses umain, System.SysUtils, FireDAC.Comp.Client;

Type
  TPedido = class
  private
    FCod_Pedido: Integer;
    FDta_Pedido: TDateTime;
    FCod_Cliente: Integer;
    FDes_Cliente: string;
    FVal_Pedido: Double;
    procedure SetCod_Cliente(const Value: Integer);

  public
    property Cod_Pedido: Integer read FCod_Pedido write FCod_Pedido;
    property Dta_Pedido: TDateTime read FDta_Pedido write FDta_Pedido;
    property Cod_Cliente: Integer read FCod_Cliente write SetCod_Cliente;
    property Des_Cliente: string read FDes_Cliente write FDes_Cliente;
    property Val_Pedido: Double read FVal_Pedido write FVal_Pedido;

  end;

implementation

{ TPedido }


procedure TPedido.SetCod_Cliente(const Value: Integer);
begin
  if Value = 0 then
    raise EArgumentException.Create('O campo ''Código do Cliente'' precisa ser preenchido!');

  FCod_Cliente := Value;
end;

end.
