DELIMITER $$

CREATE PROCEDURE ModifierAnneeScolaire(
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

    -- Gestion des erreurs SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 0;
        SET p_message = 'Erreur lors de la modification de l\'année scolaire.';
    END;

    -- Vérifier si l'année à modifier existe
    SELECT id INTO v_id FROM anneescolaires WHERE annee = p_ancienne_annee;
    
    IF v_id IS NULL THEN
        SET p_status = 0;
        SET p_message = 'L\'année scolaire à modifier n\'existe pas.';
    ELSE
        -- Vérifier si l'année scolaire possède des inscriptions
        SELECT COUNT(*) INTO v_nb_inscriptions FROM inscriptions WHERE annee_id = v_id;

        IF v_nb_inscriptions > 0 THEN
            SET p_status = 0;
            SET p_message = 'Modification annulée. L\'année scolaire possède déjà des inscriptions.';
        ELSE
            -- Vérifier le format de la nouvelle année scolaire
            IF p_nouvelle_annee NOT REGEXP '^[0-9]{4}-[0-9]{4}$' THEN
                SET p_status = 0;
                SET p_message = 'Format invalide. Utiliser le format YYYY-YYYY+1 (ex: 2024-2025).';
            ELSE
                -- Extraire les années de début et de fin
                SET v_annee_debut = CAST(LEFT(p_nouvelle_annee, 4) AS UNSIGNED);
                SET v_annee_fin = CAST(RIGHT(p_nouvelle_annee, 4) AS UNSIGNED);

                -- Vérifier si la deuxième année est bien +1 de la première
                IF v_annee_fin <> v_annee_debut + 1 THEN
                    SET p_status = 0;
                    SET p_message = 'Année invalide. La deuxième année doit être égale à la première + 1.';
                ELSE
                    -- Vérifier si la nouvelle année existe déjà
                    SELECT COUNT(*) INTO v_count FROM anneescolaires WHERE annee = p_nouvelle_annee;

                    IF v_count > 0 THEN
                        SET p_status = 0;
                        SET p_message = 'L\'année scolaire existe déjà.';
                    ELSE
                        -- Démarrer la transaction
                        START TRANSACTION;

                        -- Modifier l'année scolaire
                        UPDATE anneescolaires 
                        SET annee = p_nouvelle_annee 
                        WHERE id = v_id;

                        -- Valider la transaction
                        COMMIT;
                        SET p_status = 1;
                        SET p_message = 'Année scolaire modifiée avec succès.';
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;


-- Recherche par année (annee) au lieu de id pour identifier l'année à modifier.
-- Empêche la modification si l'année possède des inscriptions (v_nb_inscriptions > 0).
-- Vérification du format (YYYY-YYYY+1) via REGEXP et conversion en INT.
-- Empêchement des erreurs de saisie (2024-2026 est rejeté).
-- Vérification si la nouvelle année existe déjà pour éviter les doublons.
-- Utilisation de transactions (START TRANSACTION, COMMIT, ROLLBACK).
-- Gestion des exceptions avec ROLLBACK en cas d’erreur.
-- Retour d'un message détaillé pour chaque situation.

-- CALL ModifierAnneeScolaire('2024-2025', '2025-2026', @status, @message);
-- SELECT @status, @message;







