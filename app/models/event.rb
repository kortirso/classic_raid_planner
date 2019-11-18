require 'babosa'

# Represents events
class Event < ApplicationRecord
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  belongs_to :owner, class_name: 'Character'
  belongs_to :dungeon, optional: true
  belongs_to :eventable, polymorphic: true
  belongs_to :fraction

  has_many :subscribes, dependent: :destroy
  has_many :characters, through: :subscribes

  has_many :signed_subscribes, -> { where status: %w[approved signed] }, class_name: 'Subscribe'
  has_many :signed_characters, through: :signed_subscribes, source: :character
  has_many :signed_users, -> { distinct }, through: :signed_characters, source: :user

  scope :for_world, ->(world_id, fraction_id) { where eventable_type: 'World', eventable_id: world_id, fraction_id: fraction_id }
  scope :for_guild, ->(guild_id) { where eventable_type: 'Guild', eventable_id: guild_id }
  scope :for_statics, ->(static_ids) { where eventable_type: 'Static', eventable_id: static_ids }

  def self.available_for_user(user)
    user.characters.map do |character|
      available_for_character(character)
    end.flatten.uniq
  end

  # event available for character if event
  # is world event for fraction of character
  # is guild event for guild of character
  # is static event for static of character with membership
  # is static event of guild where character is gm, rl or cl
  def self.available_for_character(character)
    static_ids = character.in_statics.pluck(:id)
    events = for_world(character.world_id, character.race.fraction_id).or(for_guild(character.guild_id)).or(for_statics(static_ids))
    if character.user.any_role?(character.guild_id, 'gm', 'rl', 'cl')
      guild_static_ids = character.guild.statics.pluck(:id)
      events = events.or(for_statics(guild_static_ids))
    end
    events
  end

  def self.where_user_subscribed(user)
    character_ids = user.characters.pluck(:id)
    joins(:signed_characters).where(characters: { id: character_ids })
  end

  def available_for_user?(user)
    return true if eventable_type == 'World' && user.characters.includes(:race).any? { |character| eventable_id == character.world_id && fraction_id == character.race.fraction_id }
    return true if eventable_type == 'Guild' && user.guilds.pluck(:id).include?(eventable_id)
    return true if eventable_type == 'Static' && user.static_members.pluck(:static_id).include?(eventable_id)
    return true if eventable_type == 'Static' && eventable.staticable_type == 'Guild' && user.any_role?(eventable.staticable_id, 'gm', 'rl', 'cl')
    false
  end

  def normalize_friendly_id(text)
    text.to_slug.transliterate(:russian).normalize.to_s
  end

  def is_open?
    DateTime.now < start_time - hours_before_close.hours
  end

  def guild_role_of_user(user_id)
    return nil if eventable_type == 'World'
    return nil if eventable_type == 'Static' && eventable.staticable_type == 'Character'
    guild = eventable_type == 'Static' ? eventable.staticable : eventable
    # leaders from guild of this user
    leaders = guild.characters_with_leader_role.select { |character| character.user_id == user_id }
    return nil if leaders.empty?
    return ['rl', nil] if leaders.any? { |character| character.guild_role.name == 'rl' }
    class_leading = leaders.select { |character| character.guild_role.name == 'cl' }
    return nil if class_leading.empty?
    ['cl', class_leading.map! { |character| character.character_class.name['en'] }]
  end

  private

  def slug_candidates
    [
      :name,
      %i[name owner_id],
      %i[name owner_id id]
    ]
  end
end
