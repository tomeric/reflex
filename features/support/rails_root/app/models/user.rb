class User < ActiveRecord::Base
  acts_as_authentic
  
  def react_profile=(profile)
    self.name = profile['real_name'] || profile['user_name']
  end
end
