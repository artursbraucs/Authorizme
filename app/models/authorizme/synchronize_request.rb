module Authorizme
  class SynchronizeRequest < ActiveRecord::Base
    belongs_to :user
    belongs_to :requested_user, :class_name => "User"

    default_scope :joins => :requested_user

    scope :status_new, where(:status => "new")

    def as_json
      {id: self.id, status: self.status, requested_user: self.requested_user, created_at: self.created_at}
    end
  end
end