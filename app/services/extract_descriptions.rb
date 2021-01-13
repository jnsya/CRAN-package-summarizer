require 'rubygems/package'
require 'open-uri'

class ExtractDescriptions
  def initialize(http_client: URI, packages: Package.all)
    self.packages = packages
    self.http_client = http_client
  end

  def call
    packages.each do |package|
      begin
        data = fetch_from_url(package.url)
        description = parse_description(data, package.name)
        package.update_from_description(description)
      rescue
        Rails.logger.info "There was a problem with package: #{package.id}. URL: #{package.url}"
      end
    end
  end

  def fetch_from_url(url)
    data = http_client.parse(url).read
    StringIO.new(data)
  end

  def parse_description(data, package_name)
    Zlib::GzipReader.wrap(data) do |gz|
      Gem::Package::TarReader.new(gz) do |tar|
        tar.each { |entry| return entry.read if entry.full_name == "#{package_name}/DESCRIPTION" }
      end
    end
  end

  private

  attr_accessor :http_client, :packages
end
