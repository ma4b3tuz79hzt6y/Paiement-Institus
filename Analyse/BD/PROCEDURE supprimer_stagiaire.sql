DELIMITER $$

CREATE PROCEDURE supprimer_stagiaire(
    IN p_stagiaire_id INT UNSIGNED,
    OUT p_message VARCHAR(200),
    OUT p_success VARCHAR(200)
)
BEGIN
proc:BEGIN

    DECLARE v_exist INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- En cas d'erreur, on annule toutes les opérations
        ROLLBACK;
        SET p_success = 'FALSE';
        SET p_message = 'Une erreur est survenue lors de la suppression.';
    END;

    -- Démarrer une transaction
    START TRANSACTION;

    SET p_stagiaire_id = IFNULL(p_stagiaire_id, 0);

    -- Vérifier si le stagiaire existe
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.stagiaires
    WHERE id = p_stagiaire_id;
    
    IF v_exist = 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Le stagiaire possédant ce code est non enregistré';
        ROLLBACK;
        LEAVE proc;    
    END IF;   

    -- Vérifier si le stagiaire a déjà une inscription
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.inscriptions
    WHERE stagiaire_id = p_stagiaire_id;
   
    IF v_exist > 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Le stagiaire possède déjà une inscription. La suppression est refusée.';
        ROLLBACK;
        LEAVE proc;
    ELSE
        -- Supprimer le stagiaire
        DELETE FROM paiement_institus.stagiaires WHERE id = p_stagiaire_id;

        -- Valider la transaction si tout s'est bien passé
        COMMIT;
        SET p_success = 'TRUE';
        SET p_message = 'Le stagiaire a été supprimé avec succès.';
    END IF;
END;
END$$

DELIMITER ;

