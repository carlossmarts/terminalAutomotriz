drop schema if exists proyectoBD;
Create schema if not exists proyectoBD;
use proyectoBD;

create table modelo(
	idModelo int primary key auto_increment,
	modeloVehiculo varchar(45),
    eliminado bit(1) default b'0',
    fechaEliminado datetime
);


create table proveedor(
	cuit varchar(15) primary key,
	nombre varchar(45),
    eliminado bit(1) default b'0',
    fechaEliminado datetime
);
      
create table insumo(

	codigoInsumo int primary key,
	descripcion varchar(45),
    eliminado bit(1) default b'0',
    fechaEliminado datetime

);

create table lineaDeMontaje(
	idLineaDeMontaje int primary key,
	idModelo int,
	promedio float,
	eliminado bit(1) default b'0',
    fechaEliminado datetime,
	foreign key(idModelo) references modelo(idModelo)
 
);

create table tarea(
	idTarea int primary key,
	descripcion varchar(45),
    eliminado bit(1) default b'0',
    fechaEliminado datetime
);


create table estacionDeTrabajo(
	primary key(idTarea,idLineaDeMontaje),
	idTarea int not null, 
	idLineaDeMontaje int not null,
    ocupado bit(1) default b'0',
    eliminado bit(1) default b'0',
    fechaEliminado datetime,
    nroOrden int not null,
	foreign key(idTarea) references tarea(idTarea),
	foreign key(idLineaDeMontaje) references lineaDeMontaje(idLineaDeMontaje)

);

create table concesionaria(
	cuit varchar(15) primary key,
    eliminado bit(1) default b'0',
    fechaEliminado datetime
);

create table pedido(
	idPedido int primary key auto_increment,
	cuitConcesionaria varchar(15) not null,
	fechaHora datetime,
    eliminado bit(1) default b'0',
    fechaEliminado datetime,
	foreign key (cuitConcesionaria) references concesionaria(cuit)
);

create table detallePedido(
	idPedido int not null,
	idModelo int not null,
	cantidad int,
    eliminado bit(1) default b'0',
    fechaEliminado datetime,
	primary key(idPedido,idModelo),
	foreign key (idPedido) references pedido(idPedido),
	foreign key (idModelo) references modelo(idModelo)
);


create table automovil(
	nroChasis int primary key auto_increment,
	idModelo int not null,
	idPedido int not null,
    eliminado bit(1) default b'0',
    fechaEliminado datetime,
    fechaTerminado datetime,
	foreign key (idPedido) references detallePedido(idPedido),
    foreign key (idModelo) references modelo(idModelo)
   );

create table insumoXproveedor(
	codigoInsumo int,
	cuit varchar(15),
	primary key(codigoInsumo,cuit),
	precio float,
    eliminado bit(1) default b'0',
    fechaEliminado datetime,
	foreign key(codigoInsumo) references insumo(codigoInsumo),
	foreign key(cuit) references proveedor(cuit)

);

create table insumoXestacion(
	idTarea int,
	codigoInsumo int,
	idLineaDeMontaje int,
	cantidad int,
    eliminado bit(1) default b'0',
    fechaEliminado datetime,
	primary key(codigoInsumo,idTarea,idLineaDeMontaje),
	foreign key(codigoInsumo) references insumo(codigoInsumo),
	foreign key(idLineaDeMontaje) references estacionDeTrabajo(idLineaDeMontaje),
	foreign key(idTarea) references estacionDeTrabajo (idTarea)
	);

create table automovilxestacion(
	nroChasis int not null,
	idLineaDeMontaje int not null,
	idTarea int not null,
	primary key(nroChasis,idLineaDeMontaje, idTarea),
	horaIngreso DATETIME NOT NULL,
	horaEgreso DATETIME NULL,
    eliminado bit(1) default b'0',
    fechaEliminado datetime,
	foreign key(idLineaDeMontaje) references estacionDeTrabajo(idLineaDeMontaje),
	foreign key(idTarea) references estacionDeTrabajo(idTarea),
	foreign key(nroChasis) references automovil(nroChasis)
);