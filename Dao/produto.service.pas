unit produto.service;

interface

uses iinterface.service, conexao, produto.model, FireDAC.Comp.Client, FireDAC.Stan.Param, System.SysUtils,
     Data.DB;

type
  TProdutoService = class(TInterfacedObject, IInterfaceService<TProduto>)

  private
    TblProdutos: TFDQuery;
    QryTemp: TFDQuery;
    DsProdutos: TDataSource;

  public
    constructor Create;
    destructor Destroy; override;
    procedure PreencherGridForm(APesquisa, ACampo: string);
    procedure PreencherComboBox(TblProdutos: TFDQuery);
    procedure PreencherCamposForm(FProduto: TProduto; iCodigo: Integer);
    function GetValorUnitario(ACodigo: Integer): Double;
    function GetDataSource: TDataSource;
    procedure CriarTabelas;
    procedure CriarCamposTabelas;

  end;

implementation

{ TProdutoService }

constructor TProdutoService.Create;
begin
  CriarTabelas();
  CriarCamposTabelas();
end;

destructor TProdutoService.Destroy;
begin
  TblProdutos.Free;
  QryTemp.Free;
  DsProdutos.Free;
  inherited Destroy;
end;

procedure TProdutoService.CriarTabelas;
begin
  TblProdutos := TConexao.GetInstance.Connection.CriarQuery;
  QryTemp := TConexao.GetInstance.Connection.CriarQuery;
  DsProdutos := TConexao.GetInstance.Connection.CriarDataSource;
  DsProdutos.DataSet := TblProdutos;
end;

procedure TProdutoService.CriarCamposTabelas;
var
  FloatField: TFloatField;
  StringField: TStringField;
  DateField: TDateField;
  IntegerField: TIntegerField;
begin
  // Criando o campo COD_PRODUTO
  IntegerField := TIntegerField.Create(TblProdutos);
  IntegerField.FieldName := 'COD_PRODUTO';
  IntegerField.DataSet := TblProdutos;
  IntegerField.Name := 'TblProdutosCOD_PRODUTO';

  // Criando o campo NOME_PRODUTO
  StringField := TStringField.Create(TblProdutos);
  StringField.FieldName := 'DES_DESCRICAO';
  StringField.Size := 100;
  StringField.DataSet := TblProdutos;
  StringField.Name := 'TblProdutosDES_DESCRICAO';

  // Criando o campo VAL_PRECO
  FloatField := TFloatField.Create(TblProdutos);
  FloatField.FieldName := 'VAL_PRECO';
  FloatField.DataSet := TblProdutos;
  FloatField.Name := 'TblProdutosVAL_PRECO';
  FloatField.DisplayFormat := '#,###,##0.00';

end;

procedure TProdutoService.PreencherGridForm(APesquisa, ACampo: string);
begin
  with TblProdutos do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select prd.cod_produto, ');
    SQL.Add('prd.des_descricao, ');
    SQL.Add('prd.val_preco ');
    SQL.Add('from tab_produto prd');
    SQL.Add('where ' + ACampo + ' like :pNOME');
    SQL.Add('order by ' + ACampo);
    ParamByName('PNOME').AsString := APesquisa;
    Open();
  end;
end;

procedure TProdutoService.PreencherComboBox(TblProdutos: TFDQuery);
begin
  with TblProdutos do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from tab_produto prd order by prd.des_descricao ');
    Open();
  end;
end;

procedure TProdutoService.PreencherCamposForm(FProduto: TProduto; iCodigo: Integer);
begin
  with TblProdutos do
  begin
    SQL.Clear;
    SQL.Add('select prd.cod_produto');
    SQL.Add(',prd.des_descricao');
    SQL.Add(',prd.val_preco');
    SQL.Add('from tab_produto prd');
    SQL.Add('where cod_produto = :cod_produto');
    ParamByName('cod_produto').AsInteger := iCodigo;
    Open;

    FProduto.Cod_Produto := FieldByName('COD_PRODUTO').AsInteger;
    FProduto.Des_Descricao := FieldByName('DES_DESCRICAO').AsString;
    FProduto.Val_Preco := FieldByName('VAL_PRECO').AsFloat;
  end;
end;

function TProdutoService.GetValorUnitario(ACodigo: Integer): Double;
begin
  Result := 0;
  with QryTemp do
  begin
    SQL.Clear;
    SQL.Add('select cod_produto, ');
    SQL.Add('val_preco');
    SQL.Add('from tab_produto');
    SQL.Add('where cod_produto = :cod_produto');
    ParamByName('COD_PRODUTO').AsInteger := ACodigo;
    Open;
    Result := FieldByName('val_preco').AsFloat
  end;
end;

function TProdutoService.GetDataSource: TDataSource;
begin
  Result := DsProdutos;
end;


end.
