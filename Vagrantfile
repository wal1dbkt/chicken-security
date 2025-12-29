# -*- mode: ruby -*-
# vi: set ft=ruby :

# --- AUTOMATISATION DES CLÉS SSH (Pour le rendu Prof) ---
# On génère une paire de clés locale si elle n'existe pas encore
# Cela permet d'avoir la même clé sur Adminsible et les Nodes sans action manuelle
unless File.exist?("ansible_rsa")
  puts "=== Génération automatique des clés SSH pour le TP ==="
  system("ssh-keygen -t rsa -f ansible_rsa -q -N ''")
end

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  # =====================
  # ADMIN / ANSIBLE
  # =====================
  config.vm.define "adminsible" do |admin|
    admin.vm.box = "bento/ubuntu-22.04"
    admin.vm.hostname = "adminsible"
    admin.vm.network "private_network", ip: "192.168.56.10"

    # On sync le repo ansible
    admin.vm.synced_folder "./ansible", "/opt/ansible", owner: "vagrant", group: "vagrant"

    # INJECTION DE LA CLÉ PRIVÉE (Pour qu'Ansible puisse se connecter)
    admin.vm.provision "file", source: "ansible_rsa", destination: "/home/vagrant/.ssh/vagrant_rsa"    
    admin.vm.provider "vmware_desktop" do |v|
      v.vmx["displayName"] = "Adminsible"
      v.memory = 4096
      v.cpus = 2
      v.gui = true
    end

    # Installation Ansible + Permissions SSH correctes
    admin.vm.provision "shell", inline: <<-SHELL
      apt update -y
      apt install -y ansible python3-pip sshpass
      pip3 install pywinrm

      # Correction permissions clé SSH (CRITIQUE)
      chown vagrant:vagrant /home/vagrant/.ssh/vagrant_rsa
      chmod 600 /home/vagrant/.ssh/vagrant_rsa

      # Préparation runtime Ansible
      mkdir -p /home/vagrant/ansible_runtime
      cp -r /opt/ansible/* /home/vagrant/ansible_runtime/
      chown -R vagrant:vagrant /home/vagrant/ansible_runtime
      chmod 755 /home/vagrant/ansible_runtime
    SHELL
  end

  # =====================
  # NODE01
  # =====================
  config.vm.define "node01" do |node1|
    node1.vm.box = "generic/rocky8"
    node1.vm.hostname = "node01"
    node1.vm.network "private_network", ip: "192.168.56.20"

    # INJECTION CLÉ PUBLIQUE
    node1.vm.provision "file", source: "ansible_rsa.pub", destination: "/tmp/ansible_rsa.pub"
    node1.vm.provision "shell", inline: <<-SHELL
      cat /tmp/ansible_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
    SHELL

    node1.vm.provider "vmware_desktop" do |v|
      v.vmx["displayName"] = "Node01-HA"
      v.memory = 2048
      v.cpus = 2
      v.gui = true
    end
  end

  # =====================
  # NODE02
  # =====================
  config.vm.define "node02" do |node2|
    node2.vm.box = "generic/rocky8"
    node2.vm.hostname = "node02"
    node2.vm.network "private_network", ip: "192.168.56.21"

    # INJECTION CLÉ PUBLIQUE
    node2.vm.provision "file", source: "ansible_rsa.pub", destination: "/tmp/ansible_rsa.pub"
    node2.vm.provision "shell", inline: <<-SHELL
      cat /tmp/ansible_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
    SHELL

    node2.vm.provider "vmware_desktop" do |v|
      v.vmx["displayName"] = "Node02-HA"
      v.memory = 2048
      v.cpus = 2
      v.gui = true
    end
  end

  # =====================
  # WINDOWS SERVER
  # =====================
  config.vm.define "winsrv" do |win|
    win.vm.box = "gusztavvargadr/windows-server-2022-standard"
    win.vm.hostname = "WinSrv"
    win.vm.network "private_network", ip: "192.168.56.30"

    win.vm.communicator = "winrm"
    win.winrm.transport = :plaintext
    win.winrm.basic_auth_only = true

    win.vm.provider "vmware_desktop" do |v|
      v.vmx["displayName"] = "WinSrv-AD"
      v.memory = 4096
      v.cpus = 2
      v.gui = true
    end

    win.vm.provision "shell", privileged: true, path: "scripts/windows_prepare.ps1"
  end
end