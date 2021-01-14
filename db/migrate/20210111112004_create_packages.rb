# frozen_string_literal: true

class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :version
      t.string :r_version_needed
      t.string :dependencies
      t.string :license
      t.string :url
    end
  end
end
