class Request < ApplicationRecord
  has_many :records
  has_many :results, through: :records

  def notify_job_done
    if records.where(finished_at: nil).size==0
      self.update_attribute(:status, :done)
      UserMailer.ready_email(self).deliver_later
    end
  end

  def generate_report
    res = []
    records.each do |record|
      vals = {}
      record.results.each do |result|
        unless ['',nil,'f','[]'].include? result.value
          vals[result.source] = result.value
        end
      end
      if vals.size>0
        res << {
                'number' => record.number,
                'inn' => record.inn,
                'sud' => vals['sud'],
                'vgsu' => vals['vgsu']
               }
      end
    end
    res

    CSV.generate({}) do |csv|
      csv << ['Номер', 'ИНН', 'Судебные определения', 'ВГСУ']
      res.each do |line|
        csv << [line['number'],
          line['inn'],
          line['sud'].present? ? "Найдено" : "",
          line['vgsu'].present? ? "Найдено" : ""]
      end
    end
  end

end
