# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define 'wintest' do |wintest|
    wintest.vm.box = 'designerror/windows-7'
    wintest.vm.network 'private_network', ip: '192.168.50.5'
  end
end
