require "rails_helper"

RSpec.describe RecreateAllPackages do
  it "deletes all packages and calls the services to create new ones" do
    create_packages = instance_double("CreatePackagesFromList.new")
    update_package_details = instance_double("UpdatePackageDetails.new")
    service = RecreateAllPackages.new(create_packages: create_packages, update_package_details: update_package_details)

    expect(Package).to receive(:delete_all)
    expect(create_packages).to receive(:call)
    expect(update_package_details).to receive(:call)

    service.call
  end
end
