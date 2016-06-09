class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.string :filename
      t.string :status

      t.timestamps
    end

    create_table :records do |t|
      t.string :inn
      t.string :name
      t.string :number
      t.integer :request_id
      t.datetime :finished_at

      t.timestamps
    end

    create_table :results do |t|
      t.integer :record_id
      t.string :source
      t.text :value

      t.timestamps
    end
  end
end
