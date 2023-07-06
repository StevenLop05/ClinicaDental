Drop database if exists DBClinaMex;
Create database DBClinaMex;

Use DBClinaMex;

CREATE TABLE Pacientes(
	codigoPaciente INT NOT NULL,
    nombresPaciente VARCHAR(50) NOT NULL,
    apellidosPaciente VARCHAR(50) NOT NULL,
    sexo CHAR NOT NULL,
    fechaNacimiento DATE NOT NULL,
    direccionPaciente VARCHAR(100) NOT NULL,
    telefonoPersonal VARCHAR(8) NOT NULL,
    fechaPrimeraVisita DATE NOT NULL,
    PRIMARY KEY PK_codigoPaciente (codigoPaciente)
);

CREATE TABLE Especialidades(
	codigoEspecialidad INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(100) NOT NULL,
    PRIMARY KEY PK_codigoEspecialidad (codigoEspecialidad)
);

CREATE TABLE Medicamentos(
	codigoMedicamento INT NOT NULL AUTO_INCREMENT,
    nombreMedicamento VARCHAR(100) NOT NULL,
    PRIMARY KEY PK_codigoMedicamento (codigoMedicamento)    
);

CREATE TABLE Doctores(
	numeroColegiado INT NOT NUll,
    nombresDoctor VARCHAR(50) NOT NULL,
    apellidosDoctor VARCHAR(50) NOT NULL,
	telefonoContacto VARCHAR(8) NOT NULL,
    codigoEspecialidad INT NOT NULL,
    PRIMARY KEY PK_numeroColegiado (numeroColegiado),
    CONSTRAINT FK_Doctores_Especialidades foreign key (codigoEspecialidad)
		REFERENCES Especialidades (codigoEspecialidad)
);

CREATE TABLE Recetas(
	codigoReceta INT NOT NULL AUTO_INCREMENT,
    fechaReceta DATE NOT NULL,
    numeroColegiado INT NOT NULL,
    PRIMARY KEY PK_codigoReceta (codigoReceta),
    CONSTRAINT FK_Recetas_Doctores foreign key (numeroColegiado)
		REFERENCES Doctores (numeroColegiado)
);

CREATE TABLE Citas(
	codigoCita INT NOT NULL AUTO_INCREMENT,
    fechaCita DATE NOT NULL,
    horaCita TIME NOT NULL,
    tratamiento VARCHAR(150),
    descripCondActual VARCHAR(255) NOT NULL,
    codigoPaciente INT NOT NULL,
    numeroColegiado INT NOT NULL,
    PRIMARY KEY PK_codigoCita (codigoCita),
    CONSTRAINT FK_Citas_Pacientes foreign key (codigoPaciente)
		REFERENCES Pacientes (codigoPaciente),
	CONSTRAINT FK_Citas_Doctores foreign key (numeroColegiado)
		REFERENCES Doctores (numeroColegiado)    
);

CREATE TABLE DetalleRecetas(
	codigoDetalleReceta INT NOT NULL AUTO_INCREMENT,
    dosis VARCHAR(100) NOT NULL,
    codigoReceta INT NOT NULL,
    codigoMedicamento INT NOT NULL,
    PRIMARY KEY PK_codigoDetalleReceta (codigoDetalleReceta),
    CONSTRAINT FK_DetalleRecetas_Recetas foreign key (codigoReceta)
		REFERENCES Recetas (codigoReceta),
	CONSTRAINT FK_DetalleRecetas_Medicamentos foreign key (codigoMedicamento)
		REFERENCES Medicamentos (codigoMedicamento)
);
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------- PROCEDIMIENTOS ALMACENADOS ----------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- --------------------------------------- PACIENTES ---------------------------------------
-- --------------------------------------- AGREGAR PACIENTE ---------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_AgregarPaciente(in codigoPaciente INT, IN nombresPaciente VARCHAR(50), IN apellidosPaciente VARCHAR(50),IN sexo CHAR, 
                                            IN fechaNacimiento DATE, IN direccionPaciente VARCHAR(100), IN telefonoPersonal VARCHAR(8),IN fechaPrimeraVisita DATE)
            BEGIN
		INSERT INTO Pacientes (codigoPaciente, nombresPaciente, apellidosPaciente, sexo, fechaNacimiento,direccionPaciente, telefonoPersonal, fechaPrimeraVisita)
		VALUES(codigoPaciente, nombresPaciente, apellidosPaciente, upper(sexo), fechaNacimiento, direccionPaciente,telefonoPersonal, fechaPrimeraVisita);
            END//
