
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,  
    brand_id SERIAL not null REFERENCES brands(brand_id),  -- Auto-increment
    product_line VARCHAR,
    product_class VARCHAR,
    product_size VARCHAR,
    list_price DECIMAL,
    standard_cost DECIMAL
);

CREATE TABLE brands (
    brand_id SERIAL PRIMARY KEY,
    brand VARCHAR
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name not null VARCHAR(100),
    last_name not null VARCHAR(100),
    gender BOOLEAN,
    DOB DATE,
    job_id SERIAL not null REFERENCES jobs(job_id),  -- Auto-increment
    wealth_segment VARCHAR(50),
    deceased_indicator CHAR(1),
    owns_car BOOLEAN,
    address_id SERIAL REFERENCES addresses(address_id)  -- Auto-increment
);

CREATE TABLE jobs (
    job_id SERIAL PRIMARY KEY,
    job_title VARCHAR,
    job_industry_category VARCHAR
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    address VARCHAR,
    postcode INTEGER,
    state_id SERIAL not null REFERENCES states(state_id),  -- Auto-increment
    country_id SERIAL not null REFERENCES countries(country_id)  -- Auto-increment
);

CREATE TABLE states (
    state_id SERIAL PRIMARY KEY,
    state VARCHAR
);

CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country VARCHAR
);

CREATE TABLE property (
    property_id SERIAL PRIMARY KEY,
    customer_id INTEGER not null REFERENCES customers(customer_id),
    property_valuation INTEGER
);

CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    product_id INTEGER not null REFERENCES products(product_id), 
    customer_id INTEGER not null REFERENCES customers(customer_id), 
    transaction_date DATE,
    online_order BOOLEAN,
    order_status VARCHAR
);


INSERT INTO brands (brand) VALUES ('Unknown Brand') ON CONFLICT DO NOTHING;


ALTER TABLE customers 
ALTER COLUMN gender TYPE VARCHAR(10);


INSERT INTO jobs (job_title) VALUES ('Unknown Job') ON CONFLICT DO NOTHING;
SELECT job_id FROM jobs WHERE job_title = 'Unknown Job';
