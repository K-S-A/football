class AssessmentsController < ApplicationController
  authorize_resource only: [:create]

  def create
    @assessments = Assessment.create!(assessments_params)

    render nothing: true
  end

  private

  def assessments_params
    params[:assessments] = params[:assessments].map.with_index do |a, i|
      a[:score] = i
      a[:user_id] = current_user.id
      a[:tournament_id] = params[:tournament_id]
      a
    end

    params.permit(assessments: [:rated_user_id, :score, :user_id, :tournament_id]).require(:assessments)
  end
end
