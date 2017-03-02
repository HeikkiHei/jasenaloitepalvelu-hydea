class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper_method :current_user

	def current_user
		return nil if session[:user_id].nil?
		User.find(session[:user_id])
	end

	def check_user_logged_in
		if session[:user_id].nil?
			redirect_to ideas_path
		end
	end
end

