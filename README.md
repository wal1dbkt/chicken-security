# Mega TP Administration Systèmes Répartis

## Contexte
Projet de refonte d'infrastructure PME pour passer d'un déploiement manuel à IaC & DevOps.  
Machines : Ubuntu (Adminsible), Rocky Linux (Cluster HA), Windows Server (AD).

## Architecture
- **Adminsible (192.168.56.10)** : contrôle Ansible + Zabbix Server  
- **Node01 (192.168.56.20)** : Cluster HA Web+Samba  
- **Node02 (192.168.56.21)** : Cluster HA Web+Samba  
- **WinSrv (192.168.56.30)** : Contrôleur de Domaine

## Prérequis
- Vagrant  
- VMware Desktop  
- Internet pour télécharger les boxes et paquets

## Déploiement
```bash
git clone https://github.com/wal1dbkt/chicken-security/tree/second
cd chicken-security
vagrant up
```
Tout se configure automatiquement via le Vagrantfile.

Structure du projet
ansible/ : playbooks et rôles

scripts/windows_prepare.ps1 : préparation Windows (WinRM, utilisateur Ansible)

Vagrantfile : déploiement complet des VM

Missions
Cluster HA : Pacemaker, Corosync, VIP, Nginx, Samba

Hardening Linux : pare-feu, SSH root désactivé, updates automatiques

Windows AD : ADDS, LAPS, sécurité, pare-feu, mot de passe complexe

Zabbix : serveur + agents, supervision CPU/RAM/Web

Informations utiles
L'ordre de déploiement est géré par site.yml

L'infrastructure est entièrement automatisée

Si WinRM n’est pas prêt au premier lancement : vagrant provision adminsible

Remarques / Difficultés rencontrées
WinRM peut ne pas répondre immédiatement → relancer le provisioning

Fusion des fichiers inventory pour éviter doublons

Adaptation des IPs pour éviter conflits réseau

Contact / Auteurs
Projet réalisé par Nicolas VELLA et Walid BERKOUAT