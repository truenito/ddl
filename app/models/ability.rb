# Ability class, defines cancan permissions.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user && user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    else
      can :read, :allIU
    end
  end
end
