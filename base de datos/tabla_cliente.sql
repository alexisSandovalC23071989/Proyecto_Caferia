-----------------------------------------------------------------USUARIO (tabla_clientes)--------------------------------------------------------------------
CREATE TABLE tabla_clientes.TarjetaBancaria (
    id_Tarjeta_Bancaria NUMBER CONSTRAINT IDX_TARJETA_BANCARIA NOT NULL PRIMARY KEY,
    numero VARCHAR2(16) NOT NULL,--------------------------------Le cambie el tipo de dato para poder agregar el numero de tardejeta--------------------------
    codigo NUMBER NOT NULL,
    fechaExpiracion DATE NOT NULL
);

-----------------------------------------------------------------Se crea la table  Paises----------------------------------------------------------------------
CREATE TABLE tabla_clientes.Pais(
id_Pais NUMBER CONSTRAINT IDX_PAIS NOT NULL PRIMARY KEY,
nombre_pais VARCHAR2(50) NOT NULL
);
----------------------------------------------------------------Se crea la tabla Provincia----------------------------------------------------------------------

CREATE TABLE tabla_clientes.Provincia(
id_Provincia NUMBER CONSTRAINT IDX_PROVINCIA NOT NULL PRIMARY KEY,
nombre_provincia VARCHAR2(50) NOT NULL,
FK_Pais NUMBER,
CONSTRAINT FK_PAIS FOREIGN KEY (FK_Pais) REFERENCES tabla_clientes.Pais(id_Pais)  
);
---------------------------------------------------------------Se crea la tabla Canton--------------------------------------------------------------------------
CREATE TABLE tabla_clientes.Canton(
id_Canton NUMBER CONSTRAINT IDX_Canton NOT NULL PRIMARY KEY,
nombre_canton VARCHAR2(50) NOT NULL,
FK_Provincia NUMBER,
CONSTRAINT FK_PROVINCIA FOREIGN KEY (FK_Provincia) REFERENCES tabla_clientes.Provincia(id_Provincia)  

);
--------------------------------------------------------------Se crea la tabla Distritos--------------------------------------------------------------------------
CREATE TABLE tabla_clientes.Distritos(
id_Distritos NUMBER CONSTRAINT IDX_DISTRITOS NOT NULL PRIMARY KEY,
nombre_distrito VARCHAR2(50) NOT NULL,
FK_Canton NUMBER,
CONSTRAINT FK_CANTON FOREIGN KEY (FK_Canton) REFERENCES tabla_clientes.Canton(id_Canton)  
);

--------------------------------------------------------------Se crea la tabla Direccion---------------------------------------------------------------------------
CREATE TABLE tabla_clientes.Direccion(
id_Direccion NUMBER CONSTRAINT IDX_DIRECCION NOT NULL PRIMARY KEY,
direccion_exacta VARCHAR2(50) NOT NULL,
FK_Distritos NUMBER,
CONSTRAINT FK_DISTRITO FOREIGN KEY (FK_Distritos) REFERENCES tabla_clientes.Distritos(id_Distritos)
);

---------------------------------------------------------------Se crea la tabla Cliente-----------------------------------------------------------------------------
CREATE TABLE tabla_clientes.Cliente (
    idCliente NUMBER CONSTRAINT IDX_CLIENTE_UNQ PRIMARY KEY,
    nombre VARCHAR2(45) NOT NULL,
    apellido VARCHAR2(45) NOT NULL,
    cedula NUMBER NOT NULL,
    telefono NUMBER NOT NULL,
    correo VARCHAR2(100) NOT NULL,
    FK_Direccion NUMBER,
    CONSTRAINT FK_DIRECCION_UNQ FOREIGN KEY (FK_Direccion) REFERENCES tabla_clientes.Direccion(id_Direccion),
    FK_TarjetaBancaria NUMBER,
    CONSTRAINT FK_TARJETA_BANCARIA_UNQ FOREIGN KEY (FK_TarjetaBancaria) REFERENCES tabla_clientes.TarjetaBancaria(id_Tarjeta_Bancaria)
);

///-----------------------------------------------------------------Procedimientos para la gestiÃ³n de clientes--------------------------------------------------------------

--------------------------------------------------------------------Procedimiento para insertar los datos de Cliente---------------------------------------------------------
CREATE OR REPLACE PROCEDURE InsertarCliente(
    p_idCliente IN NUMBER,  -- Cambié de INT a NUMBER
    p_nombre IN VARCHAR2,
    p_correo IN VARCHAR2
) IS
BEGIN
    INSERT INTO tabla_clientes.Cliente (idCliente, nombre, correo)
    VALUES (p_idCliente, p_nombre, p_correo);
END;
/

---------------------------------------------------------------------------Procedimiento para Actualizar los datos de los Clientes---------------------------------------------

CREATE OR REPLACE PROCEDURE ActualizarCliente(
    p_idCliente IN NUMBER,  ----------------------------------------------- Cambié de int a number------------------------------------------------------------------------------
    p_nombre IN VARCHAR2,
    p_correo IN VARCHAR2
) IS
BEGIN
    UPDATE tabla_clientes.Cliente
    SET nombre = p_nombre, correo = p_correo
    WHERE idCliente = p_idCliente;
END;
/

------------------------------------------------------------------Procedimiento para eliminar un cliente------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE EliminarCliente(
    p_idCliente IN NUMBER  --------------------------------------- Cambié de int por number--------------------------------------------------------------------------------------
) IS
BEGIN
    DELETE FROM tabla_clientes.Cliente WHERE idCliente = p_idCliente;
END;
/
-------------------------------------------------------------------Procedimiento para listar Clientes------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ListarClientes IS
BEGIN
    FOR cliente IN (SELECT * FROM tabla_clientes.Cliente) LOOP
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || cliente.idCliente || ' - ' || cliente.nombre || ' - ' || cliente.correo);
    END LOOP;
END;
/
