-- =====================================================
-- CREATION DE LA BASE DE DONNEES
-- =====================================================

CREATE DATABASE IF NOT EXISTS gestion_commande_l2E221_25_26;
USE gestion_commande_l2E221_25_26;

-- =====================================================
-- SUPPRESSION DES TABLES SI ELLES EXISTENT
-- =====================================================

DROP TABLE IF EXISTS produit_commande;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS produit;
DROP TABLE IF EXISTS client;

-- =====================================================
-- TABLE CLIENT
-- =====================================================

CREATE TABLE client (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    telephone VARCHAR(20) UNIQUE,
    email VARCHAR(150) UNIQUE,
    adresse VARCHAR(255)
);

-- =====================================================
-- TABLE PRODUIT
-- =====================================================

CREATE TABLE produit (
    id_produit INT AUTO_INCREMENT PRIMARY KEY,
    reference VARCHAR(50) UNIQUE,
    libelle VARCHAR(150) NOT NULL,
    prix DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    description TEXT
);

-- =====================================================
-- TABLE COMMANDE
-- =====================================================

CREATE TABLE commande (
    id_commande INT AUTO_INCREMENT PRIMARY KEY,
    date_commande DATE NOT NULL,
    montant_total DECIMAL(10,2) DEFAULT 0,
    statut ENUM('SOLDEE', 'NON SOLDEE') DEFAULT 'NON SOLDEE',

    id_client INT NOT NULL,

    CONSTRAINT fk_commande_client
        FOREIGN KEY (id_client)
        REFERENCES client(id_client)
);

-- =====================================================
-- TABLE LIGNE_COMMANDE
-- =====================================================

CREATE TABLE produit_commande (
    id_commande INT,
    id_produit INT,
    quantite INT NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_commande, id_produit),
    CONSTRAINT fk_ligne_commande
        FOREIGN KEY (id_commande)
        REFERENCES commande(id_commande),
    CONSTRAINT fk_ligne_produit
        FOREIGN KEY (id_produit)
        REFERENCES produit(id_produit)
        
);

-- =====================================================
-- INSERTION DES CLIENTS
-- =====================================================

INSERT INTO client (nom, prenom, telephone, email, adresse)
VALUES
('Diop', 'Moussa', '771112233', 'moussa@gmail.com', 'Dakar'),
('Fall', 'Awa', '776665544', 'awa@gmail.com', 'Thiès'),
('Ndiaye', 'Omar', '778889900', 'omar@gmail.com', 'Saint-Louis'),
('Sarr', 'Fatou', '770000111', 'fatou@gmail.com', 'Kaolack');

-- =====================================================
-- INSERTION DES PRODUITS
-- =====================================================

INSERT INTO produit (libelle, reference, prix, stock, description)
VALUES
('Ordinateur Portable HP', "REF001",450000, 10, 'HP Core i5 16Go RAM SSD 512Go'),
('Souris Sans Fil', "REF002",15000, 50, 'Souris Bluetooth rechargeable'),
('Clavier Mecanique', "REF003",35000, 25, 'Clavier RGB Gamer'),
('Ecran 24 pouces', "REF004",120000, 15, 'Ecran Full HD'),
('Imprimante Canon', "REF005",95000, 8, 'Imprimante multifonction');

-- =====================================================
-- INSERTION DES COMMANDES
-- =====================================================

INSERT INTO commande (date_commande, montant_total, statut, id_client)
VALUES
('2026-05-10', 480000, 'SOLDEE', 1),
('2026-05-11', 15000, 'NON SOLDEE', 2),
('2026-05-12', 155000, 'SOLDEE', 3),
('2026-05-13', 545000, 'SOLDEE', 1);

-- =====================================================
-- INSERTION DES LIGNES DE COMMANDES
-- =====================================================

INSERT INTO produit_commande (
    id_commande,
    id_produit,
    quantite,
    prix_unitaire
)
VALUES
(1, 1, 1, 450000),
(1, 2, 2, 15000),

(2, 2, 1, 15000),

(3, 4, 1, 120000),
(3, 3, 1, 35000),

(4, 1, 1, 450000),
(4, 5, 1, 95000);

-- =====================================================
-- REQUETES DE VERIFICATION
-- =====================================================

-- Liste des clients
SELECT * FROM client;

-- Liste des produits
SELECT * FROM produit;

-- Liste des commandes
SELECT * FROM commande;

-- Liste des lignes de commande
SELECT * FROM produit_commande;

-- Afficher les commandes avec les clients
SELECT
    c.id_commande,
    c.date_commande,
    c.statut,
    cl.nom,
    cl.prenom,
    c.montant_total
FROM commande c
JOIN client cl
ON c.id_client = cl.id_client;

-- Afficher les produits contenus dans chaque commande
SELECT
    co.id_commande,
    p.libelle,
    lc.quantite,
    lc.prix_unitaire,
    (lc.quantite * lc.prix_unitaire) AS total_ligne
FROM produit_commande lc
JOIN produit p
ON lc.id_produit = p.id_produit
JOIN commande co
ON lc.id_commande = co.id_commande
ORDER BY co.id_commande;