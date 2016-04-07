class RegistrationsController < Devise::RegistrationsController
  def create
    # if Users.all == [] then @user.rank == 100
    # else => average users rank * 1.5
    #
    # higher rank - lower player skill
    params[:user][:rank] = (User.average(:rank) || 67) * 1.5
    super
  end

  protected

  def update_resource(resource, params)
    params.delete(:email)
    resource.update_without_password(params)
  end
end
