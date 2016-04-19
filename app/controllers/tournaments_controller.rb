class TournamentsController < ApplicationController
  before_action :find_tournament, only: [:show, :update, :destroy]

  authorize_resource only: [:create, :update, :destroy]

  def index
    @tournaments = if params[:user_id] && params[:status]
                     find_user.tournaments.where(status: params[:status])
                   else
                     Tournament.includes(:users, :rounds).all
                   end
  end

  def create
    @tournament = Tournament.create!(tournament_params)
  end

  def show
  end

  def update
    @tournament.update_attributes(tournament_params)

    render 'show'
  end

  def destroy
    @tournament.destroy

    render nothing: true
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :status, :sports_kind, :team_size, user_ids: [])
  end

  def find_tournament
    # TODO: n+1 query
    @tournament = Tournament.includes(:rounds, teams: :users).find(params[:id])
  end

  def find_user
    User.find(params[:user_id])
  end
end
