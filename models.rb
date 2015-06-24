ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")

class User < ActiveRecord::Base
  has_secure_password
  validates :name, presence: true

  has_many :reviews
  has_many :favorites
end

class Review < ActiveRecord::Base
  validates :body, presence: true
  belongs_to :user
  belongs_to :category
  has_many :favorites
end

class Category < ActiveRecord::Base
  has_many :reviews
end

class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :review
end
