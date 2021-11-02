PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL 
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL, 

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO 
    users (fname,lname)
VALUES 
    ('Alan', 'Turing'),
    ('Grace', 'Hopper'),
    ('Ada', 'Lovelace'),
    ('Tim', 'Berners-Lee');

INSERT INTO 
    questions (title, body, user_id)
VALUES
    ('Internet Inventor', 'Who invented the Internet?', 1),
    ('Codebreaking', 'Who broke the Nazi Enigma code?', 2),
    ('Compiling', 'Who invented the first computer compiler?', 3),
    ('First Programmer', 'Who was the first computer programmer?', 4);

INSERT INTO 
    replies (question_id, parent_id, user_id, body)
VALUES
    (1, null, 4, 'I thought it was Al Gore?');

INSERT INTO 
    question_likes (question_id, user_id)
VALUES
    (4, 2),
    (3, 4);
