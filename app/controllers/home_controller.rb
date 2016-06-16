class HomeController < ApplicationController
    http_basic_authenticate_with name: "admin", password: "admin"

  def import
    if !params[:file] or !params[:user][:address]
	render text: 'И e-mail и файл - обязательны!' and return
    end
    t = params[:file].tempfile
    sheet = Roo::Spreadsheet.open(t.path).sheet(0)
    rq = Request.create(filename: params[:file].original_filename, status: :queue, email: params[:user][:address])
    2.upto(sheet.last_row) do |i|
      line = sheet.row(i)
      record = Record.where(request: rq,
                   number: line[0],
                   name: line[1],
                   inn: line[2],
                   finished_at: nil).first_or_create
      ProcessRecordsJob.perform_later record
    end
    render text: 'Результаты будут отправлены на указанную электронную почту.'
  end


end
