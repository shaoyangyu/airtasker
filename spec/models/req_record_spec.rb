# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReqRecord, type: :model do
  context 'Save' do
    it 'normal' do
      record = ReqRecord.new client_ip: '127.0.0.1'
      record.save
      expect(ReqRecord.count).to eq(1)
    end
  end
end
