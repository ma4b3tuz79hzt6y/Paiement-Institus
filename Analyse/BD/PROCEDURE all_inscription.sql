DELIMITER $$

CREATE PROCEDURE all_inscriptions( 
    OUT p_success  VARCHAR(200),
    OUT p_message VARCHAR(200)
)
proc:BEGIN
   
    
    DECLARE v_inscription_id INT;
    DECLARE v_exist INT;
    -- Gestion des erreurs avec un gestionnaire
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la Recherche';
    END;
    
    -- Vérification si des Filieres sont enregistrées
    SELECT COUNT(*) INTO v_exist
    FROM filieres;
    
    
    IF v_exist = 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Aucun Inscription trouvée';
        LEAVE proc;
    ELSE
    
   -- lister les stagiaires
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

    
   -- Si tout se passe bien, renvoyer un message de succès
     SET p_message = 'Inscriptios recuperés';
     SET p_success = 'TRUE';

   
   
   END IF;   
END $$
DELIMITER ;

