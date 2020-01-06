class Session < ApplicationRecord
  belongs_to :course

  validates :when, presence: true
end
