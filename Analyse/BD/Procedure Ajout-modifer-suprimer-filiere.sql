-- Partie 1 : Gestion de l'ajout d'une filière
DELIMITER //

CREATE PROCEDURE AjouterFiliere(
    IN p_nom VARCHAR(255),
    IN p_fin_inscription DATE,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- En cas d'erreur, on annule la transaction
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de l’ajout de la filière';
    END;

    -- Démarrer une transaction
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
END //

DELIMITER ;


DELIMITER ;

-- Partie 2 : Gestion de la modification d'une filière
DELIMITER //

CREATE PROCEDURE ModifierFiliere(
    IN p_id INT,
    IN p_nom VARCHAR(255),
    IN p_fin_inscription DATE,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    
    -- Gestion des erreurs avec un gestionnaire
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la modification de la filière';
    END;

    -- Démarrer une transaction
    START TRANSACTION;
    
    -- Vérifier si des inscriptions existent pour cette filière
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
END //

DELIMITER ;


-- Partie 3 : Gestion de la suppression d'une filière
DELIMITER //

CREATE PROCEDURE SupprimerFiliere(
    IN p_id INT,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    
    -- Gestion des erreurs avec un gestionnaire
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la suppression de la filière';
    END;

    -- Démarrer une transaction
    START TRANSACTION;
    
    -- Vérification de la validité de l'ID
    IF p_id IS NULL OR p_id <= 0 THEN
        SET p_success = FALSE;
        SET p_message = 'ID invalide : il doit être un entier positif';
        ROLLBACK;
    ELSE
        -- Vérifier si la filière existe
        SELECT COUNT(*) INTO v_count FROM filieres WHERE id = p_id;
        IF v_count = 0 THEN
            SET p_success = FALSE;
            SET p_message = 'Filière inexistante';
            ROLLBACK;
        ELSE
            -- Vérifier si des inscriptions existent pour cette filière
            SELECT COUNT(*) INTO v_count FROM inscriptions WHERE filiere_id = p_id;
            IF v_count > 0 THEN
                SET p_success = FALSE;
                SET p_message = 'Suppression impossible : des inscriptions existent pour cette filière';
                ROLLBACK;
            ELSE
                -- Suppression de la filière
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
END //

DELIMITER ;


-- Partie 4 : Tests des procédures

-- Test Ajout
CALL AjouterFiliere('Informatique', '2025-06-30', @success, @message);
SELECT @success, @message;

-- Test Modification
CALL ModifierFiliere(1, 'Génie Logiciel', '2025-07-15', @success, @message);
SELECT @success, @message;

-- Test Suppression
CALL SupprimerFiliere(1, @success, @message);
SELECT @success, @message;

-- Synthèse des fonctionnalités et contraintes
-- 1. AjouterFiliere : Ajoute une filière après vérification d'unicité et de validité du nom.
-- 2. ModifierFiliere : Refuse la modification si des inscriptions existent.
-- 3. SupprimerFiliere : Vérifie que la filière n’a pas d’inscriptions avant suppression.
-- Chaque procédure retourne un indicateur de succès et un message explicatif.
-- Améliorations possibles :
-- - Ajouter un contrôle plus strict sur le format du nom de la filière.
-- - Implémenter un système de journalisation des opérations effectuées sur les filières.

