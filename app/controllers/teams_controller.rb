class TeamsController < ApplicationController
  before_action :find_tournament, only: [:index, :create, :destroy], if: -> { params[:tournament_id] }
  before_action :find_team, only: [:show, :update, :destroy], unless: -> { params[:tournament_id] }

  authorize_resource only: [:create, :update, :destroy]

  def index
    @teams = if params[:round_id]
               Round.find(params[:round_id]).teams
             else
               @tournament.teams
             end
  end

  def show
  end

  def create
    if params[:team][:team_size]
      @teams = @tournament.generate_teams
    else
      @team = @tournament.teams.create!(team_params)
    end
  end

  def update
    @team.users = [] if params[:team][:user_ids].nil?
    @team.update_attributes!(team_params)

    render 'create'
  end

  def destroy
    case
    when @tournament
      @tournament.teams.destroy_all
    when params[:user_id]
      @team.users.destroy(find_user)
    else
      @team.destroy
    end

    render nothing: true
  end

  private

  def team_params
    params.require(:team).permit(:name, :list_order_position, user_ids: [])
  end

  def find_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def find_team
    @team = Team.find(params[:id])
  end

  def find_user
    User.find(params[:user_id])
  end
end
