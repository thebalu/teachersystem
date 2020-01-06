class Session < ApplicationRecord
  belongs_to :course_id

  validates :course_id, :when, presence: true
end
