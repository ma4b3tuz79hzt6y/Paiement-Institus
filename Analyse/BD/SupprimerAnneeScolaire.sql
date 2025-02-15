DELIMITER $$

CREATE PROCEDURE SupprimerAnneeScolaire(
    IN p_annee VARCHAR(9), 
    OUT p_status INT, 
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_id INT DEFAULT 0;
    DECLARE v_nb_inscriptions INT DEFAULT 0;

    -- Gestion des erreurs SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 0;
        SET p_message = 'Erreur lors de la suppression de l\'année scolaire.';
    END;

    -- Vérifier si l'année scolaire existe
    SELECT id INTO v_id FROM anneescolaires WHERE annee = p_annee;

    IF v_id IS NULL THEN
        SET p_status = 0;
        SET p_message = 'L\'année scolaire spécifiée n\'existe pas.';
    ELSE
        -- Vérifier si l'année scolaire possède des inscriptions
        SELECT COUNT(*) INTO v_nb_inscriptions FROM inscriptions WHERE annee_id = v_id;

        IF v_nb_inscriptions > 0 THEN
            SET p_status = 0;
            SET p_message = 'Suppression annulée. L\'année scolaire possède déjà des inscriptions.';
        ELSE
            -- Démarrer la transaction
            START TRANSACTION;

            -- Supprimer l'année scolaire
            DELETE FROM anneescolaires WHERE id = v_id;

            -- Valider la transaction
            COMMIT;
            SET p_status = 1;
            SET p_message = 'Année scolaire supprimée avec succès.';
        END IF;
    END IF;
END $$

DELIMITER ;


-- Empêche la suppression si l'année possède des inscriptions (v_nb_inscriptions > 0).
-- Recherche par année (annee) au lieu de id pour identifier l'année à supprimer.
-- Utilisation de transactions (START TRANSACTION, COMMIT, ROLLBACK).
-- Gestion des exceptions avec ROLLBACK en cas d’erreur.
-- Retour d'un message détaillé pour chaque situation.

-- CALL SupprimerAnneeScolaire('2024-2025', @status, @message);
-- SELECT @status, @message;







