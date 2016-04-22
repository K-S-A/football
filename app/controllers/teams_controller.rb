class TeamsController < ApplicationController
  before_action :find_team, only: [:show]

  authorize_resource only: [:create, :update, :destroy]

  def index
    @teams = Team.includes(:users).where('tournament_id = ?', params[:tournament_id])
  end

  def show
  end

  def create
    if params[:team][:team_size]
      @tournament = Tournament.find(params[:tournament_id])
      @teams = @tournament.generate_teams(params[:team][:team_size])
    else
      @team = Team.create!(team_params)
    end
  end

  def destroy
    if params[:tournament_id]
      Team.where('tournament_id = ?', params[:tournament_id]).destroy_all
    else
      find_team
      @team.destroy
    end

    render nothing: true
  end

  private

  def team_params
    params.require(:team).permit(:name, user_ids: [])
  end

  def find_team
    @team = Team.find(params[:id])
  end
end