DELIMITER ;

CALL sp_AgregarPaciente(1001, 'Steven Alejandro', 'Lopez del Cid', 'm', '2005-01-20', 'zona 5 de mixco', '43631720', now());
CALL sp_AgregarPaciente(1002, 'Maria Juana', 'Peralta Diaz', 'f', '2002-05-18', 'zona 8 de mixco', '51650451', now());
-- --------------------------------------- LISTAR PACIENTE ---------------------------------------

DELIMITER //
	CREATE PROCEDURE sp_ListarPaciente()
            BEGIN
		SELECT
                    P.codigoPaciente, 
                    P.nombresPaciente, 
                    P.apellidosPaciente, 
                    P.sexo, 
                    P.fechaNacimiento, 
                    P.direccionPaciente, 
                    P.telefonoPersonal, 
                    P.fechaPrimeraVisita
                FROM Pacientes P;
            END//
DELIMITER ;
CALL sp_ListarPaciente();
-- --------------------------------------- BUSCAR PACIENTE ---------------------------------------
DELIMITER //
    CREATE PROCEDURE sp_BuscarPaciente(IN codPaciente INT)
        BEGIN
            SELECT
		P.codigoPaciente, 
		P.nombresPaciente, 
		P.apellidosPaciente, 
		P.sexo, 
		P.fechaNacimiento, 
		P.direccionPaciente, 
		P.telefonoPersonal, 
		P.fechaPrimeraVisita
            FROM Pacientes P
		WHERE codigoPaciente = codPaciente;
        END//
DELIMITER ;

CALL sp_BuscarPaciente(1001);
-- --------------------------------------- ELIMINAR PACIENTE ---------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EliminarPaciente(IN codPaciente INT)
            BEGIN
		DELETE FROM Pacientes
                    WHERE codigoPaciente = codPaciente;
            END//
DELIMITER ;
CALL sp_EliminarPaciente(1001);
CALL sp_ListarPaciente();
-- --------------------------------------- EDITAR PACIENTE ---------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EditarPaciente(IN codPaciente INT, IN nombPaciente VARCHAR(50), IN apPaciente VARCHAR(50), IN sx CHAR, IN fechaNac DATE, 
										IN dirPaciente VARCHAR(100), IN telPersonal VARCHAR(8), IN fechaPV DATE)
            BEGIN
		UPDATE Pacientes P SET
                    P.nombresPaciente = nombPaciente, 
                    P.apellidosPaciente = apPaciente, 
                    P.sexo = sx, 
                    P.fechaNacimiento = fechaNac, 
                    P.direccionPaciente = dirPaciente, 
                    P.telefonoPersonal = telPersonal, 
                    P.fechaPrimeraVisita = fechaPV
			WHERE codigoPaciente = codPaciente;
        END//
DELIMITER ;
CALL sp_EditarPaciente(1001, 'Steven Alejandro', 'López del Cid', 'm', '2005-01-20', 'Zona 5 de mixco', '43631720', now())

-- --------------------------------------- ESPECIALIDADES ---------------------------------------
-- --------------------------------------- AGREGAR ESPECIALIDADES -------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_AgregarEspecialidad(IN descripcion VARCHAR(100))
            BEGIN 
		INSERT INTO Especialidades (descripcion)
                    VALUES(descripcion);
            END//
