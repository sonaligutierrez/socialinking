class OnlyAdminsAuthorization < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    case subject
    when normalized(User)
      user.admin?
    when normalized(ScrapingLog)
      user.admin?
    when normalized(Category)
      user.admin?
    when normalized(PostCreator)
      if action == :update || action == :destroy
        user.admin?
      else
        true
      end
    when normalized(FacebookUser)
      if action == :update || action == :destroy
        user.admin?
      else
        true
      end
    else
      true
    end
  end
end
