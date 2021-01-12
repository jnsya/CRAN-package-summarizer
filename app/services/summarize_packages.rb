require 'net/ftp'
require 'yaml'

class SummarizePackages
  def initialize(ftp_client: Net::FTP.new('cran.r-project.org'))
    self.ftp_client = ftp_client
  end

  def call
    ftp_client.login
    data = ftp_client.get("/pub/R/src/contrib/PACKAGES", nil)
    ftp_client.close

    data.split("\n\n").each { |p| Package.create_from_summary(YAML.safe_load(p)) }
  end

  private

  attr_accessor :ftp_client
end
