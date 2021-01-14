# frozen_string_literal: true

require 'net/ftp'
require 'yaml'

# This service creates packages from the packages list overview file contained on the CRAN server.
class CreatePackagesFromList
  LIST_FILEPATH = '/pub/R/src/contrib/PACKAGES'

  def initialize(ftp_client: Net::FTP.new('cran.r-project.org'))
    self.ftp_client = ftp_client
  end

  def call
    list.split("\n\n").each do |package|
      Package.create_from_list(YAML.safe_load(package))
    end
  end

  private

  attr_accessor :ftp_client

  def list
    ftp_client.login
    list = ftp_client.get(LIST_FILEPATH, nil)
    ftp_client.close
    list
  end
end
