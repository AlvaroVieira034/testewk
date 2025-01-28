unit cliente.service;

interface

uses iinterface.service, cliente.model, conexao, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
     Data.DB;

type
  TClienteService = class(TInterfacedObject, IInterfaceService<TCliente>)

  private
    TblClientes: TFDQuery;
    QryTemp: TFDQuery;
    DsClientes: TDataSource;

  public
    constructor Create;
    destructor Destroy; override;
    procedure PreencherGridForm(APesquisa, ACampo: string);
    procedure PreencherComboBox(TblClientes: TFDQuery);
    procedure PreencherCamposForm(FCliente: TCliente; ACodigo: Integer);
    procedure CriarTabelas;
    function GetDataSource: TDataSource;

  end;

implementation

{ TClienteService }

constructor TClienteService.Create;
begin
  CriarTabelas();
end;

destructor TClienteService.Destroy;
begin
  TblClientes.Free;
  QryTemp.Free;
  DsClientes.Free;
  inherited;
end;


procedure TClienteService.CriarTabelas;
begin
  TblClientes := TConexao.GetInstance.Connection.CriarQuery;
  QryTemp := TConexao.GetInstance.Connection.CriarQuery;
  DsClientes := TConexao.GetInstance.Connection.CriarDataSource;
  DsClientes.DataSet := TblClientes;
end;

function TClienteService.GetDataSource: TDataSource;
begin
  Result := DsClientes;
end;

procedure TClienteService.PreencherGridForm(APesquisa, ACampo: string);
begin
  with TblClientes do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select cli.cod_cliente,  ');
    SQL.Add('cli.des_nomecliente, ');
    SQL.Add('cli.des_cep, ');
    SQL.Add('cli.des_cidade, ');
    SQL.Add('cli.des_uf ');
    SQL.Add('from tab_cliente cli');
    SQL.Add('where ' + ACampo + ' like :pNOME');
    SQL.Add('order by ' + ACampo);
    ParamByName('PNOME').AsString := APesquisa;
    Open();
  end;
end;

procedure TClienteService.PreencherComboBox(TblClientes: TFDQuery);
begin
  with TblClientes do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from tab_cliente order by des_nomecliente ');
    Open();
  end;
end;

procedure TClienteService.PreencherCamposForm(FCliente: TCliente; ACodigo: Integer);
begin
  with TblClientes do
  begin
    SQL.Clear;
    SQL.Add('select cli.cod_cliente,  ');
    SQL.Add('cli.des_nomecliente, ');
    SQL.Add('cli.des_cep, ');
    SQL.Add('cli.des_cidade, ');
    SQL.Add('cli.des_uf ');
    SQL.Add('from tab_cliente cli');
    SQL.Add('where cod_cliente = :cod_cliente');
    ParamByName('cod_cliente').AsInteger := ACodigo;
    Open;

    FCliente.Cod_Cliente := FieldByName('COD_CLIENTE').AsInteger;
    FCliente.Des_NomeCliente := FieldByName('DES_NOMECLIENTE').AsString;
    FCliente.Des_Cep := FieldByName('DES_CEP').AsString;
    FCliente.Des_Cidade := FieldByName('DES_CIDADE').AsString;
    FCliente.Des_UF := FieldByName('DES_UF').AsString;
  end;
end;

end.
