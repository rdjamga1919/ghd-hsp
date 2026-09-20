<?php

session_start();

if($_POST){
    if(
        isset($_POST['nom']) && !empty($_POST['nom']) &&
        isset($_POST['prenom']) && !empty($_POST['prenom']) &&
        isset($_POST['email']) && !empty($_POST['email']) &&
        isset($_POST['mot_de_passe']) && !empty($_POST['mot_de_passe']) &&
        isset($_POST['role']) && !empty($_POST['role'])
    ){
        require_once('connect.php');

        $nom = strip_tags($_POST['nom']);
        $prenom = strip_tags($_POST['prenom']);
        $email = strip_tags($_POST['email']);
        $mot_de_passe = password_hash($_POST['mot_de_passe'], PASSWORD_DEFAULT);
        $role = strip_tags($_POST['role']);

        $sql = "INSERT INTO Utilisateur (nom, prenom, email, mot_de_passe, role)
                VALUES (:nom, :prenom, :email, :mot_de_passe, :role)";

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
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter un utilisateur</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
</head>
<body>
<main class="container">
    <div class="row">
        <section class="col-12">

            <?php if(!empty($_SESSION['erreur'])): ?>
                <div class="alert alert-danger"><?= $_SESSION['erreur']; ?></div>
                <?php $_SESSION['erreur'] = ""; ?>
            <?php endif; ?>

            <h1>Ajouter un utilisateur</h1>

            <form method="post">
                <div class="form-group">
                    <label>Nom</label>
                    <input type="text" name="nom" class="form-control">
                </div>

                <div class="form-group">
                    <label>Prénom</label>
                    <input type="text" name="prenom" class="form-control">
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control">
                </div>

                <div class="form-group">
                    <label>Mot de passe</label>
                    <input type="password" name="mot_de_passe" class="form-control">
                </div>

                <div class="form-group">
                    <label>Rôle</label>
                    <select name="role" class="form-control">
                        <option value="etudiant">Étudiant</option>
                        <option value="medecin">Médecin</option>
                        <option value="partenaire">Partenaire</option>
                        <option value="gestionnaire">Gestionnaire</option>
                    </select>
                </div>

                <button class="btn btn-success">Ajouter</button>
            </form>

        </section>
    </div>
</main>
</body>
</html>
