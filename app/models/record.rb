class Record < ApplicationRecord
  belongs_to :request
  has_many :results

  def process
    process_vgsu
    process_sud
    self.update_attribute(:finished_at, Time.now)
    request.notify_job_done
  end

  def process_vgsu
    process_by_source(:vgsu, Vgsu.parse(inn)) rescue nil
  end

  def process_sud
    process_by_source(:sud, Sud.parse(inn)) rescue nil
  end

  private

  def process_by_source(source, result_text)
    res = results.where(source: source, record_id: self.id).first_or_create
    res.update_attribute(:value, result_text)
  end

end
