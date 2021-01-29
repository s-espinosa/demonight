require "rails_helper"

describe Project do
  it { should have_many :votes }
  it { should have_many(:voters).through(:votes) }
  it { should belong_to(:demo_night) }
  it { should belong_to(:owner) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
end
