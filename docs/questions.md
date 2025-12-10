<img src="../Snowflake_Logo.svg" width="200">

# Lereta Intelligence Agent - Sample Questions

This guide demonstrates the agent's comprehensive capabilities across structured analytics, unstructured document search, and machine learning predictions. Questions are organized by intelligence type and business function.

---

## 1. Tax Delinquency Risk Analysis

**Question:** "Analyze properties with delinquent property taxes. Show me the total count, breakdown by client type (NATIONAL_SERVICER, REGIONAL_LENDER, CREDIT_UNION), properties with multiple years of delinquency, and which states have the highest delinquency rates. What is the total penalty amount at risk?"

**Why Complex:**
- Multi-table joins (PROPERTIES, TAX_RECORDS, LOANS, CLIENTS)
- Filtering by delinquency status and payment dates
- Multi-dimensional breakdown (client type, state)
- Aggregation at multiple levels
- Risk assessment calculation

**Data Sources:** TAX_RECORDS, PROPERTIES, LOANS, CLIENTS

---

## 2. Flood Insurance Requirement Tracking

**Question:** "Identify all properties in high-risk flood zones requiring flood insurance. Show me breakdown by flood zone type (AE, A, VE, etc.), client type, and state. Which clients have the most properties requiring flood insurance? Calculate the percentage of total loans that require flood insurance."

**Why Complex:**
- Flood zone classification filtering
- Multiple dimension analysis (zone type, client, state)
- Insurance requirement determination
- Risk prioritization by client
- Percentage calculations

**Data Sources:** FLOOD_CERTIFICATIONS, PROPERTIES, LOANS, CLIENTS

---

## 3. Escrow Account Analysis and Shortfall Detection

**Question:** "Analyze escrow accounts for potential shortfalls. Show me accounts where current balance is insufficient for upcoming tax payments, breakdown by loan type and client, projected shortfall amounts, and properties where tax amounts increased significantly year-over-year. What is the total escrow deficiency across all accounts?"

**Why Complex:**
- Account balance calculations
- Future obligation projections
- Year-over-year comparisons
- Multi-dimensional analysis
- Shortfall quantification

**Data Sources:** ESCROW_ACCOUNTS, TAX_RECORDS, LOANS, CLIENTS

---

## 4. Property Tax Assessment Change Analysis

**Question:** "Analyze properties with significant tax assessment increases over the past year. Show me properties where assessed value increased by 20% or more, breakdown by county and property type, average increase percentage, and clients most affected. Identify potential appeal opportunities."

**Why Complex:**
- Year-over-year value comparisons
- Percentage change calculations
- Multi-dimensional breakdowns
- Client impact analysis
- Appeal opportunity identification

**Data Sources:** TAX_RECORDS, PROPERTIES, LOANS, CLIENTS

---

## 5. Client Service Utilization and Health Assessment

**Question:** "Identify clients at risk of churn. Show me clients with subscriptions expiring in next 30 days, breakdown by service type and tier, clients with recent support escalations, properties with high delinquency rates, and service quality scores below 85. Calculate churn risk score for each at-risk client."

**Why Complex:**
- Time-based filtering (30 days)
- Multi-dimensional segmentation
- Cross-service analysis (subscriptions + tax + support)
- Risk scoring calculation
- Churn prediction factors

**Data Sources:** SERVICE_SUBSCRIPTIONS, CLIENTS, TAX_RECORDS, SUPPORT_TICKETS

---

## 6. Revenue Trend Analysis with Product Performance

**Question:** "Analyze revenue trends over the past 12 months by product category (TAX_MONITORING, FLOOD_CERTIFICATION, COMPLIANCE_REPORTING, FULL_SUITE). Show me month-over-month growth rates, seasonal patterns, average transaction values, and which products show strongest growth. Compare revenue per client type."

**Why Complex:**
- Time-series analysis (12 months)
- Growth rate calculations (MoM)
- Seasonal pattern detection
- Product-level breakdown
- Segmentation by customer type

**Data Sources:** TRANSACTIONS, PRODUCTS, CLIENTS

---

## 7. Loan Portfolio Risk Assessment

**Question:** "Analyze loan portfolio health. Show me loans with delinquent taxes, loans in high-risk flood zones without proper insurance, loans approaching maturity in next 90 days, and loans where both tax and flood monitoring are required but not active. Calculate risk score for each problematic loan and prioritize by loan amount."

**Why Complex:**
- Multiple risk factor identification
- Tax and flood status cross-reference
- Maturity date calculations
- Risk prioritization
- Multi-dimensional filtering

**Data Sources:** LOANS, TAX_RECORDS, FLOOD_CERTIFICATIONS, PROPERTIES

---

## 8. Cross-Sell Service Opportunity Identification

