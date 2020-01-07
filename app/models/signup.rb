class Signup < ApplicationRecord
  belongs_to :course

  validates :course_id, :snum, presence: :true
  validate  :limit_not_reached
  validates :snum, uniqueness: {scope: :course_id}
  def limit_not_reached
    errors.add(:limit, "Course is full (limit #{course&.limit})") unless !course || (course.signups.count < course.limit)
  end

end
