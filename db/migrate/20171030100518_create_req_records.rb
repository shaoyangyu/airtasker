# frozen_string_literal: true

class CreateReqRecords < ActiveRecord::Migration
  def change
    create_table :req_records do |t|
      t.string :client_ip
      t.timestamps null: false
    end
  end
end
