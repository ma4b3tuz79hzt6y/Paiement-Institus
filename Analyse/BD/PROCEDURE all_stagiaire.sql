DELIMITER $$

CREATE PROCEDURE all_stagiaire( 
    OUT p_success  VARCHAR(200),
    OUT p_message VARCHAR(200)
)
proc:BEGIN
   
    
    DECLARE v_stagiaire_id INT;
    DECLARE v_exist INT;
    -- Gestion des erreurs avec un gestionnaire
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la Recherche';
    END;
    
    -- Vérification si des stagiaires sont enregistrées
    SELECT COUNT(*) INTO v_exist
    FROM stagiaires;
    
    
    IF v_exist = 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Aucun Stagiaire inscrit';
        LEAVE proc;
    ELSE
    
   -- lister les stagiaires
    SELECT *  FROM stagiaires;
    
   -- Si tout se passe bien, renvoyer un message de succès
     SET p_message = 'Stagiaires recuperés';
     SET p_success = 'TRUE';

   
   
   END IF;   
END $$
DELIMITER ;

