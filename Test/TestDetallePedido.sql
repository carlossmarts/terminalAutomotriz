-- test abm PedidoDetalle
select * from pedido;
select * from concesionaria;
call traerModelos();
insert into concesionaria(cuit)values('20-41716615-8');
insert into Pedido(cuitConcesionaria, fechaHora)values('20-41716615-8',now());
call altaDetallePedido(2,1,10,@msj,@valor);
call altaDetallePedido(2,3,10,@msj,@valor);
call modificarDetallePedidoModelo(2,1,3,@msj,@valor);
call bajaDetallePedido(2,3,@msj,@valor);

select * from detallepedido;
select @msj,@valor;
