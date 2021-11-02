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


end