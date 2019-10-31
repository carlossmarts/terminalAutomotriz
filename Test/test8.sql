use proyectoBD;
-- test
call procesarPedido (1,@m,@v);
select @m, @v;
select * from pedido where idPedido=1;
select m.modeloVehiculo, d.cantidad from detallePedido d inner join modelo m on d.idModelo=m.idModelo where idPedido=1;
select * from automovil;
select m.modeloVehiculo from automovil a inner join modelo m on a.idModelo = m.idModelo where idPedido=1;
select * from automovilxestacion;
select * from estacionDeTrabajo order by idLineaDeMontaje, idTarea;
select * from lineaDeMontaje;