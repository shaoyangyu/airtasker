# frozen_string_literal: true

class ReqRecord < ActiveRecord::Base
  scope :range, lambda(remote_ip, from) {
    where(client_ip: remote_ip)
      .where('created_at >= ?', from)
  }
  def n_seconds
    (created_at + 1.hours - Time.now).round(0)
  end
end
