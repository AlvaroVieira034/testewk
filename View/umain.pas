unit umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrmMain = class(TForm)
    PanelBotoesMenu: TPanel;
    BtnSair: TSpeedButton;
    BtnVendas: TSpeedButton;
    BtnProdutos: TSpeedButton;
    BtnClientes: TSpeedButton;
    Timer1: TTimer;
    ImageList: TImageList;
    procedure BtnSairClick(Sender: TObject);
    procedure BtnClientesClick(Sender: TObject);
    procedure BtnProdutosClick(Sender: TObject);
    procedure BtnVendasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}


uses ucadcliente, ucadproduto, ucadpedido;


procedure TFrmMain.BtnClientesClick(Sender: TObject);
begin
  if not Assigned(FrmCadCliente) then
    FrmCadCliente := TFrmCadCliente.Create(Self);

  FrmCadCliente.ShowModal;
  FrmCadCliente.Free;
  FrmCadCliente := nil;
end;

procedure TFrmMain.BtnProdutosClick(Sender: TObject);
begin
  if not Assigned(FrmCadProduto) then
    FrmCadProduto := TFrmCadProduto.Create(Self);

  FrmCadProduto.ShowModal;
  FrmCadProduto.Free;
  FrmCadProduto := nil;
end;

procedure TFrmMain.BtnVendasClick(Sender: TObject);
begin
  if not Assigned(FrmCadPedido) then
    FrmCadPedido := TFrmCadPedido.Create(Self);

  FrmCadPedido.ShowModal;
  FrmCadPedido.Free;
  FrmCadPedido := nil;
end;

procedure TFrmMain.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
