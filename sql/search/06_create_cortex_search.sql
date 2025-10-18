-- ============================================================================
-- Lereta Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          support transcripts, tax dispute documents, and flood determination reports
-- Syntax verified against: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
-- EXACT COPY of MedTrainer structure with Lereta-specific content
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- Step 1: Create table for support transcripts (unstructured text data)
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_TRANSCRIPTS (
    transcript_id VARCHAR(30) PRIMARY KEY,
    ticket_id VARCHAR(30),
    client_id VARCHAR(20),
    agent_id VARCHAR(20),
    transcript_text VARCHAR(16777216) NOT NULL,
    interaction_type VARCHAR(50),
    interaction_date TIMESTAMP_NTZ NOT NULL,
    sentiment_score NUMBER(5,2),
    keywords VARCHAR(500),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (ticket_id) REFERENCES SUPPORT_TICKETS(ticket_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id),
    FOREIGN KEY (agent_id) REFERENCES SUPPORT_AGENTS(agent_id)
);

-- ============================================================================
-- Step 2: Create table for tax dispute documents
-- ============================================================================
CREATE OR REPLACE TABLE TAX_DISPUTE_DOCUMENTS (
    report_id VARCHAR(30) PRIMARY KEY,
    tax_record_id VARCHAR(30),
    client_id VARCHAR(20),
    report_text VARCHAR(16777216) NOT NULL,
    report_type VARCHAR(50),
    investigation_status VARCHAR(30),
    corrective_actions_taken VARCHAR(5000),
    report_date TIMESTAMP_NTZ NOT NULL,
    created_by VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (tax_record_id) REFERENCES TAX_RECORDS(tax_record_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id)
);

-- ============================================================================
-- Step 3: Create table for flood determination reports
-- ============================================================================
CREATE OR REPLACE TABLE FLOOD_DETERMINATION_REPORTS (
    report_id VARCHAR(30) PRIMARY KEY,
    certification_id VARCHAR(30),
    property_id VARCHAR(30),
    report_text VARCHAR(16777216) NOT NULL,
    determination_type VARCHAR(50),
    flood_zone_determined VARCHAR(20),
    insurance_requirement_text VARCHAR(500),
    report_date TIMESTAMP_NTZ NOT NULL,
    created_by VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (certification_id) REFERENCES FLOOD_CERTIFICATIONS(certification_id),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id)
);

-- ============================================================================
-- Step 4: Enable change tracking (required for Cortex Search)
-- ============================================================================
ALTER TABLE SUPPORT_TRANSCRIPTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE TAX_DISPUTE_DOCUMENTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE FLOOD_DETERMINATION_REPORTS SET CHANGE_TRACKING = TRUE;

