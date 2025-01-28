unit iinterface.service;

interface

uses cliente.model, produto.model, Data.DB, FireDAC.Comp.Client;

type
  IInterfaceService<T> = interface
    ['{F79EFB7B-4807-468D-A3C2-0958FA3FAB5D}']
    procedure PreencherGridForm(APesquisa, ACampo: string);
    procedure PreencherComboBox(TblComboClientes: TFDQuery);
    procedure PreencherCamposForm(AEntity: T; ACodigo: Integer);
    procedure CriarTabelas;
    function GetDataSource: TDataSource;

  end;

implementation

end.
