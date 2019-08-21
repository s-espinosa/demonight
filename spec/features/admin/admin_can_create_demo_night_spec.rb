require 'rails_helper'

describe "when an admin logs in" do
  it "they can create a new code fair" do
    admin = create(:admin, uid: 98765)
    demo  = create(:demo_night, status: 'closed')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    visit admin_demo_nights_path
    within('.closed-demo-nights') do
      expect(page).to have_content(demo.name.humanize)
    end

    within('.active-demo-night') do
      click_link "Create New Code Fair"
    end
    fill_in "Name", with: "Code Fair - 1611"
    fill_in("demo_night[final_date]", with: "01/23/2017")
    click_button "Create Code Fair!"

    expect(current_path).to eq("/admin/demo_nights/#{DemoNight.last.id}")
    within('.projects') do
      expect(page).to have_content("No Projects Yet!")
    end

    within('.admin-tools') do
      expect(page).to have_link('open voting')
    end
    expect(DemoNight.last.final_date).to eq(Date.new(2017, 01, 23))
  end
end
