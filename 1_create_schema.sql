CREATE SCHEMA 'gamebar' DEFAULT CHARACTER SET utf8mb4;
USE gamebar;
CREATE TABLE `employees` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));