**Question:** "Identify cross-sell opportunities. Show me clients using only tax services (no flood), clients with properties in flood zones but no flood monitoring subscription, and clients with high transaction volumes but no advanced analytics. Calculate potential additional revenue for each opportunity."

**Why Complex:**
- Gap analysis across service portfolio
- Multi-dimensional opportunity identification
- Need assessment based on property data
- Revenue opportunity calculation
- Prioritization by potential value

**Data Sources:** CLIENTS, SERVICE_SUBSCRIPTIONS, PROPERTIES, FLOOD_CERTIFICATIONS, LOANS

---

## 9. Support Efficiency and Agent Performance Benchmarking

**Question:** "Analyze support performance by agent and department. Show me average resolution times, ticket volumes, satisfaction ratings, first response times, and resolution rates. Identify top performers and agents needing additional training. How does performance vary by issue type (tax vs flood vs technical)?"

**Why Complex:**
- Agent-level performance metrics
- Department-level aggregation
- Multiple quality metrics
- Performance ranking
- Multi-dimensional analysis (issue type, department)

**Data Sources:** SUPPORT_TICKETS, SUPPORT_AGENTS

---

## 10. Tax Jurisdiction Performance Analysis

**Question:** "Analyze tax jurisdictions by payment processing efficiency. Show me jurisdictions with highest delinquency rates, slowest payment processing times, most frequent payment discrepancies, and jurisdictions with highest penalty amounts. Which counties should we focus our monitoring efforts on?"

**Why Complex:**
- Jurisdiction-level aggregation
- Multiple performance metrics
- Delinquency rate calculations
- Payment timing analysis
- Priority ranking for monitoring

**Data Sources:** TAX_JURISDICTIONS, TAX_RECORDS, PROPERTIES

---

## Cortex Search Questions (Unstructured Data)

These questions test the agent's ability to search and retrieve insights from unstructured data using Cortex Search services.

### 11. Tax Payment Support Pattern Discovery

**Question:** "Search support transcripts for issues related to 'tax payment not showing' and 'escrow disbursement'. What are the most common problems clients face? What resolution procedures were successful?"

**Why Complex:**
- Semantic search over support text
- Pattern extraction from conversations
- Success factor identification
- Resolution procedure analysis

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 12. Successful Tax Appeal Strategies

**Question:** "Find tax dispute documents for successful assessment appeals. What were the common grounds for appeal? What evidence was most effective? Identify best practices for winning appeals."

**Why Complex:**
- Semantic search over dispute documentation
- Success factor extraction
- Evidence effectiveness analysis
- Best practice identification

**Data Source:** TAX_DISPUTE_DOCUMENTS_SEARCH

---

### 13. Flood Insurance Requirements Retrieval

**Question:** "What do flood determination reports say about Zone AE properties? Provide details on insurance requirements and borrower notification procedures."

**Why Complex:**
- Technical requirement retrieval
- Zone-specific information extraction
- Procedure documentation synthesis

**Data Source:** FLOOD_DETERMINATION_REPORTS_SEARCH

---

### 14. Tax Payment Resolution Analysis

**Question:** "Search support transcripts for county payment processing issues. What challenges do clients face? How does the support team help resolve payment application errors?"

**Why Complex:**
- Issue pattern identification
- Challenge extraction
- Resolution strategy analysis

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 15. Property Tax Exemption Applications

**Question:** "Find tax dispute documents involving homestead exemptions or senior citizen tax freezes. What documentation is required? What are common reasons for denial?"

**Why Complex:**
- Multi-topic document search
- Requirement extraction
- Denial reason analysis

**Data Source:** TAX_DISPUTE_DOCUMENTS_SEARCH

---

### 16. FEMA Map Change Guidance

**Question:** "What guidance do flood determination reports provide about FEMA map changes? What are the notification requirements and timelines for borrower notification?"

**Why Complex:**
- Regulatory information retrieval
- Notification requirement extraction
- Timeline documentation synthesis

**Data Source:** FLOOD_DETERMINATION_REPORTS_SEARCH

---

### 17. API Integration Support Patterns

**Question:** "Search support transcripts for API integration issues. What error messages are most common? How does the support team troubleshoot these problems?"

**Why Complex:**
- Technical issue identification
- Error pattern analysis
- Troubleshooting procedure extraction

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 18. Tax Installment Plan Requests

**Question:** "Find tax dispute documents about installment payment plan requests. What terms are typically approved? What financial hardship criteria are accepted?"

**Why Complex:**
- Payment plan analysis
- Approval criteria extraction
- Financial hardship pattern identification

**Data Source:** TAX_DISPUTE_DOCUMENTS_SEARCH

---

### 19. Coastal Flood Zone Requirements

