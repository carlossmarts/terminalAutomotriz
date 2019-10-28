use proyectoBD;
/*
11) Dado un número de pedido, se requiere listar los vehículos indicando el chasis, si se
encuentra finalizado, y si no esta terminado, indicar en qué estación se encuentra.
*/


drop procedure if exists vehiculosFinalizados;
delimiter //
-- Entrada: Numero de Pedido
-- Salida: Lista Automovil: nroChasis, terminado (1=si o 0=no), estacion (compuesta por la Tarea y la Linea de Monataje)
-- La estacion solo se indica si el Automovil no esta terminado
CREATE PROCEDURE vehiculosFinalizados(
	in _nroPedido int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	set @existePedido = (select count(*) from pedido where idPedido = _nroPedido;
    
	if @existePedido <>0 then
	-- En Caso de que Exista el Pedido, se listan los automoviles con ese pedido que esten en las estaciones de trabajo
		select idTarea, idLineaDeMontaje, nroChasis, 'en proceso' as estado from automovilxestacion 
		where horaIngreso = (select max(horaIngreso) from automovilxestacion where nroChasis = 3 and horaEgreso is null);
	-- Se agregan al Listado los Automoviles que estan terminados
    else 
		select 'error, no existePedido' into _msjRetorno;
		select -1 into _valorRetorno;
	end if;
	END 
//
delimiter ;