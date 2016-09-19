class CreateTrainingLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :training_logs do |t|
      t.string :root_domain, index: true, null: false
      t.string :uri, null: false
      t.string :trained_status, default: 'untrained', index: true, null: false
      t.timestamps
    end

    add_index :training_logs, [:root_domain, :trained_status]
    add_index :training_logs, :uri, unique: true
  end
end
