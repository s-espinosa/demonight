require "rails_helper"

describe "When a user visits the project index" do
  before do
    user1 = create(:user)
    @demo_night = create(:demo_night_with_projects)
    @demo_night.voting!
    project1, project2 = @demo_night.projects
    user1.votes.create(project: project1, representation: 1, challenge: 1, wow: 1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
  end

  it "they can edit their vote", js: true do
    visit projects_path

    within (".voted") do
      click_link("Edit Rating")
    end

    all('div.select-wrapper')[0].click
    find('div.select-wrapper li', text: '3').click
    sleep(0.2)
    all('div.select-wrapper')[1].click
    find('div.select-wrapper li', text: '3').click
    sleep(0.2)
    all('div.select-wrapper')[2].click
    find('div.select-wrapper li', text: '3').click
    sleep(0.2)
    click_on "Submit"

    expect(current_path).to eq(demo_night_projects_path(@demo_night))

  end
end
