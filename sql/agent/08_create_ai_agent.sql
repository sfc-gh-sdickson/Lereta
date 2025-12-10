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
      - question: "How many properties have delinquent property taxes?"
        answer: "I'll query PropertyLoanTaxAnalyst to count properties where delinquent is TRUE."
      - question: "Which properties require flood insurance?"
        answer: "I'll use PropertyLoanTaxAnalyst to find properties where insurance_required is TRUE."
      - question: "What is the average client satisfaction rating?"
        answer: "I'll query ClientSupportAnalyst to calculate average satisfaction_rating."
      - question: "Show me clients with high churn risk"
        answer: "I'll use SubscriptionRevenueAnalyst to find clients with low service_quality_score or expiring subscriptions."
      - question: "Predict tax delinquency risk for properties in California"
        answer: "I'll use PredictTaxDelinquencyRisk with CA filter to analyze California properties."
      - question: "Which clients are at risk of churning?"
        answer: "I'll use PredictClientChurnRisk to identify at-risk clients."
      - question: "Classify loans by risk level"
        answer: "I'll use ClassifyLoanRisk to categorize loans as LOW/MEDIUM/HIGH risk."
      - question: "Search support transcripts for tax payment issues"
        answer: "I'll use SupportTranscriptsSearch to find similar tax payment cases."

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
        type: "function"
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
        type: "function"
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
        type: "function"
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
      function: "LERETA_INTELLIGENCE.ML_MODELS.PREDICT_TAX_DELINQUENCY_RISK"
    
    PredictClientChurnRisk:
      function: "LERETA_INTELLIGENCE.ML_MODELS.PREDICT_CLIENT_CHURN_RISK"
    
    ClassifyLoanRisk:
      function: "LERETA_INTELLIGENCE.ML_MODELS.CLASSIFY_LOAN_RISK"
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
