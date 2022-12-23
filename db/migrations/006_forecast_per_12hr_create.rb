# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:forecast_per_12hrs) do
      primary_key :id

      Integer :pop
      Integer :min_temp
      Integer :max_temp

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
