class MatchesController < ApplicationController
  before_action :find_round, only: [:index, :create, :update]

  authorize_resource only: [:create, :update]
  load_and_authorize_resource only: [:destroy]

  def index
    @matches = @round.matches
  end

  # TODO: reduce complexity
  def create
    match = params[:match]

    case
    when !match.key?(:team_ids)
      @match = @round.matches.create!(match_params)
    when match[:team_ids]
      @matches = @round.generate_matches(match[:count])
    else render nothing: true, status: 400
    end
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

  private

  def match_params
    params.require(:match).permit(:host_score, :guest_score, :host_team_id, :guest_team_id, :next_id)
  end

  def find_round
    @round = Round.find(params[:round_id])
  end
end
