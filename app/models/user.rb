class User < ApplicationRecord
  validates :codename, presence: true, length: { minimum: 3, maximum: 20 }
end
