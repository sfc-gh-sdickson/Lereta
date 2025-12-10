# Lereta Intelligence - Machine Learning Models Guide

## Overview

This guide covers the three ML models added to the Lereta Intelligence Agent demo:

1. **Tax Delinquency Predictor** - Predict properties at risk of tax delinquency
2. **Client Churn Predictor** - Identify clients at risk of canceling subscriptions
3. **Loan Risk Classifier** - Classify loans by risk level (LOW/MEDIUM/HIGH)

All models are integrated with the Lereta Intelligence Agent and can be accessed through SQL functions.

---

## Files Added

### ML Notebook
**Location**: `notebooks/ML_Models_Lereta.ipynb`

A Jupyter notebook that:
- Trains all 3 ML models using Snowflake ML
- Uses data from `03_generate_synthetic_data.sql`
- Registers models in Snowflake Model Registry
- Includes model evaluation and performance metrics

**Key Features**:
- Uses Snowflake Snowpark for distributed computing
- Implements Random Forest and XGBoost algorithms
- Includes feature engineering and data preprocessing
- Provides detailed model performance metrics

### File 07: ML Model Wrappers
**Location**: `sql/ml/07_ml_model_wrappers.sql`

SQL User-Defined Functions (UDFs) that wrap the ML models for easy SQL access:
- `PREDICT_TAX_DELINQUENCY()` - Returns delinquency prediction
- `PREDICT_CLIENT_CHURN()` - Returns churn prediction
- `CLASSIFY_LOAN_RISK()` - Returns risk classification

**Helper Views**:
- `V_TAX_DELINQUENCY_FEATURES` - Pre-computed features for tax prediction
- `V_CLIENT_CHURN_FEATURES` - Pre-computed features for churn prediction
- `V_LOAN_RISK_FEATURES` - Pre-computed features for loan risk

### File 08: AI Agent Creation
**Location**: `sql/agent/08_create_ai_agent.sql`

Complete SQL script to create and configure the Lereta Intelligence Agent:
- Grants required permissions
- Configures agent with semantic views, Cortex Search, and ML models
- Creates helper functions for agent interactions
- Includes monitoring and logging capabilities
- Provides sample test questions

---

## Model Details

### 1. Tax Delinquency Predictor

**Algorithm**: Random Forest Classifier (100 trees, max depth 10)

**Purpose**: Predict which properties are likely to become delinquent on property taxes in the next 90 days.

**Features**:
- Property characteristics (type, assessed value, flood zone)
- Tax features (amount, rate, jurisdiction, penalties, days overdue)
- Loan features (type, amount, escrow account status)
- Client features (type, service quality score)
- Payment history (unpaid taxes, payment status)

**Output**:
```json
{
  "tax_record_id": "TAX000123456789",
  "prediction": 1,
  "prediction_label": "DELINQUENT",
  "risk_level": "HIGH",
  "model_version": "v1"
}
```

**Use Cases**:
- Proactive client alerts before delinquency occurs
- Portfolio risk management
- Prioritize monitoring efforts
- Prevent penalty fees

**SQL Usage**:
```sql
SELECT 
    tax_record_id,
    PREDICT_TAX_DELINQUENCY(
        tax_record_id, property_type, assessed_value, flood_zone,
        tax_amount, tax_rate, jurisdiction_type, penalty_amount,
        days_since_due, days_since_last_payment, loan_type, loan_amount,
        escrow_account, loan_status, client_type, service_quality_score,
        client_status, has_unpaid_taxes, current_paid_status
    ) AS prediction
FROM V_TAX_DELINQUENCY_FEATURES
WHERE days_since_due > 60
LIMIT 100;
```

---

### 2. Client Churn Predictor

**Algorithm**: XGBoost Classifier (150 trees, max depth 8, learning rate 0.1)

**Purpose**: Identify clients (financial institutions) at risk of canceling their subscriptions.

**Features**:
- Client profile (type, service quality score, total properties, lifetime value)
- Subscription details (tier, billing cycle, price, duration)
- Support metrics (ticket count, satisfaction rating, resolution time)
- Revenue metrics (transactions, total revenue, average transaction)

