class MatchesController < ApplicationController
  before_action :find_round

  def index
    @matches = @round.matches
  end

  private

  def find_round
    @round = Round.find(params[:round_id])
  end
end
