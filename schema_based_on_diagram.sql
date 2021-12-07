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

CREATE TABLE treatments (
    id INT GENERATED ALWAYS AS IDENTITY,
    TYPE VARCHAR(250) NOT NULL,
    name VARCHAR(250) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE join_table_histories_treatments (
    medical_histories_id INT NOT NULL,
    treatments_id INT NOT NULL,
    PRIMARY KEY(medical_histories_id, treatments_id),
    FOREIGN KEY (medical_histories_id) REFERENCES medical_histories(id),
    FOREIGN KEY (treatments_id) REFERENCES treatments(id)
);

CREATE TABLE invoices (
    id INT GENERATED ALWAYS AS IDENTITY,
    total_amount DECIMAL NOT NULL,
    generated_at TIMESTAMP NOT NULL,
    paid_at TIMESTAMP NOT NULL,
    medical_history_id INT NOT NULL UNIQUE,
    PRIMARY KEY (id),
    FOREIGN KEY (medical_history_id) REFERENCES medical_histories(id),
    CONSTRAINT chk_invoices_total_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_invoices_generated_at CHECK (generated_at < CURRENT_TIMESTAMP),
    CONSTRAINT chk_invoices_paid_at CHECK (paid_at < CURRENT_TIMESTAMP)
);

CREATE TABLE invoice_items (
    id INT GENERATED ALWAYS AS IDENTITY,
    unit_price DECIMAL NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL NOT NULL,
    invoice_id INT NOT NULL,
    treatment_id INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (invoice_id) REFERENCES invoices(id),
    FOREIGN KEY (treatment_id) REFERENCES treatments(id),
    CONSTRAINT chk_invoice_items_unit_price CHECK (unit_price >= 0),
    CONSTRAINT chk_invoice_items_quantity CHECK (quantity >= 0),
    CONSTRAINT chk_invoice_items_total_price CHECK (total_price >= 0)
);