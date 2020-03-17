class UserGameSerializer < ActiveModel::Serializer
  attributes :id, :money, :cards, :room_id, :nickname
  belongs_to :user

  def room_id
    self.object.game.room.id
  end

  def nickname
    self.object.user.nickname
  end
end
