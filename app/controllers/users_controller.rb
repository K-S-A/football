class UsersController < ApplicationController
  authorize_resource

  def index
    @users = if params[:tournament_id]
               find_tournament
               @tournament.users
             else
               User.all
             end
  end

  private

  def find_tournament
    # TODO: ...
    @tournament = Tournament.find(params[:tournament_id])
    p @tournament.rated_by?(params[:user_id])
    render nothing: true, status: 400 if @tournament.rated_by?(params[:user_id])
  end
end
