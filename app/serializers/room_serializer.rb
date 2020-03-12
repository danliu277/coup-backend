class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :password
  belongs_to :user
  has_many :user_games

  def password
    true
  end

  def user
    self.object.user
  end

  def user_games
    self.object.user_games.length
  end
end
