class AddCreditNoteCodeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :credit_note_code, :string, :default => "CN", :limit => 5
    add_column :settings, :credit_note_last_number, :integer, :default => 10000
  end
end
