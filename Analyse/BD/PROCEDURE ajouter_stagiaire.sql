DELIMITER $$

CREATE PROCEDURE ajouter_stagiaire(
    IN p_nom VARCHAR(255),
    IN p_prenom VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telephone VARCHAR(20),
    OUT p_message VARCHAR(200),
    OUT p_success  VARCHAR(200)
)
proc:BEGIN
  BEGIN
   -- Gestion des erreurs avec un gestionnaire
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de l\'Ajout';
    END;
    
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
    
    
    -- Vérification si le stagiaire existe déjà avec le même email ou téléphone
    SELECT COUNT(*) INTO v_exist
    FROM stagiaires
    WHERE (email = p_email OR telephone = p_telephone);
    
    IF v_exist > 0 THEN
        SET p_success = 'FALSE';
        SET p_message = 'Le stagiaire existe déjà avec cet email ou téléphone.';
        LEAVE proc;
    ELSE
    
   -- Ajouter le stagiaire
    INSERT INTO stagiaires (nom, prenom, email, telephone)
    VALUES (p_nom, p_prenom, p_email, p_telephone);
    
   -- Si tout se passe bien, renvoyer un message de succès
     SET p_message = 'Stagiaire et inscription ajoutés avec succès.';
     SET p_success = 'TRUE';

   
   END IF;
 END;   
END $$


DELIMITER ;

