-- page ia Réinitialisation auto-incrément MySQL



SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM paiement_institus.sessions;
DELETE FROM paiement_institus.utilisateurs;
DELETE FROM paiement_institus.roles;
DELETE FROM paiement_institus.paiements;
DELETE FROM paiement_institus.echeances;
DELETE FROM paiement_institus.inscriptions;
DELETE FROM paiement_institus.stagiaires;
DELETE FROM paiement_institus.filieres;
DELETE FROM paiement_institus.anneescolaires;

SET FOREIGN_KEY_CHECKS = 1;





-- Désactiver temporairement les contraintes de clé étrangère
SET FOREIGN_KEY_CHECKS = 0;

-- Vider les tables
TRUNCATE TABLE paiement_institus.sessions;
TRUNCATE TABLE paiement_institus.utilisateurs;
TRUNCATE TABLE paiement_institus.roles;
TRUNCATE TABLE paiement_institus.paiements;
TRUNCATE TABLE paiement_institus.echeances;
TRUNCATE TABLE paiement_institus.inscriptions;
TRUNCATE TABLE paiement_institus.stagiaires;
TRUNCATE TABLE paiement_institus.filieres;
TRUNCATE TABLE paiement_institus.anneescolaires;

-- Réactiver les contraintes de clé étrangère
SET FOREIGN_KEY_CHECKS = 1;

-- Insertion des Années Scolaires
INSERT INTO paiement_institus.anneescolaires (annee) VALUES
('2022-2023'),
('2023-2024'),
('2024-2025');

-- Insertion des Filières
INSERT INTO paiement_institus.filieres (nom, fin_incription) VALUES
('Informatique', '2024-10-01'),
('Gestion', '2024-10-15'),
('Commerce', '2024-11-01');

-- Insertion des Stagiaires
INSERT INTO paiement_institus.stagiaires (nom, prenom, email, telephone) VALUES
('El Amrani', 'Yassine', 'yassine@email.com', '0612345678'),
('Bennani', 'Salma', 'salma@email.com', '0698765432'),
('Hajji', 'Omar', 'omar@email.com', '0687654321');

-- Insertion des Inscriptions
INSERT INTO paiement_institus.inscriptions (date_inscription, nombre_echeance, montant_total, filiere_id, annee_id, stagiaire_id) VALUES
('2024-09-01', 3, 9000.00, 1, 2, 1),
('2024-09-05', 4, 12000.00, 2, 2, 2),
('2024-09-10', 2, 8000.00, 3, 2, 3);

-- Insertion des Échéances
INSERT INTO paiement_institus.echeances (montant, date_echeance, statut, inscription_id) VALUES
(3000.00, '2024-10-01', 'Non payé', 1),
(3000.00, '2024-11-01', 'Non payé', 1),
(3000.00, '2024-12-01', 'Non payé', 1),
(3000.00, '2024-10-01', 'Non payé', 2),
(3000.00, '2024-11-01', 'Non payé', 2),
(3000.00, '2024-12-01', 'Non payé', 2),
(3000.00, '2025-01-01', 'Non payé', 2),
(4000.00, '2024-10-15', 'Non payé', 3),
(4000.00, '2024-11-15', 'Non payé', 3);

-- Insertion des Paiements
INSERT INTO paiement_institus.paiements (montant, date_paiement, mode_paiement, echeance_id) VALUES
(3000.00, '2024-10-01', 'ESPECE', 1),
(3000.00, '2024-11-01', 'VIREMENT', 2),
(3000.00, '2024-12-01', 'CARTE', 3),
(3000.00, '2024-10-01', 'ESPECE', 4),
(3000.00, '2024-11-01', 'VIREMENT', 5),
(3000.00, '2024-12-01', 'CARTE', 6),
(3000.00, '2025-01-01', 'ESPECE', 7);

-- Insertion des Rôles
INSERT INTO paiement_institus.roles (nom, description) VALUES
('Administrateur', 'Gère le système et les utilisateurs.'),
('Secrétaire', 'Gère les inscriptions et les paiements.'),
('Parent', 'Consulte les paiements et échéances.');

-- Insertion des Utilisateurs
INSERT INTO paiement_institus.utilisateurs (nom, prenom, email, mot_de_passe, role_id) VALUES
('Admin', 'Principal', 'admin@email.com', 'admin123', 1),
('Sophie', 'Durand', 'sophie@email.com', 'secretaire123', 2),
('Ali', 'Mouhssine', 'ali@email.com', 'parent123', 3);

-- Insertion des Sessions
INSERT INTO paiement_institus.sessions (utilisateur_id, token, date_expiration) VALUES
(1, 'token_admin_001', '2025-01-01 12:00:00'),
(2, 'token_secretaire_001', '2025-01-01 12:00:00'),
(3, 'token_parent_001', '2025-01-01 12:00:00');




-- Tester Procedure AjouterAnneeScolaire
-- Explication des tests :
-- Ajout d'une année valide → Devrait réussir.
-- Ajout d'une année existante → Devrait afficher un message --indiquant qu'elle existe déjà.
--Format invalide → Teste plusieurs erreurs de format.
--Année incorrecte (écart de plus de 1 an) → Doit être rejetée.

-- Activer l'affichage des messages d'erreur
SET @p_status = NULL;
SET @p_message = NULL;

-- Test 1 : Ajout d'une année valide
CALL AjouterAnneeScolaire('2024-2025', @p_status, @p_message);
SELECT @p_status AS statut, @p_message AS message;

