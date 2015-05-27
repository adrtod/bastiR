# bastiR
[![Travis-CI Build Status](https://img.shields.io/travis/adrtod/bastiR.svg)](https://travis-ci.org/adrtod/bastiR)
[![GPLv2 License](http://img.shields.io/badge/license-GPLv2-blue.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

Le package R **bastiR** a pour but d'être une collection d'outils pour faciliter le suivi de chantier.
Sa première fonctionnalité est la génération de compte-rendus de réunions de chantier.

# Logiciels requis
- [R](http://www.r-project.org/) version 3.2.0 (2015-04-16)
- [RStudio](http://www.rstudio.com/) version 0.98.1103
- [MikTex](http://www.miktek.org/) version 2.9

# Installation
Pour installer la dernière version en développement sur [GitHub](https://github.com/adrtod/rchallenge), taper la commande suivante sous R :
```r
# install.packages("devtools")
devtools::install_github("adrtod/bastiR")
```

# Spécification des tableaux d'entrée
- Tableur Excel .xls version 2007
- Feuilles de calcul (onglets) :
    - Légende : classe (acteur orga, acteur exe, chapitre, état), clé (insensible à la casse), désignation, ...
    - Tâches : chapitre (clé), date de réunion, date d'échéance, acteur (clé), description, état (clé : a=A faire, f=Fait, i=Info), priorité (autromatique, clé : rappel, urgent)
    - Tâches réunion en cours : cf. Tâches
    - Armoire à plans : TODO
    - Photos : nom du fichier, commentaire
- Ne pas fusionner les cellules
- 1 colonne = 1 variable, label en 1ère ligne
- 1 ligne = 1 individu
- cellules dates au format date dans Excel

# Ressources
### Programmation sous R

- [R Markdown](http://rmarkdown.rstudio.com/)

# Contribuer au projet
- Créer un compte github

- Signaler un bug : https://github.com/adrtod/bastiR/issues

- Demander une fonctionnalité : ???

- Contribution au développement : 
    - mineure : Fork + pull request
    - majeure : Faire demande aux propriétaires du projet pour devenir administrateur
    
# Liste des tâches
- [ ] écrire intro origine et but du projet
- [ ] ajouter ressources

# Auteurs
Copyright (C) 2015, Adrien Todeschini, [Baptiste Dulau](http://www.bastir-energie.fr/).

**bastiR** est un logiciel libre distribué sous la Licence [GPL-2](http://www.gnu.org/licenses/gpl-2.0.html).
