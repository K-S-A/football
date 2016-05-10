class MatchesController < ApplicationController
  before_action :find_round, only: [:index, :create, :update, :generate]

  authorize_resource only: [:create, :update]
  load_and_authorize_resource only: [:destroy]

  def index
    @matches = @round.matches
  end

  def create
    @match = @round.matches.create!(match_params)
  end

  def update
    @match = @round.matches.find(params[:id])
    @match.update_attributes!(match_params)

    render 'create'
  end

  def destroy
    @match.destroy

    render nothing: true
  end

  def generate
    @matches = @round.generate_matches(games_count)

    render 'index'
  end

  private

  def match_params
    params.require(:match).permit(:host_score, :guest_score, :host_team_id, :guest_team_id, :next_id)
  end

  def find_round
    @round = Round.find(params[:round_id])
  end

  def games_count
    params[:match] && params[:match][:count].to_i || 1
  end
end
