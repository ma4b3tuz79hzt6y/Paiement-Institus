-- MySQL Workbench Forward Engineering


-- -----------------------------------------------------
-- Schema paiement_institus
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `paiement_institus` ;

-- -----------------------------------------------------
-- Schema paiement_institus
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `paiement_institus` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `paiement_institus` ;

-- -----------------------------------------------------
-- Table `paiement_institus`.`anneescolaires`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`anneescolaires` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`anneescolaires` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `annee` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `annee` ON `paiement_institus`.`anneescolaires` (`annee` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`filieres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`filieres` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`filieres` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `fin_incription` DATE NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `nom` ON `paiement_institus`.`filieres` (`nom` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`stagiaires`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`stagiaires` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`stagiaires` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `prenom` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NULL DEFAULT NULL,
  `telephone` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `email` ON `paiement_institus`.`stagiaires` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `telephone` ON `paiement_institus`.`stagiaires` (`telephone` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`inscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`inscriptions` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`inscriptions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date_inscription` DATE NULL DEFAULT (CURRENT_DATE),
  `nombre_echeance` INT NOT NULL DEFAULT '1',
  `montant_total` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `filiere_id` INT NOT NULL,
  `annee_id` INT NOT NULL,
  `stagiaire_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_inscriptions_filieres1`
    FOREIGN KEY (`filiere_id`)
    REFERENCES `paiement_institus`.`filieres` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_inscriptions_anneescolaires1`
    FOREIGN KEY (`annee_id`)
    REFERENCES `paiement_institus`.`anneescolaires` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inscriptions_stagiaires1`
    FOREIGN KEY (`stagiaire_id`)
    REFERENCES `paiement_institus`.`stagiaires` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_inscriptions_filieres1_idx` ON `paiement_institus`.`inscriptions` (`filiere_id` ASC) VISIBLE;

CREATE INDEX `fk_inscriptions_anneescolaires1_idx` ON `paiement_institus`.`inscriptions` (`annee_id` ASC) VISIBLE;

CREATE INDEX `fk_inscriptions_stagiaires1_idx` ON `paiement_institus`.`inscriptions` (`stagiaire_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`echeances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`echeances` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`echeances` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `montant` DECIMAL(10,2) NOT NULL,
  `date_echeance` DATE NOT NULL,
  `statut` VARCHAR(12) NOT NULL DEFAULT 'Non payé',
  `inscription_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_echeances_inscriptions1`
    FOREIGN KEY (`inscription_id`)
    REFERENCES `paiement_institus`.`inscriptions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 120
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_echeances_inscriptions1_idx` ON `paiement_institus`.`echeances` (`inscription_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`paiements`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`paiements` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`paiements` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `montant` DECIMAL(10,2) NOT NULL,
  `date_paiement` DATE NULL DEFAULT (CURRENT_DATE),
  `mode_paiement` VARCHAR(20) NOT NULL DEFAULT 'ESPECE',
  `echeance_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_paiements_echeances1`
    FOREIGN KEY (`echeance_id`)
    REFERENCES `paiement_institus`.`echeances` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_paiements_echeances1_idx` ON `paiement_institus`.`paiements` (`echeance_id` ASC) VISIBLE;




