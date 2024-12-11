class PetsController < ApplicationController
  before_action :set_pet, only: %i[show edit update destroy]

  # GET /pets or /pets.json
  def index
    @pagy, @pets = pagy(Pet.all, items: 20)
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
        format.html { redirect_to @pet, notice: "Pet was successfully created." }
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
        format.html { redirect_to @pet, notice: "Pet was successfully updated." }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1 or /pets/1.json
  def destroy
    @pet.destroy!

    respond_to do |format|
      format.html { redirect_to pets_path, status: :see_other, notice: "Pet was successfully destroyed." }
      format.json { head :no_content }
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
end
