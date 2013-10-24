name             'et_jzmq'
maintainer       'EverTrue, Inc.'
maintainer_email 'eric.herot@evertrue.com'
license          'All rights reserved'
description      'Installs/Configures jzmq'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'

depends 'zeromq', '= 2.0.8'
depends 'build-essential'
depends 'java'
depends 'apt'
