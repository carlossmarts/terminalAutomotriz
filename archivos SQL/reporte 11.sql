use proyectoBD;
/*
		Cuarta etapa - Construcción de procedimientos de reportes
11) Dado un número de pedido, se requiere listar los vehículos indicando el chasis, si se
encuentra finalizado, y si no esta terminado, indicar en qué estación se encuentra.
**/

-- Funcion para saber si el pedido Existe, y realizar validaciones cuando se ejecute el procedimiento vehiculosFinalizados
delimiter //
CREATE function existePedido(
	_idPedido int)
    returns int
begin
	set @retorno = (select count(*) from pedido where idPedido= _idPedido);
    return @retorno;
end
//
delimiter ;

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
if existePedido(_nroPedido)<>0 then
-- En Caso de que Exista el Pedido, se listan los automoviles con ese pedido que esten en las estaciones de trabajo
	select a.nroChasis, a.idPedido , (select fechaTerminado is not null)as terminado, e.idTarea as tarea, e.idLineaDeMontaje as linea
		from Automovil a inner join automovilxestacion e on e.nroChasis = a.nroChasis
			where idPedido = _nroPedido
			UNION 
-- Se agregan al Listado los Automoviles que estan terminados
	SELECT  a.nroChasis, a.idPedido , (select fechaTerminado is not null)as terminado, 0 as tarea, 0 as linea 
		from Automovil a 
			WHERE NOT exists(SELECT * FROM automovilXestacion e1 WHERE e1.nroChasis = a.nroChasis) ;
else 
	select 'error, no existePedido' into _msjRetorno;
	select -1 into _valorRetorno;
end if;
END 
//
delimiter ;
insert into automovil values(1234, 1, 1, null,null,now());
insert into automovil values(4567, 1, 1, null,null,now());
insert into automovil values(789, 1, 1, null,null,null);
insert into automovilxestacion values(789,1,1,now(),null,null,null);
SELECT 
    *
FROM
    automovil;
SELECT 
    *
FROM
    automovilXestacion;
SELECT @msj, @valoRetorno;
call vehiculosFinalizados(1,@msj,@valorRetorno);




