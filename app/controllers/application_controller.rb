require 'twitter_client'
require 'facebook_client'
require 'gplus_client'

class ApplicationController < ActionController::Base
  # protect from CSRF attacks
  protect_from_forgery with: :exception
  # initialize instance variables that are globals to the whole app
  before_filter :create_globals
  before_filter :coerce_page_number
  before_filter :allow_iframes
  # before_filter :check_for_mobile

  # if a RecordNotFound exception is raised, automatically render the 404 page
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_404
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end

  def create_globals
    @time_start      = Time.now
    
    @languages       = Language.cached
    @blog_categories = Category.cached
    
    @users_latest    = User.confirmed.order('created_at DESC').limit(20)
    @events          = Event.order('created_at DESC').limit(15)
    @show_joinus     = false
    @current_user    = session[:id].nil? ? nil : User.find_by_id( session[:id] )

    if @current_user.nil? == false
    # show modal only for not logged users
    # elsif cookies[:joinus].nil?
    #   @show_joinus = true
    #   cookies[:joinus] = { :value => "1", :expires => Time.now + 604800 }
    end

    begin
      @followers = {
        :twitter  => TwitterClient.new.followers,
        :facebook => FacebookClient.new.followers,
        :gplus    => GooglePlusClient.new.followers
      }
    rescue
      @followers = {
        :twitter  => 580,
        :facebook => 320,
        :gplus    => 514
      }
    end

  end

  def coerce_page_number
    # a nasty fix for https://github.com/mislav/will_paginate/issues/271
    params[:page] = if params[:page]
                      params[:page].to_i > 0 ? params[:page].to_i : 1
                    else
                      1
                    end
  end

  # a method to fetch languages by their names without performing a
  # new query since all languages are loaded as globals
  def langs_by_names(names)
    @languages.select { |lang| names.include? lang.name.to_sym }
  end

  def sign_in_user(user)
    @current_user = user
    @current_user.last_login = Time.now
    @current_user.last_login_ip = request.remote_ip
    @current_user.save(:validate => false)

    session[:id] = @current_user.id
  end

  def sign_out_user
    @current_user = nil
    session.delete(:id)
  end

  def redirect_to_root
    redirect_to root_path
  end

  protected

  def authenticate!
    redirect_to sign_in_url, error: 'You dont have enough permissions to be here' unless @current_user
  end

  def allow_iframes
    response.headers.delete('X-Frame-Options')
  end

  def not_authenticated!
    redirect_to root_url, error: 'Already authenticated.' unless !@current_user
  end

  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'mobile_views'
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      # Season this regexp to taste. I prefer to treat iPad as non-mobile.
      (request.user_agent =~ /Mobile|webOS/)
    end
  end
end
