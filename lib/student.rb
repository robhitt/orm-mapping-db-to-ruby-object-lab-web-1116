class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    # remember each row should be a new instance of the Student class
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end


  def self.find_by_name(name)
    sql_find = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql_find, name).map do |student|
      self.new_from_db(student)
    end.first
  end


  def self.count_all_students_in_grade_9
    sql_all_grade_9 = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql_all_grade_9).map do |student|
      self.new_from_db(student)
    end
  end

  def self.students_below_12th_grade
    # THE .STUDENTS_BELOW_12TH_GRADE METHOD
    # This is a class method that does not need an argument. This method should return an array of all the students below 12th grade.
    sql_below_12th = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql_below_12th).map do |student|
      self.new_from_db(student)
    end
  end

  def self.first_x_students_in_grade_10(num_students)
    # This is a class method that takes in an argument of the number of students from grade 10 to select.
    # This method should return an array of exactly X number of students.
    # def self.returns an array of the first X students in grade 10
    sql_first_x_grade_10 = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    DB[:conn].execute(sql_first_x_grade_10, num_students).map do |student|
      self.new_from_db(student)
    end

  end


  def  self.first_student_in_grade_10
    sql_first_grade_10 = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    DB[:conn].execute(sql_first_grade_10).map do |student|
      self.new_from_db(student)
    end.first
  end

  def self.all_students_in_grade_x(x)
    all_students_in_grade = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(all_students_in_grade, x).map do |student|
      self.new_from_db(student)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
