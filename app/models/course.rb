class Course < ApplicationRecord

  has_many :sessions, dependent: :destroy
  has_many :signups,  dependent: :destroy
  belongs_to :teacher

  enum ctype: [:lecture, :practice, :lab, :seminar]
  validates :name, :description, :ctype, :ects, :limit, presence: true
  validates :ects, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 30.0}
  validates :limit, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 300}

end
