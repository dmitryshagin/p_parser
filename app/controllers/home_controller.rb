class HomeController < ApplicationController

  def import
    t = params[:file].tempfile
    sheet = Roo::Spreadsheet.open(t.path).sheet(0)
    records = []
    2.upto(sheet.last_row) { |i| records << parse_record(sheet.row(i)) }
    render text: check_sud(records)
    # render text: check_vgsu(records)
    # render text: records
  end

  def check_vgsu(records)
    res = []
    #TODO - только две записи, для тестов, чтоб не нарваться на спам
    records.first(2).each do |record|
      res << [record[2], Vgsu.parse(record[2])]
    end
    res
    #[["19326098", false], ["2690723937", false], ["2742222080", false], ["1757106237", false], ["2937108779", false], ["2468511248", false], ["36877842", false], ["2128117970", false], ["31792911", false], ["3215406734", false], ["31442184", false], ["31728935", true], ["34021091", false], ["36968390", false], ["35244527", false], ["32300452", false], ["35712280", false], ["2757611890", false], ["2806621300", false], ["3412511357", false], ["3258206322", false], ["2895810973", false], ["3184505133", false], ["31441809", false], ["37232026", false], ["38222820", false], ["36977598", false], ["34598954", false], ["34598954", false], ["39009482", false], ["36655516", false], ["36655516", false], ["23884622", true], ["34560653", false], ["31958523", false], ["36372541", false], ["13349945", true], ["25082523", false], ["34362730", false], ["35056680", false], ["34227153", false], ["32261251", false], ["36559037", false], ["2640524007", false], ["2411112518", false], ["2812118577", false]]
  end

  def check_sud(records)
    res = []
    #TODO - только две записи, для тестов, чтоб не нарваться на спам
    records.first(2).each do |record|
      res << [record[2], Sud.parse(record[2])]
    end
    res

  end

  private

  def parse_record record
    [record[0],record[1],record[2]]
  end

end