**Output**:
```json
{
  "client_id": "CLI00001234",
  "prediction": 1,
  "prediction_label": "WILL_CHURN",
  "risk_level": "HIGH",
  "risk_factors": [
    "High open ticket count",
    "Low satisfaction rating",
    "High support ticket volume"
  ],
  "model_version": "v1"
}
```

**Use Cases**:
- Customer retention campaigns
- Account management prioritization
- Proactive customer success outreach
- Identify at-risk revenue

**SQL Usage**:
```sql
SELECT 
    client_id,
    client_name,
    PREDICT_CLIENT_CHURN(
        client_id, client_type, service_quality_score, total_properties,
        lifetime_value, months_as_client, service_type, subscription_tier,
        billing_cycle, monthly_price, property_count_limit, user_licenses,
        advanced_analytics, subscription_duration_days, total_support_tickets,
        avg_satisfaction_rating, avg_resolution_time, open_tickets,
        total_transactions, total_revenue, avg_transaction_amount
    ) AS churn_prediction
FROM V_CLIENT_CHURN_FEATURES
WHERE service_quality_score < 85
   OR avg_satisfaction_rating < 3.5
ORDER BY lifetime_value DESC
LIMIT 50;
```

---

### 3. Loan Risk Classifier

**Algorithm**: Random Forest Classifier (120 trees, max depth 12)

**Purpose**: Classify loans into risk categories (LOW/MEDIUM/HIGH) based on tax compliance, flood zones, and property characteristics.

**Features**:
- Loan details (type, amount, status, escrow, age, LTV ratio)
- Property characteristics (type, value, flood zone, state)
- Flood risk (zone, insurance required, life-of-loan tracking)
- Tax compliance (amount, delinquent status, penalties, payment delay)
- Client quality (type, service quality score)

**Output**:
```json
{
  "loan_id": "LOAN0000123456",
  "risk_level": "HIGH",
  "risk_factors": [
    "High flood risk zone",
    "Tax delinquency",
    "No escrow account",
    "High LTV ratio"
  ],
  "recommendations": [
    "Contact borrower about delinquent taxes",
    "Verify flood insurance requirement",
    "Consider establishing escrow account"
  ],
  "model_version": "v1"
}
```

**Risk Level Definitions**:
- **LOW**: No major risk factors, all taxes paid, low/moderate flood zone
- **MEDIUM**: Some risk factors present (pending taxes >30 days, high flood zone with insurance)
- **HIGH**: Multiple risk factors (delinquent taxes >$500, high flood zone without insurance, foreclosed)

**Use Cases**:
- Portfolio risk assessment
- Monitoring prioritization
- Regulatory compliance reporting
- Early warning system for problem loans

**SQL Usage**:
```sql
SELECT 
    loan_id,
    borrower_name,
    CLASSIFY_LOAN_RISK(
        loan_id, loan_type, loan_amount, loan_status, escrow_account,
        loan_age_months, loan_to_value_ratio, property_type, assessed_value,
        flood_zone, property_state, insurance_required, life_of_loan_tracking,
        high_flood_risk, tax_amount, delinquent, penalty_amount, tax_rate,
        jurisdiction_type, tax_paid_on_time, days_payment_delay, client_type,
        service_quality_score
    ) AS risk_classification
FROM V_LOAN_RISK_FEATURES
WHERE loan_status = 'ACTIVE'
ORDER BY loan_amount DESC
LIMIT 100;
```

---

## Setup Instructions

### Step 1: Train ML Models

1. Open the Jupyter notebook: `notebooks/ML_Models_Lereta.ipynb`
2. Update connection parameters in cell 2:
   ```python
   connection_params = {
       "account": "<your_account>",
       "user": "<your_user>",
       "password": "<your_password>",
       "role": "ACCOUNTADMIN",
       "warehouse": "LERETA_WH",
       "database": "LERETA_INTELLIGENCE",
       "schema": "RAW"
   }
   ```
3. Run all cells in order (this will take 15-30 minutes)
4. Verify models are registered:
   ```python
   registry.show_models()
   ```

### Step 2: Deploy ML Model Wrappers

