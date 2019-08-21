class Admin::ScoreboardController < Admin::BaseController
  def show
    @demo_night = DemoNight.current
    if @demo_night.nil?
      flash[:warning] = "There is no active code fair."
      redirect_to admin_demo_nights_path
    end
  end
end
