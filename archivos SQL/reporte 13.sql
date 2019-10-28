/*Cuarta etapa - Construcción de procedimientos de reportes
13) Dada una línea de montaje, indicar el tiempo promedio de construcción de los
vehículos (tener en cuenta sólo los vehículos terminados).
**/
use proyectoBD;
-- Entrada: Numero Linea de Montaje
-- Salida: Promedio de construccion de Vehiculos (en Horas)
-- Funcion para saber si el pedido Existe, y realizar validaciones cuando se ejecute el procedimiento vehiculosFinalizados
drop function if exists existeLineaMontaje;
delimiter //
CREATE function existeLineaMontaje(
	_idLineaMontaje int)
    returns int
begin
	set @retorno = (select count(*) from lineademontaje where idLineaDeMontaje= _idLineaMontaje);
    return @retorno;
end
//
delimiter ;

drop procedure if exists promedioConstruccion;
-- Entrada: Numero de Pedido
-- Salida: Lista Insumos: Cod.Insumo, Cantidad
delimiter //
CREATE PROCEDURE promedioConstruccion(
	in _lineaDeMontaje int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
if existeLineaMontaje(_lineaDeMontaje)<>0 then
SELECT 
   AVG(TIMESTAMPDIFF(HOUR, e.horaIngreso,a.fechaTerminado)) AS Promedio
FROM
    Automovil a
        INNER JOIN
    automovilXestacion e ON e.nroChasis = a.nroChasis
        INNER JOIN
	estaciondetrabajo es ON es.idLineaDeMontaje = e.idLineaDeMontaje
		INNER JOIN
    lineademontaje l ON l.idLineaDeMontaje = e.idLineaDeMontaje
WHERE
    e.idlineaDeMontaje = _lineaDeMontaje
    AND es.nroOrden=1;
else 
	select 'error, no existe Linea de Montaje' into _msjRetorno;
	select -1 into _valorRetorno;
end if;
END 
//
delimiter ;
SELECT 
    *
FROM
    automovil;
SELECT 
    *
FROM
    automovilxestacion;
SELECT 
    *
FROM
    estaciondetrabajo;
UPDATE automovil 
SET 
    fechaTerminado = '2019-12-27 18:00:00'
WHERE
    nroChasis = 789;
SELECT @msj, @valorRetorno;
call promedioConstruccion(1,@msj,@valorRetorno);

