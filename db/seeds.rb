require 'csv'
require 'faker'

=begin
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
=end

# Crear tipos de mascotas
puts "Creando tipos de mascotas..."
["Perro", "Gato", "Ave"].each do |type|
  PetType.find_or_create_by!(name: type)
end
puts "Tipos de mascotas creados con éxito."

# Crear ciudades desde CSV
puts "Creando ciudades..."
if File.exist?(Rails.root.join('db/cities.csv'))
  CSV.foreach(Rails.root.join('db/cities.csv')) do |row|
    City.find_or_create_by!(name: row[0])
  end
  puts "Ciudades creadas con éxito."
else
  puts "Archivo 'cities.csv' no encontrado. Asegúrate de colocarlo en 'db/'."
end

# Crear cualidades
puts "Eliminando cualidades existentes..."
Quality.delete_all

qualities = [
  "Le gusta correr en el parque",
  "Disfruta nadar en el lago",
  "Prefiere dormir durante el día",
  "Siempre está listo para comer",
  "Le encanta volar",
  "Es amigable con otros animales",
  "Le gusta jugar con juguetes",
  "Disfruta de los paseos largos",
  "Le encanta ser acariciado",
  "Es curioso y le gusta explorar"
]

puts "Creando cualidades..."
qualities.each do |quality|
  Quality.find_or_create_by!(name: quality)
end
puts "Cualidades creadas con éxito."