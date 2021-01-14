# frozen_string_literal: true

# This is the "parent" service that recreates all packages in the database.
# It deletes all existing packages and calls the services that create and populate new ones.
# It's scheduled to run once a day (see `config/schedule.rb`)
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
