require "rails_helper"

describe "logged in admin" do
  it "can delete a project from the code fairs index", js: true do
    admin = create(:admin)
    demo_night = create(:demo_night_with_projects)
    project1, project2 = demo_night.projects

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    visit admin_demo_night_path(demo_night)
    within('.projects > table > tbody') do
      within('tr:nth-child(1)') do
        page.accept_confirm do
          click_button("Delete")
        end
      end
    end
    expect(page).to_not have_content(project2.name)

  end
end
