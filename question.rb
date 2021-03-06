require_relative "user"
require_relative "model_base"

class Question < ModelBase
    attr_accessor :id, :title, :body, :user_id
    
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def self.find_by_author_id(author_id)
        qs = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT * 
            FROM questions 
            WHERE user_id = ?
        SQL
        
        qs.map { |question| Question.new(question) }
    end

    def author
        data = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
            SELECT * 
            FROM users 
            WHERE id = ?
        SQL
        User.new(data[0])

    end

    def replies
        Reply.find_by_question(@id)
    end

    def followers
        QuestionFollow.followers_for_question_id(@id)
    end

    def num_likes 
        QuestionLike.num_likes_by_question(@id)
    end 

    def likers
        QuestionLike.likers_by_question(@id)
    end

    def self.most_liked(n)
        QuestionLike.most_liked_questions(n)
    end 
end
