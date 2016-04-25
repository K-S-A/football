class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    case
    when user.admin?
      can :manage, :all
    when user.persisted?
      can :update, Tournament
      can :create, Assessment
      can :read, :all
      cannot :read, User
    else
      can :read, :all
      cannot :read, User
    end
  end
end
