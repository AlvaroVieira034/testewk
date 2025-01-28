unit conexao;

interface

uses connection, System.SysUtils;

type
  // Singleton
  TConexao = class
    private
      FConnection: TConnection;
      constructor Create;
      destructor Destroy; override;

    public
      property Connection: TConnection read FConnection write FConnection;
      class function GetInstance: TConexao;

  end;

implementation

{ TConexao}

var
  InstanciaBD: TConexao;


constructor TConexao.Create;
begin
  inherited Create;
  FConnection := TConnection.Create;
end;

destructor TConexao.Destroy;
begin

  inherited;
  FreeAndNil(FConnection);
end;

class function TConexao.GetInstance: TConexao;
begin
  if InstanciaBD = nil then
    InstanciaBD := TConexao.Create;

  Result := InstanciaBD
end;

initialization
  InstanciaBD := nil;

finalization
  if InstanciaBD <> nil then
    InstanciaBD.Free;

end.
