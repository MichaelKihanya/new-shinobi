class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :printify_id
      t.string :stripe_price_id
      t.boolean :active

      t.timestamps
    end
  end
end