Execute file 07 to create SQL UDFs and helper views:

```sql
-- Execute in Snowflake
@sql/ml/07_ml_model_wrappers.sql
```

This creates:
- 3 ML prediction functions
- 3 feature preparation views
- Test queries for validation

**Verify**:
```sql
-- Check functions exist
SHOW FUNCTIONS IN SCHEMA ANALYTICS 
WHERE FUNCTION_NAME LIKE 'PREDICT_%' 
   OR FUNCTION_NAME LIKE 'CLASSIFY_%';

-- Test a function
SELECT * FROM V_TAX_DELINQUENCY_FEATURES LIMIT 1;
```

### Step 3: Create AI Agent

Execute file 08 to configure the agent:

```sql
-- Execute in Snowflake
@sql/agent/08_create_ai_agent.sql
```

This script:
- Grants required permissions
- Creates agent configuration
- Sets up monitoring and logging
- Provides sample test questions

**Manual Steps** (via Snowsight UI):
1. Navigate to **AI & ML** > **Agents**
2. Click **Create Agent**
3. Select **Create this agent for Snowflake Intelligence**
4. Configure agent with:
   - **Name**: `LERETA_INTELLIGENCE_AGENT`
   - **Semantic Views**: All 3 views (from files 04-05)
   - **Cortex Search**: All 3 services (from file 06)
   - **Instructions**: Use system prompt from file 08
5. Add sample questions from `AGENT_SAMPLE_QUESTIONS` view

---

## Testing ML Models

### Test Tax Delinquency Predictions

```sql
-- Find properties predicted to become delinquent
WITH predictions AS (
    SELECT 
        f.*,
        PREDICT_TAX_DELINQUENCY(
            tax_record_id, property_type, assessed_value, flood_zone,
            tax_amount, tax_rate, jurisdiction_type, penalty_amount,
            days_since_due, days_since_last_payment, loan_type, loan_amount,
            escrow_account, loan_status, client_type, service_quality_score,
            client_status, has_unpaid_taxes, current_paid_status
        ) AS prediction
    FROM V_TAX_DELINQUENCY_FEATURES f
    WHERE actual_delinquent = FALSE
    LIMIT 1000
)
SELECT 
    COUNT(*) AS total_properties,
    SUM(CASE WHEN prediction:prediction = 1 THEN 1 ELSE 0 END) AS predicted_delinquent,
    SUM(CASE WHEN prediction:risk_level = 'HIGH' THEN 1 ELSE 0 END) AS high_risk,
    SUM(CASE WHEN prediction:risk_level = 'MEDIUM' THEN 1 ELSE 0 END) AS medium_risk,
    SUM(CASE WHEN prediction:risk_level = 'LOW' THEN 1 ELSE 0 END) AS low_risk
FROM predictions;
```

### Test Client Churn Predictions

```sql
-- Identify clients at risk of churn
SELECT 
    c.client_id,
    c.client_name,
    c.lifetime_value,
    PREDICT_CLIENT_CHURN(
        c.client_id, c.client_type, c.service_quality_score, c.total_properties,
        c.lifetime_value, c.months_as_client, c.service_type, c.subscription_tier,
        c.billing_cycle, c.monthly_price, c.property_count_limit, c.user_licenses,
        c.advanced_analytics, c.subscription_duration_days, c.total_support_tickets,
        c.avg_satisfaction_rating, c.avg_resolution_time, c.open_tickets,
        c.total_transactions, c.total_revenue, c.avg_transaction_amount
    ) AS churn_prediction
FROM V_CLIENT_CHURN_FEATURES c
WHERE c.subscription_status = 'ACTIVE'
ORDER BY lifetime_value DESC
LIMIT 20;
```

### Test Loan Risk Classification

