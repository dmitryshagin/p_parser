require 'net/http'
require 'openssl'
require 'json'
class Vgsu

  TARGET_URL = "https://ovsb.ics.gov.ua/view/vgsu/bank_content.php"
  def self.request(inn)
    {
      sEcho:'4',
      iColumns:'9',
      sColumns:'',
      iDisplayStart:'0',
      iDisplayLength:'10',
      mDataProp_0:'0',
      mDataProp_1:'1',
      mDataProp_2:'2',
      mDataProp_3:'3',
      mDataProp_4:'4',
      mDataProp_5:'5',
      mDataProp_6:'6',
      mDataProp_7:'7',
      mDataProp_8:'8',
      sSearch:'',
      bRegex:'false',
      sSearch_0:'',
      bRegex_0:'false',
      bSearchable_0:'true',
      sSearch_1:'',
      bRegex_1:'false',
      bSearchable_1:'true',
      sSearch_2:'',
      bRegex_2:'false',
      bSearchable_2:'true',
      sSearch_3:'',
      bRegex_3:'false',
      bSearchable_3:'true',
      sSearch_4:'',
      bRegex_4:'false',
      bSearchable_4:'true',
      sSearch_5:'',
      bRegex_5:'false',
      bSearchable_5:'true',
      sSearch_6:'',
      bRegex_6:'false',
      bSearchable_6:'true',
      sSearch_7:'',
      bRegex_7:'false',
      bSearchable_7:'false',
      sSearch_8:'',
      bRegex_8:'false',
      bSearchable_8:'false',
      code:inn,
      regdate:'~',
      q_ver:'arbitr',
      pdate:'~',
      aucdate:'~',
      aucplace:'',
      ptype:'0',
      pkind:'0',
      price:'~',
      ckind:''
    }
  end

  def self.parse(inn)
    uri = URI(TARGET_URL)

    headers = {
      # 'Origin' => 'https://ovsb.ics.gov.ua',
      # 'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36',
      # 'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      # 'Accept-Encoding' => 'gzip, deflate',
      # 'Cookie' => '__utma=83545032.356192998.1461132391.1462969704.1464072343.3; __utmc=83545032; __utmz=83545032.1464072343.3.3.utmcsr=vgsu.arbitr.gov.ua|utmccn=(referral)|utmcmd=referral|utmcct=/pages/157',
      # 'Connection' => 'keep-alive',
      'Pragma' => 'no-cache',
      'Cache-Control' => 'no-cache',
      'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4,uk;q=0.2',
      'Accept' => 'application/json, text/javascript, */*; q=0.01',
      'X-Requested-With' => 'XMLHttpRequest',
      'Referer' => 'https://ovsb.ics.gov.ua/view/vgsu/bankrut.php'
    }

    req = Net::HTTP::Post.new uri, headers
    req.set_form_data(self.request(inn))

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.ssl_version = :SSLv3
      http.request req
    end

    result = JSON.parse(res.body)
    #return true if found some records
    return result["iTotalDisplayRecords"]!='0'
  end

end
