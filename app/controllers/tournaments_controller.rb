class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :find_tournament, only: [:show, :update]

  def index
    @tournaments = Tournament.all
  end

  def create
    @tournament = Tournament.create(tournament_params)
  end

  def show
  end

  def update
    @tournament.update_attributes(tournament_params)

    render 'show'
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :status, :game_type, :team_size, user_ids: [])
  end

  def find_tournament
    @tournament = Tournament.find(params[:id])
  end
end
