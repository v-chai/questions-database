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
end