# == Class: vmwaretools
#
# Full description of class vmwaretools here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { vmwaretools:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class vmwaretools (
  $yum_vmware_repo_link	='http://packages.vmware.com/tools/esx/5.5latest/repos/vmware-tools-repo-RHEL6-9.4.0-1.el6.x86_64.rpm'
){

  case $osfamily {
    RedHat: {
      case $architecture {
      	x86_64: {
      	  exec {'setup vmware yum repository':
      	    command	=> "/usr/bin/yum -y install ${yum_vmware_repo_link}",
      	    unless	=> '/usr/bin/test -f /etc/yum.repos.d/vmware-osps.repo',
          }
          package {'vmware-tools-esx-nox':
            ensure => present,
            require => Exec['setup vmware yum repository'],
          }
      	}
      	default: { fail('Unknown architecture') }
      }
    }
    Debian: {
      case $architecture {
        amd64: {
          apt::source { 'vmware_tools':
            location          => 'http://packages.vmware.com/tools/esx/5.0latest/ubuntu',
            release           => $::lsbdistcodename,
            repos             => 'main',
            key               => 'vmware_tools',
            key_source        => 'http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub',
            include_src       => false
          }
          package {'vmware-tools-esx-nox':
            ensure => present,
            require => Apt::Source['vmware_tools'],
          }
        }
        default: { fail('Unknown architecture') }
      }
    } 
    
    default: { fail('Unrecognized operating system') }
  }
}
