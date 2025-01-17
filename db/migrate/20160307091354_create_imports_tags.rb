class CreateImportsTags < ActiveRecord::Migration
  def change
    create_table :imports_tags do |t|
      t.references :configuration, null: false, index: true
      t.string :name, null: false
      t.string :target, null: false
      t.boolean :use, null: false, default: true

      t.timestamps null: false
    end
  end
end
