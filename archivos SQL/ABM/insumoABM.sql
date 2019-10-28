
use proyectoBD;

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