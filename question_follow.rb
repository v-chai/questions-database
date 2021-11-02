require_relative "question"

class QuestionFollow
    attr_accessor :id, :question_id, :user_id
    
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM question_follows 
            WHERE id = ?
        SQL
        
        QuestionFollow.new(question[0])
    end

    def self.find_by_question(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM question_follows
            WHERE question_id = ?
        SQL
        data.map { |datum| QuestionFollow.new(datum) }
    end

    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT u.id, u.fname, u.lname
            FROM users u
            JOIN question_follows q ON u.id = q.user_id
            WHERE q.question_id = ?
        SQL
        data.map { |datum| User.new(datum) }
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT q.id, q.title, q.body, q.user_id
            FROM questions q
            JOIN question_follows qf ON q.id = qf.question_id
            WHERE qf.user_id = ?
        SQL
        data.map { |datum| Question.new(datum) }
    end 

    def self.most_followed_questions(n)
        # Fetches the n most followed questions.
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
            WITH follow_count AS (
                SELECT question_id, COUNT(*)
                FROM question_follows
                GROUP BY question_id
                ORDER BY COUNT(*) DESC
                LIMIT ?
            )
            SELECT fc.question_id, q.title, q.body, q.user_id
            FROM follow_count fc 
            LEFT OUTER JOIN questions q ON q.id = fc.question_id
        SQL
        data.map { |datum| Question.new(datum) }
    end

end