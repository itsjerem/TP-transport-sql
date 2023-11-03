-- REQUETES DE BASE
--Affichez tous les entrepôts
SELECT * FROM entrepots;

--Affichez toutes les expéditions
SELECT * FROM expeditions;


--Affichez toutes les expéditions en transit
SELECT * FROM expeditions WHERE statut = 'En transit';

--Affichez toutes les expéditions livrées
SELECT * FROM expeditions WHERE statut = 'Livré';

-- REQUETES AVANCES

--Affichez les entrepôts qui ont envoyé au moins une expédition en transit
SELECT * FROM entrepots WHERE id IN (SELECT id_entrepot_source FROM expeditions WHERE statut = 'En transit');

--Affichez les entrepôts qui ont reçu au moins une expédition en transit
SELECT * FROM entrepots WHERE id IN (SELECT id_entrepot_destination FROM expeditions WHERE statut = 'En transit');

--Affichez les expéditions qui ont un poids supérieur à 100 kg et qui sont en transit
SELECT * FROM expeditions WHERE poids > 100 AND statut = 'En transit';

--Affichez le nombre d'expéditions envoyées par chaque entrepôt en affichant le nom de l'entrepot
SELECT nom_entrepot, COUNT(*) FROM expeditions INNER JOIN entrepots ON expeditions.id_entrepot_source = entrepots.id GROUP BY id_entrepot_source;

--Affichez le nombre total d'expéditions en transit avec
SELECT COUNT(*) FROM expeditions WHERE statut = 'En transit';

--Affichez le nombre total d'expéditions livrées
SELECT COUNT(*) FROM expeditions WHERE statut = 'Livré';

--Affichez le nombre total d'expéditions pour chaque mois de l'année en cours
SELECT MONTH(date_expedition), COUNT(*) FROM expeditions WHERE YEAR(date_expedition) = YEAR(CURDATE()) GROUP BY MONTH(date_expedition);

--Affichez les entrepôts qui ont envoyé des expéditions au cours des 30 derniers jours
SELECT * FROM entrepots WHERE id IN (SELECT id_entrepot_source FROM expeditions WHERE date_expedition > DATE_SUB(CURDATE(), INTERVAL 30 DAY));

--Affichez les entrepôts qui ont reçu des expéditions au cours des 30 derniers jours
SELECT * FROM entrepots WHERE id IN (SELECT id_entrepot_destination FROM expeditions WHERE date_expedition > DATE_SUB(CURDATE(), INTERVAL 30 DAY));

--Affichez les expéditions qui ont été livrées dans un délai de moins de 5 jours ouvrables
UPDATE expeditions SET date_livraison = DATE_ADD(date_expedition, INTERVAL FLOOR(RAND() * 10) DAY); 
SELECT * FROM expeditions WHERE statut = 'Livré' AND DATEDIFF(date_expedition, date_livraison) < 5;


--Affichez les expéditions en transit qui ont été initiées par un entrepôt situé en Europe et à destination d'un entrepôt situé en Asie sachant qu'il n'y a pas de chanps pays dans la table entrpots mais que celle ci contient une cles etrangere id_pays de la table pays avec dedans les nom de pays ainsi que le continent
SELECT * 
FROM expeditions 
WHERE id_entrepot_source IN (SELECT id FROM entrepots WHERE id_pays IN (SELECT id FROM pays WHERE continent = 'Europe'))
AND id_entrepot_destination IN (SELECT id FROM entrepots WHERE id_pays IN (SELECT id FROM pays WHERE continent = 'Asie'))
AND statut = 'En transit';


--Affichez les entrepôts qui ont envoyé des expéditions à destination d'un entrepôt situé dans le même pays
SELECT id_entrepot_source, id_entrepot_destination
FROM expeditions
INNER JOIN entrepots source ON id_entrepot_source = source.id
INNER JOIN entrepots destination ON id_entrepot_destination = destination.id
WHERE source.id_pays = destination.id_pays;

--Affichez les entrepôts qui ont envoyé des expéditions à destination d'un entrepôt situé dans un pays différent
SELECT id_entrepot_source, id_entrepot_destination
FROM expeditions
INNER JOIN entrepots source ON id_entrepot_source = source.id
INNER JOIN entrepots destination ON id_entrepot_destination = destination.id
WHERE source.id_pays != destination.id_pays;

--Affichez les expéditions en transit qui ont été initiées par un entrepôt situé dans un pays dont le nom commence par la lettre "F" et qui pèsent plus de 500 kg.
SELECT date_expedition, date_livraison, poids, statut, id_entrepot_source, nom_pays
FROM expeditions
INNER JOIN entrepots ON id_entrepot_source = entrepots.id
INNER JOIN pays ON entrepots.id_pays = pays.id
WHERE pays.nom_pays LIKE 'F%' AND poids > 500 AND statut = 'En transit';

--Affichez le nombre total d'expéditions pour chaque combinaison de pays d'origine et de destination.
SELECT 
    source_pays.nom_pays AS pays_origine, 
    destination_pays.nom_pays AS pays_destination, 
    COUNT(*) AS nombre_expéditions
FROM expeditions e
JOIN entrepots source ON e.id_entrepot_source = source.id
JOIN entrepots destination ON e.id_entrepot_destination = destination.id
JOIN pays source_pays ON source.id_pays = source_pays.id
JOIN pays destination_pays ON destination.id_pays = destination_pays.id
GROUP BY source_pays.nom_pays, destination_pays.nom_pays;

--Affichez les expéditions qui ont été livrées avec un retard de plus de 2 jours ouvrables
SELECT * 
FROM expeditions
WHERE statut = 'Livré' 
AND DATEDIFF(date_livraison, date_livraison_estimee) > 2;

--	Affichez le nombre total d'expéditions pour chaque jour du mois en cours, trié par ordre décroissant.
SELECT DATE(date_expedition) AS jour, COUNT(*) AS nombre_expeditions
FROM expeditions
WHERE MONTH(date_expedition) = MONTH(CURRENT_DATE()) AND YEAR(date_expedition) = YEAR(CURRENT_DATE())
GROUP BY jour
ORDER BY nombre_expeditions DESC;


--Écrivez des requêtes pour extraire les informations suivantes : 
--Pour chaque client, affichez son nom, son adresse complète, le nombre total d'expéditions qu'il a envoyées et le nombre total d'expéditions qu'il a reçues. 
SELECT clients.nom, clients.adresse, clients.ville, COUNT(expeditions_clients.id_expedition) AS nb_expeditions_envoyees, COUNT(expeditions_clients.id_client) AS nb_expeditions_recues
FROM clients
INNER JOIN expeditions_clients ON clients.id = expeditions_clients.id_client
GROUP BY clients.id;

--Pour chaque expédition, affichez son ID, son poids, le nom du client qui l'a envoyée, le nom du client qui l'a reçue et le statut
SELECT expeditions.id, expeditions.poids, clients_source.nom AS nom_client_source, clients_destination.nom AS nom_client_destination, expeditions.statut
FROM expeditions
INNER JOIN expeditions_clients ON expeditions.id = expeditions_clients.id_expedition
INNER JOIN clients clients_source ON expeditions_clients.id_client = clients_source.id
INNER JOIN clients clients_destination ON expeditions.id_client = clients_destination.id;







