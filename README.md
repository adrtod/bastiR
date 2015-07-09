# bastiR
[![Build Status](https://travis-ci.org/adrtod/bastiR.svg?branch=master)](https://travis-ci.org/adrtod/bastiR)
[![GPLv2 License](http://img.shields.io/badge/license-GPLv2-blue.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

Le package R **bastiR** a pour but d'être une collection d'outils pour faciliter le suivi de chantier.
Sa première fonctionnalité est la génération de compte-rendus de réunions de chantier.

_**bastiR** est actuellement en contruction._

# Logiciels requis
<img src="http://www.r-project.org/Rlogo.png" alt="R" height=32/> &nbsp;
<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/9/92/LaTeX_logo.svg/220px-LaTeX_logo.svg.png" alt="LaTeX" height=32/>

- [R](http://www.r-project.org/) version >= 3.2.0 (2015-04-16)
- [Rtools](http://cran.r-project.org/bin/windows/Rtools/) (Windows seulement)
- [RStudio](http://www.rstudio.com/) version >= 0.99.441
- [LaTeX](http://www.latex-project.org/) :
    - Windows : [MiKTeX](http://miktex.org/)
    - OS X : [MacTeX](https://tug.org/mactex/)
    - Debian/Ubuntu : `sudo apt-get install texlive`
    - Fedora/RedHat : `sudo yum install texlive`

# Installation
Pour installer la dernière version en développement sur [GitHub](https://github.com/adrtod/rchallenge), entrer la commande suivante sous R :
```r
# install.packages("devtools")
devtools::install_github("adrtod/bastiR")
```

### Installation rapide sous Windows
1. Installez [R](http://cran.r-project.org/bin/windows/base/)
2. Ouvrez la console R puis entrez les commandes suivantes pour installer tous les logiciels requis ansi que le package **bastiR** :

```r
install.packages(c("installr", "devtools"))
installr::install.rtools()
installr::install.rstudio()
installr::install.miktex(64) # remplacez 64 par 32 pour la version 32-bit
devtools::install_github("adrtod/bastiR")
```

# Spécification des tableaux d'entrée
- Tableur Excel (>= 2007) `.xls` ou `.xlsx`
- Ne pas fusionner les cellules
- 1 colonne = 1 variable, libellé en 1ère ligne
- 1 ligne = 1 individu
- Colonnes de dates au format date dans Excel
- N'utiliser que les caractères reconnus par la norme [ISO 8859-1](https://fr.wikipedia.org/wiki/ISO_8859-1)
  Pour le reste utiliser les commandes LaTeX :
    - `\euro{}`, `\oe{}`, `\OE{}`
    - [symboles mathématiques et lettres grecques](http://www.commentcamarche.net/contents/620-latex-table-de-caracteres) entre dollars, ex: `$\lambda$`
    - formatage en indice ou exposant, ex: `m$^2$`
    - apostrophes simples `'` seulement
    - tirets simples seulement `-`. tiret semi-cadratin : `--`. tiret cadratin : `---`

### Feuilles de calcul (onglets)
Nom           | Description               | Colonnes
------------- | ------------------------- | -------------
**`LEGENDE`** | Légende des objets        | *Obligatoires* : <br> **`CLASSE`** : classe d'objet désigné par une clé (`acteur orga`, `acteur exe`, `section`, `etat`) <br> **`CLE`** : clé, courte chaîne de caractères, insensible à la casse <br> **`NOM`** : nom de l'objet <br> *Facultatives* : <br> **`DESIGNATION`** : nom du lot <br> **`LOT`** : numéro du lot <br> **`REPRESENTANT`**,	**`TEL`**,	**`MOBILE`**,	**`FAX`**,	**`EMAIL`**,	**`P`**,	**`DIF`**,	**`INV`**,	**`C`** ...
**`TACHES`**  | Tâches passées            | **`SECTION`** : clé (ex: `orga`=Organisation générale, `exe`=Exécution) <br> **`DATE`** : date de réunion <br> **`ECHEANCE`** : date d'échéance <br> **`DATEREALISATION`** : date de réalisation <br> **`ACTEUR`** : clé associée à l'acteur <br> **`TACHE`** : texte décrivant la tâche <br> **`ETAT`** : clé (`af`=A faire, `f`=Fait, `i`=Info, `av`=A valider, `v`=Validé, `an`=Annulé) <br> **`PRIORITE`** : automatique (`RAPPEL` ou `URGENT`)
**`CEJOUR`**  | Tâches réunion en cours   | cf. **`TACHES`**, sauf **`PRIORITE`**
**`PLANS`**   | Armoire à plans           | **`SECTION`** <br> **`SOUSSECTION`** <br> **`PLAN`**,	**`NUM`**,	**`INDICE`**,	**`DATE`**
**`PLANSNOTE`** | Note pour l'armoire à plans | **`TEXTE`**
**`PHOTOS`**  | Photographies commentées  | **`FICHIER`** : nom du fichier (avec extension, sans le chemin), ne doit pas contenir d'espace <br> **`COMMENTAIRE`** : texte

# Spécification des photos
- Fichiers reconnus : `.jpg`, `.jpeg`, `.JPG`, `.JPEG`, `.png`, `.PNG`
- Orientation portrait/paysage : effectuer les rotations nécessaires manuellement

# Traitements automatiques
- Prépare feuille de calcul `PHOTOS` avec fichiers lus dans le dossier courant
- Efface les lignes vides
- Complète `ETAT` manquant par `A faire`
- Ajoute `CEJOUR` à TACHES
- Edite clés `ETAT`, `SECTION`, `ACTEUR` en minuscule
- Tri des lignes par `ETAT`, `SECTION`, `ECHEANCE` puis `ACTEUR`
- Edite `PRIORITE` : `Rappel` (`ECHEANCE` passée) ou `Urgent` (`ECHEANCE` + 1 semaine)
- Complète `DATEREALISATION` manquante par la date de la réunion
- Supprime les lignes `Fait`/`Validé`/`Annulé` avec `DATEREALISATION` supérieure à 3 semaines

# Ressources
- Introduction à R et RStudio : TODO

# Auteurs
Copyright (C) 2015, [Adrien Todeschini](https://sites.google.com/site/adrientodeschini/), [Baptiste Dulau](http://www.bastir-energie.fr/).

**bastiR** est un logiciel libre distribué sous la Licence [GPL-2](http://www.gnu.org/licenses/gpl-2.0.html).

********************************************************************************

# Signaler un bug

<https://github.com/adrtod/bastiR/issues>

# Contribuer au développement

### Créer un compte GitHub
<https://github.com/signup>

### Installer Git
- Windows & OS X : <http://git-scm.com/downloads>
- Debian/Ubuntu : `sudo apt-get install git-core`
- Fedora/RedHat : `sudo yum install git-core`

### Contribution mineure
[Fork](https://help.github.com/articles/fork-a-repo/) & [pull](https://help.github.com/articles/using-pull-requests/)

### Contribution majeure
- Faire une demande aux propriétaires du projet GitHub pour devenir collaborateur.

- Mettre en place le projet sous RStudio :
    1. Cliquer sur **New Project** (dans le menu **File**)
    2. Choisir un nouveau projet **Version Control**
    3. Choisir **Git**
    4. Fournir l'[URL du référentiel](https://help.github.com/articles/which-remote-url-should-i-use/) (et d'autres options appropriées) et cliquer sur **Create project**.
    
    Le dépôt distant sera cloné dans le répertoire spécifié, et les fonctions de versionnage de RStudio seront ensuite disponibles pour ce répertoire.  
    Voir aussi : [projets RStudio](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects), [versionnage avec RStudio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN), [tutoriel vidéo](https://vimeo.com/119403805).
    
### Ressources
- [Packages R](http://r-pkgs.had.co.nz/)
- [Markdown](https://help.github.com/articles/markdown-basics/)
- [knitr](http://yihui.name/knitr/)
- [dplyr](https://github.com/hadley/dplyr) : [introduction](http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html), [aide mémoire](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
- R & Excel : [readxl](https://github.com/hadley/readxl), [openxlsx](https://github.com/awalker89/openxlsx), <http://www.r-bloggers.com/a-million-ways-to-connect-r-and-excel/>
- [LaTeX](http://fr.wikibooks.org/wiki/LaTeX)
    
# Liste des tâches
- [ ] code en anglais, aide en français ?
- [ ] tester sous windows
- [ ] écrire intro origine et but du projet
- [ ] ajouter ressources
- [ ] problème de lecture lorsque certaines colonnes sont apparemment vides mais ne le sont pas en réalité
- [ ] insérer et retailler seulement les photos commentées
