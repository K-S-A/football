class RoundsController < ApplicationController
  before_action :find_tournament, only: [:index, :create, :show]

  authorize_resource only: [:create]
  load_and_authorize_resource only: [:update, :destroy]

  def index
    @rounds = @tournament.rounds.includes(teams: :users)
  end

  def show
    @round = @tournament.rounds.find(params[:id])
    find_teams
  end

  def create
    @round = @tournament.rounds.create(round_params)

    render @round
  end

  def update
    @round.update_attributes(round_params)
    find_teams

    render 'show'
  end

  def destroy
    if params[:team_id]
      team = @round.teams.find(params[:team_id])
      @round.teams.delete(team)
      find_teams

      render 'show'
    else
      @round.destroy

      render nothing: true
    end
  end

  private

  def round_params
    params.require(:round).permit(:mode, team_ids: [])
  end

  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def find_teams
    @teams = Team.round_stats(params[:id])
  end
end
