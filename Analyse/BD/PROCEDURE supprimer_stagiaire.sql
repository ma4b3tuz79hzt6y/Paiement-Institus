DELIMITER $$

CREATE PROCEDURE supprimer_stagiaire(
    IN p_stagiaire_id INT UNSIGNED ,
    
    OUT p_message VARCHAR(200) ,
    OUT p_success  VARCHAR(200)
)
BEGIN

    DECLARE v_exist INT;
    
   SET p_stagiaire_id = IFNULL(p_stagiaire_id, 0);
    
    -- Vérifier si le stagiaire a déjà une inscription pour l'année scolaire spécifiée
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.inscriptions
    WHERE stagiaire_id = p_stagiaire_id;
   
    
 IF v_exist > 0 THEN
    SET p_success = 'FALSE';
    SET p_message = 'Le stagiaire possède déjà une inscription  La suppression est refusée.';
ELSE
    DELETE FROM paiement_institus.stagiaires WHERE id = p_stagiaire_id;
    SET p_success = 'TRUE';
    SET p_message = 'Le stagiaire a été supprimé avec succès.';
END IF;
   
END $$

DELIMITER ;

