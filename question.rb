require_relative "user"

class Question
    attr_accessor :id, :title, :body, :user_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Question.new(datum) }
    end
    
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def self.find_by_id(id)
        q = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM questions 
            WHERE id = ?
        SQL
        
        Question.new(q[0])
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
end
