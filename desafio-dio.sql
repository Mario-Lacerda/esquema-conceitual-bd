-- -----------------------------------------------------
-- Schema e-commerce-dio
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `e-commerce-dio` DEFAULT CHARACTER SET utf8 ;
USE `e-commerce-dio` ;

-- -----------------------------------------------------
-- Create Table `Client`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Client` (
  `idClient` INT NOT NULL AUTO_INCREMENT,
  `first name` VARCHAR(10) NOT NULL,
  `surname` VARCHAR(20) NOT NULL,
  `address` VARCHAR(45) NULL,
  `CPF` CHAR(11) NULL,
  `CNPJ` CHAR(14) NULL,
  `birthdate` DATE NOT NULL,
  PRIMARY KEY (`idClient`),
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC) VISIBLE,
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE,
  CONSTRAINT CHK_Client CHECK (`CPF` != NULL OR `CNPJ`!= NULL)
  );

-- -----------------------------------------------------
-- Create Table `Payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Payments` (
  `idPayments` INT NOT NULL AUTO_INCREMENT,
  `idClient` INT NOT NULL,
  `typePayment` ENUM('Boleto', 'Cartão', 'Dois Cartões', 'Pix') NOT NULL,
  `limitAvailable` FLOAT NULL DEFAULT 0,
  PRIMARY KEY (`idPayments`, `idClient`)
  );

-- -----------------------------------------------------
-- Create Table `Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Order` (
  `idOrder` INT NOT NULL AUTO_INCREMENT,
  `status` ENUM('Em Andamento', 'Processando', 'Enviado', 'Entregue') NULL DEFAULT 'Processando',
  `description` VARCHAR(45) NULL,
  `deliveryCost` FLOAT NULL,
  `Client_idClient` INT NOT NULL,
  `Payments_idPayments` INT NOT NULL,
  `Payments_idClient` INT NOT NULL,
  PRIMARY KEY (`idOrder`, `Payments_idPayments`, `Payments_idClient`),
  UNIQUE INDEX `idOrder_UNIQUE` (`idOrder` ASC) INVISIBLE,
  INDEX `fk_Order_Client_idx` (`Client_idClient` ASC) VISIBLE,
  INDEX `fk_Order_Payments1_idx` (`Payments_idPayments` ASC, `Payments_idClient` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Client`
    FOREIGN KEY (`Client_idClient`)
    REFERENCES `e-commerce-dio`.`Client` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Payments1`
    FOREIGN KEY (`Payments_idPayments` , `Payments_idClient`)
    REFERENCES `e-commerce-dio`.`Payments` (`idPayments` , `idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  );

-- -----------------------------------------------------
-- Create Table `Tracker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Tracker` (
  `idTracker` INT NOT NULL AUTO_INCREMENT,
  `place` VARCHAR(45) NOT NULL,
  `time` DATETIME NOT NULL,
  `trackerCode` VARCHAR(45) NOT NULL,
  `Order_idOrder` INT NOT NULL,
  PRIMARY KEY (`idTracker`, `Order_idOrder`),
  INDEX `fk_Tracker_Order1_idx` (`Order_idOrder` ASC) VISIBLE,
  CONSTRAINT `fk_Tracker_Order1`
    FOREIGN KEY (`Order_idOrder`)
    REFERENCES `e-commerce-dio`.`Order` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );

-- -----------------------------------------------------
-- Create Table `Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Product` (
  `idProduct` INT NOT NULL AUTO_INCREMENT,
  `category` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  `value` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProduct`)
  );


-- -----------------------------------------------------
-- Create Table `Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Supplier` (
  `idSupplier` INT NOT NULL AUTO_INCREMENT,
  `corporate name` VARCHAR(45) NOT NULL,
  `CNPJ` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idSupplier`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE
  );


-- -----------------------------------------------------
-- Create Table `Stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Stock` (
  `idStock` INT NOT NULL AUTO_INCREMENT,
  `place` VARCHAR(45) NULL,
  PRIMARY KEY (`idStock`)
  );


