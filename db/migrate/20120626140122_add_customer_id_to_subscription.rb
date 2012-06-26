class AddCustomerIdToSubscription < ActiveRecord::Migration
  def change
     add_column :subscriptions, :customerID, :integer
  end
end