DELIMITER ;
CALL sp_AgregarEspecialidad("Odontologia");
CALL sp_AgregarEspecialidad("Anestesiologo");
-- --------------------------------------- LISTAR ESPECIALIDADES --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_ListarEspecialidad()
            BEGIN 
		SELECT
                    E.codigoEspecialidad,
                    E.descripcion
                    FROM Especialidades E;
            END//
DELIMITER ;
CALL sp_ListarEspecialidad();
-- --------------------------------------- BUSCAR ESPECIALIDADES --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_BuscarEspecialidad(IN codEspecialidad INT)
            BEGIN 
		SELECT
                    E.codigoEspecialidad,
                    E.descripcion
                    FROM Especialidades E
			WHERE codigoEspecialidad = codEspecialidad;
            END//
DELIMITER ;
CALL sp_BuscarEspecialidad(1);
-- --------------------------------------- ELIMINAR ESPECIALIDADES ------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EliminarEspecialidad(IN codEspecialidad INT)
            BEGIN 			
                DELETE FROM Especialidades
                    WHERE codigoEspecialidad = codEspecialidad;
            END//
DELIMITER ;
CALL sp_EliminarEspecialidad(1);
CALL sp_ListarEspecialidad();
-- --------------------------------------- EDITAR ESPECIALIDADES --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EditarEspecialidad(IN codEspecialidad INT, descrip VARCHAR(100))
            BEGIN 			
                UPDATE Especialidades E 
                    SET					
                        E.descripcion = descrip                
                            WHERE codigoEspecialidad = codEspecialidad;
            END//
DELIMITER ;
CALL sp_EditarEspecialidad(1, "Supervisor");

-- --------------------------------------- MEDICAMENTOS ---------------------------------------
-- --------------------------------------- AGREGAR MEDICAMENTOS -------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_AgregarMedicamento(IN nombreMedicamento VARCHAR(100))
            BEGIN 
		INSERT INTO Medicamentos (nombreMedicamento)
                    VALUES(nombreMedicamento);
            END//
DELIMITER ;
CALL sp_AgregarMedicamento("Acetaminofen");
CALL sp_AgregarMedicamento("Tapcin");
-- --------------------------------------- LISTAR MEDICAMENTOS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_ListarMedicamento()
            BEGIN 
		SELECT
                    M.codigoMedicamento,
                    M.nombreMedicamento
            FROM Medicamentos M;
        END//
DELIMITER ;
CALL sp_ListarMedicamento();
-- --------------------------------------- BUSCAR MEDICAMENTOS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_BuscarMedicamento(IN codMedicamento INT)
            BEGIN 
                SELECT
                    M.codigoMedicamento,
                    M.nombreMedicamento
                    FROM Medicamentos M
			WHERE codigoMedicamento = codMedicamento;
            END//
DELIMITER ;
CALL sp_BuscarMedicamento(1);
-- --------------------------------------- ELIMINAR MEDICAMENTOS ------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EliminarMedicamento(IN codMedicamento INT)
            BEGIN 			
                DELETE FROM Medicamentos
                    WHERE codigoMedicamento= codMedicamento;
            END//
DELIMITER ;
CALL sp_EliminarMedicamento(1);
CALL sp_ListarMedicamento();
-- --------------------------------------- EDITAR MEDICAMENTOS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EditarMedicamento(IN codMedicamento INT, nombMedicamento VARCHAR(100))
            BEGIN 			
                UPDATE Medicamentos M
                    SET
			M.nombreMedicamento = nombMedicamento
                            WHERE codigoMedicamento = codMedicamento;
            END//
DELIMITER ;
CALL sp_EditarMedicamento(1,"ViroGrip");

-- --------------------------------------- DOCTORES ---------------------------------------
-- --------------------------------------- AGREGAR DOCTORES -------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_AgregarDoctores(IN numeroColegiado INT, IN nombresDoctor VARCHAR(50), IN apellidosDoctor VARCHAR(50),
								IN telefonoContacto VARCHAR(8), IN codigoEspecialidad INT)
            BEGIN
		INSERT INTO Doctores(numeroColegiado, nombresDoctor, apellidosDoctor, telefonoContacto, codigoEspecialidad)
                    VALUES (numeroColegiado, nombresDoctor, apellidosDoctor, telefonoContacto, codigoEspecialidad);                
            END //