-- ============================================================================
-- Step 5: Generate sample support transcripts
-- ============================================================================
INSERT INTO SUPPORT_TRANSCRIPTS
SELECT
    'TRANS' || LPAD(SEQ4(), 10, '0') AS transcript_id,
    st.ticket_id,
    st.client_id,
    st.assigned_agent_id AS agent_id,
    CASE (ABS(RANDOM()) % 20)
        WHEN 0 THEN 'Agent: Thank you for calling Lereta tax services. Customer: We received a delinquency notice for a property but we thought the tax was paid. Agent: I can check that immediately. What is the loan number? Customer: LN998877665. Agent: Pulling up the tax record now. I see the payment was made to the county, but there was a processing delay. Your escrow was debited correctly. Customer: So is there a delinquency? Agent: No, this is a timing issue. The county cleared it yesterday. I am updating your account now. Customer: Do we need to do anything? Agent: No action needed. I will send you confirmation with the updated receipt. Customer: Thank you!'
        WHEN 1 THEN 'Customer: We need a tax certificate for a closing next week. How fast can you get that? Agent: I can expedite that. What is the property address? Customer: 789 Oak Avenue, Dallas, TX. Agent: And the closing date? Customer: Next Wednesday. Agent: That gives us 7 days. Standard is 5-7 days. Let me check if the property is in our system. Yes, loan LN445566778. Is this refinance or purchase? Customer: Purchase. Title company needs it by Tuesday. Agent: I will mark as rush. You will have it Monday. There is a $25 expedite fee. Customer: Fine. Please proceed. Agent: Processing now. You will get tracking in 2 hours. Customer: Perfect!'
        WHEN 2 THEN 'Chat started. Agent: Welcome to Lereta flood services! Customer: We got an alert that FEMA updated flood maps for a property. What does that mean? Agent: A map change means FEMA revised the zone designation. Can you provide the property address? Customer: 456 River Road, Houston, TX. Agent: Let me pull that up. I see the change. Property moved from Zone X to Zone AE. Customer: What does that mean? Agent: Zone AE is high-risk which means flood insurance is now required. We ordered a new determination. Customer: How long? Agent: Should complete within 24 hours. We will notify you immediately. Customer: When does insurance need to be in place? Agent: Borrower has 45 days from notification. We will provide the official letter. Customer: Thanks!'
        WHEN 3 THEN 'Agent: Lereta API support. Customer: We are getting a 404 error on loan LN334455667 tax data. Agent: Let me troubleshoot. Are you using /api/v2/tax-records/{loanId}? Customer: Yes. Agent: Let me check that loan. I see the issue. That loan transferred recently but API sync has not completed. Customer: How long does sync take? Agent: Normally 1 hour. When was the transfer? Customer: This morning at 9 AM. Agent: It has been 6 hours. Let me trigger manual sync now. Customer: Trying again... It worked! Agent: Great! Sync runs hourly but you can contact us for manual trigger. Customer: Is there a way to check sync status via API? Agent: Yes, use /api/v2/sync-status with your portfolio ID. Customer: Perfect!'
        WHEN 4 THEN 'Email support. Customer: We were charged for a tax payment but the county says they did not receive it. Agent: Let me investigate immediately. What property address? Customer: 2345 Pine Street, Phoenix, AZ. Loan LN667788990. Agent: Reviewing disbursement records. I see we disbursed $3,450 to Maricopa County on March 15th via check 123456. Customer: County has no record. Agent: Let me check check status. It cleared our bank March 22nd. I am sending you the canceled check showing county endorsement. Customer: Could it be applied to wrong parcel? Agent: Possible. I will contact the county directly. Customer: How long? Agent: Should have answer in 24 hours. I am holding any penalties meanwhile. Customer: Thanks!'
        WHEN 5 THEN 'Phone. Agent: Lereta tax monitoring. Customer: We need escrow analysis for our entire portfolio. How does that work? Agent: I can walk you through it. How many loans? Customer: About 12,000. Agent: We can handle that. Our service reviews tax amounts, insurance, and calculates monthly payments. Are loans escrowed? Customer: About 70%. Agent: For escrowed loans, we analyze balances and projected taxes. For non-escrowed, we just monitor payments. Customer: What if taxes increase? Agent: System auto-recalculates escrow payments. We send notification and revised amount. Customer: Can we set different thresholds by loan type? Agent: Yes! You can configure rules for conventional, FHA, VA. Customer: How do we start? Agent: I will send setup guide and have specialist contact you this week. Customer: Great!'
        WHEN 6 THEN 'Customer: Why did a property tax go up 30% this year? Agent: I can research that. What is the address? Customer: 8901 Elm Street, Austin, TX. Agent: Let me pull tax history. Assessed value increased from $350,000 to $455,000. Customer: Why such a jump? Agent: County did general reappraisal. Many properties in that area saw similar increases. Customer: Can borrower appeal? Agent: Yes, counties allow appeals within 30-45 days from notice. Customer: When was notice sent? Agent: May 1st, so appeal deadline around June 15th. Customer: Can you help with appeal? Agent: We do not prepare appeals but can provide tax history and comparable sales data. Customer: Can you send that? Agent: Yes, generating report now. You will receive in 15 minutes. Customer: Helpful, thanks!'
        WHEN 7 THEN 'Chat. Customer: Loan payoff tomorrow. Need to confirm all taxes current. Agent: I can verify. What is loan number? Customer: LN112233445. Agent: Checking now. All taxes current. Last payment November 30th for fall installment. Customer: Any pending bills? Agent: No pending. Next bill not until April for spring installment. Customer: Clear to close? Agent: From tax perspective, yes. All current and no delinquencies. Want a tax clearance letter? Customer: Yes please. Agent: Generating. Sent to email. Letter confirms status as of today, valid 30 days. Customer: Any escrow balance to refund? Agent: Current balance $1,245.67. After payoff, this refunds to borrower. Customer: Excellent. Thanks! Agent: Welcome! Congratulations on payoff!'
        WHEN 8 THEN 'Agent: Lereta flood certification. Customer: We need flood certs for 500 new loans. Can you handle that? Agent: Absolutely! We process thousands daily. When do you need them? Customer: All within 5 business days for closing. Agent: Achievable. Submit via bulk upload portal. Have file prepared? Customer: Excel with all addresses. Agent: Perfect! Upload directly. We process and return results in 24-48 hours. Customer: What format for addresses? Agent: Property address, city, state, ZIP required. Loan number optional but helpful. Customer: Notified as each completes? Agent: Yes, email notifications or API webhook for real-time updates. Customer: Certificates immediate? Agent: Generated automatically. Download individually or batch. Customer: Cost? Agent: $12 per property. For 500, $6,000. Monthly billing available. Customer: Good. Uploading this afternoon. Agent: Great! I will monitor and reach out if issues.'
        WHEN 9 THEN 'Email. Customer: Borrower disputing tax amount we escrowed. They say bill lower than we collected. Agent: I can research. What property and tax year? Customer: 5678 Maple Drive, Dallas TX, 2024. Loan LN887766554. Agent: Let me review escrow analysis. We projected 2024 taxes at $4,200 based on 2023 amount of $4,000 plus 5% increase. Customer: Actual bill $3,950. What happened? Agent: County reduced assessed value after projection. Happens with successful appeal or general reduction. Customer: Refund the difference? Agent: Yes, $250 overage should refund. We will adjust monthly escrow going forward. Customer: New monthly payment? Agent: Based on actual $3,950 plus insurance $1,200, monthly should be $429. Currently $450. Recommend $430 for cushion. Customer: Make that change. How process refund? Agent: Processing now. New payment next month, refund check mailed in 5 days. Customer: Thanks!'
        WHEN 10 THEN 'Customer: Onboard new portfolio. What info needed? Agent: Great! How many loans transferring? Customer: About 8,500. Agent: We need key data for each. Customer: What specifically? Agent: Loan number, property address, borrower name, loan amount, servicer number if transferring, whether tax and flood monitoring required. Customer: We have that. What format? Agent: CSV, Excel, or API for direct integration. Have existing tax and flood data? Customer: Yes, all historical payments and certs. Agent: Excellent! Include that for complete history. Also need escrow accounts and balances if applicable. Customer: How long? Agent: For 8,500, typically 3-5 days to load, then 2-3 for verification. Customer: Week total? Agent: Yes, 7-10 days. We assign dedicated implementation manager with daily updates. Customer: Who to send file to? Agent: I will send secure link and introduce you to manager within the hour. Customer: Sounds good!'
        WHEN 11 THEN 'Phone. Agent: Lereta compliance. Customer: Need to pull tax payment history for audit. How do we get that? Agent: I can help. What timeframe? Customer: Past 3 years for all properties. Agent: You can run that in your portal. Go to Reports, Tax Payment History. Customer: What info does it show? Agent: Payment dates, amounts, check numbers, jurisdictions, delinquency history. Customer: Can we filter by property or loan? Agent: Yes, filter by loan number, property address, state, or county. Customer: Export options? Agent: PDF, Excel, or CSV. Customer: Perfect. Running now. Agent: Great! Report generates in real-time. Should complete in few minutes. Customer: Got it. Thanks!'
        WHEN 12 THEN 'Chat. Customer: How do we add new properties to monitoring? Agent: Simple process. Do you want to add individually or bulk? Customer: We have 200 new loans. Agent: Use bulk upload. Go to Portfolio Management, Bulk Add. Customer: What file format? Agent: Excel template available for download. Columns needed: loan number, property address, city, state, ZIP, loan amount. Customer: Do we need flood zone info? Agent: Optional. If you have it include it, otherwise we will determine it. Customer: When will monitoring start? Agent: As soon as file processes, usually within 24 hours. You get confirmation email. Customer: What if there are errors in file? Agent: System validates and shows errors. You can correct and re-upload. Customer: Good to know!'
        WHEN 13 THEN 'Customer: Property sold. How do we remove from monitoring? Agent: I can help. What is the loan number? Customer: LN556677889. Agent: Let me pull that up. I see this property at 123 Main St. Is this the one that sold? Customer: Yes, closed yesterday. Agent: I will mark the loan as paid off and stop monitoring. Do you need final tax clearance? Customer: Yes, for our records. Agent: Generating that now. It shows all taxes current through closing date. Customer: Perfect. Agent: Done. Loan marked paid off, monitoring stopped, clearance sent to email. Anything else? Customer: Nope, thanks! Agent: Welcome!'
        WHEN 14 THEN 'Email. Customer: We switched loan servicers. How do we update that in your system? Agent: I can update that. What is the new servicer name? Customer: Nationstar Mortgage. Agent: How many loans are affected? Customer: About 1,500. Agent: I will need a file with loan numbers and new servicer loan numbers. Customer: Have that. Where to send? Agent: I will send you secure upload link. Also need effective date of transfer. Customer: Transfer effective January 1st. Agent: Perfect. Once file uploads, we update within 24 hours and send confirmation. Customer: Will this affect tax monitoring? Agent: No interruption. We continue monitoring seamlessly. Just updates our records for reporting. Customer: Great!'
        WHEN 15 THEN 'Agent: Lereta tech support. Customer: API endpoint returning old tax amounts. We know taxes increased but API shows last year values. Agent: Let me check. What loan? Customer: LN998877665. Agent: Checking. I see new assessment came in last week. Let me verify it is in system. Yes, new amount is $4,500, up from $4,200. Customer: But API showing $4,200. Agent: When did you last call the endpoint? Customer: 10 minutes ago. Agent: Let me check cache. Ah, API cache is set to 4 hours. Your call hit cached data. Customer: How do we get current data? Agent: Add cache-control header to request or wait for cache expiration. I can also clear cache manually now. Customer: Please clear it. Agent: Cleared. Try now. Customer: Got the new amount! Thanks!'
        WHEN 16 THEN 'Customer: Flood zone changed but we are not seeing update in our reports. Agent: Let me check that. What property? Customer: 789 Riverside Dr, Houston. Agent: I see FEMA issued map change on October 1st. Zone changed from X to AE. Customer: Why not in our reports yet? Agent: Let me check. The flood cert table updated but report cache has not refreshed. Customer: When will it refresh? Agent: Report cache refreshes nightly. I can trigger manual refresh now. Customer: Please do. Agent: Triggered. Refresh completes in 2-3 minutes. Try report again then. Customer: Will try. Thanks! Agent: You are welcome. Future changes will appear in next day reports automatically.'
        WHEN 17 THEN 'Chat. Customer: How do we set up automated alerts for tax delinquencies? Agent: You can configure that in Alert Settings. Customer: Where is that? Agent: Go to Settings, Alert Configuration, Tax Monitoring Alerts. Customer: What alerts available? Agent: Tax bill received, payment due in 30 days, payment due in 15 days, payment overdue, delinquency detected. Customer: Can we set different alerts by client? Agent: Yes! Configure default alerts globally, then override for specific clients. Customer: Who receives alerts? Agent: You set email recipients per alert type. Can send to different people for different alert types. Customer: Can we get alerts via API webhook? Agent: Yes! Enable webhook in settings and provide your endpoint URL. Customer: Perfect. Setting up now!'
        WHEN 18 THEN 'Agent: Lereta flood services. Customer: Borrower claiming they do not need flood insurance but our cert says Zone AE. Agent: I can verify. What property? Customer: 5678 Oak Lane, Miami, FL. Agent: Checking certification. Confirmed Zone AE as of March 15th. FEMA panel 12345678K dated 2019. Customer: Borrower says their neighbor does not need insurance. Agent: Zone determinations are property-specific. Neighbor could be in different zone even on same street. Elevation differences matter. Customer: Can borrower appeal? Agent: They can request LOMA if property is elevated above base flood elevation. Requires elevation certificate from surveyor. Customer: How do we help with that? Agent: We can order elevation certificate for $250. Takes 5-7 business days. Customer: I will ask borrower if they want to proceed. Agent: Let me know. Happy to help!'
        WHEN 19 THEN 'Customer: Dashboard showing error loading tax data. Agent: I can troubleshoot. What error message? Customer: Says unable to connect to tax service. Agent: Let me check system status. I am not seeing any outages. Can you try refreshing your browser? Customer: Tried that. Still error. Agent: Clear your browser cache and cookies, then try again. Customer: How do I do that? Agent: In browser settings, find Clear Browsing Data, select Cookies and Cache, clear. Then log back in. Customer: Clearing now. Logging in. It is working! Agent: Great! Old cached session was causing connection issue. Customer: Good to know. Thanks! Agent: You are welcome!'
    END AS transcript_text,
    ARRAY_CONSTRUCT('PHONE', 'EMAIL', 'CHAT')[UNIFORM(0, 2, RANDOM())] AS interaction_type,
    st.created_date AS interaction_date,
    (UNIFORM(-50, 100, RANDOM()) / 1.0)::NUMBER(5,2) AS sentiment_score,
    CASE (ABS(RANDOM()) % 5)
        WHEN 0 THEN 'tax,payment,delinquency'
        WHEN 1 THEN 'flood,certification,insurance'
        WHEN 2 THEN 'escrow,analysis,disbursement'
        WHEN 3 THEN 'api,integration,technical'
        WHEN 4 THEN 'billing,invoice,payment'
    END AS keywords,
    st.created_date AS created_at
