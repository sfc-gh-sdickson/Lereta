-- ============================================================================
-- Lereta Intelligence Agent - AI Agent Creation
-- ============================================================================
-- Purpose: Create and configure the Lereta Intelligence Agent in Snowflake
--          This agent integrates:
--          - Semantic Views (structured data analytics)
--          - Cortex Search Services (unstructured document search)
--          - ML Models (predictive analytics)
-- Based on: Microchip Intelligence Template
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE LERETA_WH;
USE ROLE ACCOUNTADMIN;

-- ============================================================================
-- Step 1: Grant Required Privileges for Cortex Services
-- ============================================================================

-- Grant Cortex Analyst user role (required for using Cortex features)
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE ACCOUNTADMIN;

-- Grant usage on database and schemas
GRANT USAGE ON DATABASE LERETA_INTELLIGENCE TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA LERETA_INTELLIGENCE.ANALYTICS TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA LERETA_INTELLIGENCE.RAW TO ROLE ACCOUNTADMIN;

-- Grant privileges on semantic views
GRANT REFERENCES, SELECT ON SEMANTIC VIEW LERETA_INTELLIGENCE.ANALYTICS.SV_PROPERTY_LOAN_TAX_INTELLIGENCE TO ROLE ACCOUNTADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW LERETA_INTELLIGENCE.ANALYTICS.SV_SUBSCRIPTION_REVENUE_INTELLIGENCE TO ROLE ACCOUNTADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW LERETA_INTELLIGENCE.ANALYTICS.SV_CLIENT_SUPPORT_INTELLIGENCE TO ROLE ACCOUNTADMIN;

-- Grant usage on Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE ACCOUNTADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.TAX_DISPUTE_DOCUMENTS_SEARCH TO ROLE ACCOUNTADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.FLOOD_DETERMINATION_REPORTS_SEARCH TO ROLE ACCOUNTADMIN;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE LERETA_WH TO ROLE ACCOUNTADMIN;

-- Grant permissions on ML functions
GRANT USAGE ON FUNCTION LERETA_INTELLIGENCE.ANALYTICS.PREDICT_TAX_DELINQUENCY(VARCHAR, VARCHAR, NUMBER, VARCHAR, NUMBER, NUMBER, VARCHAR, NUMBER, NUMBER, NUMBER, VARCHAR, NUMBER, BOOLEAN, VARCHAR, VARCHAR, NUMBER, VARCHAR, NUMBER, NUMBER) TO ROLE ACCOUNTADMIN;
GRANT USAGE ON FUNCTION LERETA_INTELLIGENCE.ANALYTICS.PREDICT_CLIENT_CHURN(VARCHAR, VARCHAR, NUMBER, NUMBER, NUMBER, NUMBER, VARCHAR, VARCHAR, VARCHAR, NUMBER, NUMBER, NUMBER, BOOLEAN, NUMBER, NUMBER, NUMBER, NUMBER, NUMBER, NUMBER, NUMBER, NUMBER) TO ROLE ACCOUNTADMIN;
GRANT USAGE ON FUNCTION LERETA_INTELLIGENCE.ANALYTICS.CLASSIFY_LOAN_RISK(VARCHAR, VARCHAR, NUMBER, VARCHAR, BOOLEAN, NUMBER, NUMBER, VARCHAR, NUMBER, VARCHAR, VARCHAR, BOOLEAN, BOOLEAN, NUMBER, NUMBER, BOOLEAN, NUMBER, NUMBER, VARCHAR, NUMBER, NUMBER, VARCHAR, NUMBER) TO ROLE ACCOUNTADMIN;

-- ============================================================================
-- Step 2: Create Agent Service (Declarative Approach)
-- ============================================================================
-- Note: The AI Agent is typically created through the Snowsight UI.
--       This script provides the SQL commands to configure it programmatically.
-- ============================================================================

-- Create or replace the agent configuration
-- This creates a service that integrates Cortex Analyst, Cortex Search, and ML Models

