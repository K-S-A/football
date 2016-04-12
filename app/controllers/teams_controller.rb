class TeamsController < ApplicationController
  before_action :find_team, only: [:show]

  def index
    @teams = Team.includes(:users).where('tournament_id = ?', params[:tournament_id])
  end

  def show
  end

  def create
    if params[:team][:team_size]
      @teams = Team.batch_generate(params[:tournament_id], params[:team][:team_size])
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