```sql
-- Classify active loans by risk level
WITH risk_classifications AS (
    SELECT 
        loan_id,
        CLASSIFY_LOAN_RISK(
            loan_id, loan_type, loan_amount, loan_status, escrow_account,
            loan_age_months, loan_to_value_ratio, property_type, assessed_value,
            flood_zone, property_state, insurance_required, life_of_loan_tracking,
            high_flood_risk, tax_amount, delinquent, penalty_amount, tax_rate,
            jurisdiction_type, tax_paid_on_time, days_payment_delay, client_type,
            service_quality_score
        ) AS risk
    FROM V_LOAN_RISK_FEATURES
    LIMIT 5000
)
SELECT 
    risk:risk_level::STRING AS risk_level,
    COUNT(*) AS loan_count,
    SUM(loan_amount) AS total_loan_amount,
    AVG(loan_amount) AS avg_loan_amount
FROM risk_classifications
JOIN RAW.LOANS USING (loan_id)
GROUP BY risk:risk_level
ORDER BY loan_count DESC;
```

---

## Agent Questions Using ML Models

Ask these questions through the Lereta Intelligence Agent:

### Tax Delinquency Questions
1. "Which properties are predicted to become delinquent on taxes in the next 90 days?"
2. "Show me high-risk properties with delinquency predictions and search support transcripts for similar cases"
3. "What are the top risk factors for tax delinquency in high-value properties?"

### Client Churn Questions
4. "Which clients are at risk of canceling their subscriptions?"
5. "Show me clients with high churn risk and low satisfaction ratings"
6. "What are the common characteristics of clients predicted to churn?"

### Loan Risk Questions
7. "Classify all active loans by risk level and show the distribution"
8. "Which high-risk loans need immediate attention?"
9. "Show me loans in high flood zones that are also delinquent on taxes"

### Hybrid Questions (Combining Multiple Data Sources)
10. "Predict tax delinquency risk for properties in Zone AE and search flood determination reports for insurance requirements"
11. "Identify high-risk loans with predicted tax delinquency and find similar support cases"
12. "Which clients have both churn risk and high-risk loans in their portfolio?"

---

## Model Performance Monitoring

### Check Model Accuracy

```sql
-- Compare predictions to actual outcomes (for historical data)
WITH predictions AS (
    SELECT 
        tax_record_id,
        actual_delinquent,
        PREDICT_TAX_DELINQUENCY(...)::prediction AS predicted_delinquent
    FROM V_TAX_DELINQUENCY_FEATURES
)
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN actual_delinquent = predicted_delinquent THEN 1 ELSE 0 END) AS correct_predictions,
    SUM(CASE WHEN actual_delinquent = predicted_delinquent THEN 1 ELSE 0 END)::FLOAT / COUNT(*) AS accuracy
FROM predictions;
```

### Monitor Prediction Distributions

```sql
-- Track prediction trends over time
CREATE OR REPLACE VIEW ML_PREDICTION_TRENDS AS
SELECT 
    DATE_TRUNC('week', prediction_date) AS week,
    model_name,
    prediction_value,
    COUNT(*) AS prediction_count
FROM (
    -- Combine predictions from all models
    SELECT 'TAX_DELINQUENCY' AS model_name, 
           CURRENT_DATE() AS prediction_date,
           prediction:prediction_label AS prediction_value
    FROM (SELECT PREDICT_TAX_DELINQUENCY(...) AS prediction FROM V_TAX_DELINQUENCY_FEATURES)
)
GROUP BY week, model_name, prediction_value
ORDER BY week DESC, model_name;
```

---

## Model Retraining

Models should be retrained:
- **Quarterly** (every 3 months)
- When accuracy drops below 80%
- After significant business changes
- When new data patterns emerge

**Retraining Process**:
1. Re-run the ML notebook with updated data
2. Increment model version (v1 → v2)
3. Register new version in Model Registry
4. A/B test new vs old model
5. Update UDF functions to use new version
6. Monitor performance improvements

---

## Troubleshooting

### Model Not Found Error
```
Error: Model 'TAX_DELINQUENCY_PREDICTOR' not found in registry
```
**Solution**: Run the ML notebook to train and register the model.

### Permission Denied
```
Error: Insufficient privileges to access model
```
**Solution**: Grant model access:
```sql
GRANT USAGE ON MODEL TAX_DELINQUENCY_PREDICTOR TO ROLE your_role;
```