FROM RAW.SUPPORT_TICKETS st
WHERE st.ticket_id IS NOT NULL
LIMIT 25000;

-- ============================================================================
-- Step 6: Generate sample tax dispute documents
-- ============================================================================
INSERT INTO TAX_DISPUTE_DOCUMENTS
SELECT
    'RPT' || LPAD(SEQ4(), 10, '0') AS report_id,
    tr.tax_record_id,
    tr.client_id,
    CASE (ABS(RANDOM()) % 15)
        WHEN 0 THEN 'TAX ASSESSMENT APPEAL. Tax Year: ' || tr.tax_year::VARCHAR || '. Property assessed at $340,000 but recent comparables selling at $280,000-$295,000. Requesting reassessment based on market conditions. Documentation: appraisal, market analysis, county sales data.'
        WHEN 1 THEN 'HOMESTEAD EXEMPTION APPLICATION. Tax Year: ' || tr.tax_year::VARCHAR || '. Primary residence declaration. Reduces taxable value by $25,000 for school taxes. Documentation: drivers license, utility bills, voter registration. Expected reduction: $450 annually.'
        WHEN 2 THEN 'TAX DELINQUENCY DISPUTE. Tax Year: ' || tr.tax_year::VARCHAR || '. County shows delinquent but payment made. Evidence: canceled check with county endorsement, receipt, bank statement. Request: Remove delinquency and penalties.'
        WHEN 3 THEN 'SPECIAL ASSESSMENT CHALLENGE. Additional $2,500 assessment for street improvement. Project completed in substandard manner: drainage problems, uneven surface, incomplete sections. Request: Waiver until contractor completes proper repairs.'
        WHEN 4 THEN 'AGRICULTURAL USE VALUATION. Tax Year: ' || tr.tax_year::VARCHAR || '. 10 acres total: 7 acres farming, 3 acres residential. Agricultural rate $1,500/acre vs residential $25,000/acre. Supporting evidence: farm income, sales receipts, conservation plan.'
        WHEN 5 THEN 'PROPERTY CLASSIFICATION ERROR. Incorrectly classified as commercial. Single-family residence, residential zoning, primary occupancy. Commercial rate 2.8% vs residential 1.1%. Overpayment $4,200 annually. Request: Reclassify and refund 3 years.'
        WHEN 6 THEN 'INSTALLMENT PAYMENT PLAN. Tax Year: ' || tr.tax_year::VARCHAR || '. Total due $6,000. Delinquent. Financial hardship due to job loss. Proposed: 6 monthly payments plus current year taxes. Prevents foreclosure.'
        WHEN 7 THEN 'DUPLICATE PAYMENT INVESTIGATION. Tax Year: ' || tr.tax_year::VARCHAR || '. Taxes paid twice: once via escrow, once by borrower direct. County shows only one payment. Request: Investigation and refund of duplicate.'
        WHEN 8 THEN 'SENIOR TAX FREEZE APPLICATION. Applicant age 67. Qualifying: 65+, owned 5+ years, primary residence, income under $60,000. Freezes assessed value. Current tax will not increase regardless of future assessments.'
        WHEN 9 THEN 'PARCEL INFORMATION CORRECTION. County shows 2,500 sq ft but actual 1,850 sq ft per deed and appraisal. Over-assessment $75,000. Request: Correct square footage, adjust assessment. Expected reduction $1,200 annually.'
        WHEN 10 THEN 'ASSESSED VALUE DISPUTE. Tax Year: ' || tr.tax_year::VARCHAR || '. Property assessed $100,000 higher than appraisal. Recent appraisal $425,000, assessment $525,000. Request: Adjust to appraised value. Documentation: certified appraisal dated within 90 days.'
        WHEN 11 THEN 'DISABLED VETERAN EXEMPTION. Qualifying veteran with 100% service-connected disability. Exempt from all property taxes per state law. Documentation: VA disability letter, DD-214, property ownership proof. Request: Full tax exemption.'
        WHEN 12 THEN 'TAX BILLING ERROR. Billed for services property does not receive: street lights, sidewalks, sewer. Property on septic, private road, no municipal services. Request: Remove charges for non-existent services.'
        WHEN 13 THEN 'MULTIPLE PARCEL CONSOLIDATION. Three parcels consolidated into one but still billed separately. Request: Consolidate tax billing. Single assessment for merged property. Avoid triple billing.'
        WHEN 14 THEN 'HISTORIC PROPERTY EXEMPTION. Property on National Register. Qualifies for historic preservation exemption. Reduces assessment by 25%. Documentation: historic designation letter, preservation plan, approved renovations.'
    END AS report_text,
    ARRAY_CONSTRUCT('INITIAL_REPORT', 'INVESTIGATION_COMPLETE', 'ROOT_CAUSE_ANALYSIS', 'CORRECTIVE_ACTION_PLAN')[UNIFORM(0, 3, RANDOM())] AS report_type,
    ARRAY_CONSTRUCT('PENDING', 'INVESTIGATING', 'COMPLETE')[UNIFORM(0, 2, RANDOM())] AS investigation_status,
    'Resolution pending review by tax authority' AS corrective_actions_taken,
    DATEADD('day', UNIFORM(1, 14, RANDOM()), tr.created_at) AS report_date,
    'Tax Specialist ' || UNIFORM(1, 5, RANDOM())::VARCHAR AS created_by,
    DATEADD('day', UNIFORM(1, 14, RANDOM()), tr.created_at) AS created_at
