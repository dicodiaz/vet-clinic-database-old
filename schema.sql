/* Database schema to keep the structure of entire database. */
CREATE TABLE animals (
  id INT GENERATED BY DEFAULT AS IDENTITY,
  name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT NOT NULL,
  neutered BOOLEAN NOT NULL,
  weight_kg DEC NOT NULL,
  PRIMARY KEY (id)
);

-- Add a column species of type string to your animals table.
ALTER TABLE
  animals
ADD
  species VARCHAR(100);

/* Create a table named owners with the following columns:
 id: integer (set it as autoincremented PRIMARY KEY)
 full_name: string
 age: integer */
CREATE TABLE owners (
  id INT GENERATED BY DEFAULT AS IDENTITY,
  full_name VARCHAR(100) NOT NULL,
  age INT NOT NULL,
  PRIMARY KEY (id)
);

/* Create a table named species with the following columns:
 id: integer (set it as autoincremented PRIMARY KEY)
 name: string */
CREATE TABLE species (
  id INT GENERATED BY DEFAULT AS IDENTITY,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

/* Modify animals table:
 Make sure that id is set as autoincremented PRIMARY KEY
 Remove column species
 Add column species_id which is a foreign key referencing species table
 Add column owner_id which is a foreign key referencing the owners table */
ALTER TABLE
  animals DROP species;

ALTER TABLE
  animals
ADD
  species_id INT;

ALTER TABLE
  animals
ADD
  CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE;

ALTER TABLE
  animals
ADD
  owner_id INT;

ALTER TABLE
  animals
ADD
  CONSTRAINT fk_owner FOREIGN KEY(owner_id) REFERENCES owners(id) ON DELETE CASCADE;

/* Create a table named vets with the following columns:
 id: integer (set it as autoincremented PRIMARY KEY)
 name: string
 age: integer
 date_of_graduation: date */
CREATE TABLE vets(
  id INT GENERATED BY DEFAULT AS IDENTITY,
  name VARCHAR(100) NOT NULL,
  age INT NOT NULL,
  date_of_graduation DATE NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT chk_age CHECK (age >= 0),
  CONSTRAINT chk_date_of_graduation CHECK (date_of_graduation < CURRENT_DATE)
);

-- There is a many-to-many relationship between the tables species and vets: a vet can specialize in multiple species, and a species can have multiple vets specialized in it. Create a "join table" called specializations to handle this relationship.
CREATE TABLE specializations(
  id INT GENERATED BY DEFAULT AS IDENTITY,
  vet_id INT NOT NULL,
  species_id INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_vet FOREIGN KEY(vet_id) REFERENCES vets(id) ON DELETE CASCADE,
  CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE
);

-- There is a many-to-many relationship between the tables animals and vets: an animal can visit multiple vets and one vet can be visited by multiple animals. Create a "join table" called visits to handle this relationship, it should also keep track of the date of the visit.
CREATE TABLE visits(
  id INT GENERATED BY DEFAULT AS IDENTITY,
  animal_id INT NOT NULL,
  vet_id INT NOT NULL,
  date_of_visit DATE NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT date_of_visit CHECK (date_of_visit < CURRENT_DATE),
  CONSTRAINT fk_animal FOREIGN KEY(animal_id) REFERENCES animals(id) ON DELETE CASCADE,
  CONSTRAINT fk_vet FOREIGN KEY(vet_id) REFERENCES vets(id) ON DELETE CASCADE
);

ALTER TABLE
  owners
ADD
  COLUMN email VARCHAR(120);

INSERT INTO
  visits (animal_id, vet_id, date_of_visit)
SELECT
  *
FROM
  (
    SELECT
      id
    FROM
      animals
  ) animal_ids,
  (
    SELECT
      id
    FROM
      vets
  ) vets_ids,
  generate_series(
    '1980-01-01' :: timestamp,
    '2021-01-01',
    '4 hours'
  ) visit_timestamp;

INSERT INTO
  owners (full_name, email)
SELECT
  'Owner ' || generate_series(1, 2500000),
  'owner_' || generate_series(1, 2500000) || '@mail.com';


CREATE INDEX vet_id_asc ON visits(vet_id ASC);

-- Other commands that I found helpful but aren't a part of the project:
-- Add constrain to animals.escape_attempts field so that it can only contain positive values or zero.
ALTER TABLE
  animals
ADD
  CONSTRAINT chk_escape_attempts CHECK (escape_attempts >= 0);

-- Add constrain to animals.weight_kg field so that it can only contain positive values.
ALTER TABLE
  animals
ADD
  CONSTRAINT chk_weight_kg CHECK (weight_kg > 0);

-- Add constrain to animals.date_of_birth field so that it can only contain previous dates from today.
ALTER TABLE
  animals
ADD
  CONSTRAINT chk_date_of_birth CHECK (date_of_birth < CURRENT_DATE);

-- Add constrain to owners.age field so that it can only contain positive values or zero.
ALTER TABLE
  owners
ADD
  CONSTRAINT chk_age CHECK (age >= 0);

-- Add constrain to vets.age field so that it can only contain positive values or zero.
ALTER TABLE
  vets
ADD
  CONSTRAINT chk_age CHECK (age >= 0);

-- Add constrain to vets.date_of_graduation field so that it can only contain previous dates from today.
ALTER TABLE
  vets
ADD
  CONSTRAINT chk_date_of_graduation CHECK (date_of_graduation < CURRENT_DATE);

-- Add constrain to visits.date_of_visit field so that it can only contain previous dates from today.
ALTER TABLE
  visits
ADD
  CONSTRAINT date_of_visit CHECK (date_of_visit < CURRENT_DATE);

-- Remove constraints.
ALTER TABLE
  animals DROP CONSTRAINT chk_escape_attempts;

ALTER TABLE
  animals DROP CONSTRAINT chk_weight_kg;

ALTER TABLE
  animals DROP CONSTRAINT chk_date_of_birth;

ALTER TABLE
  owners DROP CONSTRAINT chk_age;

ALTER TABLE
  vets DROP CONSTRAINT chk_age;

ALTER TABLE
  vets DROP CONSTRAINT chk_date_of_graduation;

ALTER TABLE
  visits DROP CONSTRAINT date_of_visit;

ALTER TABLE
  animals DROP CONSTRAINT fk_species;

ALTER TABLE
  animals DROP CONSTRAINT fk_owner;

ALTER TABLE
  specializations DROP CONSTRAINT fk_vet;

ALTER TABLE
  specializations DROP CONSTRAINT fk_species;

ALTER TABLE
  visits DROP CONSTRAINT fk_animal;

ALTER TABLE
  visits DROP CONSTRAINT fk_vet;

-- Only to run in extreme cases.
DROP TABLE IF EXISTS animals;
