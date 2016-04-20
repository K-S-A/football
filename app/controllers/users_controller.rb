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

    if @tournament.assessments.where(user_id: current_user.id).count > 0
      render nothing: true, status: 400
    end
  end
end
