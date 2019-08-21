require "rails_helper"

describe "when an admin creates a code fair", js: true do

  before do
    @demo_night = create(:demo_night)
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  it "they are redirected to an index page if another code fair is active" do
    visit new_admin_demo_night_path

    fill_in "Name", with: "Code Fair - 1602"
    click_button "Create Code Fair!"

    expect(current_path).to eq(admin_demo_nights_path)
    expect(page).to have_content("There can only be 1 active code fair at a time.")
    within('.active-demo-night') do
      expect(page).to have_content(@demo_night.name.humanize)
    end

  end
end
