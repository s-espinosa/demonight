require 'rails_helper'

describe "When a visitor tries to log in" do
  context "with no active code fair" do
    it "they log in and see an apology" do
      visit '/'
      expect(current_path).to eq('/login')
      click_on "Sign in with GitHub"

      expect(current_path).to eq('/no-demo-night')
      expect(page).to have_content('Sorry')
      expect(User.last.name).to eq("First Last")
    end
  end

  context "with a code fair accepting submissions" do
    it "they log in and see a form to submit" do
      create(:demo_night)

      visit '/'
      expect(current_path).to eq('/login')
      click_on "Sign in with GitHub"

      expect(current_path).to eq(new_project_path)
      expect(User.last.name).to eq("First Last")
      within('nav') do
        expect(page).to have_link('Current Projects')
        expect(page).to have_link('New Project')
      end
    end
  end

  context "with a code fair accepting votes" do
    it "they log in and see a list of projects" do
      create(:demo_night_with_projects, status: 'voting')

      visit '/'
      expect(current_path).to eq('/login')
      click_on "Sign in with GitHub"

      expect(current_path).to eq(projects_path)
      expect(User.last.name).to eq("First Last")
      within('.unvoted ul li:nth-of-type(1)') do
        expect(page).to have_link('Rate')
        expect(page).to_not have_content('Edit')
      end
       within('nav') do
        expect(page).to_not have_link('New Project')
      end
    end
  end
end