DELIMITER ;

CALL sp_AgregarDoctores(400198339, 'Jose Manuel', 'Perez Albeño', '52894625', 2);
CALL sp_AgregarDoctores(400223440, 'Erick Fabricio', 'Lopez Lucas', '45895625', 2);
-- --------------------------------------- LISTAR DOCTORES --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_ListarDoctores()
            BEGIN
		SELECT
                    D.numeroColegiado,
                    D.nombresDoctor,
                    D.apellidosDoctor,
                    D.telefonoContacto,
                    D.codigoEspecialidad
                    FROM Doctores D;
        END //
DELIMITER ; 

CALL sp_ListarDoctores();
Select
	D.numeroColegiado,
	D.nombresDoctor,	
	D.apellidosDoctor,
	D.telefonoContacto,
	E.descripcion	
	From Doctores D
		INNER JOIN Especialidades as E ON D.codigoEspecialidad = E.codigoEspecialidad;			
-- --------------------------------------- BUSCAR DOCTORES --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_BuscarDoctores(IN numCol INT)
            BEGIN
		SELECT
                    D.numeroColegiado,
                    D.nombresDoctor,
                    D.apellidosDoctor,
                    D.telefonoContacto,
                    D.codigoEspecialidad
                    FROM Doctores D
			WHERE numeroColegiado = numCol;
            END //
DELIMITER ; 

CALL sp_BuscarDoctores(400198339);
-- --------------------------------------- ELIMINAR DOCTORES ------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EliminarDoctor(IN numCol INT)
            BEGIN
                DELETE FROM Doctores
                    WHERE numeroColegiado = numCol;
            END //
DELIMITER ;

CALL sp_EliminarDoctor(400223440);
-- --------------------------------------- EDITAR DOCTORES --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EditarDoctor(IN numCol INT, IN nomDoc VARCHAR(50), IN apellDoc VARCHAR(50), IN telCon VARCHAR(8))
            BEGIN
		UPDATE Doctores D SET
                    D.nombresDoctor = nomDoc,
                    D.apellidosDoctor = apellDoc,
                    D.telefonoContacto = telCon
			WHERE numeroColegiado = numCol;
            END //
DELIMITER ;

CALL sp_EditarDoctor(400198339, 'Raul Emanuel', 'Lopez Numal', '23614289');

-- --------------------------------------- RECETAS ---------------------------------------
-- --------------------------------------- AGREGAR RECETAS -------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_AgregarRecetas(IN fechaReceta DATE, IN numeroColegiado INT)
            BEGIN
                INSERT INTO Recetas (fechaReceta, numeroColegiado)
                    VALUES (fechaReceta, numeroColegiado);
            END //
DELIMITER ;

CALL sp_AgregarRecetas('2022-04-14', 400198339);
CALL sp_AgregarRecetas('2022-07-24', 400198339);
-- --------------------------------------- LISTAR RECETAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_ListarRecetas()
            BEGIN
		SELECT
                    R.codigoReceta,
                    R.fechaReceta,
                    R.numeroColegiado
			FROM Recetas R;
            END //
DELIMITER ;

CALL sp_ListarRecetas();
Select
	R.codigoReceta,
	R.fechaReceta,
    D.nombresDoctor,
    D.apellidosDoctor
	From Recetas R
		INNER JOIN Doctores as D ON R.numeroColegiado = D.numeroColegiado;		
-- --------------------------------------- BUSCAR RECETAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_BuscarReceta(IN codRec INT)
            BEGIN
                SELECT
                    R.codigoReceta,
                    R.fechaReceta,
                    R.numeroColegiado
                    FROM Recetas R 
                        WHERE codigoReceta = codRec;
            END //
DELIMITER ;

CALL sp_BuscarReceta(1);
-- --------------------------------------- ELIMINAR RECETAS ------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EliminarReceta(IN codRec INT)
            BEGIN
		DELETE FROM Recetas
                    WHERE codigoReceta = codRec;
            END //
