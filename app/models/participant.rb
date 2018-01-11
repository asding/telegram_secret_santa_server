class Participant < ActiveRecord::Base
  belongs_to :exchange

  validates :user_id, presence: true, uniqueness: true
  validates :user_name, presence: true
  validates :set, inclusion: { in: [true, false] }

  scope :with_chat_id, -> do
    participants = Participant.arel_table
    registrations = Registration.arel_table
    condition = participants.outer_join(registrations).
      on(participants[:user_id].eq(registrations[:user_id])).
      join_sources
    joins(condition).select(participants[Arel.star], registrations[:chat_id].as('chat_id'))
  end

  def self.not_registered_prompt
    "Sorry, you are currently not participating in any exchanges. " +
      Exchange.wrong_chat_prompt
  end
  def self.message_set_prompt
    "You have already set your personal description text! "\
      "You won't be able to edit your personal description anymore "\
      "I would distribute the names and their personal descriptions "\
      "after all other participants in the same exchange have set their descriptions."
  end
  def self.long_help_prompt
    "Commands:\n\n"\
      "/help          - display a more descriptive command list (this list of commands)\n"\
      "/set           - submits your personal description text, "\
      "you won't be able to edit your messages anymore after /set is called. "\
      "You may /set your personal description before setting any personal description for blank description. "\
      "But Bob always let his gifter know what he wants so everyone is happy. Bob is smart. Be like Bob. "\
      "Just kidding, have fun and keep sharing gifts! "\
      "Once everyone in the same message have /set their description, let the exchange game begin!\n"\
      "/edit <msg>    - if you have not /set your personal description, "\
      "send \"/edit I love to swim!\" (e.g.) to replace your previous/default preference record with \"I love to swim!\""
  end

  def self.short_help_prompt
    "Commands:\n\n"\
      "/help          - display a more descriptive command list\n"\
      "/set           - submits and locks your personal description text. "\
      "Names will be distributed once everyone in same exchange have /set their personal descriptions\n"\
      "/edit <msg>    - edit and replace personal description to <msg>"
  end
  def self.start_prompt
    "Before I send you the name of people who you would give a gift to, "\
      "please describe your hobbies, interests, wish list, or anything about yourself "\
      "that would help your gifter decide on an appropriate gift for you :)\n\n" +
      "Here are some of usable commands:\n\n" +
      long_help_prompt
  end
end
