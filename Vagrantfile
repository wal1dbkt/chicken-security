Vagrant.configure("2") do |config|

  config.ssh.insert_key = false

  # --- Machine d'administration (Ansible) ---
  config.vm.define "adminsible" do |admin|
    admin.vm.box = "bento/ubuntu-22.04"
    admin.vm.hostname = "adminsible"
    admin.vm.network "private_network", ip: "192.168.56.10"

    admin.vm.provider "vmware_desktop" do |v|
      v.vmx["displayName"] = "Adminsible"
      v.memory = 4096
      v.cpus = 2
      v.gui = true
    end

    admin.vm.provision "shell", inline: <<-SHELL
      apt update
      apt install -y ansible python3-pip
      pip3 install pywinrm
    SHELL
  end

  # --- Noeud 1 ---
  config.vm.define "node01" do |node1|
    node1.vm.box = "generic/rocky9"
    node1.vm.hostname = "node01"
    node1.vm.network "private_network", ip: "192.168.56.20"

    # Correction ici : utilisation de 'node1'
    node1.vm.provider "vmware_desktop" do |v|
      v.vmx["displayName"] = "Node01-HA"
      v.memory = 2048
      v.cpus = 2
      v.gui = true
    end
  end

  # --- Noeud 2 ---
  config.vm.define "node02" do |node2|
    node2.vm.box = "generic/rocky9"
    node2.vm.hostname = "node02"
    node2.vm.network "private_network", ip: "192.168.56.21"

    # Correction ici : utilisation de 'node2'
    node2.vm.provider "vmware_desktop" do |v|
      v.vmx["displayName"] = "Node02-HA"
      v.memory = 2048
      v.cpus = 2
      v.gui = true
    end
  end

  # --- Serveur Windows ---
  config.vm.define "winsrv" do |win|
    win.vm.box = "gusztavvargadr/windows-server-2025-standard"
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
  end

end