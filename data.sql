/* Populate database with sample data. */
INSERT INTO
  animals (
    name,
    date_of_birth,
    weight_kg,
    neutered,
    escape_attempts
  )
VALUES
  (
    'Agumon',
    TO_DATE('2020-02-03', 'YYYY-MM-DD'),
    10.23,
    TRUE,
    0
  ),
  (
    'Gabumon',
    TO_DATE('2018-11-15', 'YYYY-MM-DD'),
    8,
    TRUE,
    2
  ),
  (
    'Pikachu',
    TO_DATE('2021-01-07', 'YYYY-MM-DD'),
    15.04,
    FALSE,
    1
  ),
  (
    'Devimon',
    TO_DATE('2017-05-12', 'YYYY-MM-DD'),
    11,
    TRUE,
    5
  );