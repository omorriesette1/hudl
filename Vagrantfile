# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-6.6"
  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.define "master" do |master|
    master.vm.hostname = "prod-master"
    master.vm.network :private_network, ip: "192.168.50.10"
    master.vm.provision :shell, path: "db_configure.py"
  end

  config.vm.define "slave" do |slave|
    slave.vm.hostname = "prod-slave"
    slave.vm.network :private_network, ip: "192.168.50.20"
    slave.vm.network :private_network, ip: "172.168.50.10"
  end

  config.vm.define "dev" do |dev|
    dev.vm.hostname = "hudl-dev"
    dev.vm.network :private_network, ip: "172.168.50.20"
  end

end
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
