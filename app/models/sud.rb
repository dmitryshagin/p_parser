require 'net/http'
require 'openssl'
require 'json'
class Sud

  TARGET_URL = "http://www.reyestr.court.gov.ua/"
  def self.request(search)
    {
      SearchExpression: search,
      UserCourtCode:'',
      ChairmenName:'',
      RegNumber:'',
      RegDateBegin:'',
      RegDateEnd:'',
      CaseNumber:'',
      ImportDateBegin:'',
      ImportDateEnd:'',
      Sort:'0',
      'PagingInfo.ItemsPerPage' => '25',
      Liga:'true'
    }
  end

  def self.parse(search)
    uri = URI(TARGET_URL)

    headers = {
      'Origin' => 'http://www.reyestr.court.gov.ua',
      # 'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      # 'Accept-Encoding' => 'gzip, deflate',
      # 'Cookie' => 'ASP.NET_SessionId=4kpu3ze3pqrvbb3abgr4fmdw; __utmt=1; __utma=250989573.390366758.1461133682.1461133682.1464160292.2; __utmb=250989573.4.10.1464160292; __utmc=250989573; __utmz=250989573.1461133682.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)',
      'Connection' => 'keep-alive',
      'Upgrade-Insecure-Requests' => '1',
      'Pragma' => 'no-cache',
      'Cache-Control' => 'no-cache',
      'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4,uk;q=0.2',
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'X-Requested-With' => 'XMLHttpRequest',
      'Referer' => 'http://www.reyestr.court.gov.ua/'
    }

    req = Net::HTTP::Post.new uri, headers
    req.set_form_data(self.request(search))

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: false) do |http|
      # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      # http.ssl_version = :SSLv3
      http.request req
    end

    doc = Nokogiri::HTML(res.body)

    rows = doc.xpath('//div[@id="divresult"]//tr')
    details = rows.collect do |row|
      detail = {}
      [
        [:decision_number, 0],
        [:decision_form, 1],
        [:decision_date, 2],
        [:law_date, 3],
        [:judgement_form, 4],
        [:court_case_number, 5],
        [:court_name, 6],
        [:judge_name, 7],
      ].each do |name, index|
        detail[name] = row.xpath('td')[index].try(:text).to_s.strip.gsub('\r\n','')
      end
      detail
    end || []

    return details[1..-1]||[]
  end

end
