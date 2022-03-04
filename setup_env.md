# SETUP dev environnement

## Documentation de référence

Configuration d'un environnement de développement [Python](https://cloud.google.com/python/docs/setup)

## Installer Pyhton
1. Installer python
1. Vérifier la version de pyhton
        
        py --version
1. Vérifier la verison de pip

        py -m pip --version

## Utiliser venv pour isoler les dépendances
1. Utiliser la commande venv pour créer une copie virtuelle de l'installation Python

        cd project_directory
        py -m venv env
1. Configurez votre interface système de sorte qu'elle utilise les chemins d'accès venv pour Python en activant l'environnement virtuel.

        .\env\Scripts\activate

1. Installer les dépendance nécesaire

        pip install PACKAGE_A_INSTALLER

1. Si vous souhaitez cesser d'utiliser l'environnement virtuel et revenir à votre environnement global Python, vous pouvez le désactiver:

        deactivate