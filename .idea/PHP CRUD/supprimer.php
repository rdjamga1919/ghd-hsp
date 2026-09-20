```php
<?php

session_start();

// Vérifie que l'id existe et n'est pas vide dans l'URL
if (isset($_GET['id']) && !empty($_GET['id'])) {

    // Connexion à la base de données
    require_once('connection.php');

    // On nettoie l'id envoyé
    $id = strip_tags($_GET['id']);


    $sql = 'SELECT * FROM `Utilisateur`
            WHERE `id_utilisateur` = :id';

    // Préparation de la requête
    $query = $db->prepare($sql);

    // On associe l'id au paramètre
    $query->bindValue(':id', $id, PDO::PARAM_INT);

    // Exécution de la requête
    $query->execute();

    // Récupération de l'utilisateur
    $utilisateur = $query->fetch(PDO::FETCH_ASSOC);


    if (!$utilisateur) {

        $_SESSION['erreur'] = "Cet utilisateur n'existe pas";

        header('Location: index.php');
        exit();

    }

    $sql = 'DELETE FROM `Utilisateur`
            WHERE `id_utilisateur` = :id';

    // Préparation de la requête
    $query = $db->prepare($sql);

    // On associe l'id au paramètre
    $query->bindValue(':id', $id, PDO::PARAM_INT);

    // Exécution de la requête
    $query->execute();

    // Message de confirmation
    $_SESSION['message'] = "Utilisateur supprimé avec succès";

    // Retour à la page principale
    header('Location: index.php');
    exit();

} else {

    // L'URL ne contient pas d'id valide
    $_SESSION['erreur'] = "URL invalide";

    header('Location: index.php');
    exit();
}

