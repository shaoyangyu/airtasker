# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  context 'GET Index' do
    it 'normal' do
      get :index
      expect(response.body).to eq('ok')
    end

    it 'exceed 100' do
      100.times do
        get :index
        expect(response.body).to eq('ok')
      end
      get :index
      expect(response.status).to eq(429)
      expect(response.body).to include('Rate limit exceeded')
    end
  end
end
