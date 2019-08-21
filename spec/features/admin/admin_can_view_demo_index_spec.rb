require 'rails_helper'

describe 'when an admin visits the code fair index' do
  it 'they see a list of active and closed code fairs' do
    admin = create(:admin, uid: 98765)
    demo1 = create(:demo_night, status: 'closed')
    demo2 = create(:demo_night)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    visit admin_demo_nights_path

    within('.active-demo-night') do
      expect(page).to have_content(demo2.name.humanize)
    end
    within('.closed-demo-nights') do
      expect(page).to have_content(demo1.name.humanize)
    end
  end
end
