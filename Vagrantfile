# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # 6.64 GB Machince Size
  config.vm.define 'win7' do |win7|
    win7.vm.box = 'designerror/windows-7'
    win7.vm.network 'private_network', ip: '192.168.50.5'
    win7.vm.provider 'virtualbox' do |vb|
      vb.memory = 5120
      vb.cpus = 2
    end
  end

  # 18.3 GB Machince Size
  config.vm.define 'highsierra' do |highsierra|
    highsierra.vm.boot_timeout = 60
    highsierra.vm.synced_folder '.', '/vagrant', disabled: true # type: 'nfs' # or type: 'rsync' or disabled: true
    highsierra.vm.box = 'monsenso/macos-10.13'
    highsierra.vm.box_version = '1.1.0'
    highsierra.vm.network 'private_network', ip: '192.168.50.5'
    highsierra.vm.provider 'virtualbox' do |vb|
      vb.memory = 5120
      vb.cpus = 2
    end
  end

  # 8.6 GB Machince Size
  config.vm.define 'mojave' do |mojave|
    mojave.vm.boot_timeout = 60
    mojave.vm.synced_folder '.', '/vagrant', disabled: true # type: 'nfs' # or type: 'rsync' or disabled: true
    mojave.vm.box = 'ashiq/osx-10.14'
    mojave.vm.box_version = '0.1'
    mojave.vm.network 'private_network', ip: '192.168.50.5'
    mojave.vm.provider 'virtualbox' do |vb|
      vb.memory = 5120
      vb.cpus = 2
    end
  end
end
