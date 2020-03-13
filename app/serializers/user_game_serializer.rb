class UserGameSerializer < ActiveModel::Serializer
  attributes :id, :money, :cards, :room_id
  belongs_to :user

  def room_id
    self.object.game.room.id
  end
end
