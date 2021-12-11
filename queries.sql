/* Queries that provide answers to the questions from all projects. */
-- Find all animals whose name ends in "mon".
SELECT
  *
FROM
  animals
WHERE
  name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT
  name
FROM
  animals
WHERE
  date_of_birth BETWEEN TO_DATE('2016-01-01', 'YYYY-MM-DD')
  AND TO_DATE('2019-12-31', 'YYYY-MM-DD');

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT
  name
FROM
  animals
WHERE
  neutered = TRUE
  AND escape_attempts < 3;

-- List date of birth of all animals named either "Agumon" or "Pikachu".
SELECT
  date_of_birth
FROM
  animals
WHERE
  name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg.
SELECT
  name,
  escape_attempts
FROM
  animals
WHERE
  weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT
  *
FROM
  animals
WHERE
  neutered = TRUE;

-- Find all animals not named Gabumon.
SELECT
  *
FROM
  animals
WHERE
  name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg).
SELECT
  *
FROM
  animals
WHERE
  weight_kg BETWEEN 10.4
  AND 17.3;

-- How many animals are there?
-- 9
SELECT
  COUNT(*)
FROM
  animals;

-- How many animals have never tried to escape?
-- 2
SELECT
  COUNT(*)
FROM
  animals
WHERE
  escape_attempts = 0;

-- What is the average weight of animals?
-- 16.64kg
SELECT
  avg(weight_kg)
FROM
  animals;

-- Who escapes the most, neutered or not neutered animals?
-- Neutered
/* neutered | sum
 ----------+-----
 f        |   4
 t        |  18 */
SELECT
  neutered,
  SUM(escape_attempts)
FROM
  animals
GROUP BY
  neutered;

-- What is the minimum and maximum weight of each type of animal?
/* species | min | max
 ---------+-----+-----
 pokemon |  11 |  17
 digimon |   8 |  45 */
SELECT
  species,
  MIN(weight_kg),
  MAX(weight_kg)
FROM
  animals
GROUP BY
  species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
-- 3 for pokemon, N/A for digimon since there is not a single digimon that satisfies the condition
/* species |        avg
 ---------+--------------------
 pokemon | 3.0000000000000000 */
SELECT
  species,
  AVG(escape_attempts)
FROM
  animals
WHERE
  date_of_birth BETWEEN TO_DATE('1990-01-01', 'YYYY-MM-DD')
  AND TO_DATE('2000-12-31', 'YYYY-MM-DD')
GROUP BY
  species;

-- What animals belong to Melody Pond?
/*    owner    |    name
 -------------+------------
 Melody Pond | Blossom
 Melody Pond | Charmander
 Melody Pond | Squirtle */
SELECT
  owners.full_name AS owner,
  animals.name
FROM
  owners
  JOIN animals ON owners.id = animals.owner_id
WHERE
  owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
/*    name    | species
 ------------+---------
 Pikachu    | Pokemon
 Blossom    | Pokemon
 Charmander | Pokemon
 Squirtle   | Pokemon */
SELECT
  animals.name,
  species.name AS species
FROM
  animals
  JOIN species ON animals.species_id = species.id
WHERE
  species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
/*      owner      |    name
 -----------------+------------
 Sam Smith       | Agumon
 Jennifer Orwell | Gabumon
 Jennifer Orwell | Pikachu
 Bob             | Devimon
 Melody Pond     | Squirtle
 Melody Pond     | Charmander
 Melody Pond     | Blossom
 Dean Winchester | Angemon
 Dean Winchester | Boarmon
 Jodie Whittaker |            */
SELECT
  owners.full_name AS owner,
  animals.name
FROM
  owners
  LEFT JOIN animals ON owners.id = animals.owner_id;

-- How many animals are there per species?
/* count |  name
 -------+---------
 4 | Pokemon
 5 | Digimon */
SELECT
  COUNT(animals.name),
  species.name
FROM
  animals
  JOIN species ON animals.species_id = species.id
GROUP BY
  species.name;

-- List all Digimon owned by Jennifer Orwell.
/*      owner      |  name   | species
 -----------------+---------+---------
 Jennifer Orwell | Gabumon | Digimon */
SELECT
  owners.full_name AS owner,
  animals.name,
  species.name AS species
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
  JOIN species ON animals.species_id = species.id
WHERE
  owners.full_name = 'Jennifer Orwell'
  AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
/* owner | name | escape_attempts
 -------+------+----------------- */
SELECT
  owners.full_name AS owner,
  animals.name,
  animals.escape_attempts
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
WHERE
  owners.full_name = 'Dean Winchester'
  AND animals.escape_attempts = 0;

-- Who owns the most animals?
/*    owner    | count
 -------------+-------
 Melody Pond |     3 */
SELECT
  owners.full_name AS owner,
  COUNT(animals.name)
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
GROUP BY
  owners.full_name
ORDER BY
  COUNT(animals.name) DESC
LIMIT
  1;

-- Who was the last animal seen by William Tatcher?
/*       vet       |  name   | date_of_visit
 -----------------+---------+---------------
 William Tatcher | Blossom | 2021-01-11 */
SELECT
  vets.name AS vet,
  animals.name,
  visits.date_of_visit
