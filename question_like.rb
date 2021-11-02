require_relative "question"

class QuestionLike
    attr_accessor :id, :question_id, :user_id
    
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM question_likes
            WHERE id = ?
        SQL
        
        QuestionLike.new(question[0])
    end

    def self.find_by_question(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM question_likes
            WHERE question_id = ?
        SQL
        data.map { |datum| QuestionLike.new(datum) }
    end

    def self.likers_by_question(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT u.id, u.fname, u.lname
            FROM users u
            JOIN question_likes ql ON ql.user_id = u.id
            WHERE question_id = ?
        SQL
        data.map { |datum| User.new(datum) }
    end

    def self.num_likes_by_question(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT COUNT(*) AS num_likes
            FROM question_likes
            GROUP BY question_id
            HAVING question_id = ?
        SQL
        data[0]['num_likes']
    end

    def self.liked_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT q.id, q.title, q.body, q.user_id
            FROM questions q
            JOIN question_likes ql ON ql.question_id = q.id
            WHERE ql.user_id = ?
        SQL
        data.map { |datum| Question.new(datum) }
    end

    def self.most_liked_questions(n)
        # Fetches the n most liked questions.
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
            WITH like_count AS (
                SELECT question_id, COUNT(*)
                FROM question_likes
                GROUP BY question_id
                ORDER BY COUNT(*) DESC
                LIMIT ?
            )
            SELECT lc.question_id, q.title, q.body, q.user_id
            FROM like_count lc 
            LEFT OUTER JOIN questions q ON q.id = lc.question_id
        SQL
        data.map { |datum| Question.new(datum) }
    end
end