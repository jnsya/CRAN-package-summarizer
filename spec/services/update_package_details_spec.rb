require "rails_helper"

RSpec.describe UpdatePackageDetails do
  it "updates existing packages with data from the description file of a compressed package archive" do
    package = Package.create(name: "ForestFit")
    mock_http_client = class_double("URI")
    compressed_package = File.new(Rails.root.join("spec", "fixtures", "compressed_package.tar.gz"))
    service = UpdatePackageDetails.new(http_client: mock_http_client)
    expect(mock_http_client).to receive(:parse).and_return(compressed_package)

    service.call

    expect(package.reload.title).to eq('Statistical Modelling for Plant Size Distributions')
    expect(package.authors).to eq('Mahdi Teimouri')
    expect(package.maintainers).to eq('Mahdi Teimouri <teimouri@aut.ac.ir>')
    expect(package.publication_date).to eq(Date.new(2020,7,8))
  end
end
