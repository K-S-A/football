class MatchesController < ApplicationController
  before_action :find_round, only: [:index, :create]

  authorize_resource only: [:create]
  load_and_authorize_resource only: [:destroy]

  def index
    @matches = @round.matches
  end

  def create
    @match = @round.matches.create(match_params)
  end

  def destroy
    @match.destroy

    render nothing: true
  end

  private

  def match_params
    params.require(:match).permit(:host_score, :guest_score, :host_team_id, :guest_team_id)
  end

  def find_round
    @round = Round.find(params[:round_id])
  end
end
