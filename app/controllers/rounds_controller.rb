class RoundsController < ApplicationController
  before_action :find_tournament, only: [:index, :create, :show]

  authorize_resource only: [:create]
  load_and_authorize_resource only: [:update, :destroy, :index_teams]

  def index
    @rounds = @tournament.rounds.includes(teams: :users)
  end

  def show
    @round = @tournament.rounds.find(params[:id])
    find_teams
  end

  def create
    @round = @tournament.rounds.create!(round_params)

    render @round
  end

  def update
    @round.update_attributes!(round_params)

    find_teams

    render 'show'
  end

  def destroy
    @round.destroy

    render nothing: true
  end

  def remove_team
    @round = Round.find(params[:round_id])
    team = @round.teams.find(params[:id])
    @round.teams.delete(team)

    find_teams

    render 'show'
  end

  def index_teams
    @teams = @round.teams

    render 'teams/index'
  end

  private

  def round_params
    params.require(:round).permit(:mode, :team_id, team_ids: [])
  end

  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def find_teams
    @teams = @round.stats
  end
end
