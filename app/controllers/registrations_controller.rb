class RegistrationsController < Devise::RegistrationsController
  def create
    params[:user][:rank] = (User.average(:rank) || 0) * 0.7
    super
  end

  protected

  def update_resource(resource, params)
    params.delete(:email)
    resource.update_without_password(params)
  end
end
