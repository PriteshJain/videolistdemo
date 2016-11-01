class User < ApplicationRecord
	has_one_time_password column_name: :otp_secret_key, length: 4


	validates :mobile_no, presence: true, uniqueness: true
	validates :auth_token, presence: true, uniqueness: true
	def active?
		return self.active == 't'
	end
end
