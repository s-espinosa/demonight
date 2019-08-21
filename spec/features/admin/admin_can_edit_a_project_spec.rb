require 'rails_helper'

describe 'When an admin visits the admin code fair show path' do
  it 'they can click on a link to edit a project' do
    admin = create(:admin, uid: 123456)
    demo_night = create(:demo_night_with_projects)
    project1 = demo_night.projects.first
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit admin_demo_night_path(demo_night)
    click_link('Edit', href: edit_admin_project_path(project1))
    fill_in('project[name]', with: "New Name")
    click_on('Submit')

    expect(page).not_to have_content(project1.name)
    expect(page).to have_content("New Name")
    expect(page).to have_link('Other Projects from this Code Fair', href: admin_demo_night_path(demo_night))
  end
end
