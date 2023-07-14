class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  # .where('LOWER(name) = ?', name.downcase).order(:name).first
end
