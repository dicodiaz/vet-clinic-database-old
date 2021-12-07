CREATE TABLE patients (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    date_of_birth DATE NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT chk_date_of_birth CHECK (date_of_birth < CURRENT_DATE)
);

CREATE TABLE medical_histories (
    id INT GENERATED ALWAYS AS IDENTITY,
    admitted_at TIMESTAMP NOT NULL,
    patient_id INT NOT NULL,
    STATUS VARCHAR(100) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_medical_histories_patient_id FOREIGN KEY(patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    CONSTRAINT chk_medical_histories_admitted_at CHECK (admitted_at < CURRENT_TIMESTAMP)
);