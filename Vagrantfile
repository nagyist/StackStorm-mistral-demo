# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'securerandom'

Vagrant.configure("2") do |config|
  config.vm.box = "trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  hostname = "mistraldemo"
  config.vm.define "#{hostname}" do |box|
    box.vm.hostname = "#{hostname}.book"
    box.vm.network :private_network, ip: "172.16.80.100", :netmask => "255.255.0.0"
    box.vm.network :private_network, ip: "10.10.80.100", :netmask => "255.255.0.0"
    box.vm.network :private_network, ip: "192.168.80.100", :netmask => "255.255.255.0"
    box.vm.network :forwarded_port, guest: 8000, host: 8000
    box.vm.provision :shell, :path => "mistraldemo.sh"
	  box.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", 3072]
      vbox.customize ["modifyvm", :id, "--cpus", 2]
      vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end
end