**Question:** "What procedures do flood determination reports outline for coastal high-risk zones (VE, V)? What are the special construction and insurance requirements?"

**Why Complex:**
- Zone-specific requirement retrieval
- Regulatory compliance extraction
- Detailed procedure synthesis

**Data Source:** FLOOD_DETERMINATION_REPORTS_SEARCH

---

### 20. Comprehensive Onboarding Knowledge Synthesis

**Question:** "For a new client onboarding 5,000 loans, combine information from: 1) Support transcripts showing successful bulk onboarding, 2) Tax monitoring setup procedures, and 3) Flood certification requirements for portfolio transfers."

**Why Complex:**
- Multi-source information synthesis
- Step-by-step procedure combination
- Best practice integration
- Comprehensive solution assembly

**Data Sources:** SUPPORT_TRANSCRIPTS_SEARCH, TAX_DISPUTE_DOCUMENTS_SEARCH, FLOOD_DETERMINATION_REPORTS_SEARCH, SV_PROPERTY_LOAN_TAX_INTELLIGENCE

---

---

## Machine Learning Predictions

These questions demonstrate the agent's predictive analytics capabilities using trained ML models.

### 21. Tax Delinquency Prediction (Preventive Action)

**Question:** "Predict which properties will become delinquent on property taxes in the next 90 days. Show properties predicted as high risk with days since last payment over 60, breakdown by client type, and estimated penalty amounts if delinquency occurs."

**Why Complex:**
- ML model prediction integration
- Risk level classification
- Time-based filtering
- Client segmentation
- Financial impact calculation

**Data Sources:** V_TAX_DELINQUENCY_FEATURES, PREDICT_TAX_DELINQUENCY()

**Business Value:** Prevent $500-$5,000 in penalties per property through proactive intervention

---

### 22. Client Churn Risk Assessment

**Question:** "Identify clients at high risk of canceling their subscriptions. Show clients with churn probability over 70%, their lifetime value, key risk factors (support tickets, satisfaction ratings, usage patterns), and recommended retention actions."

**Why Complex:**
- ML churn prediction
- Risk factor extraction
- Lifetime value prioritization
- Actionable recommendation generation
- Multi-dimensional analysis

**Data Sources:** V_CLIENT_CHURN_FEATURES, PREDICT_CLIENT_CHURN()

**Business Value:** Retain clients worth $50K-$5M in lifetime value

---

### 23. Loan Risk Classification (Portfolio Monitoring)

**Question:** "Classify all active loans by risk level (LOW/MEDIUM/HIGH). Show high-risk loans by state, breakdown by risk factors (flood zones, tax delinquency, LTV ratio), and recommended monitoring actions for each risk category."

**Why Complex:**
- Multi-class ML classification
- Risk factor identification
- Geographic segmentation
- Recommendation engine
- Priority-based actionability

**Data Sources:** V_LOAN_RISK_FEATURES, CLASSIFY_LOAN_RISK()

**Business Value:** Reduce monitoring costs 30-50% through risk-based prioritization

---

### 24. Predictive Tax Compliance Analysis

**Question:** "For properties with tax amounts over $10,000, predict delinquency risk and search tax dispute documents for similar cases. What resolution strategies were successful? What proactive steps should we recommend?"

**Why Complex:**
- ML prediction + document search hybrid
- Financial threshold filtering
- Historical pattern matching
- Success factor extraction
- Proactive recommendation synthesis

**Data Sources:** V_TAX_DELINQUENCY_FEATURES, PREDICT_TAX_DELINQUENCY(), TAX_DISPUTE_DOCUMENTS_SEARCH

**Business Value:** Prevent high-value delinquencies with documented resolution strategies

---

### 25. Client Retention Campaign Targeting

**Question:** "Identify clients predicted to churn in next 6 months with lifetime value over $100K. What are their support transcript patterns? What concerns have they raised? Design a targeted retention campaign."

**Why Complex:**
- ML churn prediction with filters
- Value-based prioritization
- Support transcript analysis
- Concern pattern identification
- Campaign strategy design

**Data Sources:** V_CLIENT_CHURN_FEATURES, PREDICT_CLIENT_CHURN(), SUPPORT_TRANSCRIPTS_SEARCH

**Business Value:** Targeted retention for highest-value clients

---

### 26. High-Risk Loan Portfolio Review

**Question:** "Show loans classified as HIGH risk with predicted tax delinquency. Include property details, borrower names, current tax status, flood zone requirements, and search for similar cases in support transcripts. What intervention steps are recommended?"

**Why Complex:**
- Dual ML predictions (risk + delinquency)
- Multi-dimensional data enrichment
- Historical case retrieval
- Intervention recommendation
- Comprehensive risk assessment

