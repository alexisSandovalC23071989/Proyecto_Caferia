CREATE TABLE tabla_ventas.factura (
    id_factura NUMBER CONSTRAINT idx_factura PRIMARY KEY,
    fecha DATE NOT NULL, 
    monto DECIMAL(10, 2) NOT NULL,
    tipo VARCHAR2(45) NOT NULL,
    metodoPago VARCHAR2(45) NOT NULL,
    fk_cliente NUMBER NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (fk_cliente) REFERENCES tabla_clientes.Cliente(idCliente),
    fk_empleado NUMBER NOT NULL,
    CONSTRAINT fk_empleado FOREIGN KEY (fk_empleado) REFERENCES tabla_empleados.Empleados(id_Empleado)
);

CREATE TABLE tabla_ventas.ventas (
    id_venta NUMBER(10) CONSTRAINT idx_venta PRIMARY KEY,
    monto DECIMAL(10, 2) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    cantidad NUMBER(10) NOT NULL,
    fk_inventario NUMBER(10) NOT NULL,
    CONSTRAINT fk_inventario FOREIGN KEY (fk_inventario) REFERENCES tabla_inventario.inventario(id_inventario),
    fk_factura NUMBER(10) NOT NULL,
    CONSTRAINT fk_factura FOREIGN KEY (fk_factura) REFERENCES tabla_ventas.factura(id_factura)
);




---------Procedimientos para la Gestion de Ventas (5)
-- Procedimiento para insertar una venta
CREATE OR REPLACE PROCEDURE InsertarVenta(
    p_idVenta IN INT,
    p_monto IN NUMBER,
    p_precio IN NUMBER,
    p_cantidad IN NUMBER,
    p_FK_Inventario IN INT,
    p_FK_Factura IN INT
) IS
BEGIN
    INSERT INTO tabla_ventas.Ventas (id_Venta, monto, precio, cantidad, FK_Inventario, FK_Factura)
    VALUES (p_idVenta, p_monto, p_precio, p_cantidad, p_FK_Inventario, p_FK_Factura);
END;
/

-- Procedimiento para actualizar una venta
CREATE OR REPLACE PROCEDURE ActualizarVenta(
    p_idVenta IN INT,
    p_monto IN NUMBER,
    p_precio IN NUMBER,
    p_cantidad IN NUMBER
) IS
BEGIN
    UPDATE tabla_ventas.Ventas
    SET monto = p_monto, precio = p_precio, cantidad = p_cantidad
    WHERE id_Venta = p_idVenta;
END;
/

-- Procedimiento para eliminar una venta
CREATE OR REPLACE PROCEDURE EliminarVenta(
    p_idVenta IN INT
) IS
BEGIN
    DELETE FROM tabla_ventas.Ventas WHERE id_Venta = p_idVenta;
END;
/

-- Procedimiento para buscar una venta
CREATE OR REPLACE PROCEDURE BuscarVenta(
    p_idVenta IN INT
) IS
    v_monto tabla_ventas.Ventas.monto%TYPE;
    v_precio tabla_ventas.Ventas.precio%TYPE;
    v_cantidad tabla_ventas.Ventas.cantidad%TYPE;
BEGIN
    SELECT monto, precio, cantidad INTO v_monto, v_precio, v_cantidad
    FROM tabla_ventas.Ventas
    WHERE id_Venta = p_idVenta;

    DBMS_OUTPUT.PUT_LINE('Monto: ' || v_monto || ', Precio: ' || v_precio || ', Cantidad: ' || v_cantidad);
END;
/

-- Procedimiento para listar todas las ventas
CREATE OR REPLACE PROCEDURE ListarVentas IS
BEGIN
    FOR v IN (SELECT id_Venta, monto, precio, cantidad FROM tabla_ventas.Ventas) LOOP
        DBMS_OUTPUT.PUT_LINE('Venta: ' || v.id_Venta || ' - ' || v.monto || ' - ' || v.precio || ' - ' || v.cantidad);
    END LOOP;
END;
/