FROM
  visits
  JOIN vets ON visits.vet_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
WHERE
  vets.name = 'William Tatcher'
ORDER BY
  visits.date_of_visit DESC
LIMIT
  1;

-- How many different animals did Stephanie Mendez see?
/*       vet        | count
 ------------------+-------
 Stephanie Mendez |     4 */
SELECT
  vets.name AS vet,
  COUNT(date_of_visit)
FROM
  visits
  JOIN vets ON visits.vet_id = vets.id
WHERE
  vets.name = 'Stephanie Mendez'
GROUP BY
  vets.name;

-- List all vets and their specialties, including vets with no specialties.
/*       vet        | specialties
 ------------------+-------------
 William Tatcher  | Pokemon
 Stephanie Mendez | Digimon
 Stephanie Mendez | Pokemon
 Jack Harkness    | Digimon
 Maisy Smith      |         */
SELECT
  vets.name AS vet,
  species.name AS specialties
FROM
  specializations
  RIGHT JOIN vets ON specializations.vet_id = vets.id
  LEFT JOIN species ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
/*  name   |       vet        | date_of_visit
 ---------+------------------+---------------
 Agumon  | Stephanie Mendez | 2020-07-22
 Blossom | Stephanie Mendez | 2020-05-24 */
SELECT
  animals.name,
  vets.name AS vet,
  visits.date_of_visit
FROM
  visits
  JOIN vets ON visits.vet_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
WHERE
  vets.name = 'Stephanie Mendez'
  AND date_of_visit BETWEEN TO_DATE('2020-04-01', 'YYYY-MM-DD')
  AND TO_DATE('2020-08-30', 'YYYY-MM-DD');

-- What animal has the most visits to vets?
/*  name   | count
 ---------+-------
 Boarmon |     4 */
SELECT
  animals.name,
  COUNT(visits.date_of_visit)
FROM
  visits
  JOIN animals ON visits.animal_id = animals.id
GROUP BY
  animals.name
ORDER BY
  COUNT(visits.date_of_visit) DESC
LIMIT
  1;

-- Who was Maisy Smith's first visit?
/*     vet     |  name   | date_of_visit
 -------------+---------+---------------
 Maisy Smith | Boarmon | 2019-01-24 */
SELECT
  vets.name AS vet,
  animals.name,
  visits.date_of_visit
FROM
  visits
  JOIN vets ON visits.vet_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
WHERE
  vets.name = 'Maisy Smith'
ORDER BY
  visits.date_of_visit ASC
LIMIT
  1;

-- Details for most recent visit: animal information, vet information, and date of visit.
/* animals_info | id |  name   | date_of_birth | escape_attempts | neutered | weight_kg | species_id | owner_id | vets_info | id |       name       | age | date_of_graduation | visits_info | id | animal_id | vet_id | date_of_visit 
 --------------+----+---------+---------------+-----------------+----------+-----------+------------+----------+-----------+----+------------------+-----+--------------------+-------------+----+-----------+--------+---------------
 --           |  4 | Devimon | 2017-05-12    |               5 | t        |        11 |          2 |        3 |           |  3 | Stephanie Mendez |  64 | 1981-05-04         |             | 26 |         4 |      3 | 2021-05-04 */
SELECT
  '' AS animals_info,
  animals.*,
  '' AS vets_info,
  vets.* AS vet,
  '' AS visits_info,
  visits.*
FROM
  visits
  JOIN vets ON visits.vet_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
ORDER BY
  visits.date_of_visit DESC
LIMIT
  1;

-- How many visits were with a vet that did not specialize in that animal's species?
-- 9
/* count |      name
 -------+-----------------
 7 | Maisy Smith
 1 | William Tatcher
 1 | Jack Harkness */
SELECT
  COUNT(visits.date_of_visit),
  vets.name
FROM
  visits
  JOIN vets ON visits.vet_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
WHERE
  NOT animals.species_id = ANY (
    ARRAY(
      SELECT
        specializations.species_id
      FROM
        specializations
      WHERE
        specializations.vet_id = vets.id
    )
  )
GROUP BY
  vets.name;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
/*     vet     | species | count
 -------------+---------+-------
 Maisy Smith | Digimon |     4 */
SELECT
  vets.name AS vet,
  species.name AS species,
  COUNT(visits.date_of_visit)
FROM
  visits
  JOIN vets ON visits.vet_id = vets.id
  JOIN animals ON visits.animal_id = animals.id
  JOIN species ON animals.species_id = species.id
WHERE
  vets.name = 'Maisy Smith'
GROUP BY
  vets.name,
  species.name
ORDER BY
  COUNT(visits.date_of_visit) DESC
LIMIT
  1;

-- First query
EXPLAIN ANALYZE
SELECT
  COUNT(*)
FROM
  visits
WHERE
  animal_id = 4;

-- First query after denormalization:
EXPLAIN ANALYZE
SELECT
  count_of_visits
FROM
  animals
WHERE
  id = 4;

-- Second query
EXPLAIN ANALYZE
SELECT
  *
FROM
  visits
WHERE
  vet_id = 2;

-- Third query
EXPLAIN ANALYZE
SELECT
  *
FROM
  owners
WHERE
  email = 'owner_18327@mail.com';