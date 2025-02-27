-- Procédure pour ajouter une inscription avec gestion des erreurs
DELIMITER $$

CREATE PROCEDURE AjouterInscription(
    IN p_date_inscription DATE,
    IN p_nombre_echeance INT,
    IN p_filiere_id INT,
    IN p_annee_id INT,
    IN p_stagiaire_id INT
)
BEGIN
    DECLARE v_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur lors de l\'ajout de l\'inscription. Vérifiez les contraintes d\'intégrité';
    END;
    
    -- Vérifier si le stagiaire est déjà inscrit pour cette année scolaire
    SELECT COUNT(*) INTO v_count 
    FROM inscriptions 
    WHERE annee_id = p_annee_id AND stagiaire_id = p_stagiaire_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le stagiaire est déjà inscrit pour cette année scolaire';
    ELSE
        START TRANSACTION;
        INSERT INTO inscriptions (date_inscription, nombre_echeance, filiere_id, annee_id, stagiaire_id)
        VALUES (COALESCE(p_date_inscription, CURRENT_DATE), p_nombre_echeance, p_filiere_id, p_annee_id, p_stagiaire_id);
        COMMIT;
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Inscription ajoutée avec succès';
    END IF;
END $$

DELIMITER ;

-- Procédure pour modifier une inscription avec gestion des erreurs
DELIMITER $$

CREATE PROCEDURE ModifierInscription(
    IN p_id INT,
    IN p_date_inscription DATE,
    IN p_nombre_echeance INT,
    IN p_montant_total DECIMAL(10,2),
    IN p_filiere_id INT,
    IN p_annee_id INT,
    IN p_stagiaire_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur lors de la modification de l\'inscription. Vérifiez les contraintes d\'intégrité';
    END;
    
    START TRANSACTION;
    UPDATE inscriptions
    SET date_inscription = COALESCE(p_date_inscription, date_inscription),
        nombre_echeance = p_nombre_echeance,
        montant_total = p_montant_total,
        filiere_id = p_filiere_id,
        annee_id = p_annee_id,
        stagiaire_id = p_stagiaire_id
    WHERE id = p_id;
    COMMIT;
    SIGNAL SQLSTATE '01000'
    SET MESSAGE_TEXT = 'Inscription modifiée avec succès';
END $$

DELIMITER ;

-- Procédure pour supprimer une inscription avec gestion des erreurs
DELIMITER $$

CREATE PROCEDURE SupprimerInscription(
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

    -- Vérifier si l'inscription possède au moins une échéance
    SELECT COUNT(*) INTO v_count
    FROM echeances
    WHERE inscription_id = p_id;

    IF v_count > 0 THEN
        -- Si des échéances existent, ne pas supprimer l'inscription et retourner un message de succès
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Inscription contient des échéances, elle n\'a pas été supprimée';
    ELSE
        -- Si aucune échéance n'est associée à l'inscription, la supprimer
        START TRANSACTION;
        DELETE FROM inscriptions WHERE id = p_id;
        COMMIT;
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Inscription supprimée avec succès';
    END IF;
END $$

DELIMITER ;