FROM RAW.TAX_RECORDS tr
WHERE UNIFORM(0, 100, RANDOM()) < 50
LIMIT 15000;

-- ============================================================================
-- Step 7: Generate sample flood determination reports
-- ============================================================================
INSERT INTO FLOOD_DETERMINATION_REPORTS
SELECT
    'FLDRPT' || LPAD(SEQ4(), 10, '0') AS report_id,
    fc.certification_id,
    fc.property_id,
    'FLOOD ZONE DETERMINATION REPORT - Property: ' || p.property_address || ', ' || p.property_city || ', ' || p.property_state || '. Flood Zone: ' || fc.flood_zone || '. Determination Date: ' || fc.certification_date::VARCHAR || '. ' ||
    CASE 
        WHEN fc.flood_zone IN ('AE', 'A', 'AH', 'AO', 'VE', 'V') THEN 'FLOOD INSURANCE REQUIRED. This property is located in a Special Flood Hazard Area (SFHA). Federal law requires flood insurance for loans secured by buildings in high-risk zones. Borrower must obtain coverage within 45 days of this determination. Minimum coverage: Lesser of outstanding loan amount or maximum available. Maximum building coverage: $250,000 for single-family homes. NFIP participation confirmed. Policy must remain in force for life of loan.'
        WHEN fc.flood_zone IN ('X', 'B', 'C') THEN 'FLOOD INSURANCE NOT REQUIRED. Property located in moderate-to-low risk flood zone outside the 100-year floodplain. While not required, flood insurance is available and recommended. Approximately 25% of flood claims come from moderate-to-low risk areas. Premiums significantly lower than high-risk zones.'
        ELSE 'FLOOD INSURANCE STATUS UNDETERMINED. Area where flood hazards are undetermined but possible. Flood studies have not been completed for this area. Lender may require flood insurance at their discretion based on local knowledge or property history.'
    END || ' Determination Method: ' || fc.determination_method || '. FEMA Panel Number: ' || fc.panel_number || '. Map Date: ' || fc.map_date::VARCHAR || '. Life-of-Loan Monitoring: ' ||
    CASE WHEN fc.life_of_loan_tracking THEN 'ACTIVE. Property enrolled in continuous monitoring. If FEMA revises flood maps affecting this property, a new determination will be issued automatically and all parties notified.' ELSE 'NOT ACTIVE' END AS report_text,
    ARRAY_CONSTRUCT('STANDARD_DETERMINATION', 'LIFE_OF_LOAN', 'LOMA_REVIEW')[UNIFORM(0, 2, RANDOM())] AS determination_type,
    fc.flood_zone AS flood_zone_determined,
    CASE 
        WHEN fc.flood_zone IN ('AE', 'A', 'AH', 'AO', 'VE', 'V') THEN 'Flood insurance required - high risk zone'
        WHEN fc.flood_zone IN ('X', 'B', 'C') THEN 'Flood insurance not required - moderate to low risk'
        ELSE 'Flood insurance status undetermined'
    END AS insurance_requirement_text,
    fc.certification_date AS report_date,
    'Flood Specialist ' || UNIFORM(1, 8, RANDOM())::VARCHAR AS created_by,
    fc.created_at AS created_at
