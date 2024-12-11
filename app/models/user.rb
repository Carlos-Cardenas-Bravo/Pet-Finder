# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  nombre                 :string
#  apellido               :string
#  role                   :integer          default("normal_user")
#  edad                   :integer
#  sexo                   :string
#  receive_updates        :boolean
#
# rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
class User < ApplicationRecord
  has_many :pets, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { normal_user: 0, admin: 1 }

  def admin?
    role == "admin"
  end

  def normal_user?
    role == "normal_user"
  end

  has_one_attached :profile_image     # (para una sola imagen, si necesito más --> as_many_attached :images)

  def resized_profile_image
    if profile_image.attached?
      profile_image.variant(resize_to_limit: [200, 200]).processed
    else
      # Usa la imagen predeterminada y aplica el mismo redimensionamiento
      Rails.root.join("app/assets/images/default_profile.png").open do |file|
        variant = ActiveStorage::Blob.create_and_upload!(
          io: file,
          filename: "default_profile.png",
          content_type: "image/png"
        )
        variant.variant(resize_to_limit: [200, 200]).processed
      end
    end
  end

  # Validations
  validates :nombre, presence: true, length: { maximum: 50 }
  validates :email, :phone, presence: true
  validates :email, uniqueness: true
  validates :phone, format: { with: /\A\d{9,15}\z/, message: "debe tener entre 9 y 15 dígitos" }

  # Rol por defecto
  after_initialize :set_default_role, if: :new_record? # (Este callback establece el rol predeterminado (normal_user) para nuevos registros si no se especifica uno)

  private

  def set_default_role
      self.role ||= :normal_user
  end
end

# rubocop:enable Layout/SpaceInsideArrayLiteralBrackets
