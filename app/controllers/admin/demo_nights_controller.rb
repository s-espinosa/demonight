class Admin::DemoNightsController < Admin::BaseController
  before_action :check_active_demo_nights, only: :create
  before_action :check_active_for_update, only: :update

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
    dn.final_date = format_date(params[:demo_night][:final_date])
    if dn.save
      redirect_to admin_demo_night_path(dn)
    else
      render :new
    end
  end

  def update
    dn = DemoNight.find(params[:id])
    if params[:demo_night][:final_date]
      dn.final_date = format_date(params[:demo_night][:final_date])
    end

    if dn.update(demo_night_params!)
      if params[:demo_night][:status] == "archived"
        dn.archive
      end
      flash[:success] = "#{dn.name} now #{dn.status.humanize.downcase}"
      redirect_to admin_demo_nights_path
    else
      flash[:failure] = "Something went wrong"
      redirect_to admin_demo_night_path(dn)
    end
  end

  private

  def demo_night_params!
    params.require(:demo_night).permit(:name, :status, :final_date)
  end

  def check_active_demo_nights
    if DemoNight.all.currents.any?
      flash[:danger] = "There can only be 1 active code fair at a time."
      redirect_to admin_demo_nights_path
    end
  end

  def check_active_for_update
    if DemoNight.currents.any?
      if DemoNight.current.id != params[:id].to_i
        flash[:danger] = "There can only be 1 active code fair at a time."
        redirect_to admin_demo_nights_path
      end
    end
  end

  def format_date(date)
    month, day, year = date.split('/')
    [year, month, day].join
  end
end
