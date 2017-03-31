# SPE-CLO5

CLO5
===================

#### <i class="icon-hdd"></i> Ressources :
Vous aurez à votre disposition 3 VM.
- 172.16.230.18:student:M8TpIpi;
- 172.16.230.51:student:Q0z{x2?2
- 172.16.230.84:student:H(x-I1Cf

-------------

Outils/Langages/technologies utilisées :

- Docker
- Ansible
- Gitlab et Gitlab-CI
- XXXX

Mise en oeuvre :

- Mettre en place une API de réservation sur l'un des thèmes suivants : Hôtellerie, Restauration, Prise de rendez-vous
- Ils devront concevoir l'API selon une architecture de "Microservice" détailler dans un schéma technique.
- Mise en place les cycles d'intégration et de déploiement continu de l'application via Gitlab-CI. Les runners Gitlab-CI seront des conteneurs Docker, tous les tests d'intégration se feront dans des conteneurs.
-  Le déploiement se fera via un playbook Ansible, qui sera exécuté par Gitlab-CI. sur l'une ou les 3 VM mises à disposition.
- Des tests fonctionnels devront valider le déploiement et le fonctionnement de l'application.

----------


Cadre du projet
-------------

L'objectif, dans une logique Devops, consiste à la réalisation d'une application web en micro service sur une infrastructure en cluster. L'une de des contrainte majeure sera le déploiement continu de votre travail.

Mise en place d'une API de réservation hôtelière. Réservation de chambres, nombre de personnes par chambre réservée, petit déjeuner, annulation des réservations, garage, lit bébé, wifi ect ...

>Gestion des réservations simultanées.

Afin de s'inscrire dans le nouveau plan d'industrialisation de la mise en production des sites et applications, pour ce projet, un POC qui permettra d'automatiser la mise en production des sites et applications.

Les choix techniques validé :

- Docker
- Gitlab, Gitlab-CI
- Ansible

> Mise en place un cluster Docker Swarm multi tenant et muti environnement (preprod et prod).

A terme, à partir d'un commit poussé dans une branche précise, possibilité de déclencher le pipeline d'intégration et déploiement continue.

>Afin de pouvoir bénéficier au mieux de cette infrastructure, conception de l'API en **Microservice**. 

Problématiques:

- La répartition des fonctionnalités en service
- La collecte de logs d'exécution, les logs devront pouvoir être redirigés vers un serveur de traitement des logs.
- La mise en place d'une documentation (RAML, SWAGGER, blueprint, ...)
- La mise en place de test unitaire dans tous les dépôt de votre application.

------------------------

Plan d’action Projet CLO5
-------------

**I.	Etape 1 : Installation Ansible**
: A.	Installation Ansible 2.2 linux

:  1.	Installer sur serveur Ubuntu 16
2.	Installer Ansible 2.2 via doc officelle
(http://docs.ansible.com/ansible/intro_installation.html#installation)
3.	Test Ansible 2.2 avec clef SSH


**II.	Etape 2 : Installation du Cluster Docker via Ansible**

A.	Mise en place du rôle installation docker 1.13

1.	Installer 3 paquets
a)	Docker-machine
b)	Docker-engine
c)	Docker-compose
2.	Variabiliser selon famille linux (3 fichiers de variable .yml)
a)	main.yml
b)	Debian.yml
c)	RedHat.yml
3.	Variabiliser tous ce qui peux l’être.
4.	Ecrire la task principale (main.yml)

B.	Mise en place rôle de postconfiguration Docker

1.	Nom du rôle
a)	docker_swarm
2.	Dans la tast principale configurer le mode swarm
a)	En node  «manager » sur Vm1 
b)	En node « worker » sur Vm2 et Vm3 

**III.	Etape 3 : Déployez la registry Docker via Ansible**

A.	Mise en place du rôle registry docker

1.	Nom du rôle
a)	docker_registry
2.	Ecriture du task principale


**IV.	Etape 4 : Déployer la TICK Stack de CLO4 via Ansible**

A.Mise en place du rôle de déploiement de la stack

1.	Nom du rôle
)	docker_ticstack
2.	Variabiliser tous ce qui peux l’être
3.	Templatiser les DockerFiles
4.	Ecriture de la task principale 
a)	Deployer les templates DockerFiles
b)	Construire les images Docker à partir des templates
c)	Envoyer ces images sur votre Registry
d)	Mettre à jour les images si besoin
e)	Déployer tous les conteneurs de la suite sur le cluster Swarm

**V.	Etape 5 : Mise en place du Système de déploiement et intégration**

A.	Mise en place du rôle d’installation Gitlab

1.	Nom du rôle
a)	Installation_gitlab
2.	Vm concernée 
a)	Vm1 
3.	Mode installation 
a)	En natif

B.	Mise en place du rôle postConfiguration Gitlab-Ci

1.	Nom du rôle
a)	gitlab_ci
2.	Configuration dans un conteneur docker
a)	Dans le cluster Swarm

VI.	Etape 6 : Mise en place des pipelines d’intégration et de déploiement continue

VII.	Etape 7 : Déployer une solution de Reverse Proxy et de Load Balancing

A.	Mise en place du rôle d’installation de Traefik 

 1.	Nom du rôle
a)	Traefik

VIII.	Etape Bonus : Déploiement de de ELK
