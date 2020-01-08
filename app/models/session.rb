class Session < ApplicationRecord
  belongs_to :course

  validates :when, :ends, presence: true
  validate :sensible_end_time

  def sensible_end_time
    errors.add(:end_time, "must be after beginning time") unless (self.when < self.ends)
    errors.add(:duration, "must be less than 24 hours") unless (self.when+1.day > self.ends)
  end

end
