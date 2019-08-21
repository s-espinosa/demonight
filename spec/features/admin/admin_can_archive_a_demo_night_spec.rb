require "rails_helper"

describe "When an admin views the code fair index", js: true  do
  before do
    user  = create(:user)
    admin = create(:admin, uid: 123456)
    active = create(:demo_night_with_projects)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    @project1, @project2 = active.projects
    @project1.votes.create(user: user, representation: 5, challenge: 5, wow: 5)
    @project1.votes.create(user: user, representation: 3, challenge: 3, wow: 3)
    @project2.votes.create(user: user, representation: 2, challenge: 2, wow: 2)
    active.closed!
    @closed = active
  end

  it "they can open voting on a code fair" do
    visit admin_demo_nights_path
    within(".closed-demo-nights") do
      click_link("archive")
    end

    @closed.reload
    @project1.reload
    @project2.reload
    expect(@closed.status).to eq("archived")
    expect(@project1.votes).to eq([])
    expect(@project2.votes).to eq([])

    click_link("#{@closed.name.capitalize}")
    within(".projects > table > tbody ") do
      expect(page).to have_content("2.0")
      expect(page).to have_content("6.0")
      expect(page).to have_content("5.0")
      expect(page).to have_content("15.0")
    end
  end
end
