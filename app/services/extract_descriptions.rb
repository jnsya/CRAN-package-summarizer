require 'rubygems/package'
require 'open-uri'

class ExtractDescriptions
  def initialize(http_client: URI, packages: Package.all)
    self.packages = packages
    self.http_client = http_client
  end

  def call
    packages.find_each do |package|
      begin
        compressed_package = http_client.parse(package.url).read
        description        = get_description(compressed_package, package.name)

        package.update_from_description(description)
      rescue OpenURI::HTTPError
        Rails.logger.info "There was a problem with the URL for package: #{package.id}. URL: #{package.url}"
      end
    end
  end

  def get_description(compressed_archive, package_name)
    Zlib::GzipReader.wrap(StringIO.new(compressed_archive)) do |gz|
      Gem::Package::TarReader.new(gz) do |tar|
        tar.each do |entry|
          return entry.read if entry.full_name == "#{package_name}/DESCRIPTION"
        end
      end
    end
  end

  private

  attr_accessor :http_client, :packages
end
