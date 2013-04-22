class AddCancelNoteToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :cancel_note, :text
  end
end