-- -----------------------------------------------------
-- Create Table `Vendor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Vendor` (
  `idVendor` INT NOT NULL AUTO_INCREMENT,
  `corporate name` VARCHAR(45) NOT NULL,
  `fantasy name` VARCHAR(45) NULL,
  `seller` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NULL,
  PRIMARY KEY (`idVendor`),
  UNIQUE INDEX `corporate name_UNIQUE` (`corporate name` ASC) VISIBLE
  );


-- -----------------------------------------------------
-- Create Table `Vendor_has_Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Vendor_has_Product` (
  `Vendor_idVendor` INT NOT NULL,
  `Product_idProduct` INT NOT NULL,
  `amount` INT NULL,
  PRIMARY KEY (`Vendor_idVendor`, `Product_idProduct`),
  INDEX `fk_Vendor_has_Product_Product1_idx` (`Product_idProduct` ASC) VISIBLE,
  INDEX `fk_Vendor_has_Product_Vendor1_idx` (`Vendor_idVendor` ASC) VISIBLE,
  CONSTRAINT `fk_Vendor_has_Product_Vendor1`
    FOREIGN KEY (`Vendor_idVendor`)
    REFERENCES `e-commerce-dio`.`Vendor` (`idVendor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vendor_has_Product_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `e-commerce-dio`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );


-- -----------------------------------------------------
-- Create Table `Supplier_has_Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Supplier_has_Product` (
  `Supplier_idSupplier` INT NOT NULL,
  `Product_idProduct` INT NOT NULL,
  PRIMARY KEY (`Supplier_idSupplier`, `Product_idProduct`),
  INDEX `fk_Supplier_has_Product_Product1_idx` (`Product_idProduct` ASC) VISIBLE,
  INDEX `fk_Supplier_has_Product_Supplier1_idx` (`Supplier_idSupplier` ASC) VISIBLE,
  CONSTRAINT `fk_Supplier_has_Product_Supplier1`
    FOREIGN KEY (`Supplier_idSupplier`)
    REFERENCES `e-commerce-dio`.`Supplier` (`idSupplier`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Supplier_has_Product_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `e-commerce-dio`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );


-- -----------------------------------------------------
-- Create Table `Product_has_Stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Product_has_Stock` (
  `Product_idProduct` INT NOT NULL,
  `Stock_idStock` INT NOT NULL,
  PRIMARY KEY (`Product_idProduct`, `Stock_idStock`),
  INDEX `fk_Product_has_Stock_Stock1_idx` (`Stock_idStock` ASC) VISIBLE,
  INDEX `fk_Product_has_Stock_Product1_idx` (`Product_idProduct` ASC) VISIBLE,
  CONSTRAINT `fk_Product_has_Stock_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `e-commerce-dio`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_has_Stock_Stock1`
    FOREIGN KEY (`Stock_idStock`)
    REFERENCES `e-commerce-dio`.`Stock` (`idStock`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );


-- -----------------------------------------------------
-- Create Table `Product_has_Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `e-commerce-dio`.`Product_has_Order` (
  `Product_idProduct` INT NOT NULL,
  `Order_idOrder` INT NOT NULL,
  `amount` VARCHAR(45) NULL,
  `status` ENUM('Disponível', 'Sem estoque') NULL DEFAULT 'Disponível',
  PRIMARY KEY (`Product_idProduct`, `Order_idOrder`),
  INDEX `fk_Product_has_Order1_Order1_idx` (`Order_idOrder` ASC) VISIBLE,
  INDEX `fk_Product_has_Order1_Product1_idx` (`Product_idProduct` ASC) VISIBLE,
  CONSTRAINT `fk_Product_has_Order1_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `e-commerce-dio`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_has_Order1_Order1`
    FOREIGN KEY (`Order_idOrder`)
    REFERENCES `e-commerce-dio`.`Order` (`idOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );


-- -----------------------------------------------------
-- Insert Into Table `client`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`client`(`first name`,`surname`,`address`,`CPF`,`CNPJ`,`birthdate`)
	VALUES ( 'John','Doe','Av. Nowhere, 15','22222222222',null,'1937-01-10'),
	 		( 'Jane','Doe','St Somewhere, 998','11111111111',null,'1937-12-31');

-- -----------------------------------------------------
-- Insert Into Table `Payments`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`Payments`(`idClient`,`typePayment`,`limitAvailable`)
	VALUES ( 1, 'Cartão', 1500.30),
			( 2, 'Pix', default);

-- -----------------------------------------------------
-- Insert Into Table `order`
-- -----------------------------------------------------    
INSERT INTO `e-commerce-dio`.`order`(`status`,`description`,`deliveryCost`,`Client_idClient`,`Payments_idPayments`,`Payments_idClient`)
	VALUES ( 'Em Andamento','compra via aplicativo',0,1,1,1),
			( 'Em Andamento','compra via aplicativo',50,2,2,2),
            ( default,'compra via website',0,1,1,1),
            ( default,'compra via website',150,2,2,2);
           
-- -----------------------------------------------------
-- Insert Into Table `Tracker`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`Tracker`(`Order_idOrder`, `place`,`time`,`trackerCode`)
	VALUES ( 1, 'Barueri/SP', '2023-08-01 00:25:56','20230801CX95PI021'),
			( 2, 'Itajaí/SC', '2023-07-15 22:13:11','20230715PO56KA954'),
            ( 1, 'Gravataí/RS', '2023-08-02 13:15:03','20230801CX95PI021');
            
-- -----------------------------------------------------
-- Insert Into Table `supplier`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`supplier`(`corporate name`,`CNPJ`)
	VALUES ( 'AMAZON','10000879-1000'),
			( 'Magazine Luiza','98573272-1000'),
			( 'Mercado Livre','88854562-1000'),
			( 'Shoppee','33325887-1000');

-- -----------------------------------------------------
-- Insert Into Table `vendor`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`vendor`(`corporate name`,`fantasy name`,`seller`,`address`)
	VALUES ( 'Mundial Mix Comercio de Alimentos LTDA','Brasil Atacadista','Patricia Flores','Avenida Armando Kalil Boulos 1515'),
			( 'Supermercados Angeloni LTDA','Angeloni','Miguel Santos','Avenida Armando Kalil Boulos 200');

-- -----------------------------------------------------
-- Insert Into Table `stock`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`stock`(`place`)
	VALUES ( 'Avenida Armando Kalil Boulos 3000'),
			( 'Avenida Armando Kalil Boulos 900');

-- -----------------------------------------------------
-- Insert Into Table `product`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`product`(`category`,`description`,`value`)
	VALUES ( 'Laticíneos','Leite Santa Clara Integral 1L','3,69'),
			( 'Hortifruti','Coco seco unidade','8,90'),
            ( 'Cereais','Arroz Blue ville 1 Kg','4,79'),
            ( 'Óleos','Óleo de soja Leve 900 mL','6,79'),
            ( 'Laticíneos','Yogurt Natural Batavo 200 mL','6,30'),
			( 'Hortifruti','Alface crespa','1,99'),
            ( 'Limpeza','Desinfetante Veja 900mL','14,79'),
            ( 'Jardim','Saco de Terra Preta 20 Kg','25,90');


            
-- -----------------------------------------------------
-- Insert Into Table `product_has_order`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`product_has_order`(`Product_idProduct`,`Order_idOrder`,`amount`,`status`)
	VALUES ( 1 , 2 , '5', 'Sem Estoque' ),
			( 2 , 4 , '2', default ),
            ( 3 , 3 , '2', 'Disponível' ),
            ( 4 , 1 , '6', 'Disponível' );

-- -----------------------------------------------------
-- Insert Into Table `product_has_stock`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`product_has_stock`(`Product_idProduct`,`Stock_idStock`)
	VALUES ( 1 , 2 ),
			( 2 , 1 ),
            ( 3 , 2 ),
            ( 4 , 1 );

-- -----------------------------------------------------
-- Insert Into Table `supplier_has_product`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`supplier_has_product`(`Product_idProduct`,`Supplier_idSupplier`)
	VALUES ( 1 , 2 ),
			( 2 , 1 ),
            ( 3 , 2 ),
            ( 4 , 1 ),
			( 4 , 2 ),
			( 6 , 1 ),
			( 7 , 2 ),
			( 8 , 1 ),
			( 1 , 3 ),
			( 2 , 4 ),
            ( 3 , 3 ),
            ( 4 , 4 ),
			( 4 , 3 ),
			( 6 , 4 ),
			( 7 , 3 ),
			( 8 , 4 ),
			( 5 , 2 );

-- -----------------------------------------------------
-- Insert Into Table `vendor_has_product`
-- -----------------------------------------------------
INSERT INTO `e-commerce-dio`.`vendor_has_product`(`Product_idProduct`,`Vendor_idVendor`,`amount`)
	VALUES ( 1 , 2 , '100'),
			( 2 , 1 , '350'),
            ( 3 , 2 , '125'),
            ( 4 , 1 , '312');


-- =====================================================
-- DESAFIO DIO
-- =====================================================

-- -----------------------------------------------------
-- Pergunta: Quais são os pedidos do usuário de ID = 2?
-- -----------------------------------------------------

SELECT `e-commerce-dio`.`product`.`description` as `productDescription`,`e-commerce-dio`.`product`.`value`,`e-commerce-dio`.`product`.`category`,`e-commerce-dio`.`order`.`description` as `orderDescription`,`e-commerce-dio`.`order`.`status`, `e-commerce-dio`.`order`.`deliveryCost`
  FROM `e-commerce-dio`.`product_has_order`
  INNER JOIN `e-commerce-dio`.`order`
  ON `e-commerce-dio`.`product_has_order`.`Order_idOrder` = `e-commerce-dio`.`order`.`idOrder`
  INNER JOIN `e-commerce-dio`.`product`
  ON `e-commerce-dio`.`product_has_order`.`Product_idProduct` = `e-commerce-dio`.`product`.`idProduct`
  INNER JOIN `e-commerce-dio`.`client`
  ON `e-commerce-dio`.`order`.`Client_idClient` = `e-commerce-dio`.`client`.`idClient`
	WHERE `e-commerce-dio`.`client`.`idClient` = 2;

-- -----------------------------------------------------    
-- Pergunta: Quais lojas posso encontrar 'Alface crespa' ?
-- -----------------------------------------------------

SELECT `e-commerce-dio`.`product`.`description`, GROUP_CONCAT(`e-commerce-dio`.`supplier`.`corporate name`)
	FROM `e-commerce-dio`.`supplier_has_product`
    INNER join `e-commerce-dio`.`supplier`
    ON `e-commerce-dio`.`supplier_has_product`.`Supplier_idSupplier` = `e-commerce-dio`.`supplier`.`idSupplier`
    INNER join `e-commerce-dio`.`product`
    ON `e-commerce-dio`.`supplier_has_product`.`Product_idProduct` = `e-commerce-dio`.`product`.`idProduct`
    GROUP BY `e-commerce-dio`.`product`.`description`
    HAVING `e-commerce-dio`.`product`.`description` = 'Alface crespa';

-- -----------------------------------------------------
-- Pergunta: Quais os produtos disponíveis ordenados por categoria? 
-- -----------------------------------------------------

SELECT `e-commerce-dio`.`product`.`description`,`e-commerce-dio`.`product`.`category`,`e-commerce-dio`.`product`.`value` 
    FROM `product` 
    ORDER BY `category`;

-- -----------------------------------------------------
-- Pergunta: Qual é o detalhamento de entrega do pedido com o código de rastreio '20230801CX95PI021'
-- -----------------------------------------------------

SELECT `description`, `trackerCode`,`time`, `place` 
    FROM (
        SELECT `e-commerce-dio`.`product_has_order`.`order_idOrder`,`e-commerce-dio`.`product_has_order`.`amount`,`e-commerce-dio`.`product`.`description`
        FROM `e-commerce-dio`.`product_has_order`
        INNER JOIN `e-commerce-dio`.`order`
        ON `e-commerce-dio`.`product_has_order`.`Order_idOrder` = `e-commerce-dio`.`order`.`idOrder`
        INNER JOIN `e-commerce-dio`.`product`
        ON `e-commerce-dio`.`product_has_order`.`Product_idProduct` = `e-commerce-dio`.`product`.`idProduct`
    ) `aninhada`
    INNER JOIN `e-commerce-dio`.`tracker`
	    ON `aninhada`.`Order_idOrder` = `e-commerce-dio`.`tracker`.`Order_idOrder`
    WHERE `trackerCode` = '20230801CX95PI021'
    ORDER BY `time` DESC;