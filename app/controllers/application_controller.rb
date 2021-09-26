class ApplicationController < ActionController::Base
	
	before_action :set_current_user
	protected
	def set_current_user
		# @current_user ||= User.find_by_id(session[:user_id])
		# redirect_to login_path and return unless @current_user
		@current_user = current_user
	end
	
end
