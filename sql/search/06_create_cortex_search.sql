-- ============================================================================
-- Lereta Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          support transcripts, tax dispute documents, and training materials
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
-- Step 3: Create table for training materials
-- ============================================================================
CREATE OR REPLACE TABLE TRAINING_MATERIALS (
    material_id VARCHAR(30) PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content VARCHAR(16777216) NOT NULL,
    material_category VARCHAR(50),
    course_category VARCHAR(50),
    tags VARCHAR(500),
    author VARCHAR(100),
    last_updated TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    view_count NUMBER(10,0) DEFAULT 0,
    helpfulness_score NUMBER(3,2),
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- Step 4: Enable change tracking (required for Cortex Search)
-- ============================================================================
ALTER TABLE SUPPORT_TRANSCRIPTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE TAX_DISPUTE_DOCUMENTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE TRAINING_MATERIALS SET CHANGE_TRACKING = TRUE;

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
-- Step 7: Generate sample training materials
-- ============================================================================
INSERT INTO TRAINING_MATERIALS VALUES
('MAT001', 'Property Tax Monitoring Best Practices',
$$PROPERTY TAX MONITORING - BEST PRACTICES GUIDE

INTRODUCTION
Property tax monitoring is essential for protecting lender interests and ensuring borrower compliance. This guide covers monitoring procedures, delinquency detection, and resolution strategies.

TAX PAYMENT CYCLE
Understanding the tax cycle:
- Assessment notices (January-March)
- Tax bills issued (varies by jurisdiction)
- Payment due dates (annual, semi-annual, or quarterly)
- Delinquency notices (30-90 days after due date)
- Tax lien filing (180-365 days delinquent)

MONITORING PROCEDURES
Daily tasks:
- Review new tax bills received
- Verify assessment amounts
- Check payment due dates
- Update escrow projections

Weekly tasks:
- Review delinquency reports
- Contact counties on missing payments
- Update payment status
- Generate client reports

Monthly tasks:
- Reconcile all payments
- Analyze assessment changes
- Review jurisdiction compliance
- Escrow analysis updates

DELINQUENCY MANAGEMENT
Early detection is critical:
- Monitor due dates carefully
- Verify payments within 30 days
- Contact county if payment not posted
- Initiate research immediately

Common delinquency causes:
- County processing delays
- Payment misapplication
- Escrow account shortfalls
- Borrower direct payment conflicts

Resolution strategies:
- Trace payment with canceled checks
- Contact county tax collector directly
- Provide proof of payment
- Negotiate penalty waivers

ESCROW ANALYSIS
Annual requirements:
- Calculate projected taxes
- Review insurance premiums
- Determine monthly payment
- Check for surplus or shortage

Shortage resolution:
- Spread over 12 months plus cushion
- Notify borrower of increase
- Update servicer records
- Monitor next payment cycle

JURISDICTION MANAGEMENT
Track jurisdiction details:
- Tax rates and schedules
- Payment methods accepted
- Contact information
- Processing timelines

Best practices:
- Maintain jurisdiction database
- Document payment procedures
- Track processing delays
- Build county relationships

QUALITY CONTROL
Verification procedures:
- Double-check all payments
- Reconcile monthly
- Audit random samples
- Review error reports

TECHNOLOGY TOOLS
- Automated payment tracking
- OCR for tax bill processing
- API integrations with counties
- Real-time alerts and notifications

For questions contact Lereta Tax Services.$$,
'TRAINING', 'TAX_MONITORING', 'tax,monitoring,delinquency,escrow', 'Tax Operations Team', CURRENT_TIMESTAMP(), 3421, 4.7, TRUE, CURRENT_TIMESTAMP()),

('MAT002', 'Flood Certification Procedures',
$$FLOOD ZONE DETERMINATION - PROCEDURES GUIDE

FEMA FLOOD ZONES
Understanding zone designations:

HIGH-RISK ZONES (Insurance Required):
- Zone A: 100-year floodplain, no elevation data
- Zone AE: 100-year floodplain with elevations
- Zone AH: Shallow flooding area
- Zone AO: Sheet flow flooding area
- Zone V: Coastal high-risk
- Zone VE: Coastal with elevation data

MODERATE-TO-LOW RISK (Insurance Optional):
- Zone X: Outside 100-year floodplain
- Zone B: Legacy moderate risk designation
- Zone C: Legacy minimal risk designation

UNDETERMINED:
- Zone D: Flood hazard undetermined

DETERMINATION PROCESS
Standard procedure:
1. Receive property address
2. Access FEMA Map Service Center
3. Identify correct map panel
4. Determine flood zone
5. Note map date and panel number
6. Assess insurance requirement
7. Generate certification document

Life-of-Loan Monitoring:
- Enroll property in monitoring
- Track FEMA map changes
- Auto-generate new certs if zone changes
- Notify all parties immediately

LOMA REQUESTS
Letter of Map Amendment process:
- Borrower obtains elevation certificate
- Submit to FEMA with evidence
- FEMA reviews and issues LOMA
- Update certification records
- Remove insurance requirement if approved

INSURANCE REQUIREMENTS
When is flood insurance required?
- Property in high-risk zone (A, AE, AH, AO, V, VE)
- Building securing the loan
- Community participates in NFIP

Coverage requirements:
- Lesser of: loan amount OR maximum available
- Maximum: $250,000 residential building
- Separate contents coverage available
- Must remain in force for life of loan

BORROWER NOTIFICATION
Required notifications:
- Flood zone designation
- Insurance requirement status
- Amount of coverage needed
- Consequences of non-compliance
- 45-day timeline to obtain insurance

COMPLIANCE
Biggert-Waters Act requirements:
- Force-place if borrower does not obtain
- Annual escrow analysis if escrowed
- Premium increases upon renewal
- No grandfathering for new policies

MAP CHANGES
When FEMA updates maps:
- Review all properties in affected areas
- Determine new zones
- Issue new certifications
- Update insurance requirements
- Notify borrowers and lenders

For questions contact Lereta Flood Services.$$,
'TRAINING', 'FLOOD_CERTIFICATION', 'flood,fema,insurance,zones,determination', 'Flood Services Team', CURRENT_TIMESTAMP(), 2876, 4.8, TRUE, CURRENT_TIMESTAMP()),

('MAT003', 'Escrow Account Management Guide',
$$ESCROW ACCOUNT MANAGEMENT - COMPREHENSIVE GUIDE

ESCROW BASICS
Purpose of escrow accounts:
- Collect funds for property taxes
- Collect funds for insurance premiums
- Protect lender interest in property
- Ensure timely payments

ESCROW ANALYSIS
Annual requirements:
- Review actual disbursements
- Project next 12 months
- Calculate monthly payment
- Determine surplus or shortage

Calculation method:
1. Add all projected disbursements
2. Add 2-month cushion (maximum)
3. Subtract current balance
4. Divide by 12 for monthly payment

SHORTAGE MANAGEMENT
When shortage detected:
- Spread over 12 months minimum
- Add to monthly payment
- Notify borrower 30 days before change
- Explain reason for increase

Causes of shortages:
- Tax increases
- Insurance premium increases
- Missed payments
- Disbursement errors

SURPLUS MANAGEMENT
When surplus exceeds regulations:
- Refund amount over $50
- Or apply to next year escrow
- Borrower choice if allowed
- Process within 30 days

DISBURSEMENT PROCEDURES
Tax payment process:
- Verify bill accuracy
- Confirm due date
- Initiate payment 10 days before due
- Obtain confirmation
- Update account records

Insurance payment:
- Verify coverage current
- Confirm premium amount
- Pay before expiration
- Obtain proof of payment
- Update policy records

REGULATORY COMPLIANCE
RESPA requirements:
- Annual escrow analysis
- Initial analysis at closing
- Shortage/surplus calculation
- Borrower notification requirements
- Refund processing timelines

Maximum cushion:
- 2 months of escrow payments
- Based on projected disbursements
- Cannot exceed regulatory limit

COMMON ISSUES
Payment misapplication:
- County applies to wrong parcel
- Check lost in mail
- Electronic payment errors

Resolution:
- Trace payment immediately
- Contact tax collector
- Provide proof of payment
- Protect borrower from penalties

TECHNOLOGY
Automation benefits:
- Accurate projections
- Timely disbursements
- Automatic reconciliation
- Real-time balance tracking

Best practices:
- Maintain complete records
- Reconcile monthly
- Monitor for exceptions
- Document all transactions

For questions contact Lereta Escrow Services.$$,
'TRAINING', 'ESCROW_MANAGEMENT', 'escrow,analysis,disbursement,respa', 'Compliance Team', CURRENT_TIMESTAMP(), 1923, 4.6, TRUE, CURRENT_TIMESTAMP());

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
-- Step 10: Create Cortex Search Service for Training Materials
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE TRAINING_MATERIALS_SEARCH
  ON content
  ATTRIBUTES material_category, course_category, title
  WAREHOUSE = LERETA_WH
  TARGET_LAG = '24 hours'
  COMMENT = 'Cortex Search service for training materials - enables semantic search across training documentation'
AS
  SELECT
    material_id,
    title,
    content,
    material_category,
    course_category,
    tags,
    author,
    last_updated,
    view_count,
    helpfulness_score,
    created_at
  FROM RAW.TRAINING_MATERIALS;

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
  SELECT 'TRAINING_MATERIALS_SEARCH'
);

-- ============================================================================
-- Display data counts
-- ============================================================================
SELECT 'SUPPORT_TRANSCRIPTS' AS table_name, COUNT(*) AS row_count FROM SUPPORT_TRANSCRIPTS
UNION ALL
SELECT 'TAX_DISPUTE_DOCUMENTS', COUNT(*) FROM TAX_DISPUTE_DOCUMENTS
UNION ALL
SELECT 'TRAINING_MATERIALS', COUNT(*) FROM TRAINING_MATERIALS
ORDER BY table_name;
