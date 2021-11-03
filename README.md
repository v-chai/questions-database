# Object Relational Model project


## Learning Goals
- Know how to use a SQL script to construct a database
- Be able to debug SQL syntax errors
- Be able to use queries, written in SQL, in your Ruby code
- Know how a basic ORM (Object-Relational Mapping) system works
- Be able to write SQL queries to solve problems without using Ruby code
- Be able to use joins instead of Ruby code
- Be able to use GROUP BY and ORDER BY instead of Ruby code

## Steps
### Code import_db.sql 
Code the initial set up for the database by creating tables and inserting initial values.

### Build db using import_db.sql
Run `cat import_db.sql | sqlite3 questions.db` in terminal.

### Gemfile
Init bundle and add `gem 'sqlite3', '~> 1.3.13'` to gemfile. Then bundle install.

### Code class for database and class for each table 
For table classes, add attribute accessors to access the instance variables.

### Code SQL Queries 
#### Easy
- Question::find_by_author_id(author_id)
- Reply::find_by_user_id(user_id)
- Reply::find_by_question_id(question_id)
-- All replies to the question at any depth.
- User::find_by_name(fname, lname)
- User#authored_questions (use Question::find_by_author_id)
- User#authored_replies (use Reply::find_by_user_id)
- Question#author
- Question#replies (use Reply::find_by_question_id)
- Reply#author
- Reply#question
- Reply#parent_reply
- Reply#child_replies
-- Only do child replies one-deep; don't find grandchild comments.

#### Medium
- QuestionFollow::followers_for_question_id(question_id)
-- This will return an array of User objects!
- QuestionFollow::followed_questions_for_user_id(user_id)
-- Returns an array of Question objects.
- User#followed_questions
-- One-liner calling QuestionFollow method.
- Question#followers
-- One-liner calling QuestionFollow method.
- QuestionLike::likers_for_question_id(question_id)
- QuestionLike::num_likes_for_question_id(question_id)
- QuestionLike::liked_questions_for_user_id(user_id)
- Question#likers
-- One-liner calling QuestionLike method.
- Question#num_likes
-- One-liner calling QuestionLike method.
- User#liked_questions
-- One-liner calling QuestionLike method.

#### Hard
- QuestionFollow::most_followed_questions(n)
-- Fetches the n most followed questions.
- Question::most_followed(n)
-- Simple call to QuestionFollow
- QuestionLike::most_liked_questions(n)
- Question::most_liked(n)
-- Fetches n most liked questions.
- User#average_karma
-- Avg number of likes for a User's questions.

### Add ModelBase parent class
Add or move the following class and instance methods from child class to parent: 
- ::find_by_id
- ::all
- #save 
- #update 
- ::where
-- Accepts an options hash or SQL where query string as an argument. If argument passed is a hash or several k:v arguments, searches the database for records whose column matches the options key and whose value matches the options value, and then returns all the records which match the criteria. If argument passed is a string, pass it directly into WHERE clause of SQL query. NOTE: This is coded in accordance with the App Academy project instructions. I noted that this last feature may open the code up to SQL injection attacks. I added a small bit of code to raise an error if any common attack keywords/symbols are used. However, this is not as robust as the '?' variable-stand-ins normally used. 
