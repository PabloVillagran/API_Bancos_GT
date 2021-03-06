-- MySQL Script generated by MySQL Workbench
-- Sun Jun  6 12:44:59 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`detalle_cheque` ;
DROP TABLE IF EXISTS `mydb`.`detalle_estado_cuenta` ;
DROP TABLE IF EXISTS `mydb`.`Consulta_Cheque` ;
DROP TABLE IF EXISTS `mydb`.`Consulta_saldo` ;
DROP TABLE IF EXISTS `mydb`.`Consulta_estado_cuenta` ;
DROP TABLE IF EXISTS `mydb`.`Pago_servicio_diverso` ;
DROP TABLE IF EXISTS `mydb`.`Servicio_afiliado` ;
DROP TABLE IF EXISTS `mydb`.`Transferencia` ;
DROP TABLE IF EXISTS `mydb`.`Pago_servicio_banca` ;
DROP TABLE IF EXISTS `mydb`.`Cuenta_asociada` ;
DROP TABLE IF EXISTS `mydb`.`Sesion_usuario` ;
DROP TABLE IF EXISTS `mydb`.`API_Banco` ;
DROP TABLE IF EXISTS `mydb`.`Banco` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Banco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Banco` (
  `idBanco` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`idBanco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`API_Banco`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`API_Banco` (
  `idAPI` INT NOT NULL AUTO_INCREMENT,
  `endpoint` VARCHAR(45) NULL,
  `servicio` VARCHAR(50) NOT NULL,
  `Banco_idBanco1` INT NOT NULL,
  PRIMARY KEY (`idAPI`),
  CONSTRAINT `fk_API_Banco_Banco1`
    FOREIGN KEY (`Banco_idBanco1`)
    REFERENCES `mydb`.`Banco` (`idBanco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_API_Banco_Banco1_idx` ON `mydb`.`API_Banco` (`Banco_idBanco1` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`Sesion_usuario`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Sesion_usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Nombre_usuario` VARCHAR(45) NULL,
  `Token` VARCHAR(45) NULL,
  `fecha_hora_expira` VARCHAR(45) NULL,
  `correo_electr??nico` VARCHAR(45) NULL,
  `API_Banco_idAPI` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sesion_usuario_API_Banco1`
    FOREIGN KEY (`API_Banco_idAPI`)
    REFERENCES `mydb`.`API_Banco` (`idAPI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_sesion_usuario_API_Banco1_idx` ON `mydb`.`Sesion_usuario` (`API_Banco_idAPI` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`Cuenta_asociada`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Cuenta_asociada` (
  `numero_cuenta` INT NOT NULL AUTO_INCREMENT,
  `sesion_usuario_id` INT NOT NULL,
  `isCredito` INT NULL,
  PRIMARY KEY (`numero_cuenta`, `sesion_usuario_id`),
  CONSTRAINT `fk_cuenta_asociada_sesion_usuario1`
    FOREIGN KEY (`sesion_usuario_id`)
    REFERENCES `mydb`.`Sesion_usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_cuenta_asociada_sesion_usuario1_idx` ON `mydb`.`Cuenta_asociada` (`sesion_usuario_id` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`Pago_servicio_banca`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Pago_servicio_banca` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Monto` DOUBLE NULL,
  `Identificador_servicio` VARCHAR(45) NULL,
  `id_nota_credito` VARCHAR(45) NULL,
  `cuenta_origen` INT NOT NULL,
  `session_id` INT NOT NULL,
  `API_Banco_idAPI` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Pago_servicio_banca_API_Banco1`
    FOREIGN KEY (`API_Banco_idAPI`)
    REFERENCES `mydb`.`API_Banco` (`idAPI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pago_servicio_banca_cuenta_asociada1`
    FOREIGN KEY (`cuenta_origen` , `session_id`)
    REFERENCES `mydb`.`Cuenta_asociada` (`numero_cuenta` , `sesion_usuario_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Pago_servicio_banca_API_Banco1_idx` ON `mydb`.`Pago_servicio_banca` (`API_Banco_idAPI` ASC) ;

CREATE INDEX `fk_Pago_servicio_banca_cuenta_asociada1_idx` ON `mydb`.`Pago_servicio_banca` (`cuenta_origen` ASC, `session_id` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`Transferencia`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Transferencia` (
  `idTransferencia` INT NOT NULL AUTO_INCREMENT,
  `monto` DOUBLE NULL,
  `cuenta_destino` VARCHAR(45) NULL,
  `nota_credito` VARCHAR(45) NULL,
  `fecha_transferencia` DATE NULL,
  `cuenta_origen` INT NOT NULL,
  `session_id` INT NOT NULL,
  `API_Banco_idAPI` INT NOT NULL,
  PRIMARY KEY (`idTransferencia`),
  CONSTRAINT `fk_Transferencia_API_Banco1`
    FOREIGN KEY (`API_Banco_idAPI`)
    REFERENCES `mydb`.`API_Banco` (`idAPI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transferencia_cuenta_asociada1`
    FOREIGN KEY (`cuenta_origen` , `session_id`)
    REFERENCES `mydb`.`Cuenta_asociada` (`numero_cuenta` , `sesion_usuario_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Transferencia_API_Banco1_idx` ON `mydb`.`Transferencia` (`API_Banco_idAPI` ASC) ;

CREATE INDEX `fk_Transferencia_cuenta_asociada1_idx` ON `mydb`.`Transferencia` (`cuenta_origen` ASC, `session_id` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`Servicio_afiliado`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Servicio_afiliado` (
  `idServicio` INT NOT NULL AUTO_INCREMENT,
  `NombreServicio` VARCHAR(45) NULL,
  PRIMARY KEY (`idServicio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Pago_servicio_diverso`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Pago_servicio_diverso` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Monto` DOUBLE NULL,
  `Fecha_facturacion` DATE NULL,
  `Fecha_pago` VARCHAR(45) NULL,
  `Identificacion_factura` VARCHAR(45) NULL,
  `cuenta_origen` INT NOT NULL,
  `session_id` INT NOT NULL,
  `API_Banco_idAPI` INT NOT NULL,
  `Servicios_afiliados_idServicios` INT NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `fk_Pago_servicio_diverso_Servicios_afiliados1`
    FOREIGN KEY (`Servicios_afiliados_idServicios`)
    REFERENCES `mydb`.`Servicio_afiliado` (`idServicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pago_servicio_diverso_API_Banco1`
    FOREIGN KEY (`API_Banco_idAPI`)
    REFERENCES `mydb`.`API_Banco` (`idAPI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pago_servicio_diverso_cuenta_asociada1`
    FOREIGN KEY (`cuenta_origen` , `session_id`)
    REFERENCES `mydb`.`Cuenta_asociada` (`numero_cuenta` , `sesion_usuario_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Pago_servicio_diverso_Servicios_afiliados1_idx` ON `mydb`.`Pago_servicio_diverso` (`Servicios_afiliados_idServicios` ASC) ;

CREATE INDEX `fk_Pago_servicio_diverso_API_Banco1_idx` ON `mydb`.`Pago_servicio_diverso` (`API_Banco_idAPI` ASC) ;

CREATE INDEX `fk_Pago_servicio_diverso_cuenta_asociada1_idx` ON `mydb`.`Pago_servicio_diverso` (`cuenta_origen` ASC, `session_id` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`Consulta_Cheque`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Consulta_Cheque` (
  `idConsulta_Cheque` INT NOT NULL AUTO_INCREMENT,
  `API_Banco_Banco_idBanco` INT NOT NULL,
  `fecha_inicial` DATE NULL,
  `fecha_final` DATE NULL,
  `Consulta_Chequecol` VARCHAR(45) NULL,
  `API_Banco_idAPI` INT NOT NULL,
  `cuenta_origen` INT NOT NULL,
  `session_id` INT NOT NULL,
  PRIMARY KEY (`idConsulta_Cheque`),
  CONSTRAINT `fk_Consulta_Cheque_API_Banco1`
    FOREIGN KEY (`API_Banco_idAPI`)
    REFERENCES `mydb`.`API_Banco` (`idAPI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_Cheque_cuenta_asociada1`
    FOREIGN KEY (`cuenta_origen` , `session_id`)
    REFERENCES `mydb`.`Cuenta_asociada` (`numero_cuenta` , `sesion_usuario_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Consulta_Cheque_API_Banco1_idx` ON `mydb`.`Consulta_Cheque` (`API_Banco_idAPI` ASC, `API_Banco_Banco_idBanco` ASC) ;

CREATE INDEX `fk_Consulta_Cheque_cuenta_asociada1_idx` ON `mydb`.`Consulta_Cheque` (`cuenta_origen` ASC, `session_id` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`Consulta_saldo`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Consulta_saldo` (
  `idConsulta_saldo` INT NOT NULL AUTO_INCREMENT,
  `nombre_cuenta` VARCHAR(45) NULL,
  `saldo_disponible` DOUBLE NULL,
  `saldo_reserva` DOUBLE NULL,
  `saldo_flotante` DOUBLE NULL,
  `saldo_total` DOUBLE NULL,
  `moneda` CHAR NULL,
  `API_Banco_idAPI` INT NOT NULL,
  `cuenta_origen` INT NOT NULL,
  `session_id` INT NOT NULL,
  PRIMARY KEY (`idConsulta_saldo`),
  CONSTRAINT `fk_Consulta_saldo_API_Banco1`
    FOREIGN KEY (`API_Banco_idAPI`)
    REFERENCES `mydb`.`API_Banco` (`idAPI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_saldo_cuenta_asociada1`
    FOREIGN KEY (`cuenta_origen` , `session_id`)
    REFERENCES `mydb`.`Cuenta_asociada` (`numero_cuenta` , `sesion_usuario_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Consulta_saldo_API_Banco1_idx` ON `mydb`.`Consulta_saldo` (`API_Banco_idAPI` ASC) ;

CREATE INDEX `fk_Consulta_saldo_cuenta_asociada1_idx` ON `mydb`.`Consulta_saldo` (`cuenta_origen` ASC, `session_id` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`Consulta_estado_cuenta`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`Consulta_estado_cuenta` (
  `idConsulta_estado_cuenta` INT NOT NULL AUTO_INCREMENT,
  `fecha_inicial` DATE NULL,
  `fecha_final` DATE NULL,
  `formato_salida` VARCHAR(45) NULL,
  `API_Banco_idAPI` INT NOT NULL,
  `cuenta_origen` INT NOT NULL,
  `session_id` INT NOT NULL,
  PRIMARY KEY (`idConsulta_estado_cuenta`),
  CONSTRAINT `fk_Consulta_estado_cuenta_API_Banco1`
    FOREIGN KEY (`API_Banco_idAPI`)
    REFERENCES `mydb`.`API_Banco` (`idAPI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_estado_cuenta_cuenta_asociada1`
    FOREIGN KEY (`cuenta_origen` , `session_id`)
    REFERENCES `mydb`.`Cuenta_asociada` (`numero_cuenta` , `sesion_usuario_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Consulta_estado_cuenta_API_Banco1_idx` ON `mydb`.`Consulta_estado_cuenta` (`API_Banco_idAPI` ASC) ;

CREATE INDEX `fk_Consulta_estado_cuenta_cuenta_asociada1_idx` ON `mydb`.`Consulta_estado_cuenta` (`cuenta_origen` ASC, `session_id` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`detalle_estado_cuenta`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`detalle_estado_cuenta` (
  `correlativo` INT NOT NULL AUTO_INCREMENT,
  `id_consulta` INT NOT NULL,
  `fecha_transaccion` DATE NULL,
  `monto` DOUBLE NULL,
  `cuenta_destino` VARCHAR(45) NULL,
  PRIMARY KEY (`correlativo`, `id_consulta`),
  CONSTRAINT `fk_detalle_estado_cuenta_Consulta_estado_cuenta1`
    FOREIGN KEY (`id_consulta`)
    REFERENCES `mydb`.`Consulta_estado_cuenta` (`idConsulta_estado_cuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_detalle_estado_cuenta_Consulta_estado_cuenta1_idx` ON `mydb`.`detalle_estado_cuenta` (`id_consulta` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`detalle_cheque`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb`.`detalle_cheque` (
  `correlativo` INT NOT NULL AUTO_INCREMENT,
  `id_consulta` INT NOT NULL,
  `numero_cheque` INT NULL,
  `fecha_cobro` DATE NULL,
  `imagen_frente` BLOB NULL,
  `imagen_reverso` BLOB NULL,
  PRIMARY KEY (`correlativo`, `id_consulta`),
  CONSTRAINT `fk_detalle_cheque_Consulta_Cheque1`
    FOREIGN KEY (`id_consulta`)
    REFERENCES `mydb`.`Consulta_Cheque` (`idConsulta_Cheque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_detalle_cheque_Consulta_Cheque1_idx` ON `mydb`.`detalle_cheque` (`id_consulta` ASC) ;

-- -----------------------------------------------------
-- Insert `mydb`.`banco`
-- Inserta los bancos autorizados en el sistema
-- -----------------------------------------------------
INSERT INTO `mydb`.`banco` (`idBanco`,`Nombre`) VALUES('1','GyT');
INSERT INTO `mydb`.`banco` (`idBanco`,`Nombre`) VALUES('2','Banrural');
INSERT INTO `mydb`.`banco` (`idBanco`,`Nombre`) VALUES('3','BanTrab');
INSERT INTO `mydb`.`banco` (`idBanco`,`Nombre`) VALUES('4','Banco Industrial');
INSERT INTO `mydb`.`banco` (`idBanco`,`Nombre`) VALUES('5','BAC Credomatic');

-- -----------------------------------------------------
-- Insert `mydb`.`API_Banco`
-- Inserta los bancos autorizados en el sistema
-- -----------------------------------------------------
INSERT INTO `mydb`.`API_Banco`(`endpoint`,`servicio`, `banco_idBanco1`) VALUES ('http://localhost:9000/mockup/inicio_sesion/', 'login', '1');
INSERT INTO `mydb`.`API_Banco`(`endpoint`,`servicio`, `banco_idBanco1`) VALUES ('http://localhost:9000/mockup/registro_usuario/', 'registro', '1');
