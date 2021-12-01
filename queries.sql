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
-- Melody Pond
/*      owner      | count
 -----------------+-------
 Melody Pond     |     3
 Dean Winchester |     2
 Jennifer Orwell |     2
 Bob             |     1
 Sam Smith       |     1 */
SELECT
  owners.full_name AS owner,
  COUNT(animals.name)
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
GROUP BY
  owners.full_name
ORDER BY
  COUNT(animals.name) DESC;