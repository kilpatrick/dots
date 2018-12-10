# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # 6.64 GB
  config.vm.define 'win7' do |win7|
    win7.vm.box = 'designerror/windows-7'
    win7.vm.network 'private_network', ip: '192.168.50.5'
  end

  # 18.3 GB
  config.vm.define 'highsierra' do |highsierra|
    highsierra.vm.box = 'monsenso/macos-10.13'
    highsierra.vm.box_version = '1.1.0'
    highsierra.vm.network 'private_network', ip: '192.168.50.13'
  end

  # 8.6 GB
  config.vm.define 'mojave' do |mojave|
    mojave.vm.box = 'ashiq/osx-10.14'
    mojave.vm.box_version = '0.1'
    mojave.vm.network 'private_network', ip: '192.168.50.14'
  end
end
