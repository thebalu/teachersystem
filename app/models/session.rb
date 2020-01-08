class Session < ApplicationRecord
  belongs_to :course

  validates :when, presence: true
  validate :sensible_end_time

  def sensible_end_time
    errors.add(:end_time, "End time must be after beginning time") unless !course || (course.signups.count < course.limit)
  end

end
