-- =========================================================
-- Script de création de la base de données — Projet GDH
-- Généré à partir du MCD/MLD validés en groupe
-- =========================================================

CREATE DATABASE IF NOT EXISTS gdh_hsp
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE gdh_hsp;

-- =========================================================
-- TABLES INDÉPENDANTES
-- =========================================================

CREATE TABLE Utilisateur (
    id_utilisateur   INT AUTO_INCREMENT PRIMARY KEY,
    nom              VARCHAR(100) NOT NULL,
    prenom           VARCHAR(100) NOT NULL,
    email            VARCHAR(150) NOT NULL,
    mot_de_passe     VARCHAR(255) NOT NULL,
    date_creation    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    role             ENUM('etudiant', 'medecin', 'partenaire', 'gestionnaire') NOT NULL,
    est_valide       TINYINT(1) NOT NULL DEFAULT 0,
    UNIQUE KEY uq_utilisateur_email (email)
) ENGINE=InnoDB;

CREATE TABLE Etablissement (
    id_etablissement   INT AUTO_INCREMENT PRIMARY KEY,
    nom_etablissement  VARCHAR(150) NOT NULL,
    adresse            VARCHAR(255) NOT NULL,
    site_web           VARCHAR(255) NOT NULL,
    UNIQUE KEY uq_etablissement_site (site_web)
) ENGINE=InnoDB;

CREATE TABLE Entreprise (
    id_entreprise    INT AUTO_INCREMENT PRIMARY KEY,
    nom_entreprise   VARCHAR(150) NOT NULL,
    adresse          VARCHAR(255) NOT NULL,
    site_web         VARCHAR(255) NOT NULL,
    UNIQUE KEY uq_entreprise_site (site_web)
) ENGINE=InnoDB;

