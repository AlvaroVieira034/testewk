unit ucadastropadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmCadastroPadrao = class(TForm)
    PnlTopo: TPanel;
    BtnInserir: TSpeedButton;
    BtnAlterar: TSpeedButton;
    BtnExcluir: TSpeedButton;
    BtnGravar: TSpeedButton;
    BtnCancelar: TSpeedButton;
    BtnSair: TSpeedButton;
    PnlDados: TPanel;
    GrbDados: TGroupBox;
    PnlGrid: TPanel;
    LblTotRegistros: TLabel;
    GrbGrid: TGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCadastroPadrao: TFrmCadastroPadrao;

implementation

{$R *.dfm}

end.
