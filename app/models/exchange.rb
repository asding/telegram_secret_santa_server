class Exchange < ActiveRecord::Base
  has_many :participants

  validates_presence_of :chat_id, :chat_title
  validates_inclusion_of :is_set, in: [true, false]

  def self.idle_prompt
    "Hi, I'm GiftExchangeBot\n"\
      "To begin shuffling names for gift exhange, please type /start "
  end
  def self.wrong_chat_prompt
    "To start an exchange, please add me into a Telegram group, and type /start"
  end
end
