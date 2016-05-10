class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    case
    when user.admin?
      can :manage, :all
    when user.persisted?
      can :read, :all
      cannot :index, User
      can :update, Tournament
      can :create, Assessment
      can :index_teams, :all
      can :join, Tournament
    else
      can :read, :all
      cannot :index, User
      can :index_teams, :all
    end
  end
end
