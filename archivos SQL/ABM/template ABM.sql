/*
-- ABM Modelo
use proyectoBD;

template stored procedure
drop procedure if exists procedimiento;
delimiter //
CREATE PROCEDURE procedimiento()
BEGIN
    
END 
//
delimiter ;

template funcion
drop function if exists funcion;
delimiter //
CREATE FUNCTION funcion()
returns int
BEGIN
    
END 
//
delimiter ;

-- existe entidad
drop function if exists existeEntidad;
delimiter //
CREATE function existeEntidad(
	_pk tipo)
    returns int
begin
	set @retorno = (select count(*) from entidad where pk= _pk);
    return @retorno;
end
//
delimiter ;

-- verificar eliminado
drop function if exists entidadEliminado;
delimiter //
CREATE function entidadEliminado(
	_pk tipo)
    returns int
begin
	set @eliminado = (select eliminado from entidad where pk = _pk);
    return @eliminado;
end
//
delimiter ;

-- traer id
drop function if exists getIdEntidad;
delimiter //
CREATE function getIdEntidad(
	_pk tipo)
    returns int
begin
	set @idEntidad= (select idEntidad from entidad where pk = _pk);
    return @idEntidad;
end
//
delimiter ;


-- Traer Lista de modelos
drop procedure if exists traerEntidades;
delimiter //
CREATE PROCEDURE traerEntidades()
BEGIN
    select atributos from entidad where eliminado =0;
END 
//
delimiter ;

-- Agregar entidad
drop procedure if exists altaEntidad;
delimiter //
CREATE PROCEDURE altaEntidad(
	in _pk tipo,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    -- si no existe lo agrego
	if existeEntidad (_pk) <> 0 then
		select -1 into _valorRetorno;
        select '' into _msjRetorno;
	else
		if entidadEliminado (_pk) <> 0 then
			set @idEntidad = getIdEntidad(_pk);
            update entidad set eliminado = 0 where pk = _pk;
            update entidad set fechaEliminado = null where pk = _pk;
            -- modificar atributo que no sea parte de la pk
            select 1 into _valorRetorno;
			select 'entidad agregado nuevamente' into _msjRetorno;
		else
			insert into entidad (atrib) values (atrib);
            select 0 into _valorRetorno;
			select 'entidad agregado' into _msjRetorno;
		end if;
	end if;
		
END 
//
delimiter ;

-- Eliminar Entidad
drop procedure if exists bajaEntidad;
delimiter //
CREATE PROCEDURE bajaEntidad(
	in _pk tipo)
BEGIN
	set @idEntidad = getIdEntidad(_pk);
    update entidad set eliminado = 1 where pk= _pk; 
    update entidad set fechaEliminado = (select now()) where pk = _pk; 
END 
//
delimiter ;

-- Modificar e
drop procedure if exists modificarEntidad;
delimiter //
CREATE PROCEDURE modificarEntidad(
	in _pk tipo,
    in _nuevopk tipo,
    out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
    if entidadEliminado(_pk) <> 0 then
		select 'error, entidad eliminado' into _msjRetorno;
        select -1 into _valorRetorno;
	else
        if existeEntidad(_nuevopk) <> 0 then
			select 'error, ya existe entidad con ese pk' into _msjRetorno;
            select -1 into _valorRetorno;
		else
			set @idEntidad = getIdEntidad(_pk);
            update entidad set pk = _nuevopk where idEntidad = @idEntidad;
            select 'entidad modificado' into _msjRetorno;
            select 0 into _valorRetorno;
		end if;
    end if;
END 
//
delimiter ;

*/
