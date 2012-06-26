class AddStateToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :subscription_state, "ENUM('active', 'canceled')", :default => 'active' 
  end
end
