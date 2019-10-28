
use proyectoBD;

/* ----------------------------------------------------------------------
					ABM detallePedido
-----------------------------------------------------------------------*/
-- existe detallePedido
drop function if exists existeDetallePedido;
delimiter //
CREATE function existeDetallePedido(
	_idModelo int,
    _idPedido int)
    returns int
begin
	set @retorno = (select count(*) from detallePedido where idPedido = _idPedido and idModelo = _idModelo);
    return @retorno;
end
//
delimiter ;

-- verificar eliminado
drop function if exists detallePedidoEliminado;
delimiter //
CREATE function detallePedidoEliminado(
	_idModelo int,
    _idPedido int)
    returns int
begin
	set @eliminado = (select eliminado from detallePedido where idPedido = _idPedido and idModelo = _idModelo);
    return @eliminado;
end
//
delimiter ;



-- Traer Lista de modelos
drop procedure if exists traerDetallePedido;
delimiter //
CREATE PROCEDURE traerDetallePedido(
in _idPedido int)
BEGIN
    select m.idModeloVehiculo, m.modeloVehiculo, d.cantidad 
    from detallePedido d inner join modelo m on m.idModelo = d.idModelo 
    where eliminado =0 and idPedido = _idPedido;
END 
//
delimiter ;

-- Agregar detallePedido
drop procedure if exists altaDetallePedido;
delimiter //
CREATE PROCEDURE altaDetallePedido(
	in _idPedido int,
	in _idModelo int,
	in _cantidad int,
	out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    -- si no existe lo agrego
    set @existePedido = (select count(*) from pedido where idPedido = _idPedido);
    set @existeModelo = (select count(*) from modelo where idModelo = _idModelo);
    if @existePedido = 0 then
		select -1 into _valorRetorno;
        select 'error, no existe pedido' into _msjRetorno;
	else
		if @existeModelo = 0 then
			select -1 into _valorRetorno;
			select 'error, no existe modelo' into _msjRetorno;
		else
			if existeDetallePedido(_idModelo, _idPedido) <> 0 then
				if detallePedidoEliminado(_idModelo, _idPedido) = 0 then
					select -1 into _valorRetorno;
					select 'error, ya existe un detalle' into _msjRetorno;
				else 
					update detallePedido set eliminado = 0 where idPedido = _idPedido and idModelo = _idModelo;
					update detallePedido set fechaEliminado = null where idPedido = _idPedido and idModelo = _idModelo;
					update detallePedido set cantidad = _cantidad where idPedido = _idPedido and idModelo = _idModelo;
					select 1 into _valorRetorno;
					select 'detallePedido agregado nuevamente' into _msjRetorno;
				end if;
            else
				insert into detallePedido (idPedido,idModelo, cantidad) values (_idPedido, _idModelo, _cantidad);
				select 0 into _valorRetorno;
				select 'detallePedido agregado' into _msjRetorno;
            end if;
		end if;
	end if;
END 
//
delimiter ;

-- Eliminar detallePedido
drop procedure if exists bajadetallePedido;
delimiter //
CREATE PROCEDURE bajadetallePedido(
	in _idPedido int,
	in _idModelo int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	set @existePedido = (select count(*) from pedido where idPedido = _idPedido);
    set @existeModelo = (select count(*) from modelo where idModelo = _idModelo);
    if @existePedido = 0 then
		select -1 into _valorRetorno;
        select 'error, no existe pedido' into _msjRetorno;
	else
		if @existeModelo = 0 then
			select -1 into _valorRetorno;
			select 'error, no existe modelo' into _msjRetorno;
		else
			if detallePedidoEliminado(_idPedido, _idModelo) = 1 then
				select -1 into _valorRetorno;
				select 'error, ya se encuentra eliminado' into _msjRetorno;
			else
				set @existeAutomovil = (select count(*) from automovil where idPedido = _idPedido and idModelo = _idModelo and eliminado =0);
				if @existeAutomovil <>0 then
					select -2 into _valorRetorno;
					select 'error, ya existe automovil cargado' into _msjRetorno;
				else
					update detallePedido set eliminado = 1 where idPedido = _idPedido and idModelo = _idModelo; 
					update detallePedido set fechaEliminado = (select now()) where idPedido = _idPedido and idModelo = _idModelo; 
					select 0 into _valorRetorno;
					select 'detalle eliminado' into _msjRetorno;
				end if;
			end if;
		end if;
	end if;
END 
//
delimiter ;

-- -- Modificar modelo de detella pedido
drop procedure if exists modificarDetallePedidoModelo;
delimiter //
CREATE PROCEDURE modificarDetallePedidoModelo(
	in _idPedido int,
	in _idModelo int,
    in _nuevoIdModelo int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	set @existePedido = (select count(*) from pedido where idPedido = _idPedido);
    set @existeModelo = (select count(*) from modelo where idModelo = _idModelo);
    set @existeNuevoModelo = (select count(*) from modelo where idModelo = _nuevoIdModelo);
    if @existePedido = 0 then
		select -1 into _valorRetorno;
        select 'error, no existe pedido' into _msjRetorno;
	else
		if @existeModelo = 0 then
			select -1 into _valorRetorno;
			select 'error, no existe modelo' into _msjRetorno;
		else
			if @existeNuevoModelo = 0 then
				select -1 into _valorRetorno;
				select 'error, no existe nuevo modelo' into _msjRetorno;
			else
				if detallePedidoEliminado (_idPedido, _idModelo) <> 0 then
					select 'error, detallePedido eliminado' into _msjRetorno;
					select -1 into _valorRetorno;
				else
					if existedetallePedido(_idPedido, _nuevoIdModelo) <> 0 then
						select 'error, ya existe detallePedido con ese modelo' into _msjRetorno;
						select -1 into _valorRetorno;
					else
						update detallePedido set idModelo = _nuevoIdModelo where idPedido = _idPedido and idModelo = _idModelo; 
						select 'modelo de detallePedido modificado' into _msjRetorno;
						select 0 into _valorRetorno;
					end if;
				end if;
			end if;
		end if;
	end if;
END 
//
delimiter ;

-- Modificar cantidad de detella pedido
drop procedure if exists agregarCantidadDetallePedido;
delimiter //
CREATE PROCEDURE agregarCantidadDetallePedido(
	in _idPedido int,
	in _idModelo int,
    in _cant int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	set @existePedido = (select count(*) from pedido where idPedido = _idPedido);
    set @existeModelo = (select count(*) from modelo where idModelo = _idModelo);
    if @existePedido = 0 then
		select -1 into _valorRetorno;
        select 'error, no existe pedido' into _msjRetorno;
	else
		if @existeModelo = 0 then
			select -1 into _valorRetorno;
			select 'error, no existe modelo' into _msjRetorno;
		else
			if detallePedidoEliminado (_idPedido, _idModelo) <> 0 then
				select 'error, detallePedido eliminado' into _msjRetorno;
				select -1 into _valorRetorno;
			else
				set @cantidadActual = (select cantidad from detallePedido where idPedido = _idPedido and idModelo = _idModelo);
				update detallePedido set cantidad = (@cantidadActual+_cant)  where idPedido = _idPedido and idModelo = _idModelo; 
				select 'cantidad de detallePedido modificado' into _msjRetorno;
				select 0 into _valorRetorno;
			end if;
		end if;
	end if;
END 
//
delimiter ;