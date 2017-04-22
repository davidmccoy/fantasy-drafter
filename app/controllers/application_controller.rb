class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  before_filter -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }

  before_filter -> { flash.now[:alert] = flash[:alert].html_safe if flash[:html_safe] && flash[:alert] }
  
end
