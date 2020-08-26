class Comment < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  validates :content, presence: true

  def to_s
    comment
  end
end
