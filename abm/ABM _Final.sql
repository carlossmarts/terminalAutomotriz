-- SCRIPT ABMS DE concesionaria terminal automotriz
set global log_bin_trust_function_creators=1;
use proyectoBD;


/* ----------------------------------------------------------------------
					ABM proveedor
-----------------------------------------------------------------------*/
-- existe Proveedor
drop function if exists existeProveedor;
delimiter //
CREATE function existeProveedor(
	_cuit varchar(15))
    returns int
begin
	set @retorno = (select count(*) from proveedor where cuit= _cuit);
    return @retorno;
end
//
delimiter ;

-- verificar eliminado
drop function if exists ProveedorEliminado;
delimiter //
CREATE function ProveedorEliminado(
	_cuit varchar(15))
    returns int
begin
	set @eliminado = (select eliminado from proveedor where cuit = _cuit);
    return @eliminado;
end
//
delimiter ;

-- Traer Lista de modelos
drop procedure if exists traerProveedores;
delimiter //
CREATE PROCEDURE traerProveedores()
BEGIN
    select cuit, nombre from proveedor where eliminado =0;
END 
//
delimiter ;

-- Agregar Proveedor
drop procedure if exists altaProveedor;
delimiter //
CREATE PROCEDURE altaProveedor(
	in _cuit varchar(15),
    in _nombre varchar(45),
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	if existeProveedor (_cuit) <> 0 and ProveedorEliminado (_cuit) = 0 then
		select -1 into _valorRetorno;
        select 'error, ya existe proveedor con ese cuit' into _msjRetorno;
	else
		if ProveedorEliminado (_cuit) <> 0 then
            update proveedor set eliminado = 0 where cuit = _cuit;
            update proveedor set fechaEliminado = null where cuit = _cuit;
            call modificarNombreProveedor(_cuit, _nombre, @ms, @va);
            select 1 into _valorRetorno;
			select 'Proveedor agregado nuevamente' into _msjRetorno;
		else
			insert into proveedor (cuit, nombre) values (_cuit, _nombre);
            select 0 into _valorRetorno;
			select 'Proveedor agregado' into _msjRetorno;
		end if;
	end if;
		
END 
//
delimiter ;

-- Eliminar Proveedor
drop procedure if exists bajaProveedor;
delimiter //
CREATE PROCEDURE bajaProveedor(
	in _cuit varchar(15),
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	if ProveedorEliminado(_cuit) then
		select 'error, Proveedor eliminado' into _msjRetorno;
        select -1 into _valorRetorno;
	else
		set @existeIXP = (select count(*) from insumoXproveedor where  cuit = _cuit and eliminado = 0);
        if @existeIXP <> 0 then
			select 'error, existe insumo cargado' into _msjRetorno;
			select -2 into _valorRetorno;
        else
			update proveedor set eliminado = 1 where cuit= _cuit; 
			update proveedor set fechaEliminado = (select now()) where cuit = _cuit; 
            select 'Proveedor eliminado' into _msjRetorno;
			select 0 into _valorRetorno;
		end if;
	end if;
    if existeProveedor(_cuit)= 0 then
		select 'error, no existe proveedor' into _msjRetorno;
		select 0 into _valorRetorno;
	end if;
END 
//
delimiter ;

-- Modificar cuit
drop procedure if exists modificarCuitProveedor;
delimiter //
CREATE PROCEDURE modificarCuitProveedor(
	in _cuit varchar(15),
    in _nuevoCuit varchar(15),
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    if proveedorEliminado(_cuit) <> 0 then
		select 'error, Proveedor eliminado' into _msjRetorno;
        select -1 into _valorRetorno;
	else
        if existeProveedor(_nuevoCuit) <> 0 then
			select 'error, ya existe Proveedor con ese cuit' into _msjRetorno;
            select -1 into _valorRetorno;
		else
			update proveedor set cuit = _nuevoCuit where cuit= _cuit;
            select 'Proveedor modificado' into _msjRetorno;
            select 0 into _valorRetorno;
		end if;
    end if;
END 
//
delimiter ;


-- Modificar nombre
drop procedure if exists modificarNombreProveedor;
delimiter //
CREATE PROCEDURE modificarNombreProveedor(
	in _cuit varchar(15),
    in _nuevoNombre varchar(15),
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    if proveedorEliminado(_cuit) <> 0 then
		select 'error, Proveedor eliminado' into _msjRetorno;
        select -1 into _valorRetorno;
	else
		if existeProveedor(_cuit)=0 then
			select 'no existe proveedor' into _msjRetorno;
            select -2 into _valorRetorno;
		else
			update proveedor set nombre = _nuevoNombre where cuit= _cuit;
            select 'Proveedor modificado' into _msjRetorno;
            select 0 into _valorRetorno;
		end if;
    end if;
END 
//
delimiter ;


/* ----------------------------------------------------------------------
					ABM insumo
-----------------------------------------------------------------------*/
drop function if exists existeInsumo;
delimiter //
CREATE function existeInsumo(
	_codigoInsumo int)
    returns int
begin
	set @retorno = (select count(*) from insumo where codigoInsumo= _codigoInsumo);
    return @retorno;
end
//
delimiter ;

-- verificar eliminado
drop function if exists insumoEliminado;
delimiter //
CREATE function insumoEliminado(
	_codigoInsumo int)
    returns int
begin
	set @eliminado = (select eliminado from insumo where codigoInsumo = _codigoInsumo);
    return @eliminado;
end
//
delimiter ;

-- Traer Lista de modelos
drop procedure if exists traerInsumos;
delimiter //
CREATE PROCEDURE traerInsumos()
BEGIN
    select codigoInsumo, descripcion from insumo where eliminado =0;
END 
//
delimiter ;

-- Agregar Insumo
drop procedure if exists altaInsumo;
delimiter //
CREATE PROCEDURE altaInsumo(
	in _codigoInsumo int,
    in _descripcion varchar(45),
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    -- si no existe lo agrego
	if existeInsumo (_codigoInsumo) <> 0 and insumoEliminado(_codigoInsumo) = 0 then
		select -1 into _valorRetorno;
        select 'error, ya existe codigo de insumo' into _msjRetorno;
	else
		if insumoEliminado (_codigoInsumo) <> 0 then
            update insumo set eliminado = 0 where codigoInsumo = _codigoInsumo;
            update insumo set fechaEliminado = null where codigoInsumo = _codigoInsumo;
            call modificarDescripcionInsumo(_codigoInsumo, _descripcion, @ms, @va);
            select 1 into _valorRetorno;
			select 'Insumo agregado nuevamente' into _msjRetorno;
		else
			insert into insumo (codigoInsumo, descripcion) values (_codigoInsumo, _descripcion);
            select 0 into _valorRetorno;
			select 'Insumo agregado' into _msjRetorno;
		end if;
	end if;
		
END 
//
delimiter ;

-- Eliminar Insumo
drop procedure if exists bajaInsumo;
delimiter //
CREATE PROCEDURE bajaInsumo(
	in _codigoInsumo int,
	out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	if insumoEliminado(_codigoInsumo) = 1 then
		select -1 into _valorRetorno;
		select 'error, Insumo eliminado' into _msjRetorno;
	else
		set @existeIXP =(select count(*) from insumoXproveedor where codigoInsumo = _codigoInsumo and eliminado = 0);
        set @existeIXE =(select count(*) from insumoXestacion where codigoInsumo = _codigoInsumo and eliminado = 0);
        if @existeIXP <> 0 then
			select -2 into _valorRetorno;
			select 'error, existeInsumo por proveedor cargado' into _msjRetorno;
		else
			if @existeIXE <> 0 then
				select -3 into _valorRetorno;
				select 'error, existe insumo por estación cargado' into _msjRetorno;
			else
				select 0 into _valorRetorno;
				select 'Isumo eliminado' into _msjRetorno;
				update insumo set eliminado = 1 where codigoInsumo= _codigoInsumo; 
				update insumo set fechaEliminado = (select now()) where codigoInsumo= _codigoInsumo; 
			end if;
		end if;
	end if;
    if existeInsumo(_codigoInsumo)= 0 then
		select 'error, no existe insumo' into _msjRetorno;
		select -3 into _valorRetorno;
	end if;
    
END 
//
delimiter ;

-- Modificar codigo
drop procedure if exists modificarCodigoInsumo;
delimiter //
CREATE PROCEDURE modificarCodigoInsumo(
	in _codigoInsumo int,
    in _nuevoCodigoInsumo int,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    if InsumoEliminado(_codigoInsumo) <> 0 then				-- verificar que el modelo que quiero modificar no esté eliminado 
		select -1 into _valorRetorno;
        select 'error, insumo eliminado' into _msjRetorno;
	else
        if existeInsumo(_nuevoCodigoInsumo) <> 0 then				-- verificar que no exista un modelo con el codigo que quiero asignar	
			select -1 into _valorRetorno;
			select 'error, ya existe insumo con ese codigo' into _msjRetorno;
		else
            update insumo set codigoInsumo = _nuevocodigoInsumo where codigoInsumo = _codigoInsumo;
            select 0 into _valorRetorno;
			select 'codigo de insumo modificado' into _msjRetorno;
		end if;
    end if;
END 
//
delimiter ;


-- Modificar descripcion
drop procedure if exists modificarDescripcionInsumo;
delimiter //
CREATE PROCEDURE modificarDescripcionInsumo(
	in _codigoInsumo int,
    in _nuevoDescripcion varchar(45),
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    if insumoEliminado(_codigoInsumo) <> 0 then				-- verificar que el modelo que quiero modificar no esté eliminado 
		select -1 into _valorRetorno;
        select 'error, insumo eliminado' into _msjRetorno;
	else
		update insumo set descripcion = _nuevoDescripcion where codigoInsumo = _codigoInsumo;
		select 0 into _valorRetorno;
		select 'descripcion de insumo modificado' into _msjRetorno;
    end if;
    if existeInsumo(_codigoInsumo) = 0 then
		select -1 into _valorRetorno;
		select 'error, no existe insumo' into _msjRetorno;
	end if;
END 
//
delimiter ;


/* ----------------------------------------------------------------------
					ABM insumoXProveedor
-----------------------------------------------------------------------*/

-- existe insumoXproveedor
drop function if exists existeInsumoXproveedor;
delimiter //
CREATE function existeInsumoXproveedor(
	_codigoInsumo int,
	_cuit varchar(15))
    returns int
begin
	set @retorno = (select count(*) from insumoXproveedor 
					where codigoInsumo = _codigoInsumo
                    and cuit = _cuit);
    return @retorno;
end
//
delimiter ;

-- verificar eliminado
drop function if exists insumoXproveedorEliminado;
delimiter //
CREATE function insumoXproveedorEliminado(
	_codigoInsumo int,
    _cuit varchar(15))
    returns int
begin
	set @eliminado = (select eliminado from insumoXproveedor 
					where codigoInsumo = _codigoInsumo
                    and cuit = _cuit);
    return @eliminado;
end
//
delimiter ;

-- Traer Lista de insumosXproveedores
drop procedure if exists traerInsumosXproveedores;
delimiter //
CREATE PROCEDURE traerInsumosXproveedores()
BEGIN
    select i.codigoInsumo, i.descripcion, p.cuit as cuitProveedor, p.nombre as nombreProveedor, ixp.precio 
    from insumoXproveedor ixp
    inner join proveedor p on ixp.cuit = p.cuit
    inner join insumo i on ixp.codigoInsumo = i.codigoInsumo 
    where ixp.eliminado =0;
END 
//
delimiter ;

-- Traer Lista de insumosXproveedor
drop procedure if exists traerInsumosXproveedor;
delimiter //
CREATE PROCEDURE traerInsumosXproveedor(
in _cuit varchar(15))
BEGIN
    select i.codigoInsumo, i.descripcion, p.cuit as cuitProveedor, p.nombre as nombreProveedor, ixp.precio 
    from insumoXproveedor ixp
    inner join proveedor p on ixp.cuit = p.cuit
    inner join insumo i on ixp.codigoInsumo = i.codigoInsumo 
    where ixp.eliminado=0 and p.cuit = _cuit;
END 
//
delimiter ;
-- Agregar insumoXproveedor
drop procedure if exists altaInsumoXproveedor;
delimiter //
CREATE PROCEDURE altaInsumoXproveedor(
	in _codigoInsumo int,
    in _cuit varchar(15),
    in _precio float,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	-- verificar que existan el insumo  y el proveedor
	if existeInsumo(_codigoInsumo)=0 then
		select -1 into _valorRetorno;
        select 'error, no existe el insumo indicado' into _msjRetorno;
	else
		if existeProveedor(_cuit) = 0 then
			select -1 into _valorRetorno;
			select 'error, no existe el proveedor indicado' into _msjRetorno;
		else
    -- si no existe lo agrego
			if existeinsumoXproveedor (_codigoInsumo, _cuit) <> 0 and insumoXproveedorEliminado(_codigoInsumo, _cuit) = 0 then
				select -1 into _valorRetorno;
				select 'error, ya existe ixp' into _msjRetorno;
			else
				if insumoXproveedorEliminado (_codigoInsumo, _cuit) <> 0 then
					update insumoXproveedor set eliminado = 0 where codigoInsumo = _codigoInsumo and cuit = _cuit;
					update insumoXproveedor set fechaEliminado = null where codigoInsumo = _codigoInsumo and cuit = _cuit;
					call modificarPrecioIXP(_codigoInsumo, _cuit, _precio, @ms,@va);
					select 1 into _valorRetorno;
					select 'insumoXproveedor agregado nuevamente' into _msjRetorno;
				else
					insert into insumoXproveedor (codigoInsumo, cuit, precio) values (_codigoInsumo, _cuit, _precio);
					select 0 into _valorRetorno;
					select 'insumoXproveedor agregado' into _msjRetorno;
				end if;
			end if;
		end if;
	end if;
		
END 
//
delimiter ;

-- Eliminar insumoXproveedor
drop procedure if exists bajaInsumoXproveedor;
delimiter //
CREATE PROCEDURE bajaInsumoXproveedor(
	in _codigoInsumo int,
    in _cuit varchar(15),
	out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	if existeInsumo(_codigoInsumo)=0 then
		select -1 into _valorRetorno;
        select 'error, no existe el insumo indicado' into _msjRetorno;
	else
		if existeProveedor(_cuit) = 0 then
			select -1 into _valorRetorno;
			select 'error, no existe el proveedor indicado' into _msjRetorno;
		else	
			if insumoXproveedorEliminado(_codigoInsumo, _cuit) = 1 then
				select -1 into _valorRetorno;
				select 'error, insumoXproveedor ya eliminado' into _msjRetorno;
			else
				update insumoXproveedor set eliminado = 1 where codigoInsumo = _codigoInsumo and cuit = _cuit; 
				update insumoXproveedor set fechaEliminado = (select now()) where codigoInsumo = _codigoInsumo and cuit = _cuit; 
				select 0 into _valorRetorno;
				select 'insumoXproveedor eliminado' into _msjRetorno;
			end if;
		end if;
	end if;
END 
//
delimiter ;

-- Modificar precio
drop procedure if exists modificarPrecioIXP;
delimiter //
CREATE PROCEDURE modificarPrecioIXP(
	in _codigoInsumo int,
    in _cuit varchar(15),
    in _nuevoPrecio float,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	if existeInsumo(_codigoInsumo)=0 then
		select -1 into _valorRetorno;
        select 'error, no existe el insumo indicado' into _msjRetorno;
	else
		if existeProveedor(_cuit) = 0 then
			select -1 into _valorRetorno;
			select 'error, no existe el proveedor indicado' into _msjRetorno;
		else	
            if insumoXproveedorEliminado(_codigoInsumo, _cuit) <> 0 then
				select 'error, insumoXproveedor eliminado' into _msjRetorno;
				select -1 into _valorRetorno;
			else
				update insumoXproveedor set precio = _nuevoPrecio where codigoInsumo = _codigoInsumo and cuit = _cuit;
				select 'precio de insumoXproveedor modificado' into _msjRetorno;
				select 0 into _valorRetorno;
			end if;
		end if;
	end if;
END 
//
delimiter ;


/* ----------------------------------------------------------------------
					ABM concesionaria
-----------------------------------------------------------------------*/

-- existe concesionaria
drop function if exists existeConcesionaria;
delimiter //
CREATE function existeConcesionaria(
	_cuit varchar(15))
    returns int
begin
	set @retorno = (select count(*) from concesionaria c where c.cuit= _cuit);
    return @retorno;
end
//
delimiter ;

-- verificar eliminado
drop function if exists concesionariaEliminado;
delimiter //
CREATE function concesionariaEliminado(
	_cuit varchar(15))
    returns int
begin
	set @eliminado = (select eliminado from concesionaria where cuit= _cuit);
    return @eliminado;
end
//
delimiter ;

-- Traer Lista de concesionarias
drop procedure if exists traerConcesionarias;
delimiter //
CREATE PROCEDURE traerConcesionarias()
BEGIN
    select cuit from concesionaria where eliminado =0;
END 
//
delimiter ;

-- Agregar concesionaria
drop procedure if exists altaConcesionaria;
delimiter //
CREATE PROCEDURE altaConcesionaria(
	in _cuit varchar(15),
    out _msjRetorno varchar (45),
    out _valorRetorno int)
BEGIN
    -- si no existe lo agrego
	if existeConcesionaria(_cuit) <> 0 and concesionariaEliminado(_cuit) = 0 then
		select -1 into _valorRetorno;
        select 'error, ya existe concesionaria' into _msjRetorno;
	else
		if concesionariaEliminado (_cuit) = 1 then
			update concesionaria set eliminado = 0 where cuit = _cuit;
            update concesionaria set fechaEliminado = null where cuit = _cuit;
			select 0 into _valorRetorno;
            select 'concecionaria agregada nuevamente' into _msjRetorno;
		else
			insert into concesionaria(cuit) values (_cuit);
			select 0 into _valorRetorno;
            select 'concecionaria agregada' into _msjRetorno;
		end if;
	end if;
END 
//
delimiter ;


-- Eliminar concesionaria
drop procedure if exists bajaConcesionaria;
delimiter //
CREATE PROCEDURE bajaConcesionaria(
	in _cuit varchar(15),
	out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	-- no eliminar si existen pedidos pendientes que correspondan a esa concesionaria
    set @existePedido = (select count(*) from pedido where cuitConcesionaria = _cuit and eliminado = 0);
    if concesionariaEliminado(_cuit) = 1 then
			select 'error, ya se encuentra eliminada' into _msjRetorno;
			select -1 into _valorRetorno;
	else 
		if @existePedido <> 0 then 
			select 'error, pedidos pendientes' into _msjRetorno;
			select -2 into _valorRetorno;
		else
			update concesionaria set eliminado = 1 where cuit= _cuit; 
			update concesionaria set fechaEliminado = (select now()) where cuit= _cuit;
            select 'error, pedidos pendientes' into _msjRetorno;
			select 0 into _valorRetorno;
		end if;
    end if;
END 
//
delimiter ;

-- Modificar concesionaria cuit
drop procedure if exists modificarConcesionaria;
delimiter //
CREATE PROCEDURE modificarconcesionaria(
	in _cuit varchar(15),
    in _nuevoCuit varchar(15),
    out _msjRetorno varchar (45),
    out _valorRetorno int)
BEGIN
	if existeConcesionaria(_cuit) = 0 then				-- verificar que no exista un concesionaria con el codigo que quiero asignar	
			select -3 into _valorRetorno;
            select 'error, no existe concesionaria con ese codigo' into _msjRetorno;
    else        
		if concesionariaEliminado(_cuit) <> 0 then				-- verificar que el concesionaria que quiero modificar no esté eliminado 
			select 'error, concesionaria eliminado' into _msjRetorno;
			select -1 into _valorRetorno;
			else
			if existeConcesionaria(_nuevoCuit) <> 0 then				-- verificar que no exista un concesionaria con el codigo que quiero asignar	
				select -1 into _valorRetorno;
				select 'error, ya existe concesionaria con ese codigo' into _msjRetorno;
			else
				update concesionaria set cuit= _nuevoCuit where cuit= _cuit;
				select 0 into _valorRetorno;
				select 'concesionaria modificada' into _msjRetorno;
			end if;
         end if;   
    end if;
END 
//
delimiter ;


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



-- Traer Listas
drop procedure if exists traerDetallePedidoXpedido;
delimiter //
CREATE PROCEDURE traerDetallePedidoXpedido(
in _idPedido int)
BEGIN
	select d.idPedido, m.idModelo, m.modeloVehiculo, d.cantidad 
    from detallePedido d inner join modelo m on m.idModelo = d.idModelo 
    where d.eliminado =0 and d.idPedido = _idPedido;
END 
//
delimiter ;

drop procedure if exists traerDetallePedidoXmodelo;
delimiter //
CREATE PROCEDURE traerDetallePedidoXmodelo(
in _idModelo int)
BEGIN
    select d.idPedido, m.idModelo, m.modeloVehiculo, d.cantidad 
    from detallePedido d inner join modelo m on m.idModelo = d.idModelo 
    where d.eliminado =0 and m.idModelo = _idModelo;
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

-- ***********************************************************************************
-- ABM modelo
-- ***********************************************************************************
-- existe modelo
drop function if exists existeModelo;
delimiter //
CREATE function existeModelo(
	_modeloVehiculo varchar(45))
    returns int
begin
	set @retorno = (select count(*) from modelo m where m.modeloVehiculo = _modeloVehiculo);
    return @retorno;
end
//
delimiter ;

-- verificar eliminado
drop function if exists modeloEliminado;
delimiter //
CREATE function modeloEliminado(
	_modeloVehiculo varchar(45))
    returns int
begin
	set @eliminado = (select eliminado from modelo where modeloVehiculo = _modeloVehiculo);
    return @eliminado;
end
//
delimiter ;

-- traer id modelo
drop function if exists getIdModelo;
delimiter //
CREATE function getIdModelo(
	_modeloVehiculo varchar(45))
    returns int
begin
	set @idModelo = (select idModelo from modelo where modeloVehiculo = _modeloVehiculo);
    return @idModelo;
end
//
delimiter ;


-- Traer Lista de modelos
drop procedure if exists traerModelos;
delimiter //
CREATE PROCEDURE traerModelos()
BEGIN
    select idModelo, modeloVehiculo from modelo m where eliminado =0;
END 
//
delimiter ;

-- Agregar modelo
drop procedure if exists altaModelo;
delimiter //
CREATE PROCEDURE altaModelo(
	in _modeloVehiculo varchar(45),
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    -- si no existe lo agrego
	if existeModelo(_modeloVehiculo) = 1 then
        select 'error, ya existe modelo' into _msjRetorno;
        select -1 into _valorRetorno;
        if modeloEliminado(_modeloVehiculo) = 1 then
			set @idModelo = getIdModelo(_modeloVehiculo);
			update modelo set eliminado = 0 where idModelo = @idModelo;
			update modelo set fechaEliminado = null where idModelo = @idModelo;
            select 'agregado nuevamente' into _msjRetorno;
            select 0 into _valorRetorno;
		end if;
	else
		insert into modelo(idModelo, modeloVehiculo) values (0, _modeloVehiculo);
		select 'agregado' into _msjRetorno;
		select 0 into _valorRetorno;
    end if;
END 
//
delimiter ;

-- Eliminar Modelo
drop procedure if exists bajaModelo;
delimiter //
CREATE PROCEDURE bajaModelo(
	in _modeloVehiculo varchar(45),out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	/* Hay que obtener el id del modelo que se quiere eliminar porque sino tira un error
	al intentar hacer update de un registro referenciado por valor que no es clave primaria	
    (osea, lo que se pone en el where)
    */
	set @idModelo = getIdModelo(_modeloVehiculo);
    if modeloEliminado(_modeloVehiculo)=1 then
				select -1 into _valorRetorno;
				select 'error,no  existe modelo con esa descripcion' into _msjRetorno;
	else
				select 0 into _valorRetorno;
				select 'Baja Existosa' into _msjRetorno;
    end if;
    update modelo set eliminado = 1 where idModelo = @idModelo; 
    update modelo set fechaEliminado = (select now()) where idModelo = @idModelo;
END 
//
delimiter ;

-- Modificar modelo
drop procedure if exists modificarModelo;
delimiter //
CREATE PROCEDURE modificarModelo(
	in _modeloVehiculo varchar(45),
    in _nuevoModeloVehiculo varchar(45),
    out _msjRetorno varchar(100),
    out _valorRetorno int)
BEGIN
    if modeloEliminado(_modeloVehiculo) = 0 then				-- verificar que el modelo que quiero modificar no esté eliminado 
        if existeModelo(_nuevoModeloVehiculo) = 0 then				-- verificar que no exista un modelo con el codigo que quiero asignar	
			set @idModelo = getIdModelo(_modeloVehiculo);
            update modelo set modeloVehiculo = _nuevoModeloVehiculo where idModelo = @idModelo;
			select 0 into _valorRetorno;
            select 'modificacion exitosa' into _msjRetorno;
		else
			select -1 into _valorRetorno;
            select 'error,ya existe un modelo con ese codigo' into _msjRetorno;
        end if;
	else
		select -2 into _valorRetorno;
		select 'error,no existe el modelo a modificar ' into _msjRetorno;
    end if;
END 
//
delimiter ;




