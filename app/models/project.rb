class Project < ApplicationRecord
  has_many :votes
  has_many :voters, through: :votes, source: :user

  belongs_to :owner, class_name: "User", foreign_key: 'user_id'
  belongs_to :demo_night

  validates_presence_of :name

  def number_of_votes
    votes.count
  end

  def average_representation
    return archived_average_representation if archived_average_representation
    votes.average(:representation).round(3) if votes.count != 0
  end

  def average_challenge
    return archived_average_challenge if archived_average_challenge
    votes.average(:challenge).round(3) if votes.count != 0
  end

  def average_wow
    return archived_average_wow if archived_average_wow
    votes.average(:wow).round(3) if votes.count != 0
  end

  def average_total
    return archived_average_total if archived_average_total
    if votes.count != 0
      ((votes.sum(:representation) + votes.sum(:challenge) + votes.sum(:wow)) / votes.count.to_f).round(3)
    else
      0
    end
  end

  def archive
    self.archived_average_representation = average_representation
    self.archived_average_challenge = average_challenge
    self.archived_average_wow = average_wow
    self.archived_average_total = average_total
    self.save
  end

  def self.unvoted_by_user(user_id)
    eligible = ["BE Mod 3", "FE Mod 3", "BE Mod 4", "FE Mod 4"]
    where.not(
      id: User.find(user_id)
        .voted_projects
        .pluck(:id)
    ).where(project_type: eligible)
  end

  def self.voted_by_user(user_id)
    joins(:votes).where("votes.user_id = #{user_id}")
  end

  def self.ineligible
    eligible = ["BE Mod 3", "FE Mod 3", "BE Mod 4", "FE Mod 4"]
    where.not(project_type: eligible)
  end

  def self.current_projects
    current_demo_night = DemoNight.currents.first
    if current_demo_night
      where(demo_night_id: current_demo_night.id)
    else
      []
    end
  end
end
