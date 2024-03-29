class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  skip_before_filter :verify_authenticity_token, :only => :create
# before_action :configure_account_update_params, only: [:update]
  respond_to :json, :js

  # GET /resource/sign_up
  def new
    @regalo = Regalo.find(params[:id_regalo])
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    @regalo = Regalo.find(params[:regalo])
    resource.invite_code = params[:user][:invite_code]
    resource.skip_password_validation = true
    if resource.save
      @regalo.user = resource
      @regalo.state = 1
      @regalo.save
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)

      render "regalos/confirmation"
      # respond_to do |format|
      #   format.js {redirect_to controller: '/regalos', action: 'confirmation', user: resource.id, regalo: @regalo.id, format: :js}
      # end
      #respond_with resource, location: after_sign_up_path_for(resource)
    else
      resource.invite_code = ""
      @error_message = resource.errors.full_messages
      render "users/registrations/new"
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:invite_code, :name, :img_contact])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
