class ContactMailer < ApplicationMailer
	def contact_email
		mail(to: "prazgaitis@gmail.com", subject: "TESTING plz WORK")
	end
end
