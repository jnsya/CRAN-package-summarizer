require "rails_helper"

RSpec.describe SummarizePackages do
  it "creates the correct number of packages" do
    MockFTPClient = Struct.new(:url) do
      def get(_url, _destination)
        File.read(Rails.root.join('spec', 'fixtures', 'packages_overview_example'))
      end

      def login
      end

      def close
      end
    end

    mock_ftp_client = MockFTPClient.new
    service = SummarizePackages.new(ftp_client: mock_ftp_client)

    expect(mock_ftp_client).to receive(:login)
    expect(mock_ftp_client).to receive(:close)

    service.call

    expect(Package.count).to eq(3)

    package = Package.find_by(name: 'A3')
    expect(package).not_to eq(nil)
    expect(package.version).to eq('1.0.0')
    expect(package.r_version_needed).to eq('>=2.15.0')
    expect(package.license).to eq('GPL (>= 2)')
    expect(package.dependencies).to eq('R (>= 2.15.0), xtable, pbapply')
  end
end