
require 'faker'

# Eliminar datos existentes
puts "Eliminando usuarios existentes..."
User.destroy_all

# Ruta de la imagen por defecto
image_path = Rails.root.join("app/assets/images/default_profile.png")

# Crear usuarios regulares
puts "Creando usuarios regulares..."
10.times do
  user = User.create!(
    nombre: Faker::Name.first_name,
    email: Faker::Internet.unique.email,
    phone: Faker::Number.leading_zero_number(digits: rand(9..15)), # Genera números de entre 9 y 15 dígitos
    password: "123456",
    role: 0
  )
  user.profile_image.attach(io: File.open(image_path), filename: "default_profile.png", content_type: "image/png")
end
puts "10 usuarios regulares creados con imagen de perfil predeterminada."

# Crear usuario administrador
puts "Creando administrador..."
admin = User.create!(
  nombre: "Administrador",
  email: "admin@admin.com",
  phone: "999999999", # Número fijo válido
  password: "123456",
  role: 1
)
admin.profile_image.attach(io: File.open(image_path), filename: "default_profile.png", content_type: "image/png")
puts "Administrador creado con éxito con imagen de perfil predeterminada."

puts "Seed completado con éxito."