CREATE OR REPLACE SERVICE LERETA_INTELLIGENCE_AGENT_SERVICE
IN COMPUTE POOL LERETA_AGENT_POOL
FROM SPECIFICATION $$
spec:
  containers:
  - name: agent
    image: /snowflake/cortex/intelligence:latest
    env:
      AGENT_NAME: Lereta Intelligence Agent
      AGENT_DESCRIPTION: |
        AI agent for Lereta tax monitoring, flood certification, and compliance analytics.
        Orchestrates between structured data (Cortex Analyst), unstructured content (Cortex Search),
        and predictive ML models for comprehensive business intelligence.
      
      # Cortex Analyst Semantic Views
      SEMANTIC_VIEWS: |
        - LERETA_INTELLIGENCE.ANALYTICS.SV_PROPERTY_LOAN_TAX_INTELLIGENCE
        - LERETA_INTELLIGENCE.ANALYTICS.SV_SUBSCRIPTION_REVENUE_INTELLIGENCE
        - LERETA_INTELLIGENCE.ANALYTICS.SV_CLIENT_SUPPORT_INTELLIGENCE
      
      # Cortex Search Services
      SEARCH_SERVICES: |
        - LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH
        - LERETA_INTELLIGENCE.RAW.TAX_DISPUTE_DOCUMENTS_SEARCH
        - LERETA_INTELLIGENCE.RAW.FLOOD_DETERMINATION_REPORTS_SEARCH
      
      # ML Model Functions
      ML_FUNCTIONS: |
        - LERETA_INTELLIGENCE.ANALYTICS.PREDICT_TAX_DELINQUENCY
        - LERETA_INTELLIGENCE.ANALYTICS.PREDICT_CLIENT_CHURN
        - LERETA_INTELLIGENCE.ANALYTICS.CLASSIFY_LOAN_RISK
      
      # Agent Instructions
      SYSTEM_PROMPT: |
        You are a specialized analytics assistant for Lereta, a tax and flood services provider 
        for the financial services industry. Your capabilities include:
        
        1. STRUCTURED DATA ANALYTICS (via Cortex Analyst):
           - Property tax monitoring and delinquency tracking
           - Flood certification and insurance requirements
           - Loan portfolio analytics and risk assessment
           - Client subscription and revenue analysis
           - Support ticket efficiency and satisfaction metrics
        
        2. UNSTRUCTURED DOCUMENT SEARCH (via Cortex Search):
           - Support transcripts: Find similar customer issues and resolutions
           - Tax dispute documents: Research appeals and successful strategies
           - Flood determination reports: Access FEMA zone details and requirements
        
        3. PREDICTIVE ANALYTICS (via ML Models):
           - Tax Delinquency Prediction: Identify properties at risk
           - Client Churn Prediction: Flag at-risk client accounts
           - Loan Risk Classification: Categorize loans by risk level
        
        RESPONSE GUIDELINES:
        - For metrics/KPIs: Use Cortex Analyst on semantic views
        - For document context: Use Cortex Search services
        - For predictions: Call ML model functions
        - Keep responses concise (3-4 sentences when possible)
        - Always cite data sources (semantic view, search service, or ML model)
        - Format numerical data clearly with units and time periods
        - Highlight critical issues (delinquencies, high-risk, churn risk) prominently
        - For tax questions: Always check payment status and delinquency
        - For flood questions: Always indicate if insurance is required
        - For risk assessments: Use ML models and explain key factors
      
      WAREHOUSE: LERETA_WH
      QUERY_TIMEOUT: 60
      
    resources:
      requests:
        memory: 4Gi
        cpu: 2
      limits:
        memory: 8Gi
        cpu: 4
  
  endpoints:
  - name: agent-api
    port: 8080
    public: true
$$;

-- ============================================================================
-- Step 3: Alternative - Create Agent via SQL API (if supported)
-- ============================================================================
-- This is a conceptual representation. Actual implementation may vary based on
-- Snowflake's agent creation API availability
-- ============================================================================

-- Create agent metadata table to track configurations
CREATE TABLE IF NOT EXISTS AGENT_CONFIGS (
    agent_id VARCHAR(50) PRIMARY KEY,
    agent_name VARCHAR(200) NOT NULL,
    agent_description TEXT,
    semantic_views ARRAY,
    search_services ARRAY,
    ml_functions ARRAY,
    system_prompt TEXT,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    is_active BOOLEAN DEFAULT TRUE
);

