require 'rails_helper'

RSpec.describe DemoNight, type: :model do
  let(:demo_night) { create(:demo_night) }

  context "with 'accepting' demo night" do
    it "returns true for active demo night" do
      expect(demo_night.active?).to eq(true)
    end
  end

  context "with 'accepting' demo night" do
    before { demo_night.update(status: "voting") }

    it "returns true for active demo night" do
      expect(demo_night.active?).to eq(true)
    end
  end

  context "with closed demo night" do
    before { demo_night.update(status: "closed") }

    it "returns false for inactive demo night" do
      expect(demo_night.active?).to eq(false)
    end
  end

  context '#sorted_projects' do
    it 'returns projects based on their average total votes' do
      demonight = create(:demo_night_with_projects)
      project1 = demonight.projects.first
      project2 = demonight.projects.last
      project3 = create(:project, demo_night: demonight)
      user1 = User.first
      user2 = User.second
      project1.votes.create(user: user1, representation: 1, challenge: 1, wow: 1)
      project1.votes.create(user: user2, representation: 2, challenge: 2, wow: 2)
      project3.votes.create(user: user1, representation: 5, challenge: 5, wow: 5)
      project3.votes.create(user: user2, representation: 5, challenge: 5, wow: 5)
      projects = [project1, project2, project3]
      demonight = create(:demo_night)
      demonight.projects << projects
      demonight_projects = demonight.sorted_projects

      expect(demonight_projects.first.name).to eq(project3.name)
      expect(demonight_projects.last.name).to eq(project2.name)
    end
  end
end
