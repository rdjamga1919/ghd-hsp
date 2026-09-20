<?php
try{
    //Connexion à la base
    $db = new PDO('mysql:host=localhost;dbname=test', 'root', '');
    $db->exec("SET CHARACTER SET utf8");
} catch(PDOException $e){
    echo "Erreur : " . $e->getMessage();
    die();
}
