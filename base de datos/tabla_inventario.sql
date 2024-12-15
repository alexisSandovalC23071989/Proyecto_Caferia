---------------------------------------------------------Se crea la tabla Inventarios------------------------------------------------------------------------------------------------
CREATE TABLE tabla_inventario.Pais_Inventario(
id_Pais NUMBER CONSTRAINT IDX_PAIS_INVENTARIO NOT NULL PRIMARY KEY,
nombre_pais VARCHAR2(50) NOT NULL
);


---------------------------------------------------------Se crea la tabla Provincia Inventario---------------------------------------------------------------------------------------

CREATE TABLE tabla_inventario.Provincia_Inventario(
id_Provincia NUMBER CONSTRAINT IDX_PROVINCIA_INVENTARIO NOT NULL PRIMARY KEY,
nombre_provincia VARCHAR2(50) NOT NULL,
FK_Pais NUMBER NOT NULL 
constraint FK_PAIS_INVENTARIO references tabla_inventario.Pais_Inventario
);
--------------------------------------------------------Se crea la tabla inventario canton--------------------------------------------------------------------------------------------
CREATE TABLE tabla_inventario.Canton_Inventario(
id_Canton NUMBER CONSTRAINT IDX_Canton_INVENTARIO NOT NULL PRIMARY KEY,
nombre_canton VARCHAR2(50) NOT NULL,
FK_Provincia NUMBER NOT NULL,
CONSTRAINT FK_PROVINCIA_INVENTARIO FOREIGN KEY (FK_Provincia) REFERENCES tabla_inventario.Provincia_Inventario(id_Provincia)
);
-------------------------------------------------------Se crea la tabla distritos inventario----------------------------------------------------------------------------------------
CREATE TABLE tabla_inventario.Distritos_Inventario(
id_Distritos NUMBER CONSTRAINT IDX_DISTRITOS_INVENTARIO NOT NULL PRIMARY KEY,
nombre_distrito VARCHAR2(50) NOT NULL,
FK_Canton NUMBER NOT NULL,
CONSTRAINT FK_CANTON_INVENTARIO FOREIGN KEY (FK_Canton) REFERENCES tabla_inventario.Canton_Inventario(id_Canton)
);
----------------------------------------------------------------------Se creo la tabla dirrecion de inventario------------------------------------------------------------------
CREATE TABLE tabla_inventario.Direccion_Inventario(
id_Direccion NUMBER CONSTRAINT IDX_DIRECCION_INVENTARIO NOT NULL PRIMARY KEY,
direccion_exacta VARCHAR2(50) NOT NULL,
FK_Distritos NUMBER NOT NULL,
CONSTRAINT FK_DISTRITO_INVENTARIO FOREIGN KEY (FK_Distritos) REFERENCES tabla_inventario.Distritos_Inventario(id_Distritos)
);

CREATE TABLE tabla_inventario.Sucursal (
    id_Sucursal NUMBER CONSTRAINT IDX_SUCURSAL NOT NULL PRIMARY KEY,
    telefono NUMBER NOT NULL,
    nombre_encargado VARCHAR2(45) NOT NULL,
    primer_apellido_encargado VARCHAR2(45) NOT NULL,
    segundo_apellido_encargado VARCHAR2(45) NOT NULL,
    FK_Direccion_Sucursal NUMBER NOT NULL,
    CONSTRAINT FK_DIRECCION_SUCURSAL FOREIGN KEY (FK_Direccion_Sucursal) REFERENCES tabla_inventario.Direccion_Inventario (id_Direccion)
);

-------------------------------------------------------------------------Se crea la table inventario.proveedor-----------------------------------------------------------------------
CREATE TABLE tabla_inventario.Proveedor (
    id_Proveedor NUMBER CONSTRAINT IDX_PROVEEDOR NOT NULL PRIMARY KEY,
    nombre_proveedor VARCHAR2(100) NOT NULL,
    telefono NUMBER NOT NULL,
    correo VARCHAR2(200) NOT NULL,
    FK_Direccion_Proveedor NUMBER NOT NULL,
    CONSTRAINT FK_Direccion_Proveedor FOREIGN KEY (FK_Direccion_Proveedor) REFERENCES tabla_inventario.Direccion_Inventario(id_Direccion)
);

