unit cliente.model;

interface

uses umain, System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt;

type
  TCliente = class

  private
    FCod_Cliente: Integer;
    FDes_NomeCliente: string;
    FDes_Cep: string;
    FDes_Cidade: string;
    FDes_UF: string;

    procedure SetDes_NomeCliente(const Value: String);

  public
    property Cod_Cliente: Integer read FCod_Cliente write FCod_Cliente;
    property Des_NomeCliente: string read FDes_NomeCliente write SetDes_NomeCliente;
    property Des_Cep: string read FDes_Cep write FDes_Cep;
    property Des_Cidade: string read FDes_Cidade write FDes_Cidade;
    property Des_UF: string read FDes_UF write FDes_UF;

  end;

implementation

{ TCliente }

procedure TCliente.SetDes_NomeCliente(const Value: string);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('O campo ''Nome do Cliente'' precisa ser preenchido !');

  FDes_NomeCliente := Value;
end;

end.
