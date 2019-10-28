/* ********************************************************
					Declaracion de sp
***********************************************************/
-- Proveedor

call existeProveedor (cuit);

call ProveedorEliminado(cuit);

call traerProveedores();

call altaProveedor(cuit, nombre, @m, @v);

call bajaProveedor(cuit, @m, @v);

call modificarCuitProveedor(cuit, nuevoCuit, @m, @v);

call modificarNombreProveedor(cuit, nuevoNombre, @m, @v);

-- insumo
call existeInsumo (codigoInsumo);

call insumoEliminado(codigoInsumo);

call traerInsumos();

call altaInsumo(codigoInsumo, descripcion, @m, @v);

call bajaInsumo(codigoInsumo, @m, @v);

call modificarCodigoInsumo(codigoInsumo, nuevoCodigo, @m, @v);

call modificarDescripcionInsumo(codigoInsumo, nuevaDescripcion, @m, @v);


-- insumo por proveedor

call existeInsumoXproveedor(codigoInsumo, cuit);

call insumoXproveedorEliminado(codigoInsumo, cuit);

call traerInsumosXproveedores();

call traerInsumosXproveedor(cuit);

call altaInsumoXproveedor(codigoInsumo, cuit, precio, @m, @v);

call bajaInsumoXproveedor(codigoInsumo, cuit, @m, @v);

call modificarPrecioIXP(codigoInsumo, cuit, nuevoPrecio @m, @v);


-- Concesionaria

call existeConcesionaria (cuit);

call concesionariaEliminado(cuit);

call traerConcesionarias();

call altaConcesionaria(cuit, @m, @v);

call bajaConcesionaria(cuit, @m, @v);

call modificarConcesionaria(cuit, nuevoCuit, @m, @v);


-- pedido

call existePedido(idPedido);

call PedidoEliminado(idPedido);

call traerPedidos();

call altaPedido(cuitConcesionaria, fechaHora, @m, @v);

call bajaPedido(idPedido, @m, @v);

call modificarPedidoFecha(idPedido, nuevaFecha, @m, @v);

call modificarPedidoFecha(idPedido, nuevoCuitConcesionaria @m, @v);

-- detallePedido

call existeDetallePedido(idModelo, idPedido);

call detallePedidoEliminado(idModelo, idPedido);

call traerDetallePedidoXpedido(idPedido);

call altaDetallePedido(idPedido, idModelo, cantidad, @m, @v);

call bajaDetallePedido(idPedido, idModelo, @m, @v);

call modificarDetallePedidoModelo(idPedido, idModelo, nuevoIdModelo, @m, @v);

call agregarCantidadDetallePedido(idPedido, idModelo, cant, @m, @v);

-- modelo

call existeModelo(modeloVehiculo);

call modeloEliminado(modeloVehiculo);

call traerModelos();

call altaModelo(modeloVehiculo, @m, @v);

call bajaModelo(modeloVehiculo, @m, @v);

call modificarModelo(modeloVehiculo, nuevaModeloVehiculo, @m, @v);

