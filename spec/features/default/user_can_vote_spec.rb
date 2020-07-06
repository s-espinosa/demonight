require 'rails_helper'

describe "When a user visits a project vote page" do
  it "they can vote on that project", js: true do
    user1, user2 = create_list(:user, 2)
    demo = create(:demo_night, status: "voting")
    demo.projects << create(:project, project_type: "Posse")
    demo.projects << create(:project, project_type: "BE Mod 2")
    demo.projects << create(:project, project_type: "FE Mod 2")
    demo.projects << create(:project, project_type: "BE Mod 3")
    demo.projects << create(:project, project_type: "FE Mod 3")
    demo.projects << create(:project, project_type: "BE Mod 4")
    demo.projects << create(:project, project_type: "FE Mod 4")
    demo.projects[3..-1].each do |project|
      project.votes.create(user: user2,
                           project: project,
                           representation: 3,
                           challenge: 3,
                           wow: 3)
    end
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

    visit projects_path
    within(".ineligible") do
      expect(page).to have_content(demo.projects[0].name)
      expect(page).to have_content(demo.projects[1].name)
      expect(page).to have_content(demo.projects[2].name)
    end
    within(".unvoted") do
      expect(page).to_not have_content(demo.projects[0].name)
      expect(page).to_not have_content(demo.projects[1].name)
      expect(page).to_not have_content(demo.projects[2].name)
      expect(page).to have_content(demo.projects[3].name)
      expect(page).to have_content(demo.projects[4].name)
      expect(page).to have_content(demo.projects[5].name)
      expect(page).to have_content(demo.projects[6].name)
      click_link("Rate", href: new_project_vote_path(demo.projects[6]))
    end

    all('div.select-wrapper')[0].click
    sleep(0.2)
    find('div.select-wrapper li', text: '4').click
    sleep(0.2)
    all('div.select-wrapper')[1].click
    sleep(0.2)
    find('div.select-wrapper li', text: '4').click
    sleep(0.2)
    all('div.select-wrapper')[2].click
    sleep(0.2)
    find('div.select-wrapper li', text: '4').click
    click_on "Submit"

    expect(current_path).to eq(demo_night_projects_path(demo))
    within(".unvoted") do
      expect(page).to_not have_content(demo.projects[0].name)
      expect(page).to_not have_content(demo.projects[1].name)
      expect(page).to_not have_content(demo.projects[2].name)
      expect(page).to have_content(demo.projects[3].name)
      expect(page).to have_content(demo.projects[4].name)
      expect(page).to have_content(demo.projects[5].name)
      expect(page).to_not have_content(demo.projects[6].name)
    end
    within(".voted") do
      expect(page).to_not have_content(demo.projects[0].name)
      expect(page).to_not have_content(demo.projects[1].name)
      expect(page).to_not have_content(demo.projects[2].name)
      expect(page).to have_content(demo.projects[6].name)
    end
    expect(Vote.last.wow).to eq(4)
    expect(Vote.last.user).to eq(user1)
  end
end
