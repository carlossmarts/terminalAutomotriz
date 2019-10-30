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
-- Salida: Lista Automovil: nroChasis,estado (En proceso o Terminado) estacion (compuesta por la Tarea y la Linea de Monataje)
-- La estacion solo se indica si el Automovil no esta terminado
CREATE PROCEDURE vehiculosFinalizados(
	in _nroPedido int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
if existePedido(_nroPedido)<>0 then
SELECT 
    a.nroChasis,
    a.idPedido,
    'En proceso' AS estado,
    e.idTarea AS tarea,
    e.idLineaDeMontaje AS linea
FROM
    Automovil a
        INNER JOIN
    automovilxestacion e ON e.nroChasis = a.nroChasis
WHERE
    idPedido = _nroPedido
    and e.horaIngreso = (SELECT 
            MAX(horaIngreso)
        FROM
            automovilxestacion axe
        WHERE
            a.idPedido = _nroPedido AND horaEgreso IS NULL AND e.nroChasis = axe.nroChasis)
UNION SELECT 
    a.nroChasis,
    a.idPedido,
    'Terminado' AS estado,
    0 AS tarea,
    0 AS linea
FROM
    Automovil a
WHERE
    a.fechaTerminado is not null
    and idPedido=_nroPedido
UNION SELECT 
	a.nroChasis,
    a.idPedido,
    'Pendiente' AS estado,
    0 AS tarea,
    0 AS linea
FROM Automovil a
WHERE NOT exists (SELECT NULL FROM automovilXestacion e WHERE e.nroChasis = a.nroChasis) AND idPedido=_nroPedido ;
else 
	select 'error, no existePedido' into _msjRetorno;
	select -1 into _valorRetorno;
end if;
END 
//
delimiter ;
-- PRUEBA REPORTE 11
SELECT @msj, @valoRetorno;
call procesarPedido (1,@m,@v);
call iniciarMontaje(1,@msj,@valor);
call iniciarMontaje(3,@msj,@valor);
call iniciarMontaje(2,@msj,@valor);
call iniciarMontaje(6,@msj,@valor);
call continuarMontaje(1,@m,@v);
call continuarMontaje(1,@m,@v);
call continuarMontaje(1,@m,@v);
call continuarMontaje(1,@m,@v);
call continuarMontaje(1,@m,@v);
call continuarMontaje(1,@m,@v);
call continuarMontaje(2,@m,@v);
call vehiculosFinalizados(1,@msj,@valorRetorno);
SELECT @msj, @valor;
-- -----------------------------------------------------------------------------------

