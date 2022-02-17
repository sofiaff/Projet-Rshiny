# Projet-Rshiny

Setup pour git:
1) Créer un compte github
2) Setup une clé ssh :
	- En ligne de commande sur l'ordinateur personnel taper la commande: ssh-keygen -t rsa
	- Se connecter sur son compte github, aller dans settings, puis dans SSH and GPG key. 
	  Ajouter un nouvelle cle, puis copier coller le contenu du fichier id_rsa.pub
3) Créer un repertoire local:
	1) En ligne de commande, sur son desktop taper la commande: git clone git@github.com:sofiaff/Projet-Rshiny.git

Installer le paquet Shiny:
	intall.packages("shiny")

Rouler l'application:
	ouvrir Rstudio
	Ouvrir le fichier app.R
	Dans jobs rouler app.R

Commandes git: 
	Copier le repertoire : git clone 
	Vérifier le status du projet: git status
	Montrer les changements: git diff
	Mettre à jour le répertoire local: git pull  (DOIT ETRE FAIT À CHAQUE FOIS AVANT DE COMMENCER À TRAVAILLER)
	Ajouter les modifications localement : git add <fichiers>
	Commit et ajout de commentaire: git commit
	Soumettre les changements au répertoire distant: git push
	Changer ou créer une branche: git checkout -b <NomDeLaBranche>
	Voir l'historique des changement: git log
	
	
