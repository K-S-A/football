class TeamsController < ApplicationController
  def index
    @teams = Team.includes(:users).where('tournament_id = ?', params[:tournament_id])
  end

  def show
    @team = Team.find(params[:id])
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    render nothing: true
  end
end
