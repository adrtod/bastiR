# bastiR
[![Build Status](https://travis-ci.org/adrtod/bastiR.svg?branch=master)](https://travis-ci.org/adrtod/bastiR)
[![GPLv2 License](http://img.shields.io/badge/license-GPLv2-blue.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

Le package R **bastiR** a pour but d'?tre une collection d'outils pour faciliter le suivi de chantier.
Sa premi?re fonctionnalit? est la g?n?ration de compte-rendus de r?unions de chantier.

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
Pour installer la derni?re version en d?veloppement sur [GitHub](https://github.com/adrtod/rchallenge), taper la commande suivante sous R :
```r
# install.packages("devtools")
devtools::install_github("adrtod/bastiR")
```

# Sp?cification des tableaux d'entr?e
- Tableur Excel (>= 2007) `.xls` ou `.xlsx`
- Ne pas fusionner les cellules
- 1 colonne = 1 variable, libell? en 1?re ligne
- 1 ligne = 1 individu
- Colonnes de dates au format date dans Excel
- N'utiliser que les caract?res reconnus par la norme [ISO 8859-1](https://fr.wikipedia.org/wiki/ISO_8859-1)
  Pour le reste utiliser les commandes LaTeX :
    - `\euro{}`, `\oe{}`, `\OE{}`
    - [symboles math?matiques et lettres grecques](http://www.commentcamarche.net/contents/620-latex-table-de-caracteres) entre dollars, ex: `$\lambda$`

### Feuilles de calcul (onglets)
Nom           | Description               | Colonnes
------------- | ------------------------- | -------------
**`LEGENDE`** | L?gende des objets        | *Obligatoires* : <br> **`CLASSE`** : classe d'objet d?sign? par une cl? (`acteur orga`, `acteur exe`, `section`, `etat`) <br> **`CLE`** : cl?, courte cha?ne de caract?res, insensible ? la casse <br> **`NOM`** : nom de l'objet <br> *Facultatives* : <br> **`DESIGNATION`** : nom du lot <br> **`LOT`** : num?ro du lot <br> **`REPRESENTANT`**,	**`TEL`**,	**`MOBILE`**,	**`FAX`**,	**`EMAIL`**,	**`P`**,	**`DIF`**,	**`INV`**,	**`C`** ...
**`TACHES`**  | T?ches pass?es            | **`SECTION`** : cl? (ex: `orga`=Organisation g?n?rale, `exe`=Ex?cution) <br> **`DATE`** : date de r?union <br> **`ECHEANCE`** : date d'?ch?ance <br> **`ACTEUR`** : cl? associ?e ? l'acteur <br> **`TACHE`** : texte d?crivant la t?che <br> **`ETAT`** : cl? (`a`=A faire, `f`=Fait, `i`=Info) <br> **`PRIORITE`** : automatique (`RAPPEL` ou `URGENT`)
**`CEJOUR`**  | T?ches r?union en cours   | cf. **`TACHES`**, sauf **`PRIORITE`**
**`PLANS`**   | Armoire ? plans           | **`SECTION`** <br> **`SOUSSECTION`** <br> **`PLAN`**,	**`NUM`**,	**`INDICE`**,	**`DATE`**
**`PLANSNOTE`** | Note pour l'armoire ? plans | **`TEXTE`**
**`PHOTOS`**  | Photographies comment?es  | **`FICHIER`** : nom du fichier, ne doit pas contenir d'espace <br> **`COMMENTAIRE`** : texte

# Ressources
- Introduction ? R et RStudio : TODO

# Auteurs
Copyright (C) 2015, [Adrien Todeschini](https://sites.google.com/site/adrientodeschini/), [Baptiste Dulau](http://www.bastir-energie.fr/).

**bastiR** est un logiciel libre distribu? sous la Licence [GPL-2](http://www.gnu.org/licenses/gpl-2.0.html).

********************************************************************************

# Signaler un bug

<https://github.com/adrtod/bastiR/issues>

# Contribuer au d?veloppement

### Cr?er un compte GitHub
<https://github.com/signup>

### Installer Git
- Windows & OS X : <http://git-scm.com/downloads>
- Debian/Ubuntu : `sudo apt-get install git-core`
- Fedora/RedHat : `sudo yum install git-core`

### Contribution mineure
[Fork](https://help.github.com/articles/fork-a-repo/) & [pull](https://help.github.com/articles/using-pull-requests/)

### Contribution majeure
- Faire une demande aux propri?taires du projet GitHub pour devenir collaborateur.

- Mettre en place le projet sous RStudio :
    1. Cliquer sur **New Project** (dans le menu **File**)
    2. Choisir un nouveau projet **Version Control**
    3. Choisir **Git**
    4. Fournir l'[URL du r?f?rentiel](https://help.github.com/articles/which-remote-url-should-i-use/) (et d'autres options appropri?es) et cliquer sur **Create project**.
    
    Le d?p?t distant sera clon? dans le r?pertoire sp?cifi?, et les fonctions de versionnage de RStudio seront ensuite disponibles pour ce r?pertoire.  
    Voir aussi : [projets RStudio](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects), [versionnage avec RStudio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN), [tutoriel vid?o](https://vimeo.com/119403805).
    
### Ressources
- [Packages R](http://r-pkgs.had.co.nz/)
- [Markdown](https://help.github.com/articles/markdown-basics/)
- [knitr](http://yihui.name/knitr/)
- [dplyr](https://github.com/hadley/dplyr) : [introduction](http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html), [aide m?moire](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
- R & Excel : [readxl](https://github.com/hadley/readxl), [openxlsx](https://github.com/awalker89/openxlsx), <http://www.r-bloggers.com/a-million-ways-to-connect-r-and-excel/>
- [LaTeX](http://fr.wikibooks.org/wiki/LaTeX)
    
# Liste des t?ches
- [ ] code en anglais, aide en fran?ais ?
- [ ] tester sous windows
- [ ] ?crire intro origine et but du projet
- [ ] ajouter ressources
