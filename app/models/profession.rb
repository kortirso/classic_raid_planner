# Represents game professions
class Profession < ApplicationRecord
  has_many :character_professions, dependent: :destroy
  has_many :characters, through: :character_professions

  def self.cache_key(professions)
    {
      serializer: 'professions',
      stat_record: professions.maximum(:updated_at)
    }
  end
end
