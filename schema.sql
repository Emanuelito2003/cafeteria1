-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.0.39 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para coffe_king
CREATE DATABASE IF NOT EXISTS `coffe_king` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `coffe_king`;

-- Volcando estructura para procedimiento coffe_king.add_order
DELIMITER //
CREATE PROCEDURE `add_order`(
	IN `user_id` INT,
	IN `product_id` INT,
	IN `quantity` INT,
	IN `total` DECIMAL(10, 2)
)
BEGIN
  DECLARE product_price DECIMAL(10, 2);

  -- Obtener el precio del producto
  SELECT price INTO product_price
  FROM products
  WHERE id = product_id;

  -- Insertar la orden con el total calculado
  INSERT INTO orders (user_id, product_id, quantity, total) 
  VALUES (user_id, product_id, quantity, product_price * quantity);
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.add_product
DELIMITER //
CREATE PROCEDURE `add_product`(
	IN `name` VARCHAR(255),
	IN `price` DECIMAL(10, 2),
	IN `discount` DECIMAL(10, 2),
	IN `image` VARCHAR(255),
	IN `stock` INT
)
BEGIN
  INSERT INTO products (name, price, discount, image,stock) 
  VALUES (name, price, discount, image, stock);
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.delete_product
DELIMITER //
CREATE PROCEDURE `delete_product`(
	IN `id` INT
)
BEGIN
  DELETE FROM products WHERE products.id = id;
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.get_best_seller_products
DELIMITER //
CREATE PROCEDURE `get_best_seller_products`()
BEGIN
  SELECT * FROM products WHERE products.stock > 0 ORDER BY products.stock DESC LIMIT 4;
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.get_latest_products
DELIMITER //
CREATE PROCEDURE `get_latest_products`()
BEGIN
  SELECT * FROM products WHERE products.stock > 0 ORDER BY products.id ASC LIMIT 4;
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.get_orders
DELIMITER //
CREATE PROCEDURE `get_orders`()
BEGIN
  SELECT o.user_id, 
         u.name AS user_name, 
         u.email, 
         u.phone, 
         u.address, 
         GROUP_CONCAT(o.quantity, ' - ', p.name, ': $', o.total, ' ' SEPARATOR ',') AS product_details,
         SUM(o.total) AS total_amount
  FROM orders o
  JOIN users u ON o.user_id = u.id
  JOIN products p ON o.product_id = p.id
  GROUP BY o.user_id, u.name, u.email, u.phone, u.address
  ORDER BY o.user_id DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.get_product
DELIMITER //
CREATE PROCEDURE `get_product`(
	IN `id` INT
)
BEGIN
  SELECT * FROM products WHERE products.id = id;
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.get_products
DELIMITER //
CREATE PROCEDURE `get_products`()
BEGIN
  SELECT * FROM products WHERE products.stock > 0;
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.login
DELIMITER //
CREATE PROCEDURE `login`(
	IN `p_email` VARCHAR(255),
	IN `p_password` VARCHAR(255)
)
BEGIN
  IF (SELECT id FROM users WHERE email = p_email AND password = p_password) IS NOT NULL THEN
    SELECT * FROM users WHERE email = p_email;
  ELSE
    SELECT 'Correo o contraseña invalidos';
  END IF;
END//
DELIMITER ;

-- Volcando estructura para tabla coffe_king.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla coffe_king.orders: ~0 rows (aproximadamente)
INSERT INTO `orders` (`id`, `user_id`, `product_id`, `quantity`, `total`) VALUES
	(1, 3, 4, 1, 3.56),
	(2, 3, 3, 1, 3.71),
	(3, 3, 2, 2, 40.00),
	(4, 3, 1, 1, 70.00),
	(5, 2, 1, 1, 70.00),
	(6, 2, 2, 1, 20.00);

-- Volcando estructura para tabla coffe_king.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) NOT NULL,
  `image` varchar(255) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla coffe_king.products: ~5 rows (aproximadamente)
INSERT INTO `products` (`id`, `name`, `price`, `discount`, `image`, `stock`) VALUES
	(1, 'Cafe Irlandes', 70.00, 0.25, '/img/cafe-irish.jpg', 20),
	(2, 'Cafe Australiano', 20.00, 0.00, '/img/cafe-australiano.jpg', 93),
	(3, 'Cafe Licuado', 3.71, 0.50, '/img/cafe-liqueurs.jpg', 7),
	(4, 'Cafe Ingles', 3.56, 0.50, '/img/cafe-ingles.jpg', 9),
	(5, 'Cafe helado', 12.86, 0.70, '/img/cafe-helado.jpg', 400),
	(6, 'Te helado', 100.00, 0.10, 'https://th.bing.com/th/id/R.e2ecd6e2b5a7d7f95f4cd4c620888337?rik=h0JVMclHeJIy6g&riu=http%3a%2f%2fsalpimenta.com.ar%2fwp-content%2fuploads%2f2018%2f09%2fStarbuck-770x1024.jpg&ehk=okj5k14iFexPcZ3ltCtGBIu%2bSdRYwcvPAj0psxYqB%2b4%3d&risl=&pid=ImgRaw&r=0', 20);

-- Volcando estructura para procedimiento coffe_king.register
DELIMITER //
CREATE PROCEDURE `register`(
	IN `name` VARCHAR(255),
	IN `email` VARCHAR(255),
	IN `phone` VARCHAR(20),
	IN `address` VARCHAR(255),
	IN `password` VARCHAR(255)
)
BEGIN
  IF (SELECT COUNT(*) FROM users WHERE users.email = email) > 0 THEN
    SELECT 'Email already exists';
  ELSE
    INSERT INTO users (name, email,phone, address, password) VALUES (name, email, phone,address, password);
    SELECT * FROM users WHERE users.email = email;
  END IF;
END//
DELIMITER ;

-- Volcando estructura para procedimiento coffe_king.update_product
DELIMITER //
CREATE PROCEDURE `update_product`(
	IN `p_id` INT,
	IN `p_name` VARCHAR(255),
	IN `p_price` DECIMAL(10, 2),
	IN `p_discount` DECIMAL(10, 2),
	IN `p_image` VARCHAR(255),
	IN `p_stock` INT
)
BEGIN
  UPDATE products SET 
  name = IFNULL(p_name, name),
  price = IFNULL(p_price, price),
  discount = IFNULL(p_discount, discount),
  image = IFNULL(p_image, image),
  stock = IFNULL(p_stock, stock)
  WHERE products.id = p_id;
END//
DELIMITER ;

-- Volcando estructura para tabla coffe_king.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','USER') NOT NULL DEFAULT 'USER',
  `phone` varchar(20) NOT NULL,
  `address` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla coffe_king.users: ~3 rows (aproximadamente)
INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `phone`, `address`) VALUES
	(2, 'Pedro Paramo', 'pedro@gmail.com', '1111', 'USER', '914123456', 'mi casa'),
	(3, 'Bruce Wayne', 'bw@batmam.com', '1234', 'ADMIN', '9876543210', 'la baticueva'),
	(4, 'Robin', 'rb@gmail.com', '4321', 'ADMIN', '9141234569', 'abajo de la baticueva');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
