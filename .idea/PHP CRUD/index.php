```php
<?php

// Connexion à la base de données
require_once('connection.php');

// Récupération des utilisateurs
$sql = 'SELECT 
            id_utilisateur,
            nom,
            prenom,
            email,
            date_creation,
            role,
            est_valide
        FROM Utilisateur
        ORDER BY id_utilisateur DESC';

// Préparation de la requête
$query = $db->prepare($sql);

// Exécution de la requête
$query->execute();

// Récupération des résultats
$result = $query->fetchAll(PDO::FETCH_ASSOC);

// Fermeture de la connexion
require_once('close.php');

?>

<!DOCTYPE html>
<html lang="fr">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Liste des utilisateurs - GDH</title>

    <!-- Bootstrap -->
    <link
        rel="stylesheet"
        href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
        integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
        crossorigin="anonymous"
    >

</head>

<body>

<main class="container">

    <div class="row">

        <section class="col-12">

            <h1 class="mt-4 mb-4">
                Liste des utilisateurs
            </h1>

            <?php if (empty($result)): ?>

                <div class="alert alert-info">
                    Aucun utilisateur enregistré dans la base de données.
                </div>

            <?php else: ?>

                <div class="table-responsive">

                    <table class="table table-striped table-bordered table-hover">

                        <thead class="thead-dark">

                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Email</th>
                            <th>Date de création</th>
                            <th>Rôle</th>
                            <th>Statut</th>
                        </tr>

                        </thead>

                        <tbody>

                        <?php foreach ($result as $user): ?>

                            <tr>

                                <td>
                                    <?= htmlspecialchars($user['id_utilisateur']) ?>
                                </td>

                                <td>
                                    <?= htmlspecialchars($user['nom']) ?>
                                </td>

                                <td>
                                    <?= htmlspecialchars($user['prenom']) ?>
                                </td>

                                <td>
                                    <?= htmlspecialchars($user['email']) ?>
                                </td>

                                <td>
                                    <?= htmlspecialchars($user['date_creation']) ?>
                                </td>

                                <td>

                                    <?php

                                    switch ($user['role']) {

                                        case 'etudiant':
                                            $role = 'Étudiant';
                                            break;

                                        case 'medecin':
                                            $role = 'Médecin';
                                            break;

                                        case 'partenaire':
                                            $role = 'Partenaire';
                                            break;

                                        case 'gestionnaire':
                                            $role = 'Gestionnaire';
                                            break;

                                        default:
                                            $role = $user['role'];
                                    }

                                    ?>

                                    <?= htmlspecialchars($role) ?>

                                </td>

                                <td>

                                    <?php if ($user['est_valide'] == 1): ?>

                                        <span class="badge badge-success">
                                                    Validé
                                                </span>

                                    <?php else: ?>

                                        <span class="badge badge-warning">
                                                    En attente
                                                </span>

                                    <?php endif; ?>

                                </td>

                            </tr>

                        <?php endforeach; ?>

                        </tbody>

                    </table>

                </div>

            <?php endif; ?>

        </section>

    </div>

</main>

</body>

</html>
```
