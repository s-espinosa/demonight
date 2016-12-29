class Project < ApplicationRecord
  has_many :votes
  has_many :voters, through: :votes, source: :user

  belongs_to :owner, class_name: "User", foreign_key: 'user_id'
  belongs_to :demo_night

  validates_presence_of :name

  def average_representation
    votes.average(:representation)
  end

  def average_challenge
    votes.average(:challenge)
  end

  def average_wow
    votes.average(:wow)
  end

  def average_total
    (votes.sum(:representation) + votes.sum(:challenge) + votes.sum(:wow)) / votes.count if votes.count != 0
  end

  def self.unvoted_by_user(user_id)
    joins("LEFT JOIN(SELECT * FROM votes WHERE user_id = #{user_id}) AS user_votes ON projects.id = user_votes.project_id").where("user_votes.user_id IS NULL")
  end

  def self.voted_by_user(user_id)
    joins(:votes).where("votes.user_id = #{user_id}")
  end

  def self.current_projects
    current_demo_night = DemoNight.currents.first
    if current_demo_night
      where(demo_night_id: current_demo_night.id)
    else
      []
    end
  end

  def members
    "#{owner.name}, #{group_members}"
  end
end
