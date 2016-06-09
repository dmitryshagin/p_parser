class HomeController < ApplicationController

  def import
    t = params[:file].tempfile
    sheet = Roo::Spreadsheet.open(t.path).sheet(0)
    rq = Request.create(filename: params[:file].original_filename, status: :queue)
    2.upto(sheet.last_row) do |i|
      line = sheet.row(i)
      record = Record.where(request: rq,
                   number: line[0],
                   name: line[1],
                   inn: line[2],
                   finished_at: nil).first_or_create
      ProcessRecordsJob.perform_later record
    end
    render text: 'Your results will be sent by email'
  end


end
