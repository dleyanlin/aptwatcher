Sequel.migration do
  up do
    Sequel::Model.db.run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table(:hosts) do
      String :name, primary_key: true
      column :packages, "text[]", default: "{}"
      DateTime :last_report_at
    end
  end

  down do
    drop_table(:hosts)
  end
end
