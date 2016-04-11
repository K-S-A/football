class TournamentsController < ApplicationController
  before_action :find_tournament, only: [:show, :update]

  def index
    @tournaments = Tournament.includes(:users).all
  end

  def create
    @tournament = Tournament.create(tournament_params)
  end

  def show
  end

  def update
    params[:tournament][:user_ids] ||= []
    @tournament.update_attributes(tournament_params)

    render 'show'
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :status, :sports_kind, :team_size, user_ids: [])
  end

  def find_tournament
    #TODO - n+1 query
    @tournament = Tournament.includes(teams: :users).find(params[:id])
  end
end
