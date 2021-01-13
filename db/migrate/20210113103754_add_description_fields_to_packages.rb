class AddDescriptionFieldsToPackages < ActiveRecord::Migration[6.0]
  def change
    add_column :packages, :title, :text
    add_column :packages, :publication_date, :datetime
    add_column :packages, :authors, :text
    add_column :packages, :maintainers, :text
  end
end
