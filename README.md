# bastiR
[![Travis-CI Build Status](https://img.shields.io/travis/adrtod/bastiR.svg)](https://travis-ci.org/adrtod/bastiR)
[![GPLv2 License](http://img.shields.io/badge/license-GPLv2-blue.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

Le package R **bastiR** a pour but d'être une collection d'outils pour faciliter le suivi de chantier.
Sa première fonctionnalité est la génération de compte-rendus de réunions de chantier.

# Logiciels requis
- [R](http://www.r-project.org/) version 3.2.0 (2015-04-16)
- [RStudio](http://www.rstudio.com/) version 0.98.1103
- Distribution [LaTeX](http://www.latex-project.org/) :
    - Windows : [MikTex](http://www.miktek.org/) version 2.9

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
- [knitr](http://yihui.name/knitr/)

# Auteurs
Copyright (C) 2015, Adrien Todeschini, [Baptiste Dulau](http://www.bastir-energie.fr/).

**bastiR** est un logiciel libre distribué sous la Licence [GPL-2](http://www.gnu.org/licenses/gpl-2.0.html).

# Signaler un bug

<https://github.com/adrtod/bastiR/issues>

# Contribuer au développement

### Créer un compte GitHub
<https://github.com/signup>

### Installer Git :
- Windows & OS X: <http://git-scm.com/downloads>
- Debian/Ubuntu: `sudo apt-get install git-core`
- Fedora/RedHat: `sudo yum install git-core`

### Contribution mineure
[Fork](https://help.github.com/articles/fork-a-repo/) & [pull](https://help.github.com/articles/using-pull-requests/)

### Contribution majeure
- Faire une demande aux propriétaires du projet GitHub pour devenir administrateur.

- Mettre en place le projet sous RStudio : [tutoriel video](https://vimeo.com/119403805)
    
    1. Exécutez la commande **New Project** (dans le menu **File**)
    2. Choisissez de créer un nouveau projet **Version Control**
    3. Choisissez **Git**
    4. Fournir l'[URL du référentiel](https://help.github.com/articles/which-remote-url-should-i-use/) (et d'autres options appropriées) et puis cliquez sur **Create project**.
    
    Le dépôt distant sera cloné dans le répertoire spécifié, et les fonctions de versionnage de RStudio sera ensuite disponible pour ce répertoire.
    
# Liste des tâches
- [ ] écrire intro origine et but du projet
- [ ] ajouter ressources
