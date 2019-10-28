-- ABM Modelo
use proyectoBD;
/* template stored procedure
drop procedure if exists procedimiento;
delimiter //
CREATE PROCEDURE procedimiento()
BEGIN
    
END 
//
delimiter ;
*/
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