**Data Sources:** V_LOAN_RISK_FEATURES, V_TAX_DELINQUENCY_FEATURES, CLASSIFY_LOAN_RISK(), PREDICT_TAX_DELINQUENCY(), SUPPORT_TRANSCRIPTS_SEARCH

**Business Value:** Comprehensive risk management with documented intervention strategies

---

### 27. Predictive Client Health Dashboard

**Question:** "Create a health dashboard for top 50 clients by revenue. Include: predicted churn probability, high-risk loan count, properties with predicted tax delinquency, support satisfaction ratings, and renewal likelihood. Which clients need immediate attention?"

**Why Complex:**
- Multiple ML predictions per client
- Revenue-based ranking
- Cross-functional health metrics
- Priority alert generation
- Executive dashboard synthesis

**Data Sources:** All feature views, all ML functions, semantic views

**Business Value:** Executive visibility into client portfolio health

---

### 28. Proactive Risk Mitigation Strategy

**Question:** "For loans classified as MEDIUM or HIGH risk, predict tax delinquency probability. Show breakdown by flood zone and tax jurisdiction. Search flood reports and tax dispute documents for relevant guidance. Create a prioritized action plan."

**Why Complex:**
- Risk classification filtering
- Delinquency prediction layering
- Multi-dimensional breakdown
- Document guidance retrieval
- Action plan prioritization

**Data Sources:** CLASSIFY_LOAN_RISK(), PREDICT_TAX_DELINQUENCY(), FLOOD_DETERMINATION_REPORTS_SEARCH, TAX_DISPUTE_DOCUMENTS_SEARCH

**Business Value:** Data-driven risk mitigation with regulatory guidance

---

### 29. ML Model Performance Validation

**Question:** "For properties that became delinquent last quarter, what was the prediction accuracy? Show prediction vs. actual delinquency by state and property type. Identify where the model performs best and where it needs improvement."

**Why Complex:**
- Historical prediction validation
- Accuracy calculation
- Segmented performance analysis
- Model quality assessment
- Improvement area identification

**Data Sources:** V_TAX_DELINQUENCY_FEATURES, PREDICT_TAX_DELINQUENCY(), TAX_RECORDS

**Business Value:** Continuous model improvement and trust building

---

### 30. Comprehensive Risk Intelligence Report

**Question:** "Generate a complete risk intelligence report combining: 1) Predicted tax delinquencies by client, 2) Clients at risk of churning, 3) High-risk loan portfolio summary, 4) Support transcript analysis of common issues, 5) Flood insurance compliance gaps. Prioritize by financial impact and urgency."

**Why Complex:**
- All three ML models
- Document search integration
- Financial impact quantification
- Priority ranking algorithm
- Executive report synthesis
- Multi-source intelligence fusion

**Data Sources:** All ML functions, all search services, all semantic views

**Business Value:** Comprehensive risk management for C-level decision making

---

## Question Complexity & Capabilities Summary

The Lereta Intelligence Agent handles complex queries across three intelligence types:

### Structured Analytics (Cortex Analyst)
1. **Multi-table joins** - connecting clients, properties, loans, tax records, flood certifications
2. **Temporal analysis** - delinquency tracking, trend analysis, expiration monitoring
3. **Segmentation & classification** - client types, property types, flood zones
4. **Derived metrics** - rates, percentages, ratios, growth calculations
5. **Aggregation at multiple levels** - property, loan, client, jurisdiction

### Unstructured Search (Cortex Search)
6. **Semantic search** - understanding intent in unstructured data
7. **Pattern recognition** - support issues, tax disputes, resolution strategies
8. **Information retrieval** - finding relevant procedures and documentation
9. **Historical context** - learning from past successful resolutions
10. **Best practice extraction** - identifying what works

### Predictive Analytics (ML Models)
11. **Risk prediction** - tax delinquency, client churn, loan risk classification
12. **Risk factor identification** - explaining what drives predictions
13. **Proactive recommendations** - suggesting preventive actions
14. **Model performance** - validation and continuous improvement
15. **Financial impact quantification** - calculating business value

### Hybrid Intelligence
16. **Multi-source synthesis** - combining predictions with documents
17. **Contextual enrichment** - enhancing predictions with historical data
18. **Comprehensive reporting** - executive-level intelligence fusion
19. **Priority ranking** - sorting by business impact and urgency
20. **Actionable insights** - converting analysis into specific next steps

These 30 questions reflect realistic business intelligence needs for Lereta's tax monitoring, flood certification, and compliance operations, spanning descriptive analytics, diagnostic search, and predictive modeling.

---

**Created:** October 2025  
**Based on:** Microchip Intelligence Template  
**Intelligence Types:** Structured Analytics • Semantic Search • Predictive ML