DELIMITER ;

CALL sp_EliminarReceta(2);
-- --------------------------------------- EDITAR RECETAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EditarReceta (IN codRec INT, IN fechRec DATE)
            BEGIN
		UPDATE Recetas R SET
                    R.fechaReceta = fechRec                    
			WHERE codigoReceta = codRec;
            END //
DELIMITER ;

CALL sp_EditarReceta(1, '2022-05-14');

-- --------------------------------------- CITAS ---------------------------------------
-- --------------------------------------- AGREGAR CITAS -------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_AgregarCita(IN fechaCita DATE, IN horaCita TIME, IN tratamiento VARCHAR(50), IN descripCondActual VARCHAR(100),
											IN codigoPaciente INT, IN numeroColegiado INT)
            BEGIN	
		INSERT INTO Citas(fechaCita, horaCita, tratamiento, descripCondActual, codigoPaciente, numeroColegiado)
                    VALUES (fechaCita, horaCita, tratamiento, descripCondActual, codigoPaciente, numeroColegiado);
            END //
DELIMITER ;

CALL sp_AgregarCita('2021-05-13', '13:50:00', 'Tomar Medicamento', 'Estable', 1002, 400198339);
CALL sp_AgregarCita('2021-01-08', '05:10:00', 'Hacer Examenes', 'Estable-Delicado', 1002, 400198339);
-- --------------------------------------- LISTAR CITAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_ListarCitas()
            BEGIN
		SELECT
                    C.codigoCita,
                    C.fechaCita,
                    C.horaCita,
                    C.tratamiento,
                    C.descripCondActual,
                    C.codigoPaciente,
                    C.numeroColegiado
                    FROM Citas C;
        END //
DELIMITER ;

CALL sp_ListarCitas();
-- --------------------------------------- BUSCAR CITAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_BuscarCita(IN codCi INT)
            BEGIN
		SELECT
                    C.codigoCita,
                    C.fechaCita,
                    C.horaCita,
                    C.tratamiento,
                    C.descripCondActual,
                    C.codigoPaciente,
                    C.numeroColegiado
                    FROM Citas C
			WHERE codigoCita = codCi;
            END //
DELIMITER ;

CALL sp_BuscarCita(1);
-- --------------------------------------- ELIMINAR CITAS ------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EliminarCita(IN codCi INT)
            BEGIN
                DELETE FROM Citas
                    WHERE codigoCita = codCi;
            END //
DELIMITER ;

CALL sp_EliminarCita(2);
-- --------------------------------------- EDITAR CITAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EditarCita(IN codCi INT, IN fechCita DATE, IN horCita TIME, IN tratami VARCHAR(50), IN condActual VARCHAR(100))
            BEGIN
		UPDATE Citas C SET
                    C.fechaCita = fechCita,
                    C.horaCita = horaCita,
                    C.tratamiento = tratami,
                    C.descripCondActual = condActual
			WHERE codigoCita = codCi;
            END //
DELIMITER ;

CALL sp_EditarCita(1, '2021-09-21', '15:50:00', 'Examenes', 'Estable');
/*
Select
	C.codigoCita,
	C.fechaCita,
	time_format (C.horaCita, '%H:%i') as Hora,
	C.tratamiento,
	C.descripCondActual,
	P.nombresPaciente,
	D.nombresDoctor
	From Citas C
		INNER JOIN Pacientes as P ON C.codigoPaciente = P.codigoPaciente
			INNER JOIN Doctores AS D ON C.numeroColegiado = D.numeroColegiado;
*/


-- --------------------------------------- DETALLES RECETAS ---------------------------------------
-- --------------------------------------- AGREGAR DETALLES RECETAS -------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_AgregarDetalleReceta(IN dosis VARCHAR(100), IN codigoReceta INT, IN codigoMedicamento INT)
            BEGIN
		INSERT INTO DetalleRecetas (dosis, codigoReceta, codigoMedicamento)
                    VALUES (dosis, codigoReceta, codigoMedicamento);
            END //
