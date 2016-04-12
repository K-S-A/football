require 'features/features_spec_helper'

RSpec.feature 'Authorization', :js do
  given(:valid_user) { FactoryGirl.build(:user) }
  given(:save_user) { valid_user.save }

  scenario 'Visitor registers successfully via register form' do
    visit root_path
    click_on 'Register'

    within '#registration_form' do
      fill_in 'email', with: valid_user.email
      fill_in 'password', with: valid_user.password
      fill_in 'first_name', with: valid_user.first_name
      fill_in 'last_name', with: valid_user.last_name

      find('input[type="submit"]').click
    end

    expect(page).not_to have_content 'Register'
    expect(page).to have_content 'Logged in'
    expect(page).to have_content 'You are registered'
    expect(page).to have_content valid_user.first_name
    expect(page).to have_content valid_user.last_name
  end

  scenario 'Registered visitor logs in successfully' do
    visit root_path
    click_on 'Log in'
    save_user

    within '#login_form' do
      fill_in 'email', with: valid_user.email
      fill_in 'password', with: valid_user.password

      find('input[type="submit"]').click
    end

    expect(page).not_to have_content 'Log in'
    expect(page).to have_content 'Logged in'
    expect(page).to have_content 'You are authorized'
    expect(page).to have_content valid_user.first_name
    expect(page).to have_content valid_user.last_name
  end

  scenario 'Authorized user logs out successfully' do
    save_user
    login_as valid_user
    visit root_path

    find('a', text: 'Logged in').click
    find('a', text: 'Log Out').click

    expect(page).not_to have_content 'Logged in'
    expect(page).to have_content 'signed out'
  end

  scenario 'Visitor can\'t log in without registration' do
    visit root_path
    click_on 'Log in'

    within '#login_form' do
      fill_in 'email', with: valid_user.email
      fill_in 'password', with: valid_user.password

      find('input[type="submit"]').click
    end

    expect(page).not_to have_content 'Logged in'
    expect(page).to have_content 'Wrong user credentials'
  end

  context 'Visitor can\'t register' do
    background do
      visit root_path
      click_on 'Register'
    end

    after(:each) do
      expect(page).to have_selector('input[disabled="disabled"][value="Register"]')
    end

    scenario 'without email' do
      within '#registration_form' do
        fill_in 'email', with: "\b"
      end

      expect(page).to have_content 'field is required'
    end

    scenario 'without password' do
      within '#registration_form' do
        fill_in 'password', with: "\b"
      end

      expect(page).to have_content 'field is required'
    end

    scenario 'with password length from 1 to 7 characters' do
      within '#registration_form' do
        fill_in 'password', with: Faker::Internet.password(1, 7)
      end

      expect(page).to have_content 'Value is too short'
    end

    scenario 'with password longer than 72 characters' do
      within '#registration_form' do
        fill_in 'password', with: Faker::Internet.password(73, 100)
      end

      expect(page).to have_content 'Value is too long'
    end

    scenario 'with invalid email format' do
      within '#registration_form' do
        fill_in 'email', with: 'invalid@email.'
      end

      expect(page).to have_content 'Invalid format'
    end
  end
end
