PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions_likes;
DROP TABLE IF EXISTS questions_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname varchar(255) NOT NULL,
  lname varchar(255) NOT NULL
);
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title varchar(255) NOT NULL,
  body text NOT NULL,
  associated_author INTEGER NOT NULL,
  FOREIGN KEY (associated_author) REFERENCES users(id)
);

CREATE TABLE questions_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  users_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (users_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body text NOT NULL,
    associated_author INTEGER NOT NULL,
    associated_question INTEGER NOT NULL,
    parent_reply INTEGER,
    FOREIGN KEY (associated_author) REFERENCES users(id),
    FOREIGN KEY (associated_question) REFERENCES questions(id),
    FOREIGN KEY (parent_reply) REFERENCES replies(id)
);

CREATE TABLE questions_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  users_id INTEGER NOT NULL,
  likes INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (users_id) REFERENCES users(id)
);

INSERT INTO users (fname, lname) VALUES ('Anthony', 'Chao');
INSERT INTO users (fname, lname) VALUES ('Michael', 'Ng');
INSERT INTO users (fname, lname) VALUES ('Amin', 'Babar');
INSERT INTO users (fname, lname) VALUES ('Kyle', 'Ginzberg');
INSERT INTO users (fname, lname) VALUES ('Spencer', 'Iascone');

INSERT INTO questions (title, body, associated_author) VALUES ('What is your favorite food?', 'My favorite food is Pho.', 1);
INSERT INTO questions (title, body, associated_author) VALUES ('Who is your favorite kpop group?', 'Twice', 2);
INSERT INTO questions (title, body, associated_author) VALUES ('What is your favorite movie?', 'My favorite movie is Crazy Rich Asian.', 3);

INSERT INTO replies (body, associated_author, associated_question, parent_reply ) VALUES ('Pho is my favorite food.', 1, 1 ,NULL);
INSERT INTO replies (body, associated_author, associated_question, parent_reply ) VALUES ('BanhMi is my favorite food', 1, 1 ,1);

INSERT INTO replies (body, associated_author, associated_question, parent_reply ) VALUES ('Twice is my favorite kpop group.', 2, 2 ,NULL);
INSERT INTO replies (body, associated_author, associated_question, parent_reply ) VALUES ('BTS is my favorite kpop group.', 2, 2 ,1);
INSERT into replies (body, associated_author, associated_question, parent_reply ) VALUES ('BlackPink is my favorite kpop group.', 2, 2 ,2);

INSERT INTO questions_likes (question_id, users_id, likes) VALUES (1, 1, 1);
INSERT INTO questions_likes (question_id, users_id, likes) VALUES (1, 2, 1);

