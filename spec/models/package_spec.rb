require "rails_helper"

RSpec.describe Package do
  describe '.create_from_summary' do
    it 'creates a package with the correct attributes from the summary file' do
      summary = { "Package"=>"ActFrag",
                    "Version"=>"0.1.1",
                    "Depends"=>"R (>= 3.5.0),",
                    "Imports"=>"accelerometry, dplyr, ineq, survival, stats, tidyr",
                    "Suggests"=>"knitr, rmarkdown, testthat",
                    "License"=>"GPL-3",
                    "MD5sum"=>"027ebdd8affce8f0effaecfcd5f5ade2",
                    "NeedsCompilation"=>"no" }

      Package.create_from_summary(summary)

      package = Package.last
      expect(package.name).to eq('ActFrag')
      expect(package.version).to eq('0.1.1')
      expect(package.dependencies).to eq('R (>= 3.5.0),')
      expect(package.r_version_needed).to eq('>=3.5.0')
      expect(package.license).to eq('GPL-3')
      expect(package.url).to eq('http://cran.r-project.org/src/contrib/ActFrag_0.1.1.tar.gz')
    end

    it 'saves the correct r_version_required from various formats' do
      various_dependency_formats = ['Rglpk,rgl,corrplot,lattice,R (>= 2.10)', 'R(>= 2.10.1)', 'R (>= 3.5.0),', 'tuneR (>= 1.0), R (>= 2.10)', nil, 'corrplot']
      various_dependency_formats.each do |string|
        Package.create_from_summary({ 'Depends' => string })
      end

      expect(Package.pluck(:r_version_needed)).to match_array(['>=2.10', '>=2.10.1', '>=3.5.0', '>=2.10', '', ''])
    end
  end
end
