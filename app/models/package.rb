class Package < ApplicationRecord
  BASE_URL = 'http://cran.r-project.org/src/contrib/PACKAGE_VERSION.tar.gz'

  def self.create_from_summary(hash)
    self.create(name: hash["Package"],
                version: hash['Version'],
                r_version_needed: get_r_version_needed(hash['Depends']),
                license: hash['License'],
                dependencies: hash['Depends'],
                url: get_url(hash['Package'], hash['Version']))
  end

  class << self
    private

    def get_url(package, version)
      return '' if package.nil? || version.nil?

      BASE_URL.gsub('PACKAGE', package).gsub('VERSION', version.to_s)
    end

    def get_r_version_needed(dependencies)
      return '' if dependencies.nil?

      r_dependency = dependencies.upcase
                    .split(',')
                    .find do |str|
                      str.strip.start_with?('R ', 'R(')
                    end

      return '' if r_dependency.nil?

      r_dependency.tr('R()', '').delete(' ')
    end
  end
end
