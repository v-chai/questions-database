require_relative "question"
require_relative "model_base"

class Reply < ModelBase
    attr_accessor :id, :question_id, :parent_id, :user_id, :body
    
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
        @user_id = options['user_id']
        @body = options['body']
    end

    def save 
        if self.id 
            update
        else
            QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.parent_id, self.user_id, self.body)
                INSERT INTO 
                    replies (question_id, parent_id, user_id, body)
                VALUES
                    (?, ?, ?, ?)
            SQL
            self.id = QuestionsDatabase.instance.last_insert_row_id
        end

    end 

    def update
        QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.parent_id, self.user_id, self.body, self.id)
        UPDATE
            replies
        SET
            question_id = ?, parent_id= ?, user_id = ?, body = ?
        WHERE
            id = ?
        SQL
    end

    def self.find_by_author_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM replies
            WHERE user_id = ?
        SQL
        data.map { |datum| Reply.new(datum) }
    end

    def self.find_by_question(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM replies
            WHERE question_id = ?
        SQL
        data.map { |datum| Reply.new(datum) }
    end

    def author 
        data = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
            SELECT * 
            FROM users 
            WHERE id = ?
        SQL
        User.new(data[0])
    end

    def question 
        data = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
            SELECT * 
            FROM questions 
            WHERE id = ?
        SQL
        Question.new(data[0])
    end

    def parent_reply
        if @parent_id
            data = QuestionsDatabase.instance.execute(<<-SQL, @parent_id)
                SELECT * 
                FROM replies 
                WHERE id = ?
            SQL
            return Reply.new(data[0]) 
        else
            "Top-level reply. No parent."
        end
    end 

    def child_replies
        data = QuestionsDatabase.instance.execute(<<-SQL, @id)
            SELECT * 
            FROM replies 
            WHERE parent_id = ?
        SQL
        data.map { |datum| Reply.new(datum) }
    end

end