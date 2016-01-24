class Address < ActiveRecord::Base
  belongs_to :person

  after_create
end
