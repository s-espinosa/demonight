require 'rails_helper'

describe 'Demo Night Toggles to voting after the 15th project is created', type: :request do
  let!(:demo_night) { create(:demo_night) }
  let(:user)        { create(:user) }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) }

  context 'on project create' do
    let(:attrs)       { attributes_for(:project) }
    subject { post '/projects', params: { project: attrs } }

    it 'changes the current demo night status' do
      create_list(:project, 16, demo_night: demo_night)

      expect { subject }.to change { DemoNight.current.status }.to('voting')
    end

    it 'does not change the current demo night status' do
      create_list(:project, 15, demo_night: demo_night)

      expect { subject }.to_not change { DemoNight.current.status }
    end
  end
end
