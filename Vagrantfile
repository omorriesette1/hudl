# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-6.6"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision :shell, path: "mydb.py"

  config.vm.define "master" do |master|
    master.vm.hostname = "prod-master"
    master.vm.network :private_network, ip: "192.168.50.10"
    master.vm.provision "file", source: "./master/.ssh", destination: "~"
    master.vm.provision "file", source: "./master/my.cnf", destination: "~/my.cnf"
    master.vm.provision "shell", inline: "sudo mv /home/vagrant/my.cnf /etc"
    master.vm.provision "file", source: "./master/demo.sh", destination: "~/demo.sh"
  end

  config.vm.define "slave" do |slave|
    slave.vm.hostname = "prod-slave"
    slave.vm.network :private_network, ip: "192.168.50.20"
    slave.vm.network :private_network, ip: "172.168.50.10"
    slave.vm.provision "file", source: "./slave/.ssh", destination: "~"
    slave.vm.provision "file", source: "./slave/my.cnf", destination: "~/my.cnf"
    slave.vm.provision "shell", inline: "sudo mv /home/vagrant/my.cnf /etc"
    slave.vm.provision "file", source: "./slave/demo-slave.sh", destination: "~/demo-slave.sh"
  end

  config.vm.define "dev" do |dev|
    dev.vm.hostname = "hudl-dev"
    dev.vm.network :private_network, ip: "172.168.50.20"
    dev.vm.provision "file", source: "./dev/.ssh", destination: "~"
  end

end
