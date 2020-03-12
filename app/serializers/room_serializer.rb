class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :password
  belongs_to :user
  def user
    self.object.user.nickname
  end
end
