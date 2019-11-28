-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema spare_parts_company
-- -----------------------------------------------------
-- Вы работаете в фирме, занимающейся продажей запасных частей для автомобилей. Вашей задачей является отслеживание финансовой стороны работы компании. Основная часть деятельности, находящейся в вашем ведении, связана с работой с поставщиками. Фирма имеет определенный набор поставщиков, по каждому из которых известны название, адрес и телефон. У этих поставщиков вы приобретаете детали. Каждая деталь наряду с названием характеризуется артикулом и ценой (считаем цену постоянной). Некоторые из поставщиков могут поставлять одинаковые детали (один и тот же артикул). Каждый факт покупки запчастей у поставщика фиксируется в базе данных, причем обязательными для запоминания являются дата покупки и количество приобретенных деталей.

-- -----------------------------------------------------
-- Schema spare_parts_company
--
-- Вы работаете в фирме, занимающейся продажей запасных частей для автомобилей. Вашей задачей является отслеживание финансовой стороны работы компании. Основная часть деятельности, находящейся в вашем ведении, связана с работой с поставщиками. Фирма имеет определенный набор поставщиков, по каждому из которых известны название, адрес и телефон. У этих поставщиков вы приобретаете детали. Каждая деталь наряду с названием характеризуется артикулом и ценой (считаем цену постоянной). Некоторые из поставщиков могут поставлять одинаковые детали (один и тот же артикул). Каждый факт покупки запчастей у поставщика фиксируется в базе данных, причем обязательными для запоминания являются дата покупки и количество приобретенных деталей.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spare_parts_company` ;
USE `spare_parts_company` ;

-- -----------------------------------------------------
-- Table `spare_parts_company`.`distributor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spare_parts_company`.`distributor` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'уникальный идентификатор для каждого поставщика',
  `name` VARCHAR(45) NULL COMMENT 'Название поставщика',
  `adress` VARCHAR(45) NULL COMMENT 'Адрес поставщика',
  `phone` VARCHAR(45) NULL COMMENT 'Телефон поставщика',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Поставщик запчастей имеет название, адрес и телефон';


-- -----------------------------------------------------
-- Table `spare_parts_company`.`detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spare_parts_company`.`detail` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'уникальный идентификатор для каждой детали',
  `name` VARCHAR(45) NULL COMMENT 'Название детали',
  `code` VARCHAR(45) NULL COMMENT 'Артикул детали',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Каждая деталь наряду с названием характеризуется артикулом и ценой (считаем цену постоянной)';


-- -----------------------------------------------------
-- Table `spare_parts_company`.`purchase`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spare_parts_company`.`purchase` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'уникальный идентификатор для каждоой покупки',
  `date` DATE NULL COMMENT 'Дата покупки',
  `id_distributor` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_id_distributor_idx` (`id_distributor` ASC) VISIBLE,
  CONSTRAINT `fk_id_distributor`
    FOREIGN KEY (`id_distributor`)
    REFERENCES `spare_parts_company`.`distributor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица покупка содержит номер поставщика и дату покупки';


-- -----------------------------------------------------
-- Table `spare_parts_company`.`price_changes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spare_parts_company`.`price_changes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_detail` INT NULL,
  `new_price` DOUBLE NULL,
  `date` DATE NULL COMMENT 'Таблица изменения цен',
  PRIMARY KEY (`id`),
  INDEX `fk_id_detail_idx` (`id_detail` ASC) VISIBLE,
  CONSTRAINT `fk_id_detail_price`
    FOREIGN KEY (`id_detail`)
    REFERENCES `spare_parts_company`.`detail` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spare_parts_company`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spare_parts_company`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'уникальный идентификатор для каждого заказа',
  `count` INT NULL COMMENT 'количество деталей',
  `id_detail` INT NULL,
  `id_purchase` INT NULL,
  `id_price_changes` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_id_detail_idx` (`id_detail` ASC) VISIBLE,
  INDEX `fk_id_purchase_idx` (`id_purchase` ASC) VISIBLE,
  INDEX `fk_id_price_changes_idx` (`id_price_changes` ASC) VISIBLE,
  CONSTRAINT `fk_id_detail`
    FOREIGN KEY (`id_detail`)
    REFERENCES `spare_parts_company`.`detail` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_purchase`
    FOREIGN KEY (`id_purchase`)
    REFERENCES `spare_parts_company`.`purchase` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_price_changes`
    FOREIGN KEY (`id_price_changes`)
    REFERENCES `spare_parts_company`.`price_changes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица заказ, которая включает в себя номер сформированной покупки, номер детали и количество деталей';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
