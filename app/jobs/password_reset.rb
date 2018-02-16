class PasswordReset

	@queue = :passwordreset_queue

	def self.perform(user)
		NotificationMailer.password_reset(user).deliver_later!
	end
end
