class AssessmentsController < ApplicationController
  before_action :find_user

  authorize_resource only: [:index]

  def index
    @assessments = @user.assessments.where(tournament_id: params[:tournament_id])
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
