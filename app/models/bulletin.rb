# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :category
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image,
            attached: true,
            content_type: %i[png jpg],
            size: { less_than: 5.megabytes },
            on: :create

  def self.ransackable_attributes(_auth_object = nil)
    %w[title category_id]
  end

  aasm column: :state do
    state :draft, initial: true
    state :under_moderation
    state :published
    state :archived
    state :rejected

    event :send_to_moderation do
      transitions from: :draft, to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :archive do
      transitions from: %i[published rejected draft under_moderation], to: :archived
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end
  end
end
