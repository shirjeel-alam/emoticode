class HomeController < ApplicationController
  def index
    if !@current_user.nil?
      @sources = @current_user.stream params[:page]
      @cloud   = Tag.cloud.shuffle!
    else
      pager_params = { :page => params[:page], :per_page => 16 }

      @sources = Source.includes(:language).visible.by_trend.newer_than( 2.months.ago.to_i ).paginate pager_params
      @cloud   = Tag.cloud.shuffle!
    end
  end

  def trending
    pager_params = { :page => params[:page], :per_page => 16 }

    @sources = Source.includes(:language).visible.by_trend.newer_than( 2.months.ago.to_i ).paginate pager_params
    @cloud   = Tag.cloud.shuffle!
  end

  def recent
    pager_params = { :page => params[:page], :per_page => 16 }
    
    @recent  = Source.includes(:language).visible.paginate pager_params
    @cloud   = Tag.cloud.shuffle!    
  end
end
