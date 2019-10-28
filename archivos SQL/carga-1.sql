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

call altaInsumo(301, 'valvulas de admision', @m, @v);
call altaInsumo(302, 'cigueñal', @m, @v);

call altaInsumo(401, 'parabrisas', @m, @v);
call altaInsumo(402, 'cubiertas', @m, @v);

call altaInsumo(501, 'cable', @m, @v);
call altaInsumo(502, 'lampara', @m, @v);

call altaInsumo(601, 'bolsas de residuo', @m, @v);
call altaInsumo(601, 'tempera', @m, @v);

call traerInsumos();

-- Insumo por proveedor

call altaInsumoXproveedor(101, '30-11111111-1', 1000, @m, @v);
select @m, @v;
call altaInsumoXproveedor(102, '30-11111111-1', 2000, @m, @v);
call altaInsumoXproveedor(103, '30-11111111-2', 1500, @m, @v);

call altaInsumoXproveedor(201, '30-22222222-1', 1000, @m, @v);
call altaInsumoXproveedor(202, '30-22222222-1', 1000, @m, @v);

call altaInsumoXproveedor(301, '30-33333333-1', 1000, @m, @v);
call altaInsumoXproveedor(302, '30-33333333-1', 1000, @m, @v);

call altaInsumoXproveedor(401, '30-33333333-2', 1000, @m, @v);
call altaInsumoXproveedor(402, '30-33333333-2', 1000, @m, @v);

call altaInsumoXproveedor(501, '30-33333333-2', 1000, @m, @v);
call altaInsumoXproveedor(502, '30-33333333-2', 1000, @m, @v);

call altaInsumoXproveedor(601, '30-33333333-2', 1000, @m, @v);
call altaInsumoXproveedor(602, '30-33333333-2', 1000, @m, @v);

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
-- tarea
insert into tarea (idTarea, descripcion) values (1,'Pintura');
insert into tarea (idTarea, descripcion) values (2,'Ensamblado de Chapa');
insert into tarea (idTarea, descripcion) values (3,'Mecanica Motor');
insert into tarea (idTarea, descripcion) values (4,'Mecanica Rodaje');
insert into tarea (idTarea, descripcion) values (5,'Electricidad');
insert into tarea (idTarea, descripcion) values (6,'Prueba');

select * from tarea;

-- Lineas de Montaje
insert into lineaDeMontaje (idLineaDeMontaje,idModelo, promedio) values(1,1,500);
insert into lineaDeMontaje (idLineaDeMontaje,idModelo, promedio) values(2,2,1200);
insert into lineaDeMontaje (idLineaDeMontaje,idModelo, promedio) values(3,3,1500);
insert into lineaDeMontaje (idLineaDeMontaje,idModelo, promedio) values(4,4,2000);

select * from lineaDeMontaje;


-- Carga de estaciones de trabajo

insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(1,1,1);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(2,1,2);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(3,1,3);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(4,1,4);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(5,1,5);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(6,1,6);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(1,2,1);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(2,2,2);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(3,2,3);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(4,2,4);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(5,2,5);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(6,2,6);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(1,3,1);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(2,3,2);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(3,3,3);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(4,3,4);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(5,3,5);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(6,3,6);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(1,4,1);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(2,4,2);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(3,4,3);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(4,4,4);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(5,4,5);
insert into estacionDeTrabajo (idTarea,idLineaDeMontaje,nroOrden)values(6,4,6);

-- Insumo X Estacion

insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,101,1,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,102,1,4,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,103,1,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,101,2,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,102,2,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,103,2,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,101,3,4,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,102,3,5,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,103,3,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,101,4,4,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,102,4,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(1,103,4,3,0,null);



insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(2,201,2,1,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(2,202,2,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(2,201,1,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(2,202,1,5,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(2,201,3,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(2,202,3,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(2,201,4,1,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(2,202,4,3,0,null);

insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(3,301,3,1,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(3,302,3,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(3,301,1,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(3,302,1,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(3,301,2,4,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(3,302,2,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(3,301,4,1,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(3,302,4,2,0,null);

insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(4,401,3,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(4,402,3,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(4,401,2,4,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(4,402,2,4,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(4,401,1,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(4,402,1,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(4,401,4,4,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(4,402,4,4,0,null);

insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(5,502,4,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(5,501,4,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(5,502,3,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(5,501,3,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(5,502,2,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(5,501,2,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(5,502,1,3,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(5,501,1,3,0,null);



insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(6,601,4,1,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(6,601,3,2,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(6,601,2,1,0,null);
insert into insumoXestacion(idTarea,codigoInsumo ,idLineaDeMontaje,cantidad ,eliminado ,fechaEliminado)values(6,601,1,1,0,null);



