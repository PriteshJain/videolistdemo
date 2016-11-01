class ApplicationController < ActionController::API
	before_filter :validate_api_token
	include ApiResponse

	def validate_api_token
		auth_token = params[:auth_token]
		if user = User.where(auth_token: auth_token).first
			session[:current_user] = user
		else
    	render json: bad_request_json(message: 'You need to be logged in')
    	return
		end
	end

	def current_user
		session[:current_user]
	end

end
