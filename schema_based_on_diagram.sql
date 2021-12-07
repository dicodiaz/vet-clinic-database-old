CREATE TABLE patients (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    date_of_birth DATE NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT chk_date_of_birth CHECK (date_of_birth < CURRENT_DATE)
)