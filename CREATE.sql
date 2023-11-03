CREATE TABLE pays (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom_pays VARCHAR(255) NOT NULL,
    continent VARCHAR(255) NOT NULL
);

CREATE TABLE entrepots (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom_entrepot VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    id_pays INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_pays) REFERENCES pays(id)
);

CREATE TABLE expeditions (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date_expedition DATE NOT NULL,
    date_livraison DATE NOT NULL,
    date_livraison_estimee DATE NULL,
    id_entrepot_source INT UNSIGNED NOT NULL,
    id_entrepot_destination INT UNSIGNED NOT NULL,
    poids DECIMAL(10,2) NOT NULL,
    statut VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_entrepot_source) REFERENCES entrepots(id),
    FOREIGN KEY (id_entrepot_destination) REFERENCES entrepots(id)
);


--Ajoutez une table "clients" 
CREATE TABLE clients (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    ville VARCHAR(255) NOT NULL,
    id_pays INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_pays) REFERENCES pays(id)
);

--	Ajoutez une table de jointure "expeditions_clients" 
CREATE TABLE expeditions_clients (
    id_expedition INT UNSIGNED NOT NULL,
    id_client INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_expedition) REFERENCES expeditions(id),
    FOREIGN KEY (id_client) REFERENCES clients(id)
);

--Modifiez la table "expeditions" pour y ajouter une colonne "id_client" (entier, clé étrangère faisant référence à la table "clients").
ALTER TABLE expeditions ADD COLUMN id_client INT UNSIGNED NOT NULL;