FROM RAW.FLOOD_CERTIFICATIONS fc
JOIN RAW.PROPERTIES p ON fc.property_id = p.property_id
WHERE UNIFORM(0, 100, RANDOM()) < 50
LIMIT 20000;

-- ============================================================================
-- Step 8: Create Cortex Search Service for Support Transcripts
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE SUPPORT_TRANSCRIPTS_SEARCH
  ON transcript_text
  ATTRIBUTES client_id, agent_id, interaction_type, interaction_date
  WAREHOUSE = LERETA_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for customer support transcripts - enables semantic search across support interactions'
AS
  SELECT
    transcript_id,
    transcript_text,
    ticket_id,
    client_id,
    agent_id,
    interaction_type,
    interaction_date,
    sentiment_score,
    keywords,
    created_at
  FROM RAW.SUPPORT_TRANSCRIPTS;

-- ============================================================================
-- Step 9: Create Cortex Search Service for Tax Dispute Documents
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE TAX_DISPUTE_DOCUMENTS_SEARCH
  ON report_text
  ATTRIBUTES client_id, report_type, investigation_status, report_date
  WAREHOUSE = LERETA_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for tax dispute documents - enables semantic search across tax dispute documentation'
AS
  SELECT
    report_id,
    report_text,
    tax_record_id,
    client_id,
    report_type,
    investigation_status,
    corrective_actions_taken,
    report_date,
    created_by,
    created_at
  FROM RAW.TAX_DISPUTE_DOCUMENTS;

