require 'plivo'
class UserService < BaseService
	attr_accessor :params

	def initialize(_params)
		self.params = _params
		if self.params[:id] != nil
			self.user = User.where(id: self.params[:id]).first
		end
	end

	def create!
		user = User.new(self.params)
		user.name = "User" + SecureRandom.hex(4) + SecureRandom.hex(4)
		user.auth_token = genrate_random_key
		user.active = false
		user.save
		return user
	end

	def update!
		user.update(self.params)
		return user
	end

	def find(id)
		return User.find(id)
	end

	def authenticate_otp(_params)
		self.params = _params
		user = User.where(mobile_no: self.params[:mobile_no]).first
		if user && !user.active?
			if user.authenticate_otp(self.params[:otp], drift: 300)
				user.active = true
				user.save
			end
		end
		return user
	end

	def regenerate_otp
		generate_otp
	end

	def generate_otp
		# Send SMS
		user = User.where(mobile_no: params[:mobile_no]).first
		if user
			send_otp(user)
		else
			user = create!
		end
		return user
	end

	private
	def send_otp(user)
		p = Plivo::RestAPI.new(ENV['PLIVIO_AUTH_ID'], ENV['PLIVIO_AUTH_TOKEN'])
		message = "Your VideoList verification code is #{user.otp_code}"
		sms_params = {
			'src' => ENV['PLIVIO_SRC_MOBILE'], # Sender's phone number with country code
			'dst' => user.mobile_no, # Receiver's phone Number with country code
			'text' => message, # Your SMS Text Message - English
		#	'text' => 'こんにちは、元気ですか？' # Your SMS Text Message - Japanese
		#	'text' => 'Ce est texte généré aléatoirement' # Your SMS Text Message - French
			'method' => 'POST' # The method used to call the url
		}
		response = p.send_message(sms_params)
	end
	def genrate_random_key
		new_random = SecureRandom.hex(24)
		if User.where(auth_token: new_random).first.present?
			new_random = genrate_random_key
		end
		return new_random
	end
end