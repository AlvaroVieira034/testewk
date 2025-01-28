unit iinterface.repository;

interface

uses cliente.model, produto.model, Data.DB, System.SysUtils;

type
  IInterfaceRepository<T> = interface
    ['{B9F75D2C-E75F-4DAA-A595-F173214A7858}']
    function Inserir(AEntity: T; out sErro: string): Boolean;
    function Alterar(AEntity: T; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro : string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;

  end;

implementation

end.
