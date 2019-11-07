class Post
    attr_reader :id, :message, :user
    def initialize(id:, message:, user:)
        @id = id
        @message = message
        @user = user
    end
end