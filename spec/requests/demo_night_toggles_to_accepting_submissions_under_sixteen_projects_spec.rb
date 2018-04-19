require 'rails_helper'

describe 'Demo Night Toggles to accepting submissions after 16th project is created', type: :request do
  let!(:demo_night) { create(:demo_night, status: 'voting') }
  let(:admin)       { create(:admin) }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin) }

  context 'on project destroy' do
    subject { delete "/admin/projects/#{Project.last.id}" }

    it 'changes the current demo night status' do
      create_list(:project, 15, demo_night: demo_night)

      expect { subject }.to change { DemoNight.current.status }.to('accepting_submissions')
    end

    it 'does not current demo night status' do
      create_list(:project, 16, demo_night: demo_night)

      expect { subject }.to_not change { DemoNight.current.status }
    end
  end
end
