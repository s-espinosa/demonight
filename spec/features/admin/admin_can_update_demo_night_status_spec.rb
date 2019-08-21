require "rails_helper"

describe "When an admin views the code fair index", js: true  do
  before do
    admin  = create(:admin)
    @active = create(:demo_night)
    @closed = create(:demo_night, status: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  it "they can open voting on a code fair" do
    visit admin_demo_nights_path
    within('.active-demo-night') do
      click_link("open voting")
    end

    expect(page).to have_content("#{@active.name} now voting")
    within('.active-demo-night') do
      expect(page).to_not have_link('open voting')
      expect(page).to have_link('close')
    end
    @active.reload
    expect(@active.status).to eq("voting")
  end
end
