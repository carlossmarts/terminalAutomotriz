-- ABM Proveedor
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