---------------------------------------------------------------------------Se crea la tabla inventario categoria---------------------------------------------------------------------
CREATE TABLE tabla_inventario.Categoria (
    id_Categoria NUMBER CONSTRAINT IDX_CATEAGORIA NOT NULL PRIMARY KEY,
    descripcion VARCHAR2(100) NOT NULL
);
--------------------------------------------------------------------------Se crea la tabla inventario productos-----------------------------------------------------------------------
CREATE TABLE tabla_inventario.Producto (
    id_Producto NUMBER CONSTRAINT IDX_PRODUCTO NOT NULL PRIMARY KEY,
    descripcion VARCHAR2(200) NOT NULL,
    precio NUMBER(10,2) NOT NULL,
    codigoBarras VARCHAR(200) NOT NULL,
    FK_Categoria NUMBER NOT NULL,
    CONSTRAINT FK_CATEGORIA FOREIGN KEY (FK_Categoria) REFERENCES tabla_inventario.Categoria (id_Categoria)
);

CREATE TABLE tabla_inventario.inventario (
    id_inventario NUMBER(10) CONSTRAINT idx_inventario PRIMARY KEY,
    cantidad NUMBER NOT NULL,
    fk_proveedor NUMBER NOT NULL,
    fk_producto NUMBER NOT NULL,
    fk_sucursal NUMBER NOT NULL,
    CONSTRAINT fk_proveedor FOREIGN KEY (fk_proveedor) REFERENCES tabla_inventario.proveedor(id_proveedor),
    CONSTRAINT fk_producto FOREIGN KEY (fk_producto) REFERENCES tabla_inventario.producto(id_producto),
    CONSTRAINT fk_sucursal FOREIGN KEY (fk_sucursal) REFERENCES tabla_inventario.sucursal(id_sucursal)
);

///-------------------------------------------------------------------Procedimientos para la gestion de productos----------------------------------------------------------------------
----------------------------------------------------------------------Procedimiento para insertar un producto--------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE InsertarProducto(
    p_idProducto IN INT,
    p_descripcion IN VARCHAR2,
    p_precio IN NUMBER
) IS
BEGIN
    INSERT INTO tabla_inventario.Producto (id_Producto, descripcion, precio)
    VALUES (p_idProducto, p_descripcion, p_precio);
END;
/


------------------------------------------------------------------Procedimiento para actualizar un producto--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ActualizarProducto(
    p_idProducto IN INT,
    p_descripcion IN VARCHAR2,
    p_precio IN NUMBER
) IS
BEGIN
    UPDATE tabla_inventario.Producto
    SET descripcion = p_descripcion, precio = p_precio
    WHERE id_Producto = p_idProducto;
END;
/

------------------------------------------------------------------------Procedimiento para eliminar un producto------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE EliminarProducto(
    p_idProducto IN INT
) IS
BEGIN
    DELETE FROM tabla_inventario.Producto
    WHERE id_Producto = p_idProducto;
------------------------------------------------------------------------Se agrega mensaje para cuando se elimina un producto----------------------------------------------------------    
    DBMS_OUTPUT.PUT_LINE('Producto eliminado: ' || p_idProducto);
END;
/

----------------------------------------------------------------------------Procedimiento para buscar un producto---------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE BuscarProducto(
    p_idProducto IN INT
) IS
    v_descripcion tabla_inventario.Producto.descripcion%TYPE;
    v_precio tabla_inventario.Producto.precio%TYPE;
BEGIN
    SELECT descripcion, precio INTO v_descripcion, v_precio
    FROM tabla_inventario.Producto
    WHERE id_Producto = p_idProducto;

    DBMS_OUTPUT.PUT_LINE('Descripción: ' || v_descripcion || ', Precio: ' || v_precio);
END;
/

-----------------------------------------------------------------------Procedimiento para listar todos los productos-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ListarProductos IS
BEGIN
    FOR producto IN (SELECT id_Producto, descripcion, precio FROM tabla_inventario.Producto) LOOP
        DBMS_OUTPUT.PUT_LINE('Producto: ' || producto.id_Producto || ' - ' || producto.descripcion || ' - ' || producto.precio);
    END LOOP;
END;
/
