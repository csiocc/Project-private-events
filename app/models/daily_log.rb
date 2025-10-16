class DailyLog < ApplicationRecord
  has_many :daily_log_reads
  has_many :readers, through: :daily_log_reads, source: :user
end
