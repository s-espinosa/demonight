class VotesController < ApplicationController
  before_action :check_voting

  def new
    @project = Project.find(params[:project_id])
    check_eligibility(@project)
    @vote    = Vote.new
  end

  def create
    @project = Project.find(params[:project_id])
    @vote    = @project.votes.new(vote_params)
    @vote.user = current_user
    if @vote.save
      flash[:success] = "Rating received!"
      redirect_to demo_night_projects_path(@project.demo_night_id)
    else
      flash[:error] = "Rating not registered. Try again."
      redirect_to new_project_vote_path(@project)
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @vote = Vote.find(params[:id])
  end

  def update
    vote = Vote.find(params[:id])
    project = Project.find(params[:project_id])
    vote.update(vote_params)
    redirect_to demo_night_projects_path(project.demo_night_id)
  end

  private

  def vote_params
    params.require(:vote).permit(:representation, :challenge, :wow)
  end

  def check_eligibility(project)
    redirect_to clever_path if Project.ineligible.include?(project)
  end

  def check_voting
    unless DemoNight.currents.first.voting?
      flash[:error] = "Rating not yet started for the current Code Fair"
      redirect_to root_path unless DemoNight.currents.first.voting?
    end
  end
end
