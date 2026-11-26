# lydiapp

Application iOS UIKit qui affiche une liste de contacts issus de l'API [randomuser.me](https://randomuser.me), avec cache local Core Data.

Projet réalisé dans le cadre d'un test technique (description du dépôt : « Test from Lydia »). L'historique des commits suit les étapes de l'exercice.

## Fonctionnalités

- Liste « Contacts » avec photo, nom et prénom, chargée par pages de 10 et paginée automatiquement au défilement.
- Persistance Core Data : les contacts sont enregistrés (mis à jour s'ils existent déjà) et réaffichés au lancement suivant, même hors ligne.
- Tirer pour rafraîchir (rechargement de la première page).
- Recherche par prénom, nom, e-mail ou téléphone (`UISearchController`).
- Tri par prénom ou par nom depuis un menu.
- Fiche détail : civilité, prénom, nom, e-mail, téléphone, genre, âge, date de naissance.
- Gestion des erreurs réseau, de décodage et Core Data, présentées dans une alerte.

## Choix techniques

- UIKit entièrement en code (pas de storyboard hors écran de lancement), Auto Layout.
- `async/await` pour le réseau, `UserViewModel` annoté `@Observable`.
- Chargement asynchrone des miniatures avec annulation (`AsyncImageView`).
- Aperçus SwiftUI (`#Preview`) des contrôleurs via `UIViewControllerRepresentable`.

## Prérequis

- Xcode 26 ou plus récent
- iOS 26.0, iPhone

## Build

```bash
git clone https://github.com/guikbsx/lydiapp.git
cd lydiapp
git checkout develop
open lydiapp.xcodeproj
```

Lancer le schéma `lydiapp` sur un simulateur iPhone. Aucune clé d'API n'est nécessaire.

## Structure du projet

```
lydiapp/
├── Models/        User (réponse API), SortOption, erreurs
├── Service/       UserService (réseau), CoreDataManager, UserViewModel
├── Views/         liste, cellule, détail, AsyncImageView
├── Samples/       données d'exemple et playground
└── lydiapp.xcdatamodeld   modèle Core Data (UserEntity)
```

## Tests

Pas de cible de tests pour l'instant.

## Licence

Distribué sous licence Apache 2.0. Voir [LICENSE](LICENSE).
