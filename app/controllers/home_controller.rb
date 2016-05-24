class HomeController < ApplicationController

  def import
    t = params[:file].tempfile
    sheet = Roo::Spreadsheet.open(t.path).sheet(0)
    records = []
    2.upto(sheet.last_row) { |i| records << parse_record(sheet.row(i)) }
    render text: check_vgsu(records)
    # render text: records
  end

  def check_vgsu(records)
    res = []
    records.first(2).each do |record|
      res << [record[2], Vgsu.parse(record[2])]
    end
    res
  end

  private

  def parse_record record
    [record[0],record[1],record[2]]
  end

end
