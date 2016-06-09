class UserMailer < ApplicationMailer

  def ready_email(request)
    @request  = request
    attachments["#{request.filename}_result.csv"] = request.generate_report
    mail(to: 'dmitry.shagin@gmail.com', subject: 'Welcome to My Awesome Site')
  end

end
