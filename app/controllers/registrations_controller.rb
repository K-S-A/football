class RegistrationsController < Devise::RegistrationsController
  def create
    # if Users.count == 0 then @user.rank == 0
    # else => average users rank * 1.5
    #
    # higher rank - lower player skill
    params[:user][:rank] = (User.average(:rank) || 0) * 1.5
    super
  end

  protected

  def update_resource(resource, params)
    params.delete(:email)
    resource.update_without_password(params)
  end
end
