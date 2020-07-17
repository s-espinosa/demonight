class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authorize_user
  helper_method :current_user
  helper_method :owner_and_accepting
  helper_method :current_admin?

  force_ssl if Rails.env.production?

  private

  def current_admin?
    current_user && current_user.admin?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize_user
    redirect_to login_path unless current_user
  end

  def root_redirect
    if current_user.admin?
      admin_demo_nights_path
    elsif DemoNight.current && DemoNight.current.accepting_submissions?
      new_project_path
    elsif DemoNight.current && DemoNight.current.voting?
      projects_path
    else
      no_demo_night_path
    end
  end

  def owner_and_accepting(project_id)
    project = Project.find(project_id)
    current_dn = DemoNight.current
    current_dn.status == "accepting_submissions" && project.demo_night_id == current_dn.id && project.user_id == current_user.id
  end

  def modules
    ["BE Mod 2", "BE Mod 3", "BE Mod 4", "FE Mod 2", "FE Mod 3", "FE Mod 4", "Posse", "Mod 4 Cross Poll"]
  end
end
