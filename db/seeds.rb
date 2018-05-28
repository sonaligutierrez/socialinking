# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin User
user = User.create({email: "admin@social.linking", password: "12345678", password_confirmation: "12345678" })

# Account
account = Account.create({name: "Prosumia", url: "https://www.prosumia.la/"})

# Post Creator
post_creator = PostCreator.create({fb_user: "luiseloyhernandez@gmail.com", fb_pass: "xyzw123456", account_id: account.id ,fan_page: "Cambiemos", url: "https://www.facebook.com/cambiemos/", avatar: "https://scontent.fscl6-1.fna.fbcdn.net/v/t1.0-1/p200x200/33468449_1111474448991887_5106211791294169088_n.jpg?_nc_cat=0&oh=84060e2f2a85fadcf4d24ff2d08872e9&oe=5B872929"})

# Posts
post_a = Post.create({post_creator_id: post_creator.id, url: "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507"})

post_b = Post.create({post_creator_id: post_creator.id, url: "https://m.facebook.com/story.php?story_fbid=1111182739021058&id=543211639151507"})

# Categories
Category.create(name: "Uncategorized")