program TesteWK;

uses
  Vcl.Forms,
  umain in 'View\umain.pas' {FrmMain},
  cliente.model in 'Model\cliente.model.pas',
  produto.model in 'Model\produto.model.pas',
  pedido.model in 'Model\pedido.model.pas',
  pedidoitens.model in 'Model\pedidoitens.model.pas',
  ucadastropadrao in 'View\ucadastropadrao.pas' {FrmCadastroPadrao},
  ucadcliente in 'View\ucadcliente.pas' {FrmCadCliente},
  iinterface.repository in 'Interface\iinterface.repository.pas',
  conexao in 'Util\conexao.pas',
  connection in 'Util\connection.pas',
  iinterface.service in 'Interface\iinterface.service.pas',
  ipedido.repository in 'Interface\ipedido.repository.pas',
  ipedido.service in 'Interface\ipedido.service.pas',
  ipedidoitens.repository in 'Interface\ipedidoitens.repository.pas',
  cliente.repository in 'Dao\cliente.repository.pas',
  cliente.service in 'Dao\cliente.service.pas',
  cliente.controller in 'Controller\cliente.controller.pas',
  cep.service in 'Util\cep.service.pas',
  ucadproduto in 'View\ucadproduto.pas' {FrmCadProduto},
  produto.service in 'Dao\produto.service.pas',
  produto.repository in 'Dao\produto.repository.pas',
  produto.controller in 'Controller\produto.controller.pas',
  untFormat in 'Util\untFormat.pas',
  pedido.repository in 'Dao\pedido.repository.pas',
  pedido.service in 'Dao\pedido.service.pas',
  pedidoitens.repository in 'Dao\pedidoitens.repository.pas',
  pedido.controller in 'Controller\pedido.controller.pas',
  pedidoitens.controller in 'Controller\pedidoitens.controller.pas',
  upesqpedidos in 'View\upesqpedidos.pas' {FrmPesquisaPedidos},
  ucadpedido in 'View\ucadpedido.pas' {FrmCadPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
