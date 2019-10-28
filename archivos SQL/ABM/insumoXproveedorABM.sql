
-- ABM Modelo
use proyectoBD;
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
    where ixp.eliminado=0;
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