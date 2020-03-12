# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

GameMove.destroy_all
Game.destroy_all
UserGame.destroy_all
Card.destroy_all
Room.destroy_all
User.destroy_all

4.times {
    Card.create(name: 'Ambassador', image: 'Ambassador.png')
    Card.create(name: 'Contessa', image: 'Contessa.png')
    Card.create(name: 'Assassin', image: 'Assassin.png')
    Card.create(name: 'Duke', image: 'Duke.png')
    Card.create(name: 'Captain', image: 'Captain.png')
}

user1 = User.create(nickname: 'user1')

Room.create(name: 'room1', password: '123', user: user1)