-- Test 9
/*
9) Se requiere crear un procedimiento que al recibir como parámetro la patente del
automóvil, se le dé inicio al montaje del mismo, es decir, que al ejecutar dicho
procedimiento el automóvil con la patente indicada es “posicionado” en la primer
estación de la línea de montaje que le fue asignada al crear el vehículo con el
procedimiento (8)
Nota: No puede ingresarse el vehículo en la estación de trabajo si es que hay otro
automóvil en dicho lugar.
En caso de no ser posible la inserción del vehículo en la primer estación por
encontrarse ocupada, deberá retornar un resultado informando esta situación,
además del chasis del vehículo que está ocupando dicha estación.
*/
select @msj, @valor;

call iniciarMontaje(1,@msj,@valor);
call iniciarMontaje(2,@msj,@valor);
call iniciarMontaje(3,@msj,@valor);
call iniciarMontaje(4,@msj,@valor);

select * from pedido;
select * from detallePedido;
select * from automovilXestacion;
select idLineaDeMontaje, idTarea, ocupado from estacionDeTrabajo order by idLineaDeMontaje, idTarea;

select * from estacionDeTrabajo where idLineaDeMontaje = 1;

select * from lineaDeMontaje;