CREATE TABLE Hopital (
    id_hopital   INT AUTO_INCREMENT PRIMARY KEY,
    nom_hopital  VARCHAR(150) NOT NULL,
    commune      VARCHAR(150) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Specialite (
    id_specialite       INT AUTO_INCREMENT PRIMARY KEY,
    libelle_specialite  VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_specialite_libelle (libelle_specialite)
) ENGINE=InnoDB;

CREATE TABLE Canal_forum (
    id_canal    INT AUTO_INCREMENT PRIMARY KEY,
    nom_canal   VARCHAR(100) NOT NULL,
    acces       ENUM('generale', 'medecins', 'etudiants') NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Evenement (
    id_evenement           INT AUTO_INCREMENT PRIMARY KEY,
    titre                  VARCHAR(150) NOT NULL,
    description            TEXT NOT NULL,
    type_evenement         VARCHAR(100) NOT NULL,
    adresse_lieu           VARCHAR(255) NOT NULL,
    element_requis         VARCHAR(255) NULL,
    nombre_place           INT NOT NULL,
    date_heure_evenement   DATETIME NOT NULL
) ENGINE=InnoDB;

-- =========================================================
-- TABLES DE SPÉCIALISATION (rôle Utilisateur)
-- =========================================================

CREATE TABLE Etudiant (
    id_etudiant        INT AUTO_INCREMENT PRIMARY KEY,
    cv_etudiant        VARCHAR(255) NULL,
    formation          VARCHAR(150) NOT NULL,
    ref_utilisateur    INT NOT NULL,
    ref_etablissement  INT NOT NULL,
    UNIQUE KEY uq_etudiant_utilisateur (ref_utilisateur),
    CONSTRAINT fk_etudiant_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE,
    CONSTRAINT fk_etudiant_etablissement
        FOREIGN KEY (ref_etablissement) REFERENCES Etablissement(id_etablissement)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Medecin (
    id_medecin       INT AUTO_INCREMENT PRIMARY KEY,
    numero_rpps      VARCHAR(20) NOT NULL,
    ref_utilisateur  INT NOT NULL,
    UNIQUE KEY uq_medecin_rpps (numero_rpps),
    UNIQUE KEY uq_medecin_utilisateur (ref_utilisateur),
    CONSTRAINT fk_medecin_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Partenaire (
    id_partenaire    INT AUTO_INCREMENT PRIMARY KEY,
    poste            VARCHAR(100) NOT NULL,
    ref_utilisateur  INT NOT NULL,
    ref_entreprise   INT NOT NULL,
    UNIQUE KEY uq_partenaire_utilisateur (ref_utilisateur),
    CONSTRAINT fk_partenaire_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE,
    CONSTRAINT fk_partenaire_entreprise
        FOREIGN KEY (ref_entreprise) REFERENCES Entreprise(id_entreprise)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- TABLES DE JONCTION (relations N:N)
-- =========================================================

-- Un médecin peut enseigner dans plusieurs établissements
CREATE TABLE Enseigner (
    ref_etablissement  INT NOT NULL,
    ref_medecin        INT NOT NULL,
    PRIMARY KEY (ref_etablissement, ref_medecin),
    CONSTRAINT fk_enseigner_etablissement
        FOREIGN KEY (ref_etablissement) REFERENCES Etablissement(id_etablissement)
        ON DELETE CASCADE,
    CONSTRAINT fk_enseigner_medecin
        FOREIGN KEY (ref_medecin) REFERENCES Medecin(id_medecin)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Un médecin peut exercer dans plusieurs hôpitaux du groupe
CREATE TABLE Exercer (
    ref_medecin  INT NOT NULL,
    ref_hopital  INT NOT NULL,
    PRIMARY KEY (ref_medecin, ref_hopital),
    CONSTRAINT fk_exercer_medecin
        FOREIGN KEY (ref_medecin) REFERENCES Medecin(id_medecin)
        ON DELETE CASCADE,
    CONSTRAINT fk_exercer_hopital
        FOREIGN KEY (ref_hopital) REFERENCES Hopital(id_hopital)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Un médecin peut avoir plusieurs spécialités
CREATE TABLE Posseder (
    ref_medecin     INT NOT NULL,
    ref_specialite  INT NOT NULL,
    PRIMARY KEY (ref_medecin, ref_specialite),
    CONSTRAINT fk_posseder_medecin
        FOREIGN KEY (ref_medecin) REFERENCES Medecin(id_medecin)
        ON DELETE CASCADE,
    CONSTRAINT fk_posseder_specialite
        FOREIGN KEY (ref_specialite) REFERENCES Specialite(id_specialite)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Un événement peut avoir plusieurs organisateurs
CREATE TABLE Organiser (
    ref_evenement    INT NOT NULL,
    ref_utilisateur  INT NOT NULL,
    PRIMARY KEY (ref_evenement, ref_utilisateur),
    CONSTRAINT fk_organiser_evenement
        FOREIGN KEY (ref_evenement) REFERENCES Evenement(id_evenement)
        ON DELETE CASCADE,
    CONSTRAINT fk_organiser_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Inscriptions des participants à un événement
CREATE TABLE S_inscrire (
    ref_evenement    INT NOT NULL,
    ref_utilisateur  INT NOT NULL,
    PRIMARY KEY (ref_evenement, ref_utilisateur),
    CONSTRAINT fk_sinscrire_evenement
        FOREIGN KEY (ref_evenement) REFERENCES Evenement(id_evenement)
        ON DELETE CASCADE,
    CONSTRAINT fk_sinscrire_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- OFFRES ET CANDIDATURES
-- =========================================================

CREATE TABLE Offre (
    id_offre           INT AUTO_INCREMENT PRIMARY KEY,
    titre              VARCHAR(150) NOT NULL,
    description        TEXT NOT NULL,
    missions           TEXT NOT NULL,
    salaire            DECIMAL(10,2) NULL,
    type_d_offre       ENUM('stage', 'alternance', 'cdd', 'cdi') NOT NULL,
    etat               ENUM('ouverte', 'fermee') NOT NULL DEFAULT 'ouverte',
    date_publication   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ref_utilisateur    INT NOT NULL,
    CONSTRAINT fk_offre_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Candidature (
    id_candidature     INT AUTO_INCREMENT PRIMARY KEY,
    motivation         TEXT NOT NULL,
    date_candidature   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    statut             ENUM('en_attente', 'accepte', 'bloque') NOT NULL DEFAULT 'en_attente',
    ref_utilisateur    INT NOT NULL,
    ref_offre          INT NOT NULL,
    UNIQUE KEY uq_candidature_utilisateur_offre (ref_utilisateur, ref_offre),
    CONSTRAINT fk_candidature_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE,
    CONSTRAINT fk_candidature_offre
        FOREIGN KEY (ref_offre) REFERENCES Offre(id_offre)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- CONTACT
-- =========================================================

CREATE TABLE Demande_contact (
    id_demande         INT AUTO_INCREMENT PRIMARY KEY,
    nom_expediteur     VARCHAR(150) NOT NULL,
    email_expediteur   VARCHAR(150) NOT NULL,
    sujet              VARCHAR(150) NOT NULL,
    message            TEXT NOT NULL,
    date_d_envoi       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ref_utilisateur    INT NOT NULL,
    CONSTRAINT fk_demande_contact_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- FORUM
-- =========================================================

CREATE TABLE Post_forum (
    id_post                INT AUTO_INCREMENT PRIMARY KEY,
    titre                  VARCHAR(150) NOT NULL,
    contenu                TEXT NOT NULL,
    date_heure_creation    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ref_canal              INT NOT NULL,
    ref_utilisateur        INT NOT NULL,
    CONSTRAINT fk_post_canal
        FOREIGN KEY (ref_canal) REFERENCES Canal_forum(id_canal)
        ON DELETE CASCADE,
    CONSTRAINT fk_post_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Reponse_forum (
    id_reponse             INT AUTO_INCREMENT PRIMARY KEY,
    contenu                TEXT NOT NULL,
    date_heure_reponse     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ref_post               INT NOT NULL,
    ref_utilisateur        INT NOT NULL,
    CONSTRAINT fk_reponse_post
        FOREIGN KEY (ref_post) REFERENCES Post_forum(id_post)
        ON DELETE CASCADE,
    CONSTRAINT fk_reponse_utilisateur
        FOREIGN KEY (ref_utilisateur) REFERENCES Utilisateur(id_utilisateur)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================================
-- DONNÉES DE RÉFÉRENCE (les 9 hôpitaux + spécialités du cahier des charges)
-- =========================================================

INSERT INTO Hopital (nom_hopital, commune) VALUES
    ('Hôpital Sud Paris', 'Marreuil-sur-Seine'),
    ('Hôpital Nord Paris', 'Saint-Maximin'),
    ('Hôpital Général de Lyon', 'Limonest'),
    ('Hôpital Général de Marseille', 'Peypin'),
    ('Hôpital Général de Bordeaux', 'Beychac-et-Caillau'),
    ('Hôpital Général de Nantes', 'Mauves-sur-Loire'),
    ('Hôpital Général de Toulouse', 'Muret'),
    ('Hôpital Général de Strasbourg', 'Vendenheim'),
    ('Hôpital Général de Rennes', 'Pont-Péan');

INSERT INTO Specialite (libelle_specialite) VALUES
    ('Cardiologue'), ('Neurologue'), ('Gastroentérologue'), ('Dermatologue'),
    ('Pédiatrie'), ('Oncologue'), ('Pneumologue'), ('Rhumatologue'),
    ('Endocrinologue'), ('Ophtalmologue'), ('Gynécologue'), ('Psychiatre'),
    ('Urologue'), ('Néphrologue'), ('Hématologue'), ('Oto-rhino-laryngologue'),
    ('Chirurgien orthopédique'), ('Anesthésiologue'), ('Médecin interne'),
    ('Médecin généraliste');

INSERT INTO Canal_forum (nom_canal, acces) VALUES
    ('Général', 'generale'),
    ('Médecins', 'medecins'),
    ('Étudiants', 'etudiants');
