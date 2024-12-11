require 'csv'
require 'faker'
require 'httparty'
require 'open-uri'

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

=end

# Eliminar mascotas existentes
puts "Eliminando mascotas existentes..."
Pet.destroy_all

# URL base de la API de Pexels
PEXELS_API_URL = "https://api.pexels.com/v1/search"

# Método para obtener fotos de mascotas desde Pexels
def fetch_pet_photos
  headers = { "Authorization" => ENV["PEXELS_API_KEY"] }
  response = HTTParty.get(PEXELS_API_URL, headers: headers, query: { query: "pets", per_page: 25 })

  if response.success?
    response["photos"].map { |photo| photo["src"]["medium"] }
  else
    puts "Error al obtener fotos de Pexels: #{response.body}"
    []
  end
end

# Obtener fotos de Pexels
puts "Obteniendo fotos de Pexels..."
photos = fetch_pet_photos
if photos.empty?
  puts "No se obtuvieron fotos. Por favor, revisa tu clave de API."
  exit
end

# Crear 25 mascotas con fotos aleatorias y datos simulados
puts "Creando mascotas..."
photos.each_with_index do |photo_url, index|
  begin
    pet = Pet.create!(
      name: Faker::Creature::Dog.name,
      nickname: Faker::Creature::Dog.sound,
      is_nickname: [true, false].sample,
      pet_type_id: PetType.all.sample.id, # Esto selecciona un ID válido de PetType
      description: Faker::Lorem.paragraph,
      found_on: Faker::Date.backward(days: 30),
      city: City.all.sample, # Asocia directamente la ciudad
      qualities: Quality.all.sample(3), # Asocia cualidades directamente
      contact_email: Faker::Internet.unique.email, # Asegura correos válidos
      user: User.all.sample
    )

    # Asignar cualidades de forma única
    unique_qualities = Quality.all.sample(3)
    unique_qualities.each do |quality|
      pet.qualities << quality unless pet.qualities.include?(quality)
    end

    # Adjuntar foto desde la URL
    file = URI.open(photo_url)
    pet.photos.attach(io: file, filename: "photo_#{index}.jpg", content_type: "image/jpeg")

    puts "Mascota #{pet.name} creada con éxito."
  rescue ActiveRecord::RecordInvalid => e
    puts "Error creando mascota: #{e.message}"
  rescue StandardError => e
    puts "Error general: #{e.message}"
  end
end

puts "25 mascotas creadas con fotos de Pexels."