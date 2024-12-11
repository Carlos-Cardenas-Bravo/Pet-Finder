# rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
class Pet < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  # Imagen por defecto si no se suben imágenes
  def default_image
    if images.attached?
      images.first.variant(resize_to_limit: [500, 500]).processed
    else
      "default_pet.jpg" # Coloca esta imagen en `app/assets/images`
    end
  end

  validates :name, :description, :found_on, :city, presence: true
  validates :pet_type, inclusion: { in: %w[Perro Gato Ave], message: "%{value} no es un tipo válido" }
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }
end

# rubocop:enable Layout/SpaceInsideArrayLiteralBrackets
