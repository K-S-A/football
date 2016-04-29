class UsersController < ApplicationController
  authorize_resource
  load_resource only: [:show]

  def index
    @users = if params[:tournament_id]
               find_tournament
               @tournament.users
             else
               User.all
             end
  end

  def show
  end

  private

  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])

    render nothing: true, status: 400 if @tournament.rated_by?(params[:user_id])
  end
end