-- ============================================================================
-- Step 10: Create Cortex Search Service for Flood Determination Reports
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE FLOOD_DETERMINATION_REPORTS_SEARCH
  ON report_text
  ATTRIBUTES property_id, determination_type, flood_zone_determined, report_date
  WAREHOUSE = LERETA_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for flood determination reports - enables semantic search across flood documentation'
AS
  SELECT
    report_id,
    report_text,
    certification_id,
    property_id,
    determination_type,
    flood_zone_determined,
    insurance_requirement_text,
    report_date,
    created_by,
    created_at
  FROM RAW.FLOOD_DETERMINATION_REPORTS;

-- ============================================================================
-- Step 11: Verify Cortex Search Services Created
-- ============================================================================
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- ============================================================================
-- Display success message
-- ============================================================================
SELECT 'Cortex Search services created successfully' AS status,
       COUNT(*) AS service_count
FROM (
  SELECT 'SUPPORT_TRANSCRIPTS_SEARCH' AS service_name
  UNION ALL
  SELECT 'TAX_DISPUTE_DOCUMENTS_SEARCH'
  UNION ALL
  SELECT 'FLOOD_DETERMINATION_REPORTS_SEARCH'
);

-- ============================================================================
-- Display data counts
-- ============================================================================
SELECT 'SUPPORT_TRANSCRIPTS' AS table_name, COUNT(*) AS row_count FROM SUPPORT_TRANSCRIPTS
UNION ALL
SELECT 'TAX_DISPUTE_DOCUMENTS', COUNT(*) FROM TAX_DISPUTE_DOCUMENTS
UNION ALL
SELECT 'FLOOD_DETERMINATION_REPORTS', COUNT(*) FROM FLOOD_DETERMINATION_REPORTS
ORDER BY table_name;
