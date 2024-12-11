# rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
class Pet < ApplicationRecord
  belongs_to :user
  belongs_to :pet_type
  belongs_to :city
  has_and_belongs_to_many :qualities
  has_many_attached :photos # Cambiado a `photos` para consistencia con el seed

  # Método para manejar la imagen por defecto si no hay fotos subidas
  def default_image
    if photos.attached?
      photos.first.variant(resize_to_limit: [500, 500]).processed
    else
      ActionController::Base.helpers.asset_path("default_pet.jpg") # Requiere que `default_pet.jpg` esté en `app/assets/images`
    end
  end

  # Validaciones
  validates :name, :description, :found_on, :city, presence: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }
end


# rubocop:enable Layout/SpaceInsideArrayLiteralBrackets
