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
CREATE TABLE IF NOT EXISTS `paiement_institus`.`anneescolaires` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `annee` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `annee` ON `paiement_institus`.`anneescolaires` (`annee` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`filieres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paiement_institus`.`filieres` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `fin_incription` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `nom` ON `paiement_institus`.`filieres` (`nom` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`stagiaires`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paiement_institus`.`stagiaires` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `prenom` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NULL DEFAULT NULL,
  `telephone` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 106
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `email` ON `paiement_institus`.`stagiaires` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `telephone` ON `paiement_institus`.`stagiaires` (`telephone` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`inscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paiement_institus`.`inscriptions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date_inscription` DATE NULL DEFAULT (CURRENT_DATE),
  `nombre_echeance` INT NOT NULL DEFAULT '1',
  `montant_total` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `filiere_id` INT NOT NULL,
  `annee_id` INT NOT NULL,
  `stagiaire_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_inscriptions_anneescolaires1`
    FOREIGN KEY (`annee_id`)
    REFERENCES `paiement_institus`.`anneescolaires` (`id`),
  CONSTRAINT `fk_inscriptions_filieres1`
    FOREIGN KEY (`filiere_id`)
    REFERENCES `paiement_institus`.`filieres` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_inscriptions_stagiaires1`
    FOREIGN KEY (`stagiaire_id`)
    REFERENCES `paiement_institus`.`stagiaires` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 17
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_inscriptions_filieres1_idx` ON `paiement_institus`.`inscriptions` (`filiere_id` ASC) VISIBLE;

CREATE INDEX `fk_inscriptions_anneescolaires1_idx` ON `paiement_institus`.`inscriptions` (`annee_id` ASC) VISIBLE;

CREATE INDEX `fk_inscriptions_stagiaires1_idx` ON `paiement_institus`.`inscriptions` (`stagiaire_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`echeances`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paiement_institus`.`echeances` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `montant` DECIMAL(10,2) NOT NULL,
  `date_echeance` DATE NOT NULL,
  `statut` VARCHAR(12) NOT NULL DEFAULT 'Non payé',
  `inscription_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_echeances_inscriptions1`
    FOREIGN KEY (`inscription_id`)
    REFERENCES `paiement_institus`.`inscriptions` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 120
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_echeances_inscriptions1_idx` ON `paiement_institus`.`echeances` (`inscription_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`paiements`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paiement_institus`.`paiements` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `montant` DECIMAL(10,2) NOT NULL,
  `date_paiement` DATE NULL DEFAULT (CURRENT_DATE),
  `mode_paiement` VARCHAR(20) NOT NULL DEFAULT 'ESPECE',
  `echeance_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_paiements_echeances1`
    FOREIGN KEY (`echeance_id`)
    REFERENCES `paiement_institus`.`echeances` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_paiements_echeances1_idx` ON `paiement_institus`.`paiements` (`echeance_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paiement_institus`.`roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(50) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `nom` ON `paiement_institus`.`roles` (`nom` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`utilisateurs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paiement_institus`.`utilisateurs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) NOT NULL,
  `prenom` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `mot_de_passe` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL,
  `date_creation` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_utilisateur_role`
    FOREIGN KEY (`role_id`)
    REFERENCES `paiement_institus`.`roles` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `email` ON `paiement_institus`.`utilisateurs` (`email` ASC) VISIBLE;

CREATE INDEX `fk_utilisateur_role` ON `paiement_institus`.`utilisateurs` (`role_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `paiement_institus`.`sessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `paiement_institus`.`sessions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `utilisateur_id` INT NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `date_expiration` DATETIME NOT NULL,
  `date_creation` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_session_utilisateur`
    FOREIGN KEY (`utilisateur_id`)
    REFERENCES `paiement_institus`.`utilisateurs` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `token` ON `paiement_institus`.`sessions` (`token` ASC) VISIBLE;

CREATE INDEX `fk_session_utilisateur` ON `paiement_institus`.`sessions` (`utilisateur_id` ASC) VISIBLE;

USE `paiement_institus` ;

-- -----------------------------------------------------
-- procedure AjouterAnneeScolaire
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AjouterAnneeScolaire`(
    IN p_annee VARCHAR(9), 
    OUT p_status INT, 
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_annee_debut INT;
    DECLARE v_annee_fin INT;

    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 0;
        SET p_message = 'Erreur lors de l\'ajout de l\'année scolaire.';
    END;

    
    IF p_annee NOT REGEXP '^[0-9]{4}-[0-9]{4}$' THEN
        SET p_status = 0;
        SET p_message = 'Format invalide. Utiliser le format YYYY-YYYY+1 (ex: 2024-2025).';
    ELSE
        
        SET v_annee_debut = CAST(LEFT(p_annee, 4) AS UNSIGNED);
        SET v_annee_fin = CAST(RIGHT(p_annee, 4) AS UNSIGNED);

        
        IF v_annee_fin <> v_annee_debut + 1 THEN
            SET p_status = 0;
            SET p_message = 'Année invalide. La deuxième année doit être égale à la première + 1.';
        ELSE
            
            START TRANSACTION;

            
            SELECT COUNT(*) INTO v_count FROM anneescolaires WHERE annee = p_annee;

            IF v_count > 0 THEN
                
                SET p_status = 0;
                SET p_message = 'L\'année scolaire existe déjà.';
                ROLLBACK;
            ELSE
                
                INSERT INTO anneescolaires (annee) VALUES (p_annee);
                
                
                COMMIT;
                SET p_status = 1;
                SET p_message = 'Année scolaire ajoutée avec succès.';
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AjouterFiliere
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AjouterFiliere`(
    IN p_nom VARCHAR(255),
    IN p_fin_inscription DATE,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de l’ajout de la filière';
    END;

    
    START TRANSACTION;
    
    IF p_nom IS NULL OR TRIM(p_nom) = '' THEN
        SET p_success = FALSE;
        SET p_message = 'Le nom de la filière ne peut pas être vide ou nul';
        ROLLBACK;
    ELSE
        SELECT COUNT(*) INTO v_count FROM filieres WHERE LOWER(nom) = LOWER(p_nom);
        IF v_count > 0 THEN
            SET p_success = FALSE;
            SET p_message = 'La filière existe déjà';
            ROLLBACK;
        ELSE
            INSERT INTO filieres (nom, fin_incription) VALUES (p_nom, p_fin_inscription);
            SET p_success = TRUE;
            SET p_message = 'Filière ajoutée avec succès';
            COMMIT;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AjouterInscription
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AjouterInscription`(
    IN p_date_inscription DATE,
    IN p_nombre_echeance INT,
    IN p_filiere_id INT,
    IN p_annee_id INT,
    IN p_stagiaire_id INT,
    OUT message VARCHAR(255),
    OUT success VARCHAR(10)
    
)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        
        SET message = 'Erreur lors de l\'ajout de l\'inscription. Vérifiez les contraintes d\'intégrité';
        SET success = 'FALSE';
    END;
    
    
    SELECT COUNT(*) INTO v_count 
    FROM inscriptions 
    WHERE annee_id = p_annee_id AND stagiaire_id = p_stagiaire_id;
    
    IF v_count > 0 THEN
       
       SET message = 'Le stagiaire est déjà inscrit pour cette année scolaire';
       SET success = 'FALSE';   
    ELSE
        START TRANSACTION;
        INSERT INTO inscriptions (date_inscription, nombre_echeance, filiere_id, annee_id, stagiaire_id)
        VALUES (COALESCE(p_date_inscription, CURRENT_DATE), p_nombre_echeance, p_filiere_id, p_annee_id, p_stagiaire_id);
        
         SET message = 'Inscription ajoutée avec succès';
         SET success = 'TRUE';
        COMMIT;
       
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ModifierAnneeScolaire
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ModifierAnneeScolaire`(
    IN p_ancienne_annee VARCHAR(9), 
    IN p_nouvelle_annee VARCHAR(9), 
    OUT p_status INT, 
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_annee_debut INT;
    DECLARE v_annee_fin INT;
    DECLARE v_id INT DEFAULT 0;
    DECLARE v_nb_inscriptions INT DEFAULT 0;

    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 0;
        SET p_message = 'Erreur lors de la modification de l\'année scolaire.';
    END;

    
    SELECT id INTO v_id FROM anneescolaires WHERE annee = p_ancienne_annee;
    
    IF v_id IS NULL THEN
        SET p_status = 0;
        SET p_message = 'L\'année scolaire à modifier n\'existe pas.';
    ELSE
        
        SELECT COUNT(*) INTO v_nb_inscriptions FROM inscriptions WHERE annee_id = v_id;

        IF v_nb_inscriptions > 0 THEN
            SET p_status = 0;
            SET p_message = 'Modification annulée. L\'année scolaire possède déjà des inscriptions.';
        ELSE
            
            IF p_nouvelle_annee NOT REGEXP '^[0-9]{4}-[0-9]{4}$' THEN
                SET p_status = 0;
                SET p_message = 'Format invalide. Utiliser le format YYYY-YYYY+1 (ex: 2024-2025).';
            ELSE
                
                SET v_annee_debut = CAST(LEFT(p_nouvelle_annee, 4) AS UNSIGNED);
                SET v_annee_fin = CAST(RIGHT(p_nouvelle_annee, 4) AS UNSIGNED);

                
                IF v_annee_fin <> v_annee_debut + 1 THEN
                    SET p_status = 0;
                    SET p_message = 'Année invalide. La deuxième année doit être égale à la première + 1.';
                ELSE
                    
                    SELECT COUNT(*) INTO v_count FROM anneescolaires WHERE annee = p_nouvelle_annee;

                    IF v_count > 0 THEN
                        SET p_status = 0;
                        SET p_message = 'L\'année scolaire existe déjà.';
                    ELSE
                        
                        START TRANSACTION;

                        
                        UPDATE anneescolaires 
                        SET annee = p_nouvelle_annee 
                        WHERE id = v_id;

                        
                        COMMIT;
                        SET p_status = 1;
                        SET p_message = 'Année scolaire modifiée avec succès.';
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ModifierFiliere
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ModifierFiliere`(
    IN p_id INT,
    IN p_nom VARCHAR(255),
    IN p_fin_inscription DATE,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la modification de la filière';
    END;

    
    START TRANSACTION;
    
    
    SELECT COUNT(*) INTO v_count FROM inscriptions WHERE filiere_id = p_id;
    IF v_count > 0 THEN
        SET p_success = FALSE;
        SET p_message = 'Modification impossible : des inscriptions existent pour cette filière';
        ROLLBACK;
    ELSE
        UPDATE filieres 
        SET nom = p_nom, fin_incription = p_fin_inscription 
        WHERE id = p_id;
        
        SELECT COUNT(*) INTO v_count FROM filieres WHERE id = p_id;
            
        IF v_count = 0 THEN
            SET p_success = FALSE;
            SET p_message = 'Aucune filière trouvée avec cet ID';
            ROLLBACK;
        ELSE
            SET p_success = TRUE;
            SET p_message = 'Filière modifiée avec succès';
            COMMIT;
        END IF;

     END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SupprimerAnneeScolaire
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SupprimerAnneeScolaire`(
    IN p_annee VARCHAR(9), 
    OUT p_status INT, 
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_id INT DEFAULT 0;
    DECLARE v_nb_inscriptions INT DEFAULT 0;

    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 0;
        SET p_message = 'Erreur lors de la suppression de l\'année scolaire.';
    END;

    
    SELECT id INTO v_id FROM anneescolaires WHERE annee = p_annee;

    IF v_id IS NULL THEN
        SET p_status = 0;
        SET p_message = 'L\'année scolaire spécifiée n\'existe pas.';
    ELSE
        
        SELECT COUNT(*) INTO v_nb_inscriptions FROM inscriptions WHERE annee_id = v_id;

        IF v_nb_inscriptions > 0 THEN
            SET p_status = 0;
            SET p_message = 'Suppression annulée. L\'année scolaire possède déjà des inscriptions.';
        ELSE
            
            START TRANSACTION;

            
            DELETE FROM anneescolaires WHERE id = v_id;

            
            COMMIT;
            SET p_status = 1;
            SET p_message = 'Année scolaire supprimée avec succès.';
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SupprimerFiliere
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SupprimerFiliere`(
    IN p_id INT,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la suppression de la filière';
    END;

    
    START TRANSACTION;
    
    
    IF p_id IS NULL OR p_id <= 0 THEN
        SET p_success = FALSE;
        SET p_message = 'ID invalide : il doit être un entier positif';
        ROLLBACK;
    ELSE
        
        SELECT COUNT(*) INTO v_count FROM filieres WHERE id = p_id;
        IF v_count = 0 THEN
            SET p_success = FALSE;
            SET p_message = 'Filière inexistante';
            ROLLBACK;
        ELSE
            
            SELECT COUNT(*) INTO v_count FROM inscriptions WHERE filiere_id = p_id;
            IF v_count > 0 THEN
                SET p_success = FALSE;
                SET p_message = 'Suppression impossible : des inscriptions existent pour cette filière';
                ROLLBACK;
            ELSE
                
                DELETE FROM filieres WHERE id = p_id;
                
                IF ROW_COUNT() = 0 THEN
                    SET p_success = FALSE;
                    SET p_message = 'Échec de la suppression : ID non trouvé';
                    ROLLBACK;
                ELSE
                    SET p_success = TRUE;
                    SET p_message = 'Filière supprimée avec succès';
                    COMMIT;
                END IF;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SupprimerInscription
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SupprimerInscription`(
    IN p_id INT
)
BEGIN
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur lors de la suppression de l\'inscription. Vérifiez les contraintes d\'intégrité';
    END;

    
    SELECT COUNT(*) INTO v_count
    FROM echeances
    WHERE inscription_id = p_id;

    IF v_count > 0 THEN
        
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Inscription contient des échéances, elle n\'a pas été supprimée';
    ELSE
        
        START TRANSACTION;
        DELETE FROM inscriptions WHERE id = p_id;
        COMMIT;
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Inscription supprimée avec succès';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ajouter_stagiaire
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ajouter_stagiaire`(
    IN p_nom VARCHAR(255),
    IN p_prenom VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telephone VARCHAR(20),
    OUT p_message VARCHAR(200),
    OUT p_success  VARCHAR(200)
)
proc:BEGIN
  BEGIN
    DECLARE v_stagiaire_id INT;
    DECLARE v_exist INT;
    
    If (p_nom = '' OR p_prenom ='') THEN
        SET p_message = 'Nom  et Prenom obligatoire';
        SET p_success = 'FALSE';
        LEAVE proc;
    END IF; 
    
    If (p_email = '' OR p_telephone ='') THEN
        SET p_message = 'Telephone  et Email obligatoire';
        SET p_success = 'FALSE';
        LEAVE proc;
    END IF; 
    
    
    
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.stagiaires
    WHERE (email = p_email OR telephone = p_telephone);
    
    IF v_exist > 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Le stagiaire existe déjà avec cet email ou téléphone.';
        LEAVE proc;
    ELSE
    
   
    INSERT INTO paiement_institus.stagiaires (nom, prenom, email, telephone)
    VALUES (p_nom, p_prenom, p_email, p_telephone);
    
   
     SET p_message = 'Stagiaire et inscription ajoutés avec succès.';
     SET p_success = 'TRUE';

   
   END IF;
 END;   
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure all_filiere
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_filiere`( 
    OUT p_success  VARCHAR(200),
    OUT p_message VARCHAR(200)
)
proc:BEGIN
   
    
    DECLARE v_filiere_id INT;
    DECLARE v_exist INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la Recherche';
    END;
    
    
    SELECT COUNT(*) INTO v_exist
    FROM filieres;
    
    
    IF v_exist = 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Aucun Stagiaire inscrit';
        LEAVE proc;
    ELSE
    
   
    SELECT *  FROM filieres;
    
   
     SET p_message = 'Filieres recuperés';
     SET p_success = 'TRUE';

   
   
   END IF;   
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure all_inscriptions
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_inscriptions`( 
    OUT p_success  VARCHAR(200),
    OUT p_message VARCHAR(200)
)
proc:BEGIN
   
    
    DECLARE v_inscription_id INT;
    DECLARE v_exist INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la Recherche';
    END;
    
    
    SELECT COUNT(*) INTO v_exist
    FROM filieres;
    
    
    IF v_exist = 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Aucun Inscription trouvée';
        LEAVE proc;
    ELSE
    
   
    SELECT inscriptions.*,
           stagiaires.nom,stagiaires.prenom,
           filieres.nom as filiere ,
           anneescolaires.annee    
    FROM   inscriptions,stagiaires,filieres,anneescolaires  
    where (stagiaires.id = inscriptions.stagiaire_id)  
                   and 
          (filieres.id = inscriptions.filiere_id)
                   and
          (anneescolaires.id =inscriptions.annee_id )  ;

    
   
     SET p_message = 'Inscriptios recuperés';
     SET p_success = 'TRUE';

   
   
   END IF;   
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure all_stagiaire
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_stagiaire`( 
    OUT p_success  VARCHAR(200),
    OUT p_message VARCHAR(200)
)
proc:BEGIN
   
    
    DECLARE v_stagiaire_id INT;
    DECLARE v_exist INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la Recherche';
    END;
    
    
    SELECT COUNT(*) INTO v_exist
    FROM stagiaires;
    
    
    IF v_exist = 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Aucun Stagiaire inscrit';
        LEAVE proc;
    ELSE
    
   
    SELECT *  FROM stagiaires;
    
   
     SET p_message = 'Stagiaires recuperés';
     SET p_success = 'TRUE';

   
   
   END IF;   
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure authentifier_utilisateur
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `authentifier_utilisateur`(
    IN p_email VARCHAR(150), 
    IN p_mot_de_passe VARCHAR(255),
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_utilisateur_id INT;
    DECLARE v_role_id INT;
    DECLARE v_mot_de_passe_hache VARCHAR(255);

    
    SELECT id, role_id, mot_de_passe INTO v_utilisateur_id, v_role_id, v_mot_de_passe_hache
    FROM utilisateurs WHERE email = p_email;

    IF v_utilisateur_id IS NULL THEN
        SET p_success = FALSE;
        SET p_message = 'Utilisateur non trouvé';
    ELSEIF v_mot_de_passe_hache != SHA2(p_mot_de_passe, 256) THEN
        SET p_success = FALSE;
        SET p_message = 'Mot de passe incorrect';
    ELSE
        SET p_success = TRUE;
        SET p_message = 'Authentification réussie';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mettre_a_jour_stagiaire
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mettre_a_jour_stagiaire`(
    IN p_stagiaire_id INT,
    IN p_nom VARCHAR(255),
    IN p_prenom VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telephone VARCHAR(20),
    OUT p_success  VARCHAR(200),
    OUT p_message VARCHAR(200)  
)
BEGIN
proc:BEGIN
    DECLARE v_exist INT;
    
    If (p_nom = '' OR p_prenom ='') THEN
        SET p_message = 'Nom  et Prenom obligatoire';
        SET p_success = 'FALSE';
        LEAVE proc;
    END IF; 
    
    If (p_email = '' OR p_telephone ='') THEN
        SET p_message = 'Telephone  et Email obligatoire';
        SET p_success = 'FALSE';
        LEAVE proc;
    END IF; 
    
    
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.stagiaires
    WHERE id = p_stagiaire_id;
    
    IF v_exist = 0 THEN
        SET p_message = 'Le stagiaire n\'existe pas.';
        SET p_success = 'FALSE';
        LEAVE proc;
    END IF;
    
    
    
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.stagiaires
    WHERE email = p_email AND id != p_stagiaire_id;
    
    IF v_exist > 0 THEN
        SET p_message = 'L\'email existe déjà pour un autre stagiaire.';
        SET p_success = 'FALSE';
        LEAVE proc;
    END IF;
    
    
    
    UPDATE paiement_institus.stagiaires
    SET nom = p_nom,
        prenom = p_prenom,
        email = p_email,
        telephone = p_telephone
    WHERE id = p_stagiaire_id;
    
    
    SET p_message = 'Les informations du stagiaire ont été mises à jour avec succès.';
    SET p_success = 'TRUE' ;
END;    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifier_profil_utilisateur
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modifier_profil_utilisateur`(
    IN p_id INT,
    IN p_nom VARCHAR(100),
    IN p_email VARCHAR(150),
    IN p_mot_de_passe_actuel VARCHAR(255),
    IN p_nouveau_mot_de_passe VARCHAR(255),
    OUT p_message VARCHAR(255),
    OUT p_success BOOLEAN
)
BEGIN
    DECLARE v_mot_de_passe_stocke VARCHAR(255);
    
    
    SELECT mot_de_passe INTO v_mot_de_passe_stocke 
    FROM utilisateurs 
    WHERE id = p_id;

    
    IF v_mot_de_passe_stocke IS NULL THEN
        SET p_message = 'Utilisateur non trouvé';
        SET p_success = FALSE;
    ELSE
        
        IF v_mot_de_passe_stocke = SHA2(p_mot_de_passe_actuel, 256) THEN
            
            UPDATE utilisateurs
            SET 
                nom = p_nom,
                email = p_email,
             
                mot_de_passe = IF(p_nouveau_mot_de_passe IS NOT NULL AND p_nouveau_mot_de_passe != '', SHA2(p_nouveau_mot_de_passe, 256), mot_de_passe)
            WHERE id = p_id;

            SET p_message = 'Profil mis à jour avec succès';
            SET p_success = TRUE;
        ELSE
            SET p_message = 'Mot de passe actuel incorrect';
            SET p_success = FALSE;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure supprimer_stagiaire
-- -----------------------------------------------------

DELIMITER $$
USE `paiement_institus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `supprimer_stagiaire`(
    IN p_stagiaire_id INT UNSIGNED,
    OUT p_message VARCHAR(200),
    OUT p_success VARCHAR(200)
)
BEGIN
proc:BEGIN

    DECLARE v_exist INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        
        ROLLBACK;
        SET p_success = 'FALSE';
        SET p_message = 'Une erreur est survenue lors de la suppression.';
    END;

    
    START TRANSACTION;

    SET p_stagiaire_id = IFNULL(p_stagiaire_id, 0);

    
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.stagiaires
    WHERE id = p_stagiaire_id;
    
    IF v_exist = 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Le stagiaire possédant ce code est non enregistré';
        ROLLBACK;
        LEAVE proc;    
    END IF;   

    
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.inscriptions
    WHERE stagiaire_id = p_stagiaire_id;
   
    IF v_exist > 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Le stagiaire possède déjà une inscription. La suppression est refusée.';
        ROLLBACK;
        LEAVE proc;
    ELSE
        
        DELETE FROM paiement_institus.stagiaires WHERE id = p_stagiaire_id;

        
        COMMIT;
        SET p_success = 'TRUE';
        SET p_message = 'Le stagiaire a été supprimé avec succès.';
    END IF;
END;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
