/* Database schema to keep the structure of entire database. */
CREATE TABLE animals (
  id int generated always AS identity PRIMARY KEY,
  name varchar(100),
  date_of_birth date,
  escape_attempts int,
  neutered boolean,
  weight_kg decimal
);