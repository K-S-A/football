class TeamsController < ApplicationController
  authorize_resource

  before_action :find_tournament, only: [:create, :generate]
  before_action :find_team, only: [:show, :update, :destroy, :remove_user]

  def show
  end

  def create
    @team = @tournament.teams.create!(team_params)
  end

  def update
    @team.update_attributes!(team_params)

    render 'create'
  end

  def destroy
    @team.destroy

    render nothing: true
  end

  def generate
    @teams = @tournament.generate_teams

    render 'index'
  end

  def remove_user
    @team.users.destroy(find_user)

    render nothing: true
  end

  private

  def team_params
    params.require(:team).permit(:name, :list_order_position, user_ids: [])
  end

  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def find_team
    @team = Team.find(params[:id])
  end

  def find_user
    User.find(params[:user_id])
  end
end