-- Test 2 : Ajout d'une année existante
CALL AjouterAnneeScolaire('2024-2025', @p_status, @p_message);
SELECT @p_status AS statut, @p_message AS message;

-- Test 3 : Année avec format incorrect
CALL AjouterAnneeScolaire('20242025', @p_status, @p_message);
SELECT @p_status AS statut, @p_message AS message;

CALL AjouterAnneeScolaire('24-25', @p_status, @p_message);
SELECT @p_status AS statut, @p_message AS message;

CALL AjouterAnneeScolaire('abcd-efgh', @p_status, @p_message);
SELECT @p_status AS statut, @p_message AS message;

-- Test 4 : Année avec un décalage incorrect
CALL AjouterAnneeScolaire('2024-2026', @p_status, @p_message);
SELECT @p_status AS statut, @p_message AS message;

CALL AjouterAnneeScolaire('2024-2023', @p_status, @p_message);
SELECT @p_status AS statut, @p_message AS message;

-- Vérifier les données après tests
SELECT * FROM anneescolaires;

-- Tester Procedure stockée  AjouterFiliere
-- Explication des tests :
-- Ajout d'une filière valide → Devrait réussir.
-- Ajout d'une filière existante → Devrait échouer avec un message d'erreur.
-- Ajout d'une filière avec un nom en majuscule → Vérifie si la comparaison est insensible à la casse.
-- Ajout avec un nom vide → Devrait être refusé.
-- Ajout avec un nom NULL → Devrait être refusé.
-- Ajout avec une date de fin d'inscription NULL → Devrait être accepté.

-- Activer l'affichage des messages d'erreur
SET @p_success = NULL;
SET @p_message = NULL;

-- Test 1 : Ajout d'une filière valide
CALL AjouterFiliere('Informatique', '2025-09-15', @p_success, @p_message);
SELECT @p_success AS success, @p_message AS message;

-- Test 2 : Ajout de la même filière (devrait échouer)
CALL AjouterFiliere('Informatique', '2025-09-20', @p_success, @p_message);
SELECT @p_success AS success, @p_message AS message;

-- Test 3 : Ajout d'une filière avec un nom en majuscule (devrait échouer si insensible à la casse)
CALL AjouterFiliere('INFORMATIQUE', '2025-09-25', @p_success, @p_message);
SELECT @p_success AS success, @p_message AS message;

-- Test 4 : Ajout d'une filière avec un nom vide (devrait échouer)
CALL AjouterFiliere('', '2025-09-30', @p_success, @p_message);
SELECT @p_success AS success, @p_message AS message;

-- Test 5 : Ajout d'une filière avec un nom NULL (devrait échouer)
CALL AjouterFiliere(NULL, '2025-10-01', @p_success, @p_message);
SELECT @p_success AS success, @p_message AS message;

-- Test 6 : Ajout d'une filière avec une date de fin d'inscription nulle (devrait réussir)
CALL AjouterFiliere('Gestion', NULL, @p_success, @p_message);
SELECT @p_success AS success, @p_message AS message;

-- Vérification des résultats après les tests
SELECT * FROM filieres;

-- Tester procedure AjouterInscription
 

-- Nettoyage et préparation des données de test
DELETE FROM inscriptions;
DELETE FROM stagiaires;
DELETE FROM anneescolaires;
DELETE FROM filieres;

-- Insertion de données de base pour les tests
INSERT INTO anneescolaires (id, annee) VALUES (1, '2024-2025');
INSERT INTO filieres (id, nom, fin_incription) VALUES (1, 'Informatique', '2024-09-30');
INSERT INTO stagiaires (id, nom, prenom) VALUES (1, 'Ali', 'Ahmed');

-- Déclaration des variables de sortie
SET @message = '';
SET @success = '';

-- Cas 1 : Inscription réussie
CALL AjouterInscription('2024-02-27', 3, 1, 1, 1, @message, @success);
SELECT @message, @success;  -- Doit afficher "Inscription ajoutée avec succès", "TRUE"

-- Cas 2 : Tentative de réinscription du même stagiaire pour la même année (devrait échouer)
CALL AjouterInscription('2024-03-01', 2, 1, 1, 1, @message, @success);
SELECT @message, @success;  -- Doit afficher "Le stagiaire est déjà inscrit pour cette année scolaire", "FALSE"

-- Cas 3 : Inscription avec une date NULL (devrait prendre la date du jour)
CALL AjouterInscription(NULL, 4, 1, 1, 1, @message, @success);
SELECT @message, @success;  -- Doit échouer car stagiaire déjà inscrit

-- Cas 4 : Inscription avec un filière_id invalide (devrait échouer)
CALL AjouterInscription('2024-02-27', 3, 99, 1, 1, @message, @success);
SELECT @message, @success;  -- Doit afficher une erreur d'intégrité

-- Cas 5 : Inscription avec un annee_id invalide (devrait échouer)
CALL AjouterInscription('2024-02-27', 3, 1, 99, 1, @message, @success);
SELECT @message, @success;  -- Doit afficher une erreur d'intégrité

-- Cas 6 : Inscription avec un stagiaire_id invalide (devrait échouer)
CALL AjouterInscription('2024-02-27', 3, 1, 1, 99, @message, @success);
SELECT @message, @success;  -- Doit afficher une erreur d'intégrité


