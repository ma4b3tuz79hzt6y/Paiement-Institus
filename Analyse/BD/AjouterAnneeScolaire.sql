DELIMITER $$

CREATE PROCEDURE AjouterAnneeScolaire(
    IN p_annee VARCHAR(9), 
    OUT p_status INT, 
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_annee_debut INT;
    DECLARE v_annee_fin INT;

    -- Gestion des erreurs SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 0;
        SET p_message = 'Erreur lors de l\'ajout de l\'année scolaire.';
    END;

    -- Vérifier le format de l'année scolaire
    IF p_annee NOT REGEXP '^[0-9]{4}-[0-9]{4}$' THEN
        SET p_status = 0;
        SET p_message = 'Format invalide. Utiliser le format YYYY-YYYY+1 (ex: 2024-2025).';
    ELSE
        -- Extraire les années de début et de fin
        SET v_annee_debut = CAST(LEFT(p_annee, 4) AS UNSIGNED);
        SET v_annee_fin = CAST(RIGHT(p_annee, 4) AS UNSIGNED);

        -- Vérifier si la deuxième année est bien +1 de la première
        IF v_annee_fin <> v_annee_debut + 1 THEN
            SET p_status = 0;
            SET p_message = 'Année invalide. La deuxième année doit être égale à la première + 1.';
        ELSE
            -- Démarrer la transaction
            START TRANSACTION;

            -- Vérifier si l'année existe déjà
            SELECT COUNT(*) INTO v_count FROM anneescolaires WHERE annee = p_annee;

            IF v_count > 0 THEN
                -- Année déjà existante
                SET p_status = 0;
                SET p_message = 'L\'année scolaire existe déjà.';
                ROLLBACK;
            ELSE
                -- Insérer la nouvelle année scolaire
                INSERT INTO anneescolaires (annee) VALUES (p_annee);
                
                -- Valider la transaction
                COMMIT;
                SET p_status = 1;
                SET p_message = 'Année scolaire ajoutée avec succès.';
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Vérification du format (YYYY-YYYY+1) via REGEXP et conversion en INT.
-- Empêchement des erreurs de saisie (2024-2026 est rejeté).
-- Vérification si l'année existe avant l'insertion.
-- Gestion des transactions pour éviter les corruptions de données.
-- Gestion des exceptions avec ROLLBACK en cas d’erreur.
-- Retour d'un message détaillé pour chaque situation.

-- CALL AjouterAnneeScolaire('2024-2025', @status, @message);
-- SELECT @status, @message;










