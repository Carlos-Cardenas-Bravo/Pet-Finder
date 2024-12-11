# rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
class ApplicationController < ActionController::Base
  include Pagy::Backend
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Aplica la autenticación en toda la aplicación, excepto en los controladores de Devise y en la acción `index` de WelcomeController
  before_action :authenticate_user!, unless: :devise_or_welcome_index?

# Redirige después del inicio de sesión
def after_sign_in_path_for(resource)
  pets_path # Cambiar a la lógica principal de la aplicación
end

  protected

  # Método que excluye los controladores de Devise y la acción index de WelcomeController
  def devise_or_welcome_index?
    devise_controller? || (controller_name == "welcome" && action_name == "index")
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nombre, :phone, :profile_image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nombre, :phone, :profile_image])
  end
end

# rubocop:enable Layout/SpaceInsideArrayLiteralBrackets
