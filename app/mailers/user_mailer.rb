class UserMailer < ApplicationMailer

  def ready_email(request)
    @request  = request
    attachments["#{request.filename}_result.csv"] = request.generate_report
    mail(to: request.email, subject: 'Обработка задания завершена.')
  end

end
