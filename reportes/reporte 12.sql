/*Cuarta etapa - Construcción de procedimientos de reportes
12) Dado un número de pedido, se requiere listar los insumos que será necesario
solicitar, indicando código de insumo y cantidad requerida para ese pedido.
**/

use proyectoBD;
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

drop procedure if exists insumosNecesarios;
-- Entrada: Numero de Pedido
-- Salida: Lista Insumos: Cod.Insumo, Cantidad
delimiter //
CREATE PROCEDURE insumosNecesarios(
	in _nroPedido int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
if existePedido(_nroPedido)<>0 then
SELECT 
    i.codigoInsumo AS CodInsumo,
    (SUM(i.cantidad) * d.cantidad) AS Cantidad
FROM
    insumoxestacion i
        INNER JOIN
    lineademontaje l ON l.idLineaDeMontaje = i.idLineaDeMontaje
        INNER JOIN
    modelo m ON m.idModelo = l.idModelo
        INNER JOIN
    detallepedido d ON d.idModelo = m.idModelo
        INNER JOIN
    pedido p ON p.idPedido = d.idPedido
WHERE
    p.idPedido = _nroPedido
GROUP BY CodInsumo;
else 
	select 'error, no existePedido' into _msjRetorno;
	select -1 into _valorRetorno;
end if;
END 
//
delimiter ;

insert into insumoxestacion values(1,101,1,2,null,null);
insert into insumoxestacion values(1,101,2,2,null,null);
insert into insumoxestacion values(2,102,2,5,null,null);
insert into insumoxestacion values(3,101,3,5,null,null);
SELECT 
    *
FROM
    pedido;
SELECT 
    *
FROM
    detallepedido;
SELECT 
    *
FROM
    modelo;
SELECT 
    *
FROM
    lineademontaje;
SELECT 
    *
FROM
    insumoxestacion;
-- PRUEBA 
select @msj, @valorRetorno;
call insumosNecesarios(1,@msj, @valorRetorno);
