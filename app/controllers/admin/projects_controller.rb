class Admin::ProjectsController < Admin::BaseController

  def index
    @projects = Project.all
  end

  def edit
    @project = Project.find(params[:id])
    @modules = ["BE Mod 1", "BE Mod 2", "BE Mod 3", "BE Mod 4", "FE Mod 1", "FE Mod 2", "FE Mod 3", "FE Mod 4", "Posse"]
  end

  def update
    project = Project.find(params[:id])
    if project.update(project_params)
      redirect_to admin_project_path(project)
    else
      flash[:danger] = "Something went wrong!"
      redirect_to admin_edit_project_path(project)
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def destroy
    Project.find(params[:id]).delete
    redirect_to request.referrer
  end

  private
  def project_params
    params.require(:project).permit(:group_members, :name, :project_type, :final_confirmation)
  end
end
