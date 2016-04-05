class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @tournaments = Tournament.all
  end

  def create
    @tournament = current_user.tournaments.create(tournament_params)
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :status)
  end
end
