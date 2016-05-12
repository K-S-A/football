class RoundsController < ApplicationController
  authorize_resource
  load_resource only: [:update, :destroy, :index_teams, :remove_team]

  before_action :find_tournament, only: [:index, :create, :show]

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
    team = @round.teams.find(params[:team_id])
    @round.teams.delete(team)

    find_teams

    render 'show'
  end

  def index_teams
    @teams = @round.teams.includes(:users)

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
