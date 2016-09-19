class CreateDomainEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :domain_entries do |t|
      t.string :data_type, null: false
      t.string :method, null: false
      t.string :pattern, null: false
      t.references :domain
      t.timestamps
    end
  end
end
