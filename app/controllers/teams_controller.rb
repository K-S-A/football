class TeamsController < ApplicationController
  def index
    @teams = if params[:tournament_id]
      Team.where('tournament_id = ?', params[:tournament_id])
    else
      Team.all
    end
  end
end
