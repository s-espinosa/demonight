class DemoNight < ApplicationRecord
  has_many :projects
  has_many :votes, through: :projects
  validates :final_date, presence: true

  enum status: [:accepting_submissions, :voting, :closed, :archived]

  def self.current
    where(status: ["accepting_submissions", "voting"]).first
  end

  def self.currents
    where(status: ["accepting_submissions", "voting"])
  end

  def self.inactives
    where(status: ["closed"])
  end

  def self.archived
    where(status: "archived")
  end

  def active?
    status != "closed" && status != "archived"
  end

  def sorted_projects
    projects.sort_by { |p| p.average_total }.reverse
  end

  def self.top(number)
    current.sorted_projects.take(number)
  end

  def number_of_projects
    projects.count
  end

  def archive
    projects.each { |project| project.archive }
    votes.each { |vote| vote.delete }
  end
end
