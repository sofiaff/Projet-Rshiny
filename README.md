# Projet-Rshiny

Setup pour git:
1) Créer un compte github
2) Setup une clé ssh :
	- En ligne de commande sur l'ordinateur personnel taper la commande: ssh-keygen -t rsa
	- Se connecter sur son compte github, aller dans settings, puis dans SSH and GPG key. 
	  Ajouter un nouvelle cle, puis copier coller le contenu du fichier id_rsa.pub
3) Créer un repertoire local:
	1) En ligne de commande, sur son desktop taper la commande: git clone git@github.com:sofiaff/Projet-Rshiny.git

<br/>	
<h2> Paquets à installer pour que l'application fonctionne:</h2> <br/>
	install.packages("shiny")<br/>
	install.packages("ggplot2")<br/>
	install.packages("ggfortify")<br/>
	install.packages("ggrepel")<br/>
<br/>	
## Rouler l'application:<br/>
	Ouvrir Rstudio<br/>
	Ouvrir le fichier app.R<br/>
	Dans jobs rouler app.R<br/>
<br/>
##Commandes git: <br/>
*	Copier le repertoire : git clone <br/>
*	Vérifier le status du projet: git status <br/>
*	Montrer les changements: git diff <br/>
*	Mettre à jour le répertoire local: git pull  (DOIT ETRE FAIT À CHAQUE FOIS AVANT DE COMMENCER À TRAVAILLER)<br/>
*	Ajouter les modifications localement : git add <fichiers> <br/>
*	Commit et ajout de commentaire: git commit <br/>
*	Soumettre les changements au répertoire distant: git push <br/>
*	Changer ou créer une branche: git checkout -b NomDeLaBranche <br/>
*	Voir l'historique des changement: git log <br/>

	
Pour Mac: Si erreur lors de l'affichage du Heatmap installer le paquet suivant:<br/>
	installer XQuartz:https://www.xquartz.org
