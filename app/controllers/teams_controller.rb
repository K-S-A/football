class TeamsController < ApplicationController
  def index
    @teams = if params[:tournament_id]
      Team.where('tournament_id = ?', params[:tournament_id])
    else
      Team.all
    end
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
