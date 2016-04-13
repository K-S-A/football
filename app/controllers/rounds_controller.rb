class RoundsController < ApplicationController
  def index
    @rounds = Round.includes(teams: :users).where('tournament_id = ?', params[:tournament_id])
  end
end
