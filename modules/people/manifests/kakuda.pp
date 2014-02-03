class people::kakuda {
  include iterm2::stable
  include dropbox
  include eclipse::java
  include chrome
  include clipmenu
  include emacs::formacosx
  include unarchiver
  
  osx_login_item { 'ClipMenu':
    name    => 'ClipMenu',
    path    => '/Applications/ClipMenu.app',
    hidden  => true,
    require => Class['clipmenu'],
  }
  
  homebrew::tap { 'homebrew/science': }
  
  # homebrew
  package {
    [
      'cscope',
#      'gfortran',
      'leiningen',
      'python3',
      'reattach-to-user-namespace',
      'redis',
      'sbcl',
      'ssh-copy-id',
      'tmux',
    ]:
    ensure => latest,
  }

  # package { 'R':
  #   require => Homebrew::Tap["homebrew/science"]
  # }
  
  # Python packages
  # package {
  #   [
  #     'virtualenv',
  #     'virtualenvwrapper',
  #   ]:
  #   ensure   => latest,
  #   provider => pip,
  # }  

  package { 'GoogleJapaneseInput':
    source   => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
    provider => pkgdmg;
  }

  package { 'zsh':
    install_options => [
      '--disable-etcdir'
    ]
  }

  file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before  => Osx_chsh[$::luser];
  }
  
  osx_chsh { $::luser:
    shell => "${boxen::config::homebrewdir}/bin/zsh";
  }

  include osx::finder::show_all_on_desktop
  include osx::finder::unhide_library
  include osx::disable_app_quarantine
  include osx::dock::autohide
  include osx::no_network_dsstores
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  
  class { 'osx::dock::position':
    position => 'left'
  }
}