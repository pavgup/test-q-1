class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.references :order
      t.references :product

      t.timestamps
    end
    add_index :line_items, :order_id
    add_index :line_items, :product_id
  end
end
