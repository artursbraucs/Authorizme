module Authorizme
  class SynchronizeRequest < ActiveRecord::Base
    belongs_to :user
    belongs_to :requested_user, :class_name => "User"

    scope :status_new, joins(:requested_user).where(:status => "new")

    def as_json
      {id: self.id, status: self.status, requested_user: self.requested_user, created_at: self.created_at}
    end
  end
end