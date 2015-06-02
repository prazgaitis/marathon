class ContactsController < ApplicationController
  def new
  	@contact = Contact.new
  end

  def create
  	@contact = Contact.new(params[:contact])
  	@contact.request = request
  	if @contact.deliver
  		flash.now[:notice] = 'Thanks for the email!'
  	else
  		flash.now[:error] = 'Oops, can\'t send email.'
  		render :new
  	end
  end
end
