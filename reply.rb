require_relative "question"

class Reply
    attr_accessor :id, :question_id, :parent_id, :user_id, :body
    
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
        @user_id = options['user_id']
        @body = options['body']
    end

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM replies 
            WHERE id = ?
        SQL
        
        Reply.new(reply[0])
    end

    def self.find_by_question(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM replies
            WHERE question_id = ?
        SQL
        data.map { |datum| Reply.new(datum) }
    end


end