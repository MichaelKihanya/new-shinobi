class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :amount
      t.string :status
      t.string :stripe_payment_intent_id
      t.string :printify_order_id
      t.string :customer_email
      t.text :shipping_address

      t.timestamps
    end
  end
end
