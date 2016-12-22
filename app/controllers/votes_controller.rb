class VotesController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @vote    = Vote.new
  end

  def create
    @project = Project.find(params[:project_id])
    @vote    = @project.votes.new(vote_params)
    @vote.user = current_user
    if @vote.save
      flash[:success] = "Vote tallied!"
      redirect_to demo_night_projects_path(@project.demo_night_id)
    else
      flash[:error] = "Vote not registered. Try again."
      redirect_to new_project_vote_path(@project)
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:representation, :challenge, :wow)
  end
end