-- Insert agent configuration
INSERT INTO AGENT_CONFIGS 
VALUES (
    'LERETA_INTELLIGENCE_AGENT',
    'Lereta Intelligence Agent',
    'AI agent for Lereta tax monitoring, flood certification, and compliance analytics. Integrates structured data analytics (Cortex Analyst), unstructured document search (Cortex Search), and predictive ML models.',
    ARRAY_CONSTRUCT(
        'LERETA_INTELLIGENCE.ANALYTICS.SV_PROPERTY_LOAN_TAX_INTELLIGENCE',
        'LERETA_INTELLIGENCE.ANALYTICS.SV_SUBSCRIPTION_REVENUE_INTELLIGENCE',
        'LERETA_INTELLIGENCE.ANALYTICS.SV_CLIENT_SUPPORT_INTELLIGENCE'
    ),
    ARRAY_CONSTRUCT(
        'LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
        'LERETA_INTELLIGENCE.RAW.TAX_DISPUTE_DOCUMENTS_SEARCH',
        'LERETA_INTELLIGENCE.RAW.FLOOD_DETERMINATION_REPORTS_SEARCH'
    ),
    ARRAY_CONSTRUCT(
        'LERETA_INTELLIGENCE.ANALYTICS.PREDICT_TAX_DELINQUENCY',
        'LERETA_INTELLIGENCE.ANALYTICS.PREDICT_CLIENT_CHURN',
        'LERETA_INTELLIGENCE.ANALYTICS.CLASSIFY_LOAN_RISK'
    ),
    'You are a specialized analytics assistant for Lereta, a tax and flood services provider for the financial services industry. You have access to structured data analytics via Cortex Analyst, unstructured document search via Cortex Search, and predictive ML models. Always identify your data source and keep responses concise and actionable.',
    CURRENT_TIMESTAMP(),
    CURRENT_TIMESTAMP(),
    TRUE
);

-- ============================================================================
-- Step 4: Create Helper Functions for Agent Interactions
-- ============================================================================

-- Function to query semantic views through the agent
CREATE OR REPLACE FUNCTION AGENT_QUERY_SEMANTIC_VIEW(
    view_name VARCHAR,
    user_question VARCHAR
)
RETURNS VARIANT
LANGUAGE SQL
AS
$$
    -- This would integrate with Cortex Analyst
    -- Placeholder for actual Cortex Analyst query
    SELECT OBJECT_CONSTRUCT(
        'view', view_name,
        'question', user_question,
        'status', 'Query submitted to Cortex Analyst',
        'timestamp', CURRENT_TIMESTAMP()
    )
$$;

-- Function to search documents through the agent
CREATE OR REPLACE FUNCTION AGENT_SEARCH_DOCUMENTS(
    search_service VARCHAR,
    search_query VARCHAR,
    limit_results INTEGER
)
RETURNS TABLE (
    document_id VARCHAR,
    relevance_score FLOAT,
    document_text TEXT
)
LANGUAGE SQL
AS
$$
    -- This would integrate with Cortex Search
    -- Example for support transcripts
    WITH search_results AS (
        SELECT PARSE_JSON(
            SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
                search_service,
                OBJECT_CONSTRUCT(
                    'query', search_query,
                    'limit', limit_results
                )::VARCHAR
            )
        )['results'] AS results
    )
    SELECT 
        result.value:id::VARCHAR AS document_id,
        result.value:score::FLOAT AS relevance_score,
        result.value:text::TEXT AS document_text
    FROM search_results,
    LATERAL FLATTEN(input => results) AS result
$$;

-- Function to get ML predictions through the agent
CREATE OR REPLACE FUNCTION AGENT_GET_ML_PREDICTIONS(
    model_name VARCHAR,
    entity_id VARCHAR
)
RETURNS OBJECT
LANGUAGE SQL
AS
$$
    SELECT OBJECT_CONSTRUCT(
        'model', model_name,
        'entity_id', entity_id,
        'prediction', CASE 
            WHEN model_name = 'TAX_DELINQUENCY_PREDICTOR' THEN 'Use PREDICT_TAX_DELINQUENCY function'
            WHEN model_name = 'CLIENT_CHURN_PREDICTOR' THEN 'Use PREDICT_CLIENT_CHURN function'
            WHEN model_name = 'LOAN_RISK_CLASSIFIER' THEN 'Use CLASSIFY_LOAN_RISK function'
            ELSE 'Unknown model'
        END,
        'timestamp', CURRENT_TIMESTAMP()
    )
