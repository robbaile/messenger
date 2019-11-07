require 'pg'
require_relative './post.rb'

class User
    attr_reader :id, :email

    def initialize(id:, email:)
      @id  = id
      @email = email
    end

    def self.find(email, password)
        connection = connect
        result = connection.exec("SELECT * from users WHERE email = $1 AND password = crypt($2, password) ", [email, password])
        result.map do |user|
            User.new(id: user['id'], email: user['email'])
        end
    end

    def self.create(email, password)
        connection = connect
        connection.exec("INSERT INTO users (email, password) VALUES ($1, crypt($2, gen_salt('bf')));", [email, password])
    end

    def self.get_posts(id)
        connection = connect
        result = connection.exec("SELECT * from posts where user_id = $1", [id])
        result.map do |post|
            Post.new(id: post['id'], message: post['message'], user: connection.exec("SELECT email from users where id = $1", [id]).first['email'])
        end
    end

    def self.create_post(id, message)
        connection = connect 
        connection.exec("INSERT INTO posts (user_id, message) VALUES ($1, $2)", [id, message])
    end

    def self.delete_post(id)
        connection = connect 
        connection.exec("DELETE FROM posts WHERE id=$1;", [id])
    end

    def self.get_users(id)
        connection = connect
        result = connection.exec("SELECT id, email from users WHERE NOT id=$1", [id])
        result.map do |user|
            User.new(id: user['id'], email: user['email'])
        end
    end

    private

    def self.connect
        db_name = 'messenger'
        return PG.connect(dbname: db_name) 
    end
end