<?php

session_start();

if ($_POST) {
    if (
        isset($_POST['nom']) && !empty($_POST['nom']) &&
        isset($_POST['prenom']) && !empty($_POST['prenom']) &&
        isset($_POST['email']) && !empty($_POST['email']) &&
        isset($_POST['mot_de_passe']) && !empty($_POST['mot_de_passe']) &&
        isset($_POST['role']) && !empty($_POST['role'])
    ) {
        require_once('connect.php');

        $nom = strip_tags($_POST['nom']);
        $prenom = strip_tags($_POST['prenom']);
        $email = strip_tags($_POST['email']);
        $mot_de_passe = password_hash($_POST['mot_de_passe'], PASSWORD_DEFAULT);
        $role = strip_tags($_POST['role']);

        $sql = 'INSERT INTO Utilisateur (nom, prenom, email, mot_de_passe, role)
                VALUES (:nom, :prenom, :email, :mot_de_passe, :role);';

        $query = $db->prepare($sql);
        $query->bindValue(':nom', $nom);
        $query->bindValue(':prenom', $prenom);
        $query->bindValue(':email', $email);
        $query->bindValue(':mot_de_passe', $mot_de_passe);
        $query->bindValue(':role', $role);

        $query->execute();

        $_SESSION['message'] = "Utilisateur ajouté";
        header('Location: index.php');
        exit;
    } else {
        $_SESSION['erreur'] = "Le formulaire est incomplet";
    }
}

