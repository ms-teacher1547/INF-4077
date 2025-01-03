
# INF 4077: Mobile Application Development

## Description
Ce projet est une application mobile destinée à aider les utilisateurs à organiser leurs repas, suivre leur apport nutritionnel, calculer des indicateurs de santé comme l'IMC et recevoir des recommandations de repas personnalisées.

## Informations sur le projet
- **Département**: UYI - Dep info
- **Session**: 2024-2025
- **Cours**: INF 4077 - Développement d'applications mobiles
- **Professeur**: Dr. Azanzi Jiomekong
- **Date limite**: 03/01/2025

## Fonctionnalités
1. **Authentification**
   - Inscription avec les champs: nom, email, mot de passe.
   - Connexion avec email et mot de passe.
2. **Gestion du profil utilisateur et calcul de l'IMC**
   - Saisie de la taille (en cm) et du poids (en kg).
   - Calcul de l'IMC avec interprétation du résultat (ex: sous-poids, poids normal, surpoids, obésité).
3. **Enregistrement et historique des repas**
   - Enregistrement des repas avec nom, nombre de calories, date et heure de consommation.
   - Affichage de l'historique des repas enregistrés.
4. **Calculs statistiques**
   - Calcul des calories totales consommées par jour, semaine, mois, année.
   - Moyenne des calories consommées par semaine.
   - Alerte si l'utilisateur dépasse un objectif calorique quotidien défini dans son profil.
5. **Recommandation de repas**
   - Recommandation de repas basée sur l'IMC de l'utilisateur.
6. **Modification et suppression de repas**
   - Options pour éditer et supprimer des repas de l'historique.
7. **Réservation au restaurant le plus proche**
   - Option pour réserver une table au restaurant le plus proche.
8. **Réservation avec un diététicien le plus proche**
   - Option pour réserver un rendez-vous avec un diététicien le plus proche.
9. **Chat-bot**
   - Option pour envoyer et recevoir des messages, et télécharger des fichiers.

## Instructions d'installation

### Prérequis
Assurez-vous d'avoir les outils suivants installés sur votre machine :
- [Git](https://git-scm.com/)
- [Flutter](https://flutter.dev/docs/get-started/install)

### Installation de Flutter
1. Téléchargez le SDK Flutter depuis le [site officiel](https://flutter.dev/docs/get-started/install).
2. Extrayez l'archive téléchargée dans le répertoire désiré.
3. Ajoutez Flutter à votre PATH :
   - Sur macOS/Linux, ajoutez la ligne suivante à votre fichier `.bashrc` ou `.zshrc` :
     ```sh
     export PATH="$PATH:`pwd`/flutter/bin"
     ```
   - Sur Windows, ajoutez le chemin `C:\path\to\flutter\bin` à la variable d'environnement PATH.

### Cloner le dépôt et installer les dépendances
1. Clonez le dépôt : `git clone https://github.com/ms-teacher1547/INF-4077.git`
2. Accédez au répertoire du projet : `cd INF-4077`
3. Installez les dépendances : `flutter pub get`
4. Lancez l'application sur un émulateur ou un appareil physique : `flutter run`

## Utilisation
1. Enregistrez-vous ou connectez-vous à l'application.
2. Gérez votre profil et saisissez vos informations de santé pour calculer votre IMC.
3. Enregistrez les repas que vous consommez et consultez votre historique.
4. Utilisez les fonctionnalités de calcul statistique pour suivre votre apport calorique.
5. Recevez des recommandations de repas personnalisées.
6. Modifiez ou supprimez des repas de votre historique si nécessaire.
7. Réservez une table au restaurant ou un rendez-vous avec un diététicien via l'application.
8. Utilisez le chat-bot pour communiquer et partager des fichiers.

## Contributeur
- [ms-teacher1547](https://github.com/ms-teacher1547)

## Licence
Ce projet est privé et ne dispose pas de licence ouverte.

