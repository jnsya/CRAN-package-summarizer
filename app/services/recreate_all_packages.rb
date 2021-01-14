# frozen_string_literal: true

class RecreateAllPackages
  def initialize(create_packages: CreatePackagesFromList.new, update_package_details: UpdatePackageDetails.new)
    self.create_packages = create_packages
    self.update_package_details = update_package_details
  end

  def call
    Package.delete_all
    create_packages.call
    update_package_details.call
  end

  private

  attr_accessor :create_packages, :update_package_details
end
