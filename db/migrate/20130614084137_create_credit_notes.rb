class CreateCreditNotes < ActiveRecord::Migration
  def change
    create_table :credit_notes do |t|
    	t.integer :outlet_id
      t.string :credit_note_number
      t.date :credit_date
      t.text :remark
      t.boolean :posted

      t.timestamps
    end
  end
end