$$;

-- ============================================================================
-- Step 5: Create Sample Agent Queries for Testing
-- ============================================================================

-- Create a view with sample questions for the agent
CREATE OR REPLACE VIEW AGENT_SAMPLE_QUESTIONS AS
SELECT * FROM VALUES
    ('TAX_001', 'STRUCTURED', 'How many properties have delinquent property taxes?', 'SV_PROPERTY_LOAN_TAX_INTELLIGENCE'),
    ('FLOOD_001', 'STRUCTURED', 'Which properties require flood insurance due to high-risk zones?', 'SV_PROPERTY_LOAN_TAX_INTELLIGENCE'),
    ('CLIENT_001', 'STRUCTURED', 'What is the average client satisfaction rating?', 'SV_CLIENT_SUPPORT_INTELLIGENCE'),
    ('REVENUE_001', 'STRUCTURED', 'What is the monthly recurring revenue from subscriptions?', 'SV_SUBSCRIPTION_REVENUE_INTELLIGENCE'),
    ('SUPPORT_001', 'UNSTRUCTURED', 'Search support transcripts for tax payment issues', 'SUPPORT_TRANSCRIPTS_SEARCH'),
    ('DISPUTE_001', 'UNSTRUCTURED', 'Find tax dispute documents about successful assessment appeals', 'TAX_DISPUTE_DOCUMENTS_SEARCH'),
    ('FLOOD_002', 'UNSTRUCTURED', 'What do flood determination reports say about Zone AE properties?', 'FLOOD_DETERMINATION_REPORTS_SEARCH'),
    ('ML_001', 'PREDICTION', 'Predict tax delinquency risk for high-value properties', 'PREDICT_TAX_DELINQUENCY'),
    ('ML_002', 'PREDICTION', 'Identify clients at risk of churn', 'PREDICT_CLIENT_CHURN'),
    ('ML_003', 'PREDICTION', 'Classify loans by risk level', 'CLASSIFY_LOAN_RISK'),
    ('HYBRID_001', 'HYBRID', 'Show me delinquent properties and search for similar support cases', 'MULTIPLE'),
    ('HYBRID_002', 'HYBRID', 'Which high-risk loans need attention and what do our procedures say?', 'MULTIPLE')
AS T(question_id, query_type, question_text, data_source);

-- ============================================================================
-- Step 6: Create Agent Monitoring and Logging
-- ============================================================================

-- Create table to log agent interactions
CREATE TABLE IF NOT EXISTS AGENT_INTERACTION_LOG (
    log_id VARCHAR(50) DEFAULT UUID_STRING(),
    session_id VARCHAR(50),
    user_id VARCHAR(100),
    user_question TEXT,
    query_type VARCHAR(50), -- STRUCTURED, UNSTRUCTURED, PREDICTION, HYBRID
    data_sources ARRAY,
    agent_response TEXT,
    response_time_ms NUMBER,
    tokens_used NUMBER,
    success BOOLEAN,
    error_message TEXT,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (log_id)
);

-- Create view for agent performance metrics
CREATE OR REPLACE VIEW AGENT_PERFORMANCE_METRICS AS
SELECT 
    DATE_TRUNC('day', created_at) AS date,
    query_type,
    COUNT(*) AS total_queries,
    SUM(CASE WHEN success THEN 1 ELSE 0 END) AS successful_queries,
    AVG(response_time_ms) AS avg_response_time_ms,
    SUM(tokens_used) AS total_tokens_used,
    AVG(tokens_used) AS avg_tokens_per_query
FROM AGENT_INTERACTION_LOG
GROUP BY date, query_type
ORDER BY date DESC, query_type;

-- ============================================================================
-- Step 7: Agent Configuration Summary
-- ============================================================================

