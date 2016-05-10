class TournamentsController < ApplicationController
  before_action :find_tournament, only: [:show, :update, :destroy, :index_teams, :destroy_teams, :join, :remove_user]

  authorize_resource only: [:create, :update, :destroy]

  def index
    @tournaments = if params[:status] == 'completed'
                     current_user.unrated_tournaments
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
    @tournament.rank_users if tournament_closing?
    @tournament.update_attributes!(tournament_params)

    render 'show'
  end

  def destroy
    @tournament.destroy

    render_nothing_with(200)
  end

  def index_teams
    @teams = @tournament.teams

    render 'teams/index'
  end

  def destroy_teams
    @tournament.teams.destroy_all

    render nothing: true
  end

  def join
    @tournament.users << current_user

    render nothing: true
  end

  def remove_user
    user = @tournament.users.find(params[:user_id])
    @tournament.users.delete(user)

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
