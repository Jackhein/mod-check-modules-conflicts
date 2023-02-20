# SQUELETTE - Module modèle 

[English](README.md) | [Français](README_FR.md)

### Déscription

*Déscription du module*

### Mise en place du module:

###### Récupérer le projet

Clonez le projet dans le dossier module sous le nom `${MODULE_NAME}`.

###### Modification de l'acquisition des points de talent

À partir de maintenant nous considérons que vous vous trouvez à la racine de votre serveur.
Appliquer le patch git en utilisant la commande suivante:\
`git apply --ignore-space-change --ignore-whitespace modules/${MODULE_NAME}/.patch`

Ou modifiez directement `src/` via votre éditeur favori\
et appliquez les modifications trouvées dans `modules/${MODULE_NAME}/.patch`.

###### Modifcation de la Base de Données

Appliquez les requêtes dans les fichiers sql sous le dossier `modules/${MODULE_NAME}/sql/`\
sur la table respectif (world => acore\_world / auth => acore\_auth / char => acore\_char)

Voici une commande que j'utilise souvent pour appliquer directement plusieurs fichiers sql:\
`for sql in $(find modules/${MODULE_NAME}/sql/*world*/ -type f -name '*.sql'); do mysql -uUSERDB -hHOSTDB -Dacore_world -p < ${sql}; done`

###### Ajout des données DBC

Copiez les sous dossier des DBC depuis `modules/${MODULE_NAME}/data/`\
Et placez les dans votre dossier data (comme indiqué dans worldserver.conf).

Ajoutez les égalements dans le dossier data du client.

###### Recompilez et voilà.

### Licence

Licence MIT

### Crédits

* [Jackhein](https://github.com/Jackhein) (auteur du module)
* [Miorey](https://github.com/Miorey/)

Notre serveur [MurlocVillage](https://wotlk.murlocvillage.com/fr/)\
&emsp;&emsp;&ensp;&nbsp;Merci à [AzerothCore](http://azerothcore.org/)

