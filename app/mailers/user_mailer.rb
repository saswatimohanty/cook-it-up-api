class UserMailer < ApplicationMailer
  default from: 'cookitup@app.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Cook It Up!')
  end
end
