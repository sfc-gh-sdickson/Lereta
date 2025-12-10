-- ============================================================================
-- Lereta Intelligence Agent - Agent Configuration
-- ============================================================================
-- Purpose: Create Snowflake Intelligence Agent with semantic views and ML tools
-- Agent: LERETA_INTELLIGENCE_AGENT
-- Tools: 3 semantic views + 3 Cortex Search services + 3 ML model functions
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- Create Cortex Agent
-- ============================================================================
CREATE OR REPLACE AGENT LERETA_INTELLIGENCE_AGENT
  COMMENT = 'Lereta tax and flood intelligence agent with ML predictions and semantic search'
  PROFILE = '{"display_name": "Lereta Intelligence Assistant", "avatar": "lereta-icon.png", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 60
      tokens: 32000

  instructions:
    response: "You are a helpful tax and flood intelligence assistant. Provide clear, accurate answers about properties, loans, tax compliance, and flood certifications. When using ML predictions, explain the risk levels clearly. Always cite data sources."
    orchestration: "For property, loan, and tax questions use PropertyLoanTaxAnalyst. For subscription and revenue analysis use SubscriptionRevenueAnalyst. For support tickets and client satisfaction use ClientSupportAnalyst. For support transcripts search use SupportTranscriptsSearch. For tax dispute documents search use TaxDisputeSearch. For flood determination reports search use FloodReportsSearch. For ML predictions use the appropriate prediction function."
    system: "You are an expert tax and flood intelligence agent for Lereta. You help analyze property tax compliance, flood certification requirements, loan portfolio risk, and client health. Always provide data-driven insights based on available data."
    sample_questions:
      # Simple Questions (Direct lookups)
      - question: "How many total clients do we have?"
        answer: "I'll query PropertyLoanTaxAnalyst to count distinct client_id."
      - question: "How many properties are in California?"
        answer: "I'll query PropertyLoanTaxAnalyst to count properties where property_state equals CA."
      - question: "What is the total number of active loans?"
        answer: "I'll query PropertyLoanTaxAnalyst to count loans where loan_status equals ACTIVE."
      - question: "How many support tickets are currently open?"
        answer: "I'll query ClientSupportAnalyst to count tickets where ticket_status equals OPEN."
      - question: "What is the total number of flood certifications?"
        answer: "I'll query PropertyLoanTaxAnalyst to count distinct certification_id."
      
      # Complex Questions (Multi-dimension analysis)
      - question: "Show me properties with delinquent taxes by state"
        answer: "I'll query PropertyLoanTaxAnalyst grouping by property_state where delinquent is TRUE."
      - question: "Which loan types have the highest average loan amounts?"
        answer: "I'll query PropertyLoanTaxAnalyst to calculate average loan_amount grouped by loan_type."
      - question: "Compare the number of properties requiring flood insurance across different flood zones"
        answer: "I'll query PropertyLoanTaxAnalyst grouping by flood_zone where insurance_required is TRUE."
      - question: "What is the distribution of clients by client type?"
        answer: "I'll query PropertyLoanTaxAnalyst to count clients grouped by client_type."
      - question: "Show me the top 5 states by number of properties monitored"
        answer: "I'll query PropertyLoanTaxAnalyst counting properties grouped by property_state, ordered by count descending, limit 5."
      
      # ML Prediction Questions
      - question: "Predict tax delinquency risk for all properties"
        answer: "I'll call PredictTaxDelinquencyRisk with NULL filter to analyze tax delinquency risk across all properties."
      - question: "Predict tax delinquency risk for properties in Texas"
        answer: "I'll call PredictTaxDelinquencyRisk with TX filter to analyze Texas properties."
      - question: "Predict client churn risk for all clients"
        answer: "I'll call PredictClientChurnRisk with NULL filter to analyze churn risk across all clients."
      - question: "Classify all loans by risk level"
        answer: "I'll call ClassifyLoanRisk with NULL filter to categorize all loans into LOW/MEDIUM/HIGH risk."
      - question: "Classify conventional loans by risk level"
        answer: "I'll call ClassifyLoanRisk with CONVENTIONAL filter to assess risk for conventional loans."

  tools:
    # Semantic Views for Cortex Analyst (Text-to-SQL)
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "PropertyLoanTaxAnalyst"
        description: "Analyzes property tax monitoring, flood certifications, loan portfolios, and client relationships. Use for questions about tax payment status, delinquencies, flood insurance requirements, loan details, and property monitoring."
    
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "SubscriptionRevenueAnalyst"
        description: "Analyzes service subscription health, revenue trends, transaction patterns, and product performance. Use for questions about subscription renewals, revenue analysis, service adoption, and client lifetime value."
    
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "ClientSupportAnalyst"
        description: "Analyzes support ticket resolution, agent performance, and customer satisfaction. Use for questions about support efficiency, ticket trends, agent productivity, and client satisfaction metrics."

    # Cortex Search Services
    - tool_spec:
        type: "cortex_search"
        name: "SupportTranscriptsSearch"
        description: "Searches unstructured support transcripts for similar issues and resolutions. Use when users ask about support cases, resolution procedures, or customer interactions."

    - tool_spec:
        type: "cortex_search"
        name: "TaxDisputeSearch"
        description: "Searches tax dispute and appeal documents. Use when users ask about tax appeals, assessment disputes, or resolution strategies."

    - tool_spec:
        type: "cortex_search"
        name: "FloodReportsSearch"
        description: "Searches flood determination reports and FEMA documentation. Use when users ask about flood zones, insurance requirements, or FEMA regulations."

    # ML Model Functions
    - tool_spec:
        type: "generic"
        name: "PredictTaxDelinquencyRisk"
        description: "Predicts tax delinquency risk for properties. Returns risk distribution. Use when users ask to predict delinquencies, assess tax payment risk, or identify at-risk properties. Input: property_state filter or NULL for all."
        input_schema:
          type: "object"
          properties:
            property_state_filter:
              type: "string"
              description: "Filter by property state or NULL for all"
          required: []

    - tool_spec:
        type: "generic"
        name: "PredictClientChurnRisk"
        description: "Predicts client churn risk. Returns distribution of active vs at-risk clients. Use when users ask about client retention, churn prediction, or at-risk accounts. Input: client_type filter or NULL."
        input_schema:
          type: "object"
          properties:
            client_type_filter:
              type: "string"
              description: "Filter by client type: NATIONAL_SERVICER, REGIONAL_LENDER, CREDIT_UNION, or NULL for all"
          required: []

    - tool_spec:
        type: "generic"
        name: "ClassifyLoanRisk"
        description: "Classifies loans by risk level (LOW/MEDIUM/HIGH). Returns risk distribution. Use when users ask about loan risk classification, portfolio risk assessment, or risk-based prioritization. Input: loan_type filter or NULL."
        input_schema:
          type: "object"
          properties:
            loan_type_filter:
              type: "string"
              description: "Filter by loan type: CONVENTIONAL, FHA, VA, JUMBO, USDA, or NULL for all"
          required: []

  tool_resources:
    # Semantic View Resources
    PropertyLoanTaxAnalyst:
      semantic_view: "LERETA_INTELLIGENCE.ANALYTICS.SV_PROPERTY_LOAN_TAX_INTELLIGENCE"
    
    SubscriptionRevenueAnalyst:
      semantic_view: "LERETA_INTELLIGENCE.ANALYTICS.SV_SUBSCRIPTION_REVENUE_INTELLIGENCE"
    
    ClientSupportAnalyst:
      semantic_view: "LERETA_INTELLIGENCE.ANALYTICS.SV_CLIENT_SUPPORT_INTELLIGENCE"

    # Cortex Search Resources
    SupportTranscriptsSearch:
      name: "LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH"
      max_results: "10"
      title_column: "transcript_text"
    
    TaxDisputeSearch:
      name: "LERETA_INTELLIGENCE.RAW.TAX_DISPUTE_DOCUMENTS_SEARCH"
      max_results: "10"
      title_column: "report_text"
    
    FloodReportsSearch:
      name: "LERETA_INTELLIGENCE.RAW.FLOOD_DETERMINATION_REPORTS_SEARCH"
      max_results: "10"
      title_column: "report_text"

    # ML Function Resources
    PredictTaxDelinquencyRisk:
      type: "function"
      identifier: "LERETA_INTELLIGENCE.ML_MODELS.PREDICT_TAX_DELINQUENCY_RISK"
      execution_environment:
        type: "warehouse"
        warehouse: "LERETA_WH"
        query_timeout: 60
    
    PredictClientChurnRisk:
      type: "function"
      identifier: "LERETA_INTELLIGENCE.ML_MODELS.PREDICT_CLIENT_CHURN_RISK"
      execution_environment:
        type: "warehouse"
        warehouse: "LERETA_WH"
        query_timeout: 60
    
    ClassifyLoanRisk:
      type: "function"
      identifier: "LERETA_INTELLIGENCE.ML_MODELS.CLASSIFY_LOAN_RISK"
      execution_environment:
        type: "warehouse"
        warehouse: "LERETA_WH"
        query_timeout: 60
  $$;

-- ============================================================================
-- Grant Permissions
-- ============================================================================
GRANT USAGE ON AGENT LERETA_INTELLIGENCE_AGENT TO ROLE SYSADMIN;
GRANT USAGE ON AGENT LERETA_INTELLIGENCE_AGENT TO ROLE ACCOUNTADMIN;

-- ============================================================================
-- Verification
-- ============================================================================
SELECT 'Lereta Intelligence Agent created successfully' AS STATUS;

SHOW AGENTS IN SCHEMA ANALYTICS;
DESC AGENT LERETA_INTELLIGENCE_AGENT;

-- ============================================================================
-- Next Steps: Test agent with sample questions from docs/questions.md
-- ============================================================================
