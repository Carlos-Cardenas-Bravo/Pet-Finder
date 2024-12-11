json.extract! pet, :id, :name, :nickname, :is_nickname, :pet_type, :description, :found_on, :city, :qualities, :contact_name, :contact_email, :contact_phone, :user_id, :created_at, :updated_at
json.url pet_url(pet, format: :json)
