class CreatePaymentMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_methods do |t|
      t.integer :user_id
      t.string :address_city
      t.string :address_country
      t.string :address_line1
      t.string :address_line2
      t.string :address_state
      t.string :address_zip
      t.string :address_line1_check
      t.string :address_zip_check
      t.string :cvc_check
      t.string :brand
      t.string :country
      # dynamic_last4 #: null
      t.string :exp_month
      t.string :exp_year
      t.string :funding #: "credit"
      t.string :stripe_id
      t.string :last4
      # metadata #: {}
      t.string :name
      t.string :object #: "card"
      # tokenization_method #: null
    end
  end
end
