DELIMITER $$

CREATE PROCEDURE mettre_a_jour_stagiaire(
    IN p_stagiaire_id INT,
    IN p_nom VARCHAR(255),
    IN p_prenom VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telephone VARCHAR(20),
    OUT p_success  VARCHAR(200),
    OUT p_message VARCHAR(200)  
)
BEGIN
proc:BEGIN
    DECLARE v_exist INT;
     -- Gestion des erreurs avec un gestionnaire
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SET p_success = FALSE;
        SET p_message = 'Une erreur est survenue lors de la mise ajour';
    END;
    
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
    
    -- Vérifier si le stagiaire existe
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.stagiaires
    WHERE id = p_stagiaire_id;
    
    IF v_exist = 0 THEN
        SET p_message = 'Le stagiaire n\'existe pas.';
        SET p_success = 'FALSE';
        LEAVE proc;
    END IF;
    
    
    -- Vérifier si l'email existe déjà pour un autre stagiaire
    SELECT COUNT(*) INTO v_exist
    FROM paiement_institus.stagiaires
    WHERE email = p_email AND id != p_stagiaire_id;
    
    IF v_exist > 0 THEN
        SET p_message = 'L\'email existe déjà pour un autre stagiaire.';
        SET p_success = 'FALSE';
        LEAVE proc;
    END IF;
    
    
    -- Mettre à jour le stagiaire
    UPDATE paiement_institus.stagiaires
    SET nom = p_nom,
        prenom = p_prenom,
        email = p_email,
        telephone = p_telephone
    WHERE id = p_stagiaire_id;
    
    -- Retourner un message de succès
    SET p_message = 'Les informations du stagiaire ont été mises à jour avec succès.';
    SET p_success = 'TRUE' ;
END;    
END $$

DELIMITER ;

-- CALL mettre_a_jour_stagiaire(3, 'Doe', 'John', 'john.doe@email.com', '0612345678',@r,@m);


