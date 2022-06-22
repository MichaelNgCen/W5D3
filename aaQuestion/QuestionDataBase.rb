require 'sqlite3'
require 'singleton'

class QuestionsDB < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Questions
  attr_accessor :title, :body, :associated_author

  def self.all
    data = QuestionsDB.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
  end

  def self.find_by_title(title)
    question = QuestionsDB.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL
    return nil unless question.length > 0

    Questions.new(question.first) # questions is stored in an array!
  end

  def self.find_by_id(id)
    question = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0

    Questions.new(question.first) # questions is stored in an array!
  end

  def self.find_by_associated_author(name)
    author = Users.find_by_name(name)
    raise "#{name} not found in DB" unless author

    question = QuestionsDB.instance.execute(<<-SQL, users.id)
      SELECT
        *
      FROM
        Questions
      WHERE
        users.id = ?
    SQL

    Questions.map { |question| Questions.new(question) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @associated_author = options['associated_author']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDB.instance.execute(<<-SQL, @title, @body, @associated_author)
      INSERT INTO
        Questions (title, body, associated_author)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDB.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    QuestionsDB.instance.execute(<<-SQL, @title, @body, @associated_author, @id)
      UPDATE
        Questions
      SET
        title = ?, body = ?, associated_author = ?
      WHERE
        id = ?
    SQL
  end
end

class Users
  attr_accessor :fname, :lname
  attr_reader :id

  def self.all
    data = QuestionsDB.instance.execute("SELECT * FROM Users")
    data.map { |datum| Users.new(datum) }
  end

  def self.find_by_id(id)
    user = QuestionsDB.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0

    Questions.new(questions.first) # questions is stored in an array!
  end

  def self.find_by_name(fname, lname)
    person = QuestionsDB.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        Users
      WHERE
        fname = ?, lname = ?
    SQL
    return nil unless person.length > 0 # person is stored in an array!

    Users.new(person.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDB.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        Users (fname, lname)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDB.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    QuestionsDB.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        Users 
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end

  def get_questions
    raise "#{self} not in database" unless @id
    questions = QuestionsDB.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        Questions
      WHERE
        Associated_author = ?
    SQL
    questions.map { |question| Questions.new(question) }
  end

end

class QuestionsFollow         #WE NEED TO UPDATE THIS
    attr_reader :question_id, :users_id, :id
  
    def self.all
      data = QuestionsDB.instance.execute("SELECT * FROM question_follows")
      data.map { |datum| question_follows.new(datum) }
    end
    
    def self.find_by_question_id(question_id)
      question_id = QuestionsDB.instance.execute(<<-SQL, question_id)
        SELECT
          *
        FROM
          question_follows
        WHERE
          question_id = ?
      SQL
      return nil unless question_id.length > 0
  
      QuestionsFollow.new(question_id.first)
    end
        SELECT
          *
        FROM
          question_follows
        WHERE
          id = ?
      SQL
      return nil unless question_follows.length > 0
  
      QuestionsFollow.new(question_follows.first) # questions is stored in an array!
    end

    def self.find_by_id(id)
      question_follows = QuestionsDB.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          question_follows
        WHERE
          id = ?
      SQL
      return nil unless question_follows.length > 0
  
      QuestionsFollow.new(question_follows.first) # questions is stored in an array!
    end
  
    def initialize(options)
      @id = options['id']
      @fname = options['fname']
      @lname = options['lname']
    end
  
    def create
      raise "#{self} already in database" if @id
      QuestionsDB.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO
          Users (fname, lname)
        VALUES
          (?, ?)
      SQL
      @id = QuestionsDB.instance.last_insert_row_id
    end
  
    def update
      raise "#{self} not in database" unless @id
      QuestionsDB.instance.execute(<<-SQL, @fname, @lname, @id)
        UPDATE
          Users 
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
    end
  
    def get_questions
      raise "#{self} not in database" unless @id
      questions = QuestionsDB.instance.execute(<<-SQL, @id)
        SELECT
          *
        FROM
          Questions
        WHERE
          Associated_author = ?
      SQL
      questions.map { |question| Questions.new(question) }
    end
  
  end

  class Replies         #WE NEED TO UPDATE THIS
    attr_accessor :body, :associated_author, :associated_question, :parent_reply
    attr_reader :id
  
    def self.all
      data = QuestionsDB.instance.execute("SELECT * FROM replies")
      data.map { |datum| Replies.new(datum) }
    end
  
    def self.find_by_user_id(id)
      reply = QuestionsDB.instance.execute(<<-SQL, body, associated_author, )
        SELECT
          *
        FROM
          Users
        WHERE
          fname = ?
      SQL
      return nil unless person.length > 0 # person is stored in an array!
  
      Users.new(person.first)
    end
  
    def self.find_by_name(lname)
      person = QuestionsDB.instance.execute(<<-SQL, lname)
        SELECT
          *
        FROM
          Users
        WHERE
          lname = ?
      SQL
      return nil unless person.length > 0 # person is stored in an array!
  
      Users.new(person.first)
    end
  
    def initialize(options)
      @id = options['id']
      @fname = options['fname']
      @lname = options['lname']
    end
  
    def create
      raise "#{self} already in database" if @id
      QuestionsDB.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO
          Users (fname, lname)
        VALUES
          (?, ?)
      SQL
      @id = QuestionsDB.instance.last_insert_row_id
    end
  
    def update
      raise "#{self} not in database" unless @id
      QuestionsDB.instance.execute(<<-SQL, @fname, @lname, @id)
        UPDATE
          Users 
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
    end
  
  end

  class QuestionLikes         #WE NEED TO UPDATE THIS
    attr_accessor :fname, :lname
    attr_reader :id
  
    def self.all
      data = QuestionsDB.instance.execute("SELECT * FROM question_likes")
      data.map { |datum| QuestionLikes.new(datum) }
    end
  
    def self.find_by_id(id)
      likes = QuestionsDB.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          question_likes
        WHERE
          id = ?
      SQL
      return nil unless likes.length > 0
  
      QuestionLikes.new(likes.first) # questions is stored in an array!
    end
  
    def initialize(options)
      @id = options['id']
      @question_id = options['question_id']
      @users_id = options['question_id']
    end
  
    def create
      raise "#{self} already in database" if @id
      QuestionsDB.instance.execute(<<-SQL, @question_id, @users_id)
        INSERT INTO
          question_likes (question_id, users_id)
        VALUES
          (?, ?)
      SQL
      @id = QuestionsDB.instance.last_insert_row_id
    end
  
    def update
      raise "#{self} not in database" unless @id
      QuestionsDB.instance.execute(<<-SQL, @question_id, @users_id, @id)
        UPDATE
          Users 
        SET
          question_id = ?, users_id = ?
        WHERE
          id = ?
      SQL
    end
  
  end