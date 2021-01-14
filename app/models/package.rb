class Package < ApplicationRecord
  BASE_URL = 'http://cran.r-project.org/src/contrib/PACKAGE_VERSION.tar.gz'

  def self.create_from_summary(summary)
    self.create(name:             summary["Package"],
                version:          summary['Version'],
                r_version_needed: get_r_version_needed(summary['Depends']),
                license:          summary['License'],
                dependencies:     summary['Depends'],
                url:              get_url(summary['Package'], summary['Version']))
  end

  def update_from_description(description)
    description = convert_dcf_to_hash(description)

    begin
      update(title: description["Title"], authors: description['Author'], maintainers: description['Maintainer'], publication_date: description['Date/Publication'].to_date)
    rescue ActiveRecord::StatementInvalid
      Rails.logger.info "There was a problem with: #{package.id}. Check the encoding."
    end
  end

  private

  def convert_dcf_to_hash(dcf_string)
    dcf_string.split("\n").map do |str|
      str.split(":", 2).map(&:strip)
    end.select do |arr|
      arr.count == 2
    end.to_h
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
