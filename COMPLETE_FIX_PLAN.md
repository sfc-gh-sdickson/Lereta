# Lereta ML Models - Complete Fix Plan

## Analysis Complete

I have now read the ENTIRE Hootsuite and Origence projects including:
- All 9 SQL files (setup, data, views, semantic views, search, ML functions, agent, procedures)
- Both complete notebooks
- All documentation (setup guides, questions, README, lessons learned)
- Architecture diagrams

## Key Patterns from Hootsuite/Origence

### 1. Database Structure (File 01)
- 3 schemas: RAW, ANALYTICS, ML_MODELS ✅ Lereta has this
- GRANT statements for permissions ⚠️ Lereta needs to add

### 2. Tables (File 02)
- ALL tables have `CHANGE_TRACKING = TRUE` ❌ Lereta missing this
- Proper constraints and foreign keys ✅ Lereta has this

### 3. Data Generation (File 03)
- TRUNCATE all tables at start ✅ Just added to Lereta
- SELECT status messages after each table ✅ Lereta has this
- Proper data volumes ✅ Lereta has this

### 4. Views (File 04)
- Analytical views for reporting ✅ Lereta has this
- ML feature views with:
  - ID column (customer_id, loan_id, etc.) ✅ Lereta has this
  - Feature columns cast to ::FLOAT ❌ Lereta missing FLOAT casts
  - Label column (churn_risk_label, default_risk_label, etc.) ✅ Lereta has labels
- Simple GROUP BY ALL syntax ⚠️ Lereta uses explicit GROUP BY

### 5. Semantic Views (File 05)
- Standard semantic view syntax ✅ Lereta has this
- DATE_TRUNC dimensions for time filtering ✅ Lereta has this
- CASE expressions for categorical bins ✅ Lereta has this

### 6. Cortex Search (File 06)
- Standard search service syntax ✅ Lereta has this
- GRANT USAGE statements ⚠️ Lereta needs to add

### 7. ML Functions (File 07) - CRITICAL DIFFERENCE
**Hootsuite/Origence Pattern (SIMPLE SQL):**
```sql
CREATE OR REPLACE FUNCTION PREDICT_CHURN_RISK(industry_filter VARCHAR)
RETURNS VARCHAR
AS
$$
    SELECT 
        'Total: ' || COUNT(*) || ', High Risk: ' || SUM(CASE...)
    FROM (
        SELECT MODEL!PREDICT(features...) as pred
        FROM V_FEATURES
        WHERE filter
        LIMIT 100
    )
$$;
```

**Lereta Current (COMPLEX PYTHON):**
- 300+ lines of Python per function
- Complex logic, error handling, recommendations
- Returns OBJECT not VARCHAR

**FIX NEEDED**: Rewrite file 07 to match Hootsuite simple pattern

### 8. Agent (File 08) - CRITICAL DIFFERENCE
**Hootsuite/Origence Pattern:**
```sql
CREATE OR REPLACE AGENT AGENT_NAME
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto
  instructions:
    response: "..."
    orchestration: "..."
  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "AnalystName"
  tool_resources:
    AnalystName:
      semantic_view: "DB.SCHEMA.VIEW"
  $$;
```

**Lereta Current:**
- Uses CREATE OR REPLACE SERVICE syntax (wrong)
- Not using FROM SPECIFICATION properly

**FIX NEEDED**: Rewrite file 08 to match Hootsuite/Origence pattern

### 9. Notebook - CRITICAL DIFFERENCES
**Hootsuite/Origence Pattern:**
- Cell 0: `import streamlit as st; st.image("Snowflake_Logo.svg", width=300)`
- Cell 2: `import os; print(os.listdir('.'))`
- Simple models: n_estimators=3, max_depth=3
- OneHotEncoder (not OrdinalEncoder)
- Drop ID columns before training
- Drop label from sample_input_data
- target_platforms=['WAREHOUSE']
- Delete model before re-registration

**Lereta Current:**
- Missing streamlit cell
- Missing os.listdir cell  
- Model 1 correct, Models 2 & 3 still have old code

**FIX NEEDED**: Complete Models 2 & 3 in notebook

## Complete Fix List

### IMMEDIATE FIXES NEEDED:

1. **File 02** (02_create_tables.sql):
   - Add `CHANGE_TRACKING = TRUE` to ALL 20 tables

2. **File 04** (04_create_views.sql):
   - Cast ALL numeric columns to ::FLOAT in ML feature views
   - Verify label columns are correct

3. **File 07** (07_ml_model_wrappers.sql):
   - COMPLETELY REWRITE using simple SQL pattern
   - Use MODEL!PREDICT() syntax
   - Return VARCHAR summaries not OBJECT
   - Remove all Python UDF complexity

4. **File 08** (08_create_ai_agent.sql):
   - COMPLETELY REWRITE using CREATE OR REPLACE AGENT
   - Use FROM SPECIFICATION $$...$$ syntax
   - Add tool_spec for each tool
   - Add tool_resources mapping

5. **Notebook** (ML_Models_Lereta_NEW.ipynb):
   - Add streamlit image cell at start
   - Add os.listdir cell
   - Complete Models 2 & 3 updates
   - Verify all 3 models match pattern

6. **Documentation**:
   - Update README with correct execution order
   - Update AGENT_SETUP with correct pattern
   - Update questions.md with tested questions

## Execution Order (VERIFIED from Hootsuite)

1. File 01 - Database/schemas
2. File 02 - Tables
3. File 03 - Data generation
4. File 04 - Views (including ML feature views)
5. Notebook - Train models
6. File 05 - Semantic views
7. File 06 - Cortex Search
8. File 07 - ML functions (wraps trained models)
9. File 08 - Agent creation

## Critical Lessons from GENERATION_FAILURES_AND_LESSONS.md

1. TRUNCATE tables at start of file 03 ✅ Done
2. Cast to ::FLOAT in feature views ❌ Not done
3. Simple SQL functions not Python ❌ Not done
4. Delete models before re-registration ✅ Done in notebook
5. Test ALL sample questions ❌ Not done
6. Use working examples as templates ⚠️ Partially done

## Next Steps

I will now systematically fix each file, one at a time, verifying against Hootsuite/Origence patterns.

