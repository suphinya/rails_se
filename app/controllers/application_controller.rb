class ApplicationController < ActionController::Base
	
	before_action :set_current_user
	protected
	def set_current_user
		# @current_user ||= User.find_by_id(session[:user_id])
		# redirect_to login_path and return unless @current_user
		@current_user = current_user
	end
	
	require 'themoviedb'
      Tmdb::Api.key("5cac13bbd8f3425d3f00d485015680bb")

    def set_config
  	  @configuration = Tmdb::Configuration.new
    end
    
end
