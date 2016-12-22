class Admin::DemoNightsController < Admin::BaseController
  before_action :check_active_demo_nights, only: :create

  def index
    @demo_nights = DemoNight.all
  end

  def new
    @demo_night = DemoNight.new
  end

  def show
    @demo_night = DemoNight.find(params[:id])
  end

  def create
    dn = DemoNight.new(demo_night_params!)
    if dn.save
      redirect_to admin_demo_night_path(dn)
    else
      render :new
    end
  end

  def update
    dn = DemoNight.find(params[:id])
    if dn.update(demo_night_params!)
      flash[:success] = "#{dn.name} now #{dn.status.humanize.downcase}"
      redirect_to admin_demo_night_path(dn)
    else
      flash[:failure] = "Something went wrong"
      redirect_to admin_demo_night_path(dn)
    end
  end

  private

  def demo_night_params!
    params.require(:demo_night).permit(:name, :status)
  end

  def check_active_demo_nights
    if DemoNight.all.currents.any?
      flash[:danger] = "There can only be 1 active demo night at a time."
      redirect_to admin_demo_nights_path
    end
  end
end
