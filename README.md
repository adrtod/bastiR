# bastiR
[![Travis-CI Build Status](https://img.shields.io/travis/adrtod/bastiR.svg)](https://travis-ci.org/adrtod/bastiR)
[![GPLv2 License](http://img.shields.io/badge/license-GPLv2-blue.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

Le package R **bastiR** a pour but d'�tre une collection d'outils pour faciliter le suivi de chantier.
Sa premi�re fonctionnalit� est la g�n�ration de compte-rendus de r�unions de chantier.

# Logiciels requis
- [R](http://www.r-project.org/) version 3.2.0 (2015-04-16)
- [RStudio](http://www.rstudio.com/) version 0.98.1103
- [MikTex](http://www.miktek.org/) version 2.9

# Installation
Pour installer la derni�re version en d�veloppement sur [GitHub](https://github.com/adrtod/rchallenge), taper la commande suivante sous R :
```r
# install.packages("devtools")
devtools::install_github("adrtod/bastiR")
```

# Sp�cification des tableaux d'entr�e
- Tableur Excel .xls version 2007
- Feuilles de calcul (onglets) :
    - L�gende : classe (acteur orga, acteur exe, chapitre, �tat), cl� (insensible � la casse), d�signation, ...
    - T�ches : chapitre (cl�), date de r�union, date d'�ch�ance, acteur (cl�), description, �tat (cl� : a=A faire, f=Fait, i=Info), priorit� (autromatique, cl� : rappel, urgent)
    - T�ches r�union en cours : cf. T�ches
    - Armoire � plans : TODO
    - Photos : nom du fichier, commentaire
- Ne pas fusionner les cellules
- 1 colonne = 1 variable, label en 1�re ligne
- 1 ligne = 1 individu
- cellules dates au format date dans Excel

# Ressources
### Programmation sous R

- [R Markdown](http://rmarkdown.rstudio.com/)

# Contribuer au projet
- Cr�er un compte github

- Signaler un bug : https://github.com/adrtod/bastiR/issues

- Demander une fonctionnalit� : ???

- Contribution au d�veloppement : 
    - mineure : Fork + pull request
    - majeure : Faire demande aux propri�taires du projet pour devenir administrateur
    
# Liste des t�ches
- [ ] �crire intro origine et but du projet
- [ ] ajouter ressources

# Auteurs
Copyright (C) 2015, Adrien Todeschini, [Baptiste Dulau](http://www.bastir-energie.fr/).

**bastiR** est un logiciel libre distribu� sous la Licence [GPL-2](http://www.gnu.org/licenses/gpl-2.0.html).
