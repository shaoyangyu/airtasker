# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :record_client
  def index
    render text: 'ok'
  end

  private

  def record_client
    records = ReqRecord.range(request.remote_ip, 1.hours.ago)
    if records.count >= 100
      return(render text: "Rate limit exceeded. Try again in #{records.first.n_seconds} seconds", status: 429)
    end
    ReqRecord.create(client_ip: request.remote_ip)
  end
end
