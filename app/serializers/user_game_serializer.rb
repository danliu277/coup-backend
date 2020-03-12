class UserGameSerializer < ActiveModel::Serializer
  attributes :id, :money, :cards
  belongs_to :user
end
