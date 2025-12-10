-- ============================================================================
-- Lereta Intelligence Agent - Database and Schema Setup
-- ============================================================================
-- Purpose: Initialize the database, schema, and warehouse for the Lereta
--          Intelligence Agent solution
-- ============================================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS LERETA_INTELLIGENCE;

-- Use the database
USE DATABASE LERETA_INTELLIGENCE;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;
CREATE SCHEMA IF NOT EXISTS ML_MODELS
  COMMENT = 'ML model registry and prediction functions';

-- Create a virtual warehouse for query processing
CREATE OR REPLACE WAREHOUSE LERETA_WH WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Lereta Intelligence Agent queries';

-- Set the warehouse as active
USE WAREHOUSE LERETA_WH;

-- Display confirmation
SELECT 'Database, schema, and warehouse setup completed successfully' AS STATUS;

