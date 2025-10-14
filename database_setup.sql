-- ====================================================================
-- Step 1: Create the Database
-- This command creates a new database for our project.
-- Note: Some SQL clients require you to run this command separately.
-- In others, you might create the database through the UI.
-- ====================================================================

CREATE DATABASE report_db;


-- ====================================================================
-- Step 2: Create the Superstore Table
-- This command creates the table that will hold the superstore sales data.
-- The column names and data types are based on the standard
-- "Sample - Superstore" dataset.
--
-- Note on Data Types:
-- - VARCHAR is used for text fields. The length (e.g., 255) is a max length.
-- - DATE is for date values.
-- - DECIMAL(10, 2) is used for currency to handle precision.
-- - INT is for whole numbers.
-- ====================================================================

CREATE TABLE superstore (
    "Row ID" INT,
    "Order ID" VARCHAR(255),
    "Ship Mode" VARCHAR(255),
    "Customer ID" VARCHAR(255),
    "Customer Name" VARCHAR(255),
    "Segment" VARCHAR(255),
    "Country" VARCHAR(255),
    "City" VARCHAR(255),
    "State" VARCHAR(255),
    "Postal Code" INT,
    "Region" VARCHAR(255),
    "Product ID" VARCHAR(255),
    "Category" VARCHAR(255),
    "Sub-Category" VARCHAR(255),
    "Product Name" VARCHAR(255),
    "Sales" DECIMAL(10, 2),
    "Quantity" INT,
    "Discount" DECIMAL(10, 2),
    "Profit" DECIMAL(10, 2)
);

-- After running this script, you will have an empty 'superstore' table
-- in your 'report_db' database, ready for data import.
