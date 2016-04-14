class RoundsController < ApplicationController
  before_action :find_tournament, only: [:index, :create]

  authorize_resource only: [:create, :update, :destroy]

  def index
    @rounds = @tournament.rounds.includes(teams: :users)
  end

  def show
    @round = Round.where('tournament_id = ?', params[:tournament_id]).find(params[:id])
    @teams = Team.round_stats(params[:id])
  end

  def create
    @round = @tournament.rounds.create(round_params)

    render @round
  end

  private

  def round_params
    params.require(:round).permit(:mode)
  end

  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
