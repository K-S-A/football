class RoundsController < ApplicationController
  def index
    @rounds = Round.includes(teams: :users).where('tournament_id = ?', params[:tournament_id])
  end

  def show
    @round = Round.where('tournament_id = ?', params[:tournament_id]).find(params[:id])
    @teams = Team.round_stats(params[:id])
  end
end
