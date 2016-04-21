class TournamentsController < ApplicationController
  before_action :find_tournament, only: [:show, :update, :destroy]

  authorize_resource only: [:create, :update, :destroy]

  def index
    @tournaments = if params[:user_id] && params[:status]
                     Tournament.unrated_tournaments(params[:user_id])
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
    if current_user.admin?
      @tournament.rank_users if tournament_closing?
      @tournament.update_attributes(tournament_params)
    else
      @tournament.users << current_user
    end

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

  def tournament_closing?
    tournament_params[:status] != @tournament.status && tournament_params[:status] == 'closed'
  end
end
