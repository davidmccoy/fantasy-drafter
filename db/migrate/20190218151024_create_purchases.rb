class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.integer :payment_method_id
      t.references :purchasable, polymorphic: true, index: true
      t.string :stripe_charge_id
      t.string :stripe_balance_transaction_id
      t.string :stripe_customer_id
      t.string :stripe_object
      t.bigint :amount
      t.bigint :amount_refunded
      t.string :currency
      t.text :description
      t.text :receipt_url
      t.jsonb :stripe_source, null: false, default: '{}'
    end
  end
end
