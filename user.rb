require "sqlite3"
require "singleton"

class QuestionsDatabase < SQLite3::Database
    include Singleton
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end

class User
    attr_accessor :id, :fname, :lname

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| Question.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        user_info = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM users 
            WHERE id = ?
        SQL
        
        User.new(user_info[0])
    end

    def self.find_by_name(fname, lname)
        user_info = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT * 
            FROM users 
            WHERE fname = ? AND lname = ?
        SQL
        User.new(user_info[0])
    end

    def authored_replies
        Reply.find_by_author_id(@id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(@id)
    end

end