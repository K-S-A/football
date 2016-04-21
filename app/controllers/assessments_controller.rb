class AssessmentsController < ApplicationController
  authorize_resource only: [:create]

  def create
    Assessment.transaction do
      assessments_params.each.with_index do |param, i|
        param[:score] = i
        param[:user_id] = i != 10 ? current_user.id : nil
        param[:tournament_id] = params[:tournament_id]

        Assessment.create!(param)
      end
    end

    render nothing: true
  end

  private

  def assessments_params
    params.permit(assessments: [:rated_user_id, :score, :user_id, :tournament_id]).require(:assessments)
  end
end
