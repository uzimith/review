ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")

class User < ActiveRecord::Base
  has_secure_password
  validates :name, presence: true

  has_many :reviews
end

class Review < ActiveRecord::Base
  validates :body, presence: true
  belongs_to :user
  belongs_to :category
end

class Category < ActiveRecord::Base
  has_many :reviews
end
