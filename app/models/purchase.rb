class Purchase < ApplicationRecord
  belongs_to :purchasable, polymorphic: true
  belongs_to :user
  belongs_to :payment_method
end
