/* ********************************************************
					CARGA DE DATOS
***********************************************************/
use proyectoBD;
-- Proveedores
call altaProveedor('30-11111111-1', 'pintureria', @m, @v);

call altaProveedor('30-11111111-2', 'pintureria2', @m, @v);

call altaProveedor('30-22222222-1', 'metalurgica', @m, @v);

call altaProveedor('30-33333333-1', 'vidrieria', @m, @v);

call traerProveedores;

-- Insumos

call altaInsumo(101, 'pintura roja', @m, @v);
call altaInsumo(102, 'pintura azul', @m, @v);
call altaInsumo(103, 'pintura verde', @m, @v);

call altaInsumo(201, 'chapa techo', @m, @v);
call altaInsumo(202, 'chapa puerta', @m, @v);

call altaInsumo(301, 'parabrisas', @m, @v);

call traerInsumos();

-- Insumo por proveedor

call altaInsumoXproveedor(101, '30-11111111-1', 1000, @m, @v);
select @m, @v;
call altaInsumoXproveedor(102, '30-11111111-1', 2000, @m, @v);
call altaInsumoXproveedor(103, '30-11111111-2', 1500, @m, @v);

call altaInsumoXproveedor(201, '30-22222222-1', 1000, @m, @v);
call altaInsumoXproveedor(202, '30-22222222-1', 1000, @m, @v);

call altaInsumoXproveedor(301, '30-33333333-1', 1000, @m, @v);

call traerInsumosXproveedores();

-- Concesionaria
call altaConcesionaria('20-12345678-1', @m, @v);
call altaConcesionaria('20-87654321-1', @m, @v);

call traerConcesionarias();

-- Modelo

call altaModelo('Fiat uno', @m, @v);
call altaModelo('Fiat cronos', @m, @v);
call altaModelo('Fiat argo', @m, @v);
call altaModelo('Fiorino', @m, @v);

-- Pedido
call altaPedido('20-12345678-1',now(), @m, @v);
call altaPedido('20-87654321-1',now(), @m, @v);

-- DetallePedido
select * from pedido;
select * from modelo;
call altaDetallePedido(1, 1, 5, @m, @v);
call altaDetallePedido(1, 2, 3, @m, @v);
call altaDetallePedido(1, 4, 2, @m, @v);
call altaDetallePedido(2, 1, 1, @m, @v);
call altaDetallePedido(2, 2, 2, @m, @v);
call altaDetallePedido(2, 3, 3, @m, @v);
call altaDetallePedido(2, 4, 4, @m, @v);

call traerDetallePedidoXpedido(1);
call traerDetallePedidoXpedido(2);

call traerDetallePedidoXmodelo(1);
call traerDetallePedidoXmodelo(2);
call traerDetallePedidoXmodelo(3);
call traerDetallePedidoXmodelo(4);
