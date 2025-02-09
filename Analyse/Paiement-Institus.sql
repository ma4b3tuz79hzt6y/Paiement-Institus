-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

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
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `email` ON `paiement_institus`.`stagiaires` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `telephone` ON `paiement_institus`.`stagiaires` (`telephone` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`filieres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`filieres` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`filieres` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `nom` ON `paiement_institus`.`filieres` (`nom` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`inscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`inscriptions` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`inscriptions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `stagiaire_id` INT NOT NULL,
  `filiere_id` INT NOT NULL,
  `annee_id` INT NOT NULL,
  `date_inscription` DATE NOT NULL DEFAULT curdate(),
  `nombre_echeance` INT NOT NULL DEFAULT '1',
  `montant_total` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  CONSTRAINT `inscriptions_ibfk_1`
    FOREIGN KEY (`stagiaire_id`)
    REFERENCES `paiement_institus`.`stagiaires` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `inscriptions_ibfk_2`
    FOREIGN KEY (`filiere_id`)
    REFERENCES `paiement_institus`.`filieres` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `inscriptions_ibfk_3`
    FOREIGN KEY (`annee_id`)
    REFERENCES `paiement_institus`.`anneescolaires` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `stagiaire_id` ON `paiement_institus`.`inscriptions` (`stagiaire_id` ASC, `annee_id` ASC) VISIBLE;

CREATE INDEX `filiere_id` ON `paiement_institus`.`inscriptions` (`filiere_id` ASC) VISIBLE;

CREATE INDEX `annee_id` ON `paiement_institus`.`inscriptions` (`annee_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`echeances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`echeances` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`echeances` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `inscription_id` INT NOT NULL,
  `montant` DECIMAL(10,2) NOT NULL,
  `date_echeance` DATE NOT NULL,
  `statut` ENUM('Non payé', 'Partiellement payé', 'Payé') NULL DEFAULT 'Non payé',
  PRIMARY KEY (`id`),
  CONSTRAINT `echeances_ibfk_1`
    FOREIGN KEY (`inscription_id`)
    REFERENCES `paiement_institus`.`inscriptions` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `inscription_id` ON `paiement_institus`.`echeances` (`inscription_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`paiements`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `paiement_institus`.`paiements` ;

CREATE TABLE IF NOT EXISTS `paiement_institus`.`paiements` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `echeance_id` INT NOT NULL,
  `montant` DECIMAL(10,2) NOT NULL,
  `date_paiement` DATE NOT NULL DEFAULT curdate(),
  `mode_paiement` ENUM('Espece', 'Cheque', 'Virement', 'Carte_bancaire') NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `paiements_ibfk_1`
    FOREIGN KEY (`echeance_id`)
    REFERENCES `paiement_institus`.`echeances` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `echeance_id` ON `paiement_institus`.`paiements` (`echeance_id` ASC) VISIBLE;

USE `paiement_institus` ;

-- -----------------------------------------------------
-- procedure AjouterInscription
-- -----------------------------------------------------

USE `paiement_institus`;
DROP procedure IF EXISTS `paiement_institus`.`AjouterInscription`;

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AjouterInscription`(
    IN p_stagiaire_id INT,
    IN p_filiere_id INT,
    IN p_annee_id INT,
    IN p_nombre_echeance INT,
    IN p_montant_total DECIMAL(10,2)
)
BEGIN
    DECLARE v_count_stagiaire INT;
    DECLARE v_count_filiere INT;
    DECLARE v_count_annee INT;
    DECLARE v_count INT;

    
    SELECT COUNT(*) INTO v_count_stagiaire 
    FROM stagiaires 
    WHERE id = p_stagiaire_id;

    
    SELECT COUNT(*) INTO v_count_filiere 
    FROM filieres 
    WHERE id = p_filiere_id;

    
    SELECT COUNT(*) INTO v_count_annee 
    FROM anneescolaires 
    WHERE id = p_annee_id;

    
    IF v_count_stagiaire = 0 THEN
        SELECT 'Stagiaire non disponible' AS message;
    
    ELSEIF v_count_filiere = 0 THEN
        SELECT 'Filière non disponible' AS message;
    
    ELSEIF v_count_annee = 0 THEN
        SELECT 'Année scolaire non disponible' AS message;
    ELSE
        
        SELECT COUNT(*) INTO v_count
        FROM inscriptions 
        WHERE stagiaire_id = p_stagiaire_id AND annee_id = p_annee_id;

        IF v_count > 0 THEN
            SELECT 'Le stagiaire est déjà inscrit pour cette année scolaire' AS message;
        ELSE
            
            INSERT INTO inscriptions (stagiaire_id, filiere_id, annee_id, nombre_echeance, montant_total, date_inscription) 
            VALUES (p_stagiaire_id, p_filiere_id, p_annee_id, p_nombre_echeance, p_montant_total, CURRENT_DATE());

            SELECT 'Inscription ajoutée avec succès' AS message;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AjouterStagiaire
-- -----------------------------------------------------

USE `paiement_institus`;
DROP procedure IF EXISTS `paiement_institus`.`AjouterStagiaire`;

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AjouterStagiaire`(
    IN p_nom VARCHAR(255),
    IN p_prenom VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telephone VARCHAR(20),
    OUT p_result BOOLEAN
)
BEGIN
    DECLARE v_count INT;

    
    SELECT COUNT(*) INTO v_count 
    FROM stagiaires 
    WHERE email = p_email OR telephone = p_telephone;

    IF v_count > 0 THEN
        SET p_result = FALSE; 
    ELSE
        
        INSERT INTO stagiaires (nom, prenom, email, telephone) 
        VALUES (p_nom, p_prenom, p_email, p_telephone);

        SET p_result = TRUE; 
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CreerAnneeScolaire
-- -----------------------------------------------------

USE `paiement_institus`;
DROP procedure IF EXISTS `paiement_institus`.`CreerAnneeScolaire`;

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreerAnneeScolaire`(
    IN p_date_debut DATE,
    IN p_date_fin DATE,
    OUT p_result BOOLEAN
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_annee VARCHAR(9);

    
    SET v_annee = CONCAT(YEAR(p_date_debut), '-', YEAR(p_date_fin));

    
    SELECT COUNT(*) INTO v_count 
    FROM anneescolaires 
    WHERE annee = v_annee;

    IF v_count > 0 THEN
        SET p_result = FALSE; 
    ELSE
        
        INSERT INTO anneescolaires (annee) VALUES (v_annee);
        SET p_result = TRUE; 
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CreerFiliere
-- -----------------------------------------------------

USE `paiement_institus`;
DROP procedure IF EXISTS `paiement_institus`.`CreerFiliere`;

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreerFiliere`(
    IN p_nom VARCHAR(255),
    OUT p_result BOOLEAN
)
BEGIN
    DECLARE v_count INT;

    
    SELECT COUNT(*) INTO v_count 
    FROM filieres 
    WHERE nom = p_nom;

    IF v_count > 0 THEN
        SET p_result = FALSE; 
    ELSE
        
        INSERT INTO filieres (nom) VALUES (p_nom);
        SET p_result = TRUE; 
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GenererEcheances
-- -----------------------------------------------------

USE `paiement_institus`;
DROP procedure IF EXISTS `paiement_institus`.`GenererEcheances`;

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenererEcheances`(
    IN p_stagiaire_id INT,
    IN p_filiere_id INT,
    IN p_annee_id INT,
    IN p_type_echeance ENUM('debut', 'fin'),
    IN p_montant_echeance DECIMAL(10,2),
    OUT p_result BOOLEAN
)
BEGIN
    DECLARE v_count_echeances INT;
    DECLARE v_date_inscription DATE;
    DECLARE v_nombre_echeance INT;
    DECLARE v_montant_total DECIMAL(10,2);
    DECLARE v_i INT;
    DECLARE v_date_echeance DATE;
    DECLARE v_inscription_id INT;

    
    SELECT id, date_inscription, montant_total, nombre_echeance INTO v_inscription_id, v_date_inscription, v_montant_total, v_nombre_echeance
    FROM inscriptions
    WHERE stagiaire_id = p_stagiaire_id AND annee_id = p_annee_id AND filiere_id = p_filiere_id;

    IF v_inscription_id IS NULL THEN
        SET p_result = FALSE; 
    ELSE
        
        SELECT COUNT(*) INTO v_count_echeances
        FROM echeances
        WHERE inscription_id = v_inscription_id;

        IF v_count_echeances > 0 THEN
            SET p_result = FALSE; 
        ELSE
            
            SET v_i = 1;
            WHILE v_i <= v_nombre_echeance DO
                
                IF p_type_echeance = 'debut' THEN
                    SET v_date_echeance = DATE_ADD(v_date_inscription, INTERVAL (v_i - 1) * 30 DAY); 
                ELSE
                    SET v_date_echeance = DATE_ADD(v_date_inscription, INTERVAL v_i * 30 DAY); 
                END IF;

                
                INSERT INTO echeances (inscription_id, montant, date_echeance) 
                VALUES (v_inscription_id, p_montant_echeance, v_date_echeance);

                
                SET v_i = v_i + 1;
            END WHILE;

            
            UPDATE inscriptions
            SET nombre_echeance = v_nombre_echeance, montant_total = p_montant_echeance * v_nombre_echeance
            WHERE id = v_inscription_id;

            SET p_result = TRUE; 
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure MettreAJourStagiaire
-- -----------------------------------------------------

USE `paiement_institus`;
DROP procedure IF EXISTS `paiement_institus`.`MettreAJourStagiaire`;

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MettreAJourStagiaire`(
    IN p_id INT,
    IN p_nom VARCHAR(255),
    IN p_prenom VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telephone VARCHAR(20),
    OUT p_result BOOLEAN
)
BEGIN
    DECLARE v_count INT;

    
    SELECT COUNT(*) INTO v_count 
    FROM stagiaires 
    WHERE id = p_id;

    IF v_count > 0 THEN
        
        UPDATE stagiaires 
        SET nom = p_nom, 
            prenom = p_prenom, 
            email = p_email, 
            telephone = p_telephone
        WHERE id = p_id;

        SET p_result = TRUE; 
    ELSE
        SET p_result = FALSE; 
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ModifierEcheance
-- -----------------------------------------------------

USE `paiement_institus`;
DROP procedure IF EXISTS `paiement_institus`.`ModifierEcheance`;

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ModifierEcheance`(
    IN p_echeance_id INT,
    IN p_nouveau_montant DECIMAL(10,2),
    IN p_nouvelle_date_echeance DATE,
    OUT p_result BOOLEAN
)
BEGIN
    DECLARE v_statut_echeance ENUM('Non payé', 'Partiellement payé', 'Payé');
    DECLARE v_inscription_id INT;
    DECLARE v_montant_total DECIMAL(10,2);
    DECLARE v_nombre_echeances INT;

    
    SELECT statut, inscription_id INTO v_statut_echeance, v_inscription_id
    FROM echeances
    WHERE id = p_echeance_id;

    
    IF v_statut_echeance IN ('Payé', 'Partiellement payé') THEN
        SET p_result = FALSE; 
    ELSE
        
        UPDATE echeances
        SET montant = p_nouveau_montant,
            date_echeance = p_nouvelle_date_echeance
        WHERE id = p_echeance_id;

        
        SELECT SUM(montant) INTO v_montant_total
        FROM echeances
        WHERE inscription_id = v_inscription_id
        GROUP BY inscription_id;

        
        UPDATE inscriptions
        SET montant_total = v_montant_total
        WHERE id = v_inscription_id;

        
        SET p_result = TRUE;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ModifierFiliereInscription
-- -----------------------------------------------------

USE `paiement_institus`;
DROP procedure IF EXISTS `paiement_institus`.`ModifierFiliereInscription`;

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ModifierFiliereInscription`(
    IN p_inscription_id INT,  
    IN p_nouvelle_filiere_id INT,  
    IN p_annee_id INT,  
    OUT p_result BOOLEAN  
)
BEGIN
    
    IF NOT EXISTS (SELECT id FROM filieres WHERE id = p_nouvelle_filiere_id) THEN
        SET p_result = FALSE;
        
    END IF;

    
    IF NOT EXISTS (SELECT id FROM anneescolaires WHERE id = p_annee_id) THEN
        SET p_result = FALSE;
      
    END IF;

    
    UPDATE inscriptions
    SET filiere_id = p_nouvelle_filiere_id
    WHERE id = p_inscription_id AND annee_id = p_annee_id;

    
    IF ROW_COUNT() > 0 THEN
        SET p_result = TRUE;  
    ELSE
        SET p_result = FALSE;  
    END IF;

END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
