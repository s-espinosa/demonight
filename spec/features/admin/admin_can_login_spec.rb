require 'rails_helper'

describe "When an admin tries to log in" do
  context "with valid credentials and a current code fair" do
    it "they can log in and see projects" do
      create(:admin, uid: 123456)
      project1 = create(:project)
      visit '/'
      expect(current_path).to eq('/login')
      click_on "Sign in with GitHub"

      expect(current_path).to eq(admin_demo_nights_path)
      within('.nav-wrapper') do
        expect(page).to have_content("Code Fairs")
        expect(page).to have_content("Current Projects")
        expect(page).to have_content("New Project")
      end

      expect(page).to have_content(project1.demo_night.name.humanize)
    end
  end

  context "with valid credentials and a current code fair" do
    it "they can log in and see a button to create a new code fair" do
      create(:admin, uid: 123456)
      visit '/'
      expect(current_path).to eq('/login')
      click_on "Sign in with GitHub"

      expect(current_path).to eq(admin_demo_nights_path)
      within('.nav-wrapper') do
        expect(page).to have_content("New Code Fair")
      end
    end
  end

end
