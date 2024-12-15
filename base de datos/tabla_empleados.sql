-----------------------------------------------------------------------Usuario tabla_empleados---------------------------------------------------------------------
-----------------------------------------------------------------------Se crea la tabla Funciones-----------------------------------------------------------------
CREATE TABLE tabla_empleados.Funcion (
    id_Funcion NUMBER CONSTRAINT IDX_FUNCION NOT NULL PRIMARY KEY,
    descripcion VARCHAR2(100) NOT NULL
);

----------------------------------------------------------------------Se crea la tabla horarios----------------------------------------------------------------------

CREATE TABLE tabla_empleados.Horario (
    id_Horario NUMBER CONSTRAINT IDX_Horario NOT NULL PRIMARY KEY,
    horaEntrada TIMESTAMP NOT NULL, 
    horaSalida TIMESTAMP NOT NULL
);


----------------------------------------------------------------------Se crea la tabla Empleados-----------------------------------------------------------------------
CREATE TABLE tabla_empleados.Empleados (
    id_Empleado NUMBER CONSTRAINT IDX_EMPLEADO NOT NULL PRIMARY KEY,
    nombre VARCHAR2(45) NOT NULL,
    primer_apellido VARCHAR2(45) NOT NULL,
    segundo_apellido VARCHAR2(45) NOT NULL,
    correo VARCHAR2(200),
    telefono NUMBER NOT NULL,
    FK_Funcion NUMBER NOT NULL,
    CONSTRAINT FK_FUNCION FOREIGN KEY (FK_Funcion) REFERENCES tabla_empleados.Funcion(id_Funcion),
    FK_Horario NUMBER NOT NULL,
     CONSTRAINT FK_HORARIO FOREIGN KEY (FK_Horario) REFERENCES tabla_empleados.Horario(id_Horario)
);



--------------------------------------------------------------------Procedimientos para la Gestion de Empleados (5)----------------------------------------------------------------

-------------------------------------------------------------------- Procedimiento para insertar un empleado-----------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE InsertarEmpleado(
    p_idEmpleado IN NUMBER,  --------------------------------------- Cambie de int a number---------------------------------------------------------------------------------------
    p_nombre IN VARCHAR2,
    p_primerApellido IN VARCHAR2,
    p_segundoApellido IN VARCHAR2,
    p_correo IN VARCHAR2,
    p_telefono IN NUMBER,
    p_fkFuncion IN NUMBER,
    p_fkHorario IN NUMBER
) IS
BEGIN
    INSERT INTO tabla_empleados.Empleados (
        id_Empleado, nombre, primer_apellido, segundo_apellido, correo, telefono, FK_Funcion, FK_Horario
    ) VALUES (
        p_idEmpleado, p_nombre, p_primerApellido, p_segundoApellido, p_correo, p_telefono, p_fkFuncion, p_fkHorario
    );
END;
/

--------------------------------------------------------------------------- Procedimiento para actualizar un empleado----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE ActualizarEmpleado(
    p_idEmpleado IN NUMBER,  -- Cambie de int a number
    p_nombre IN VARCHAR2,
    p_primerApellido IN VARCHAR2,
    p_segundoApellido IN VARCHAR2,
    p_correo IN VARCHAR2,
    p_telefono IN NUMBER
) IS
BEGIN
    UPDATE tabla_empleados.Empleados
    SET nombre = p_nombre,
        primer_apellido = p_primerApellido,
        segundo_apellido = p_segundoApellido,
        correo = p_correo,
        telefono = p_telefono
    WHERE id_Empleado = p_idEmpleado;
END;
/
-- --------------------------------------------------------------------------Procedimiento para eliminar un empleado--------------------------------------------------------------
CREATE OR REPLACE PROCEDURE EliminarEmpleado(
    p_idEmpleado IN NUMBER  --------------------------------------------------Cambie de int a number------------------------------------------------------------------------------
) IS
BEGIN
    DELETE FROM tabla_empleados.Empleados WHERE id_Empleado = p_idEmpleado;
END;
/

 
------------------------------------------------------------------------------Procedimiento para buscar un empleado---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE BuscarEmpleado(
    p_idEmpleado IN NUMBER  ---------------------------------------------------Cambie de int a number----------------------------------------------------------------------------
) IS
    v_nombre tabla_empleados.Empleados.nombre%TYPE;
    v_primerApellido tabla_empleados.Empleados.primer_apellido%TYPE;
    v_segundoApellido tabla_empleados.Empleados.segundo_apellido%TYPE;
BEGIN
    SELECT nombre, primer_apellido, segundo_apellido
    INTO v_nombre, v_primerApellido, v_segundoApellido
    FROM tabla_empleados.Empleados
    WHERE id_Empleado = p_idEmpleado;

    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre || ', Apellidos: ' || v_primerApellido || ' ' || v_segundoApellido);
END;
/

-------------------------------------------------------------------------------Procedimiento para listar todos los empleados-------------------------------------------------------
CREATE OR REPLACE PROCEDURE ListarEmpleados IS
BEGIN
    FOR emp IN (SELECT id_Empleado, nombre, primer_apellido, segundo_apellido FROM tabla_empleados.Empleados) LOOP
        DBMS_OUTPUT.PUT_LINE('Empleado: ' || emp.id_Empleado || ' - ' || emp.nombre || ' - ' || emp.primer_apellido || ' ' || emp.segundo_apellido);
    END LOOP;
END;
/

