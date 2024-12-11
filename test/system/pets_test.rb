require "application_system_test_case"

class PetsTest < ApplicationSystemTestCase
  setup do
    @pet = pets(:one)
  end

  test "visiting the index" do
    visit pets_url
    assert_selector "h1", text: "Pets"
  end

  test "should create pet" do
    visit pets_url
    click_on "New pet"

    fill_in "City", with: @pet.city
    fill_in "Contact email", with: @pet.contact_email
    fill_in "Contact name", with: @pet.contact_name
    fill_in "Contact phone", with: @pet.contact_phone
    fill_in "Description", with: @pet.description
    fill_in "Found on", with: @pet.found_on
    check "Is nickname" if @pet.is_nickname
    fill_in "Name", with: @pet.name
    fill_in "Nickname", with: @pet.nickname
    fill_in "Pet type", with: @pet.pet_type
    fill_in "Qualities", with: @pet.qualities
    fill_in "User", with: @pet.user_id
    click_on "Create Pet"

    assert_text "Pet was successfully created"
    click_on "Back"
  end

  test "should update Pet" do
    visit pet_url(@pet)
    click_on "Edit this pet", match: :first

    fill_in "City", with: @pet.city
    fill_in "Contact email", with: @pet.contact_email
    fill_in "Contact name", with: @pet.contact_name
    fill_in "Contact phone", with: @pet.contact_phone
    fill_in "Description", with: @pet.description
    fill_in "Found on", with: @pet.found_on
    check "Is nickname" if @pet.is_nickname
    fill_in "Name", with: @pet.name
    fill_in "Nickname", with: @pet.nickname
    fill_in "Pet type", with: @pet.pet_type
    fill_in "Qualities", with: @pet.qualities
    fill_in "User", with: @pet.user_id
    click_on "Update Pet"

    assert_text "Pet was successfully updated"
    click_on "Back"
  end

  test "should destroy Pet" do
    visit pet_url(@pet)
    click_on "Destroy this pet", match: :first

    assert_text "Pet was successfully destroyed"
  end
end
