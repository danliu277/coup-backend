# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

GameMove.destroy_all
UserCard.destroy_all
GameCard.destroy_all
GameMove.destroy_all
UserGame.destroy_all
Card.destroy_all
Game.destroy_all
Room.destroy_all
User.destroy_all

3.times {
    Card.create(name: 'Ambassador', image: 'Ambassador.png', value: 1)
    Card.create(name: 'Contessa', image: 'Contessa.png', value: 2)
    Card.create(name: 'Assassin', image: 'Assassin.png', value: 3)
    Card.create(name: 'Duke', image: 'Duke.png', value: 4)
    Card.create(name: 'Captain', image: 'Captain.png', value: 5)
}
