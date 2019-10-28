
use proyectoBD;

/* ----------------------------------------------------------------------
					ABM Pedido
-----------------------------------------------------------------------*/


-- existe Pedido
drop function if exists existePedido;
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

-- verificar eliminado
drop function if exists PedidoEliminado;
delimiter //
CREATE function PedidoEliminado(
	_idPedido int)
    returns int
begin
	set @eliminado = (select eliminado from pedido where idPedido= _idPedido);
    return @eliminado;
end
//
delimiter ;


-- Traer Lista de modelos
drop procedure if exists traerPedidos;
delimiter //
CREATE PROCEDURE traerPedidos()
BEGIN
    select p.idPedido, p.cuitConcesionaria from pedido p where eliminado = 0;
END 
//
delimiter ;

-- Agregar Pedido
drop procedure if exists altaPedido;
delimiter //
CREATE PROCEDURE altaPedido(
    in _cuitConcesionaria varchar(15),
    in _fechaHora datetime,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	set @existeConcesionara = (select count(*) from concesionaria where cuit = _cuitConcesionaria);
	if @existeConcesionaria =0 then
		select -1 into _valorRetorno;
		select 'error, no existe concesionaria' into _msjRetorno;
	else
		insert into pedido (idPedido,cuitConcesionaria, fechaHora ) 
					values (0,_cuitConcesionaria, _fechaHora );
		select 0 into _valorRetorno;
		select 'Pedido agregado' into _msjRetorno;
	end if;
END 
//
delimiter ;

-- Eliminar Pedido
drop procedure if exists bajaPedido;
delimiter //
CREATE PROCEDURE bajaPedido(
	in _idPedido int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	set @existe = (select count(*) from pedido where idPedido = _idPedido);
    if @existe = 0 then
		select 'error, no existe el pedido' into _msjRetorno;
		select -3 into _valorRetorno;
	else
		if PedidoEliminado(_idPedido) = 1 then
			select 'error, ya se encuentra eliminado' into _msjRetorno;
			select -1 into _valorRetorno;
		else
			set @existeDetalle = (select count(*) from detallePedido where idPedido = _idPedido and eliminado = 0);
			if @existeDetalle <> 0 then
				select 'error, ya existe detalle cargado' into _msjRetorno;
				select -2 into _valorRetorno;
			else
				update pedido set eliminado = 1 where idPedido= _idPedido; 
				update pedido set fechaEliminado = (select now()) where idPedido = _idPedido; 
				select 'pedido eliminado' into _msjRetorno;
				select 0 into _valorRetorno;
			end if;
		end if;
	end if;
END 
//
delimiter ;

-- Modificar fecha
drop procedure if exists modificarPedidoFecha;
delimiter //
CREATE PROCEDURE modificarPedidoFecha(
	in _idPedido int,
    in _nuevaFecha datetime,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	set @existe = (select count(*) from pedido where idPedido = _idPedido);
    if @existe = 0 then
		select 'error, no existe el pedido' into _msjRetorno;
		select -3 into _valorRetorno;
	else
		if PedidoEliminado(_idPedido) <> 0 then
			select 'error, Pedido eliminado' into _msjRetorno;
			select -1 into _valorRetorno;
		else
			update pedido set fechaHora = _nuevaFecha where idPedido = _idPedido;
			select 'Pedido modificado' into _msjRetorno;
			select 0 into _valorRetorno;
		end if;
	end if;
END 
//
delimiter ;

-- Modificar fecha
drop procedure if exists modificarPedidoConcesionaria;
delimiter //
CREATE PROCEDURE modificarPedidoConcesionaria(
	in _idPedido int,
    in _nuevoCuitConcesionaria varchar(15),
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	set @existe = (select count(*) from pedido where idPedido = _idPedido);
    if @existe = 0 then
		select 'error, no existe el pedido' into _msjRetorno;
		select -3 into _valorRetorno;
	else
		if PedidoEliminado(_idPedido) <> 0 then
			select 'error, Pedido eliminado' into _msjRetorno;
			select -1 into _valorRetorno;
		else
			update pedido set cuitConcesionaria = _nuevoCuitConcesionaria where idPedido = _idPedido;
			select 'Pedido modificado' into _msjRetorno;
			select 0 into _valorRetorno;
		end if;
	end if;
END 
//
delimiter ;
