# -*- mode: ruby -*-
# vi: set ft=ruby :

# Global configs across all machines
Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-6.7"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision :shell, path: "mydb.py"

  # Master server configurations
  config.vm.define "master" do |master|
    master.vm.hostname = "prod-master"
    master.vm.network :private_network, ip: "192.168.50.10"
    master.vm.provision "file", source: "./master/.ssh", destination: "~"
    master.vm.synced_folder "master/", "/home/vagrant/master"
    master.vm.provision :shell, path: "master-provision.sh"
  end

  # Slave server configurations
  config.vm.define "slave" do |slave|
    slave.vm.hostname = "prod-slave"
    slave.vm.network :private_network, ip: "192.168.50.20"
    slave.vm.network :private_network, ip: "172.168.50.10"
    slave.vm.provision "file", source: "./slave/.ssh", destination: "~"
    slave.vm.synced_folder "slave/", "/home/vagrant/slave"
    slave.vm.provision :shell, path: "slave-provision.sh"
  end

  # Development server configurations
  config.vm.define "dev" do |dev|
    dev.vm.hostname = "hudl-dev"
    dev.vm.network :private_network, ip: "172.168.50.20"
    dev.vm.provision "file", source: "./dev/.ssh", destination: "~"
    dev.vm.synced_folder "dev/", "/home/vagrant/dev"
    dev.vm.provision :shell, path: "dev-provision.sh"
  end

end
