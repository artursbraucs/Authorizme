class User < ActiveRecord::Base
  #Relations
  belongs_to :origin_provider, :class_name => "UserProvider"
  has_many :providers, :class_name => "UserProvider"
end