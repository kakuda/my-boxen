class people::kakuda {
  include atom
  include clipmenu
  include brewcask
  include vagrant

  # brewcask
  $apps = [
    'audacity',
    'dropbox',
    'emacs',
    'google-chrome',
    'kindle',
    'iterm2',
    'java',
    'lighttable',
    'virtualbox',
    'the-unarchiver',
  ]

  package { $apps:
    provider => brewcask
  }

  # homebrew
  package {
    [
#      'cscope',
#      'reattach-to-user-namespace',
#      'ssh-copy-id',
      'direnv',
      'go',
      'leiningen',
      'pyenv',
      'tmux',
    ]:
    ensure => latest,
  }

  osx_login_item { 'ClipMenu':
    name    => 'ClipMenu',
    path    => '/Applications/ClipMenu.app',
    hidden  => true,
    require => Class['clipmenu'],
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
  include osx::global::natural_mouse_scrolling
  include osx::keyboard::capslock_to_control

  class { 'osx::dock::position':
    position => 'left'
  }
  class { 'osx::global::key_repeat_delay':
    delay => 12
  }
  class { 'osx::global::key_repeat_rate':
    rate => 1
  }
}
