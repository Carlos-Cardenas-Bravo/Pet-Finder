class PetsController < ApplicationController
  before_action :set_pet, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[edit update]
  before_action :authorize_admin!, only: %i[destroy]
  require 'pagy/extras/bulma'

  def search
    query = params[:query]
    @pets = if query.present?
              Pet.where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
            else
              Pet.all
            end
  end

  # GET /pets or /pets.json
  def index
    @pagy, @pets = pagy(Pet.all, items: 10)
  end

  # GET /pets/1 or /pets/1.json
  def show
  end

  # GET /pets/new
  def new
    @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets or /pets.json
  def create
    @pet = current_user.pets.new(pet_params)

    # Assign contact information from the current user
    @pet.contact_name = current_user.nombre
    @pet.contact_email = current_user.email
    @pet.contact_phone = current_user.phone

    respond_to do |format|
      if @pet.save
        format.html { redirect_to @pet, notice: "La mascota fue creada con éxito." }
        format.json { render :show, status: :created, location: @pet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1 or /pets/1.json
  def update
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @pet, notice: "La mascota fue actualizada con éxito." }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1 or /pets/1.json
  def destroy
    if current_user.admin?
      @pet.destroy!
      respond_to do |format|
        format.html { redirect_to pets_path, status: :see_other, notice: "La mascota fue eliminada con éxito." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.js { render 'unauthorized_destroy' } # Renderiza un archivo JS con la advertencia
        format.html { redirect_back fallback_location: pets_path, alert: "No tienes permiso para eliminar esta mascota." }
        format.json { head :forbidden }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pet
    @pet = Pet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pet_params
    params.require(:pet).permit(:name, :nickname, :is_nickname, :pet_type_id, :description, :found_on, :city_id, quality_ids: [], photos: [])
  end

  # Permitir solo que el usuario correspondiente o un administrador editen y actualicen.
  def authorize_user!
    unless current_user.admin? || @pet.user == current_user
      redirect_to pets_path, alert: "No tienes permiso para realizar esta acción.", status: :forbidden
    end
  end

  # Solo permitir que administradores eliminen mascotas.
  def authorize_admin!
    unless current_user.admin?
      redirect_to pets_path, alert: "Solo los administradores pueden eliminar mascotas.", status: :forbidden
    end
  end
end