CREATE OR REPLACE VIEW AGENT_CONFIGURATION_SUMMARY AS
SELECT 
    'LERETA_INTELLIGENCE_AGENT' AS agent_id,
    'Lereta Intelligence Agent' AS agent_name,
    'Production' AS environment,
    
    -- Semantic Views
    ARRAY_CONSTRUCT(
        'SV_PROPERTY_LOAN_TAX_INTELLIGENCE',
        'SV_SUBSCRIPTION_REVENUE_INTELLIGENCE',
        'SV_CLIENT_SUPPORT_INTELLIGENCE'
    ) AS semantic_views,
    
    -- Cortex Search Services
    ARRAY_CONSTRUCT(
        'SUPPORT_TRANSCRIPTS_SEARCH',
        'TAX_DISPUTE_DOCUMENTS_SEARCH',
        'FLOOD_DETERMINATION_REPORTS_SEARCH'
    ) AS search_services,
    
    -- ML Models
    ARRAY_CONSTRUCT(
        'TAX_DELINQUENCY_PREDICTOR',
        'CLIENT_CHURN_PREDICTOR',
        'LOAN_RISK_CLASSIFIER'
    ) AS ml_models,
    
    -- Capabilities
    ARRAY_CONSTRUCT(
        'Structured Data Analytics',
        'Unstructured Document Search',
        'Predictive ML Models',
        'Hybrid Query Orchestration'
    ) AS capabilities,
    
    -- Status
    TRUE AS is_active,
    CURRENT_TIMESTAMP() AS last_updated;

-- ============================================================================
-- Step 8: Validation Queries
-- ============================================================================

-- Verify semantic views exist
SELECT 'Semantic Views' AS component, 
       COUNT(*) AS count 
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'ANALYTICS' 
  AND TABLE_NAME LIKE 'SV_%';

-- Verify Cortex Search services exist
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- Verify ML functions exist
SELECT 'ML Functions' AS component,
       COUNT(*) AS count
FROM INFORMATION_SCHEMA.FUNCTIONS
WHERE FUNCTION_SCHEMA = 'ANALYTICS'
  AND (FUNCTION_NAME LIKE 'PREDICT_%' OR FUNCTION_NAME LIKE 'CLASSIFY_%');

-- Display agent configuration
SELECT * FROM AGENT_CONFIGURATION_SUMMARY;

-- Display sample questions
SELECT * FROM AGENT_SAMPLE_QUESTIONS ORDER BY query_type, question_id;

-- ============================================================================
-- Step 9: Next Steps for Agent Deployment
-- ============================================================================

/*
To complete the agent deployment:

1. **Snowsight UI Configuration** (Recommended):
   - Navigate to AI & ML > Agents in Snowsight
   - Click "Create Agent" > "Create this agent for Snowflake Intelligence"
   - Name: LERETA_INTELLIGENCE_AGENT
   - Add Cortex Analyst tools (all 3 semantic views)
   - Add Cortex Search services (all 3 search services)
   - Configure orchestration with system prompt from this script
   - Add sample questions from AGENT_SAMPLE_QUESTIONS view

2. **ML Model Integration**:
   - Test each ML function with sample data
   - Create stored procedures for batch predictions
   - Set up scheduled jobs for proactive alerts

3. **Monitoring and Maintenance**:
   - Monitor AGENT_PERFORMANCE_METRICS view
   - Review AGENT_INTERACTION_LOG for usage patterns
   - Retrain ML models quarterly or when performance degrades
   - Update semantic views as business requirements change

4. **Security and Access Control**:
   - Create role LERETA_AGENT_USER for end users
   - Grant appropriate permissions
   - Implement row-level security if needed
   - Configure authentication and authorization

5. **Testing**:
   - Test all sample questions from AGENT_SAMPLE_QUESTIONS
   - Verify ML model predictions are accurate
   - Validate Cortex Search returns relevant results
   - Test hybrid queries that span multiple data sources

6. **Documentation**:
   - Update docs/AGENT_SETUP.md with ML model details
   - Create user guide with example questions
   - Document ML model features and retraining procedures
*/

-- ============================================================================
-- Agent Creation Complete
-- ============================================================================
SELECT 
    '✅ Lereta Intelligence Agent Configuration Complete' AS status,
    '3 Semantic Views + 3 Cortex Search Services + 3 ML Models' AS components,
    'Follow docs/AGENT_SETUP.md for Snowsight UI configuration' AS next_steps,
    CURRENT_TIMESTAMP() AS completed_at;

