/* ----------------------------------------------------------------------
					punto 9

Se requiere crear un procedimiento que al recibir como parámetro la patente del
automóvil, se le dé inicio al montaje del mismo, es decir, que al ejecutar dicho
procedimiento el automóvil con la patente indicada es “posicionado” en la primer
estación de la línea de montaje que le fue asignada al crear el vehículo con el
procedimiento (8)
                    
-----------------------------------------------------------------------*/
use proyectoBD;

drop function if exists estaProcesado;
delimiter //
CREATE function estaProcesado(
	_codigoChasis varchar(15))
    returns int
begin
	set @retorno = (select count(*) from automovilxestacion where nroChasis=_codigoChasis);
    return @retorno;
end
//
delimiter ;

drop function if exists existeAuto;
delimiter //
CREATE function existeAuto(
	_codigoChasis varchar(15))
    returns int
begin
	set @retorno = (select count(*) from automovil where nroChasis=_codigoChasis);
    return @retorno;
end
//
delimiter ;


drop procedure if exists iniciarMontaje;
delimiter //
CREATE PROCEDURE iniciarMontaje(
	in _codigoChasis int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
begin

DECLARE estaOcupado bit(1) DEFAULT 0;

-- vemos que el auto exista
if (existeAuto(_codigoChasis) = 0) then
	-- no existe el auto, nos vamos
	select 'Auto no existe' into _msjRetorno;
    select -1 into _valorRetorno;

-- vemos que el auto no este ya siendo montado
elseif (estaProcesado(_codigoChasis) <> 0) then
	-- ya esta procesado el auto, nos vamos
	select 'Auto ya procesado' into _msjRetorno;
    select -2 into _valorRetorno;

-- vemos que no este ubicado otro auto
else
	-- tengo que seleccionar la estacion correspondiente (linea para el modelo del auto, orden 1)
	set @_idModelo = (select idModelo from automovil where nroChasis=_codigoChasis);
	select e.ocupado from estaciondetrabajo e 
    inner join lineademontaje l on e.idLineaDeMontaje = l.idLineaDeMontaje
    where l.idModelo= @_idModelo AND e.nroOrden = 1
    into estaOcupado;
    
    set @_idTarea = (select e.idTarea from estaciondetrabajo e 
    inner join lineademontaje l on e.idLineaDeMontaje = l.idLineaDeMontaje
    where l.idModelo= @_idModelo AND e.nroOrden = 1);
    
    set @_idLinea = (select e.idLineaDeMontaje from estaciondetrabajo e 
    inner join lineademontaje l on e.idLineaDeMontaje = l.idLineaDeMontaje
    where l.idModelo= @_idModelo AND e.nroOrden = 1);
    
	-- vemos que no este ubicado otro auto
    if (estaOcupado = 1) then
		-- si esta ocupado
		select 'Lugar no disponible' into _msjRetorno;
		select -3 into _valorRetorno;    
    else
		-- montamos el auto: 
		-- 	generamos el automovilxestacion
		insert into automovilxestacion values (_codigoChasis, @_idLinea, @_idTarea, now(), null, null, null);
		-- 	actualizamos el ocupado (aca hay que arreglar ese where)
		update estaciondetrabajo e
        inner join lineademontaje l ON e.idLineaDeMontaje = l.idLineaDeMontaje
        set ocupado = 1 where l.idModelo= @_idModelo AND e.nroOrden = 1;
	end if;
end if;
end
//
delimiter ;