DELIMITER ;

CALL sp_AgregarDetalleReceta('Tomar cada 8 horas', 1, 2);
CALL sp_AgregarDetalleReceta('Tomar cada 24 horas', 1, 2);
-- --------------------------------------- LISTAR DETALLES RECETAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_ListarDetallesRecetas()
            BEGIN
		SELECT
                    DR.codigoDetalleReceta,
                    DR.dosis,
                    DR.codigoReceta,
                    DR.codigoMedicamento
                    FROM DetalleRecetas DR;
            END //
DELIMITER ;

CALL sp_ListarDetallesRecetas();
Select
	DR.codigoDetalleReceta,
	DR.dosis,
    R.codigoReceta,
    M.nombreMedicamento
	From DetalleRecetas DR
		INNER JOIN Medicamentos as M ON DR.codigoMedicamento = M.codigoMedicamento
			INNER JOIN Recetas as R ON DR.codigoReceta = R.codigoReceta;	
-- --------------------------------------- BUSCAR DETALLES RECETAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_BuscarDetalleReceta(IN codDR INT)
            BEGIN
                SELECT
                    DR.codigoDetalleReceta,
                    DR.dosis,
                    DR.codigoReceta,
                    DR.codigoMedicamento
                    FROM DetalleRecetas DR
			WHERE codigoDetalleReceta = codDR;
            END //
DELIMITER ;

CALL sp_BuscarDetalleReceta(1);
-- --------------------------------------- ELIMINAR DETALLES RECETAS ------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EliminarDetalleReceta(IN codDR INT) 
            BEGIN
		DELETE FROM DetalleRecetas
                    WHERE codigoDetalleReceta = codDR;
            END //
DELIMITER ;

CALL sp_EliminarDetalleReceta(2);
-- --------------------------------------- EDITAR DETALLES RECETAS --------------------------------------
DELIMITER //
	CREATE PROCEDURE sp_EditarDetalleReceta(IN codDR INT, IN dos VARCHAR(100))
            BEGIN
                UPDATE DetalleRecetas DR SET
                    DR.dosis = dos
			WHERE codigoDetalleReceta = codDR;
            END //
DELIMITER ;

CALL sp_EditarDetalleReceta(1, 'Tomar en ayunos');

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin';


CREATE TABLE Usuario(
	codigoUsuario INT NOT NULL AUTO_INCREMENT,
    nombreUsuario VARCHAR(100) NOT NULL,
    apellidoUsuario VARCHAR(100) NOT NULL,
    usuarioLogin VARCHAR(50) NOT NULL,
    contrasena VARCHAR(50) NOT NULL,
    PRIMARY KEY PK_codigoUsuario (codigoUsuario)
);

DELIMITER //
	CREATE PROCEDURE sp_AgregarUsuario(IN nombreUsuario VARCHAR(100), IN apellidoUsuario VARCHAR(100), IN usuarioLogin VARCHAR(50), IN contrasena VARCHAR(50))
		BEGIN
			INSERT INTO Usuario(nombreUsuario, apellidoUsuario, usuarioLogin, contrasena)
				VALUES (nombreUsuario, apellidoUsuario, usuarioLogin, contrasena);
        END//
DELIMITER ;

DELIMITER //
	CREATE PROCEDURE sp_ListarUsuarios()
		BEGIN
			SELECT
				U.codigoUsuario,
				U.nombreUsuario, 
                U.apellidoUsuario, 
                U.usuarioLogin, 
                U.contrasena
                FROM Usuario U;
        END//
DELIMITER ;

CALL sp_AgregarUsuario('Steven','Lopez','stelop','@123');
CALL sp_ListarUsuarios();

CREATE TABLE Login(
	usuarioMaster VARCHAR(50) NOT NULL,
    passwordLogin VARCHAR(50) NOT NULL,
    PRIMARY KEY PK_usuarioMaster (usuarioMaster)
);
