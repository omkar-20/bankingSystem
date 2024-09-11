class CustomerMailer < ApplicationMailer
  default from: 'bhosale1119omkar@gmail.com'

  def account_creation_email(user, plain_password, account)
    @customer = user
    @plain_password = plain_password
    @account = account
    mail(to: @customer.email, subject: 'Your Account Has Been Created')
  end
end
