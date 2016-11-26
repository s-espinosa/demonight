class ProjectsController < ApplicationController

  def new
    @project = Project.new
    @modules = ["BE Mod 2", "BE Mod 3", "BE Mod 4", "FE Mod 2", "FE Mod 3", "FE Mod 4", "Posse"]
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = "Project successfully submitted!"
      redirect_to project_path(@project)
    else
      flash[:error] = "There was an issue creating this project"
      render :new
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def index
    @projects = Project.all
  end

  private

  def project_params
    params.require(:project).permit(:group_members, :name, :project_type, :final_confirmation)
  end
end