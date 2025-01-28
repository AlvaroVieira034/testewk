unit produto.model;

interface

uses System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt;

type
  TProduto = class

  private
    FCod_Produto: Integer;
    FDes_Descricao: string;
    FVal_Preco: Double;
    procedure SetDes_Descricao(const Value: String);

  public
    property Cod_Produto: Integer read FCod_Produto write FCod_Produto;
    property Des_Descricao: string read FDes_Descricao write SetDes_Descricao;
    property Val_Preco: Double read FVal_Preco write FVal_Preco;

  end;

implementation

{ TProduto }

procedure TProduto.SetDes_Descricao(const Value: String);
begin
  if Value = EmptyStr then
    raise EArgumentException.Create('O campo ''Descrição do produto'' precisa ser preenchido !');

  FDes_Descricao := Value;
end;

end.