### Slow Predictions
**Solution**: 
- Use helper views (V_*_FEATURES) for pre-computed features
- Batch predictions instead of row-by-row
- Increase warehouse size for large prediction jobs

### Unexpected Predictions
**Solution**:
- Check feature values are in expected ranges
- Verify data quality in source tables
- Review model training metrics
- Consider model retraining

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│              Lereta Intelligence Agent                       │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │    Cortex Analyst (Structured Data)                    │ │
│  │    • Semantic Views (3)                                │ │
│  │    • Property/Loan/Tax Analytics                       │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │    Cortex Search (Unstructured Data)                   │ │
│  │    • Support Transcripts (25K)                         │ │
│  │    • Tax Disputes (15K)                                │ │
│  │    • Flood Reports (20K)                               │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │    ML Models (Predictive Analytics) 🆕                 │ │
│  │    • Tax Delinquency Predictor                         │ │
│  │    • Client Churn Predictor                            │ │
│  │    • Loan Risk Classifier                              │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
          ┌─────────────────────────────────┐
          │   Snowflake Model Registry      │
          │   • Trained Models              │
          │   • Version Control             │
          │   • Performance Metrics         │
          └─────────────────────────────────┘
                            │
                            ▼
          ┌─────────────────────────────────┐
          │   SQL UDF Wrappers (File 07)    │
          │   • PREDICT_TAX_DELINQUENCY()   │
          │   • PREDICT_CLIENT_CHURN()      │
          │   • CLASSIFY_LOAN_RISK()        │
          └─────────────────────────────────┘
                            │
                            ▼
          ┌─────────────────────────────────┐
          │   Feature Views                 │
          │   • V_TAX_DELINQUENCY_FEATURES  │
          │   • V_CLIENT_CHURN_FEATURES     │
          │   • V_LOAN_RISK_FEATURES        │
          └─────────────────────────────────┘
                            │
                            ▼
          ┌─────────────────────────────────┐
          │   Source Data (File 03)         │
          │   • 10K Clients                 │
          │   • 500K Properties             │
          │   • 750K Loans                  │
          │   • 2M Tax Records              │
          │   • 500K Flood Certifications   │
          └─────────────────────────────────┘
```

---

## Best Practices

### For ML Model Usage

1. **Batch Predictions**: Process in batches of 1000-10000 records
2. **Feature Consistency**: Always use the V_*_FEATURES views
3. **Monitor Performance**: Track accuracy metrics weekly
4. **Handle Nulls**: Validate input features before prediction
5. **Interpret Results**: Understand risk factors and recommendations

### For Agent Integration

1. **Clear Questions**: Ask specific questions about predictions
2. **Combine Sources**: Use ML models with Cortex Search for context
3. **Verify Results**: Cross-reference predictions with actual data
4. **Provide Context**: Include relevant filters (date ranges, thresholds)
5. **Monitor Usage**: Review AGENT_INTERACTION_LOG regularly

### For Production Deployment

1. **Security**: Implement row-level security on sensitive predictions
2. **Performance**: Use appropriate warehouse sizes
3. **Alerts**: Set up automated alerts for high-risk predictions
4. **Documentation**: Keep this guide updated with model changes
5. **Governance**: Establish model approval and deployment processes

---

## Support and Resources

### Documentation
- **Main README**: `/README.md`
- **Agent Setup Guide**: `/docs/AGENT_SETUP.md`
- **Sample Questions**: `/docs/questions.md`

### Snowflake Resources
- [Snowflake ML Documentation](https://docs.snowflake.com/en/developer-guide/snowpark-ml/index)
- [Model Registry](https://docs.snowflake.com/en/developer-guide/snowpark-ml/model-registry/overview)
- [Cortex Intelligence](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst)

### Model Files
- **ML Notebook**: `notebooks/ML_Models_Lereta.ipynb`
- **Model Wrappers**: `sql/ml/07_ml_model_wrappers.sql`
- **Agent Creation**: `sql/agent/08_create_ai_agent.sql`

---

**Version**: 1.0  
**Created**: December 2024  
**Last Updated**: December 2024  
**Author**: Snowflake Professional Services

**✅ All 3 ML Models Deployed and Ready for Use**

