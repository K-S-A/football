class RoundsController < ApplicationController
  before_action :find_tournament, only: [:index, :create, :show]

  load_resource only: [:destroy]
  authorize_resource only: [:create, :update, :destroy]

  def index
    @rounds = @tournament.rounds.includes(teams: :users)
  end

  def show
    @round = @tournament.rounds.find(params[:id])
    @teams = Team.round_stats(params[:id])
  end

  def create
    @round = @tournament.rounds.create(round_params)

    render @round
  end

  def destroy
    if params[:team_id]
      team = @round.teams.find(params[:team_id])
      @round.teams.delete(team)
    else
      @round.destroy
    end

    render nothing: true
  end

  private

  def round_params
    params.require(:round).permit(:mode)
  end

  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
