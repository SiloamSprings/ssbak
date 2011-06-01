#!/usr/bin/env ruby

require 'rubygems'
require 'logger'
require 'pony'

#-- CONFIG --

# general script settings
DBCOPY_DIR="/opt/novell/groupwise/agents/bin/"
BACKUP_DIR="/storage1/mx0/gwcopy/"
ADMIN_CONTACT="isys@siloamsprings.com"
MOUNT="storage1"

# pony/smtp settings
HOST = ""
PORT = ""
USER = ""
PASS = ""
DOMAIN = ""

#-- END CONFIG --

# setup a logfile with weekly rotation
log = Logger.new "/var/log/gwback_ruby", 'weekly'

log.info("starting gwcopy.rb")

# check to see if our mount is up
if (%x{mount} =~ /#{MOUNT}/)
  log.info("backup mounts appear to be available, proceeding with backup")
  
  # backup the domain
  domlog = %x{#{DBCOPY_DIR}dbcopy /mail/siloamsprings #{BACKUP_DIR}do/}
  log.info("DOMAIN BACKUP INFODUMP")
  log.info(domlog)

  # backup the post office
  polog = %x{#{DBCOPY_DIR}dbcopy /mail/siloamsprings_po/ #{BACKUP_DIR}po/}
  log.info("POST OFFICE BACKUP INFODUMP")
  log.info(polog)
  
  log.info("gwcopy.rb run complete")

else
  # log the lack of a mountpoint and contact an admin
  log.fatal("mountpoint \"#{MOUNT}\" not detected")
  log.info("contacting admin at \"#{ADMIN_CONTACT}\"")

  Pony.mail(:to => ADMIN_CONTACT, :via => :smtp, :smtp => {
    :host     => HOST,
    :port     => PORT,
    :user     => USER,
    :password => PASS,
    :auth     => :plain,  
    :domain   => DOMAIN
  })
end
