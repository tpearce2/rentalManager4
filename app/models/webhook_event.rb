class WebhookEvent < ActiveRecord::Base
  attr_accessible :description, :event_type
end
