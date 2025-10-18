<img src="..\Snowflake_Logo.svg" width="200">

# Lereta Intelligence Agent - Complex Questions

These 10 complex questions demonstrate the intelligence agent's ability to analyze Lereta's tax monitoring, flood certification, loan portfolio, revenue metrics, and support operations across multiple dimensions.

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

## Question Complexity Summary

These questions test the agent's ability to:

1. **Multi-table joins** - connecting clients, properties, loans, tax records, flood certifications
2. **Temporal analysis** - delinquency tracking, trend analysis, expiration monitoring
3. **Segmentation & classification** - client types, property types, flood zones
4. **Derived metrics** - rates, percentages, ratios, growth calculations
5. **Risk assessment** - delinquency risk, flood risk, churn risk
6. **Pattern recognition** - support issues, tax disputes, resolution strategies
7. **Comparative analysis** - benchmarking, performance comparison, rankings
8. **Opportunity identification** - cross-sell, at-risk clients, service gaps
9. **Aggregation at multiple levels** - property, loan, client, jurisdiction
10. **Quality metrics** - satisfaction ratings, resolution times, service quality scores
11. **Semantic search** - understanding intent in unstructured data
12. **Information synthesis** - combining insights from multiple sources

These questions reflect realistic business intelligence needs for Lereta's tax monitoring, flood certification, and compliance operations.

---

**Version:** 1.0  
**Created:** October 2025  
**Based on:** MedTrainer Intelligence Template


