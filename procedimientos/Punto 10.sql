/* ----------------------------------------------------------------------
PUNTO 10

Se requiere crear un procedimiento que al recibir como parámetro la patente del
automóvil, se finaliza la labor de la estación en la que se encuentra y se le ingresa
en la estación siguiente.

De la misma manera que se realizó en el punto anterior debe analizarse si es posible
ingresar el automóvil en dicha estación. En caso de o ser posible deberá informarse
la situación.

IMPORTANTE:
En caso de que la estación en la que estoy finalizando la labor sea la última de la
línea de montaje, debemos marcar el automóvil como finalizado, lo que implica
modificar la fecha de finalización del registro de la tabla vehiculos.

-----------------------------------------------------------------------*/

-- Primero vemos si existe el auto (si no existe nos vamos)
-- Despues vemos si esta finalizado (si esta finalizado nos vamos) IS NULL
-- Despues vemos si esta en una estacion (y cual) (si no esta nos vamos?)
-- Despues vemos si la siguiente estacion existe
-- a. Si no existe, hay que finalizar el auto
-- b. Si no esta libre, nos vamos
-- c. Si esta libre:
-- Primero actualizamos el estado de la estacion siguiente a ocupada
-- Actualizamos el estacionxauto
-- Creamos el estacionxauto nuevo
-- Actualizamos la estacion que estamos dejando
-- Prendemos fuego todo

use proyectoBD;

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


drop function if exists fechaFinalizado;
delimiter //
CREATE function fechaFinalizado(
	_codigoChasis int)
    returns int
begin
	set @retorno = (select count(*) from automovil where nroChasis=_codigoChasis and fechaTerminado is not null);
    return @retorno;
end
//
delimiter ;

drop procedure if exists traerEstacion;
delimiter //
CREATE PROCEDURE traerEstacion(
    in _nroChasis int,
    out _orden int,
    out _idLineaDeMontaje int)
BEGIN
	select e.nroOrden, e.idLineaDeMontaje into _orden, _idLineaDeMontaje 
    from estaciondetrabajo e
    inner join automovilxestacion a on e.idLineaDeMontaje=a.idLineaDeMontaje AND e.idTarea=a.idTarea
    where a.nroChasis=_nroChasis and a.horaIngreso IS NOT NULL and a.horaEgreso IS NULL;
END 
//
delimiter ;


drop function if exists siguienteEstacion;
delimiter //
CREATE function siguienteEstacion(
-- idLineaMontaje + orden actual , devuelve estacion?
	_idLineaMontaje int,
    _orden int)
    returns int
begin
	set @retorno = (select idTarea from estaciondetrabajo e where idLineaDeMontaje=_idLineaMontaje AND nroOrden=(_orden+1)); 
    return @retorno;
end
//
delimiter ;


drop procedure if exists continuarMontaje;
delimiter //
CREATE PROCEDURE continuarMontaje(
	in _codigoChasis int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
begin

-- Primero vemos si existe el auto (si no existe nos vamos)
if (existeAuto(_codigoChasis) = 0) then
	-- no existe el auto, nos vamos
	select 'Auto no existe' into _msjRetorno;
    select -1 into _valorRetorno;

-- vemos que el auto no este ya siendo montado
elseif (estaProcesado(_codigoChasis) = 0) then
	-- todavia no esta iniciado el proceso, nos vamos
	select 'Auto no procesado aun' into _msjRetorno;
    select -2 into _valorRetorno;
    
-- Despues vemos si esta finalizado (si esta finalizado nos vamos) 
elseif (fechaFinalizado(_codigoChasis) <> 0) then
	-- Este auto ya esta terminado
	select 'Auto ya terminado' into _msjRetorno;
    select -3 into _valorRetorno;

else
	-- Despues vemos en que estacion esta y si la siguiente estacion existe
	call traerEstacion(_codigoChasis, @_nroOrden, @_idLineaDeMontaje);
	set @_tareaEstacionSiguiente = siguienteEstacion(@_idLineaDeMontaje, @_nroOrden);
    select @_tareaEstacionSiguiente into _msjRetorno; 

	-- a. Si no existe, hay que finalizar el auto
	if (@_tareaEstacionSiguiente IS NULL) then
		-- Hay que terminar este auto.
		-- primero cerramos autoxestacion
		update automovilxestacion
		set horaEgreso= now()
		where nroChasis=_codigoChasis and horaIngreso IS NOT NULL and horaEgreso IS NULL;
		
        -- segundo fecha de fin de auto
		update automovil
		set fechaTerminado= now()
		where nroChasis=_codigoChasis;
		
        -- tercero actualizar estacion
		update estaciondetrabajo
		set ocupado=0
		where nroOrden=@_nroOrden and idLineaDeMontaje= @_idLineaDeMontaje;
	
    else
	-- b. Si esta ocupada, no se sigue
	set @_ocupado = (select ocupado from estaciondetrabajo where idTarea=@_tareaEstacionSiguiente and idLineaDeMontaje=@_idLineaDeMontaje);

	if ( @_ocupado = 1) then
		select 'Siguiente estacion ocupada' into _msjRetorno;
		select -4 into _valorRetorno;
    
	-- c. Si esta libre:    
	else
		-- Primero actualizamos el estado de la estacion siguiente a ocupada
		update estaciondetrabajo 
		set ocupado = 1 where idTarea=@_tareaEstacionSiguiente AND idLineaDeMontaje= @_idLineaDeMontaje;
		
		-- Actualizamos el estacionxauto
		update automovilxestacion
		set horaEgreso= now()
		where nroChasis=_codigoChasis and horaIngreso IS NOT NULL and horaEgreso IS NULL;
		
		-- Creamos el estacionxauto nuevo
		insert into automovilxestacion values (_codigoChasis, @_idLineaDeMontaje, @_tareaEstacionSiguiente, now(), null, null, null);

		-- Actualizamos la estacion que estamos dejando
		update estaciondetrabajo
		set ocupado=0
		where nroOrden=@_nroOrden and idLineaDeMontaje= @_idLineaDeMontaje;
        
        select 0 into _valorRetorno;
    
-- Prendemos fuego todo

end if;
end if;
end if;
end
//
delimiter ;