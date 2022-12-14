# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:regions) do
      primary_key :id

      String :country
      String :city, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
