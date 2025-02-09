DELIMITER $$

CREATE PROCEDURE generer_echeances(
    IN p_inscription_id INT,
    IN p_nombre_echeance INT,
    IN p_montant_echeance DECIMAL(10,2),
    OUT p_result TINYINT(1)  -- Correction du type BOOLEAN (MySQL ne supporte pas BOOLEAN en sortie)
)
BEGIN
    DECLARE v_echeance_count INT;
    DECLARE v_date_reference DATE;
    DECLARE v_date_echeance DATE;
    DECLARE i INT;
    
    this_proc:BEGIN
    -- Vérifier si l'inscription existe avant de continuer
    IF NOT EXISTS (SELECT 1 FROM paiement_institus.inscriptions WHERE id = p_inscription_id) THEN
         SET p_result = 0; 
         LEAVE this_proc;
    END IF;

    -- Vérifier si l'inscription possède déjà des échéances
    SELECT COUNT(*) INTO v_echeance_count
    FROM paiement_institus.echeances
    WHERE inscription_id = p_inscription_id;
    
    -- Si des échéances existent déjà, retourner FALSE
    IF v_echeance_count > 0 THEN
        SET p_result = 0;  -- FALSE
    ELSE
        -- Récupérer la date d'inscription comme point de référence
        SELECT date_inscription INTO v_date_reference
        FROM paiement_institus.inscriptions
        WHERE id = p_inscription_id;

        -- Insérer les échéances
        SET i = 0;
        WHILE i < p_nombre_echeance DO
            -- Calcul de la date d'échéance
            SET v_date_echeance = DATE_ADD(v_date_reference, INTERVAL i MONTH);

            -- Insérer dans la table `echeances`
            INSERT INTO paiement_institus.echeances (inscription_id, montant, date_echeance, statut)
            VALUES (p_inscription_id, p_montant_echeance, v_date_echeance, 'Non payé');

            SET i = i + 1;
        END WHILE;

        -- Mettre à jour la table `inscriptions` avec le nombre d'échéances uniquement
        UPDATE paiement_institus.inscriptions
        SET nombre_echeance = p_nombre_echeance
        WHERE id = p_inscription_id;
        
        -- Retourner TRUE pour indiquer que les échéances ont été ajoutées
        SET p_result = 1;  -- TRUE
    END IF;
  end;  
END $$

DELIMITER ;

