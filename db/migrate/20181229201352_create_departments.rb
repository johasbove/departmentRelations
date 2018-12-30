class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name
      t.references :father, index: true

      t.timestamps
    end

    add_index :departments, [:name, :father_id], unique: true
  end
end
