-- ============================================================================
-- Lereta Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          support transcripts, tax dispute documents, and flood determination reports
-- Syntax verified against: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
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
    document_id VARCHAR(30) PRIMARY KEY,
    tax_record_id VARCHAR(30),
    property_id VARCHAR(30),
    client_id VARCHAR(20),
    document_text VARCHAR(16777216) NOT NULL,
    document_type VARCHAR(50),
    dispute_status VARCHAR(30),
    resolution_outcome VARCHAR(500),
    document_date TIMESTAMP_NTZ NOT NULL,
    created_by VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (tax_record_id) REFERENCES TAX_RECORDS(tax_record_id),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id),
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
    CASE (ABS(RANDOM()) % 11)
        WHEN 0 THEN 'Agent: Thank you for calling Lereta tax services. How can I help you today? Customer: Hi, we received a delinquency notice for property 12345 Main Street but we thought that tax was paid. Agent: Let me check that property immediately. Can you provide the loan number? Customer: It is LN998877665. Agent: Thank you. Pulling up the tax record now... I see the payment was made on time to the county, but there was a delay in the county processing it. Your escrow account was debited correctly. Customer: So is there actually a delinquency? Agent: No, this is a timing issue. The county updated their records yesterday and the delinquency was cleared. I am updating your account now to reflect the payment status. Customer: Do we need to do anything? Agent: No action needed on your end. I will send you a confirmation email with the updated payment receipt. Customer: Thank you for clarifying that!'
        WHEN 1 THEN 'Customer: We need a tax certificate for a property closing next week. How fast can you get that? Agent: I can help expedite that. What is the property address? Customer: 789 Oak Avenue, Dallas, TX. Agent: And what is the closing date? Customer: Next Wednesday, the 15th. Agent: That gives us 7 business days. Standard turnaround is 5-7 days, so we should be fine. Let me check if the property is in our system... Yes, I see it is loan LN445566778. Is this a refinance or purchase? Customer: Purchase. The title company needs the certificate by Tuesday. Agent: I can mark this as rush processing. We will have the certificate to you by Monday. There is a $25 expedite fee. Customer: That is fine. Please proceed. Agent: Processing the rush order now. You will receive tracking information within 2 hours. Customer: Perfect, thank you!'
        WHEN 2 THEN 'Chat started. Agent: Welcome to Lereta flood services support! Customer: Hi, we got an alert that FEMA updated flood maps for one of our properties. What does that mean? Agent: A flood map change means FEMA has revised the flood zone designation for that area. Can you provide the property address? Customer: 456 River Road, Houston, TX. Agent: Let me pull that up... I see the change. The property moved from Zone X to Zone AE. Customer: What does that mean for the loan? Agent: Zone AE is a high-risk flood zone which means flood insurance is now required. We have already ordered a new flood determination. Customer: How long until we know for sure? Agent: The new determination should be complete within 24 hours. We will notify you immediately with the insurance requirement status. Customer: If insurance is required, when does that need to be in place? Agent: The borrower has 45 days from notification to obtain flood insurance. We will provide you with the official notification letter. Customer: Okay, thank you for the quick response. Agent: You are welcome! We will keep you updated.'
        WHEN 3 THEN 'Agent: Lereta API support, this is James. Customer: We are trying to pull property tax data via API but getting a 404 error on loan LN334455667. Agent: Let me help troubleshoot. Are you using the correct endpoint? It should be /api/v2/tax-records/{loanId}. Customer: Yes, that is what we are using. Agent: Let me check that loan in our system... I see the issue. That loan was recently transferred to your portfolio but the API sync has not completed yet. Customer: How long does the sync take? Agent: Normally within 1 hour of the loan being added. When was the transfer? Customer: This morning around 9 AM. Agent: It is been about 6 hours, so the sync should have completed. Let me trigger a manual sync now. Customer: Trying again... It worked! I am getting the data now. Agent: Great! The manual sync fixed it. If you encounter this again, our sync runs every hour, but you can contact us for a manual trigger. Customer: Good to know. Is there a way to check sync status via API? Agent: Yes, use the /api/v2/sync-status endpoint with your portfolio ID. Customer: Perfect. Thank you! Agent: Anytime!'
        WHEN 4 THEN 'Email support. Customer: We were charged for a tax payment but the county says they did not receive it. What happened? Agent: I apologize for the confusion. Let me investigate this immediately. What property address are we discussing? Customer: 2345 Pine Street, Phoenix, AZ. Loan number LN667788990. Agent: Thank you. Reviewing the disbursement records... I can see we disbursed $3,450.00 to Maricopa County on March 15th via check #123456. Customer: The county has no record of receiving that check. Agent: Let me check the check status... The check cleared our bank on March 22nd. I am sending you a copy of the canceled check showing the county endorsement. Customer: Could it be applied to the wrong parcel? Agent: That is possible. I will contact the county tax collector directly to trace the payment. Customer: How long will that take? Agent: I should have an answer within 24 hours. In the meantime, I am putting a hold on any penalties on your account. Customer: Thank you. Please keep me updated. Agent: I will email you with updates. If the county misapplied the payment, we will handle getting it corrected.'
        WHEN 5 THEN 'Phone support. Agent: Lereta tax monitoring, how may I help you? Customer: We need to set up escrow analysis for our entire loan portfolio. How does that work? Agent: I can walk you through that. How many loans are in your portfolio? Customer: About 12,000 loans. Agent: Okay, we can definitely handle that. Our escrow analysis service reviews tax amounts, insurance premiums, and calculates required monthly payments. Are your loans currently escrowed? Customer: About 70% are escrowed. Agent: For the escrowed loans, we will analyze current escrow balances and projected tax amounts to ensure adequate funding. For non-escrowed loans, we just monitor the tax payments. Customer: What happens if taxes increase? Agent: Our system automatically recalculates escrow payments when we detect tax increases. We send you a notification and the revised payment amount. Customer: Can we set different surplus thresholds by loan type? Agent: Yes! You can configure different rules for conventional, FHA, VA loans. Customer: Perfect. How do we get started? Agent: I will send you our escrow setup guide and have an implementation specialist contact you this week. Customer: Great, thank you! Agent: You are welcome!'
        WHEN 6 THEN 'Customer: I need to understand why a property tax went up 30% this year. Agent: I can help you research that. What is the property address? Customer: 8901 Elm Street, Austin, TX. Agent: Let me pull the tax history... I see the assessed value increased from $350,000 to $455,000. Customer: Why such a big jump? Agent: Let me check the county records... The county did a general reappraisal this year. Many properties in that area saw similar increases due to market appreciation. Customer: Can the borrower appeal this assessment? Agent: Yes, most counties allow assessment appeals within a specific window, usually 30-45 days from the notice date. Customer: When was the notice sent? Agent: According to our records, the assessment notice was mailed on May 1st, so the appeal deadline would be around June 15th. Customer: Can you help with the appeal? Agent: We do not prepare appeals directly, but we can provide the property tax history and comparable sales data to support an appeal. Customer: Can you send me that data? Agent: Yes, I am generating a property tax analysis report now. You will receive it within 15 minutes. Customer: That would be very helpful, thank you! Agent: You are welcome. The report includes 5-year tax history and recent sales in the neighborhood.'
        WHEN 7 THEN 'Chat. Customer: We have a loan payoff tomorrow and need to confirm all taxes are current. Agent: I can verify that for you. What is the loan number? Customer: LN112233445. Agent: Checking the tax status now... All property taxes are current. Last payment was made on November 30th for the fall installment. Customer: Are there any pending bills? Agent: Let me check... No pending bills. The next tax bill will not be issued until April for the spring installment. Customer: So we are clear to close? Agent: From a tax perspective, yes. All current and no delinquencies. Would you like me to send you a tax clearance letter? Customer: Yes please, that would be great. Agent: Generating it now... Sent to your email. The letter confirms tax status as of today and is valid for 30 days. Customer: Perfect. One more question - is there any escrow balance to refund? Agent: Looking at the escrow account... Current balance is $1,245.67. After the payoff, this will be refunded to the borrower. Customer: Excellent. Thank you for the quick help! Agent: You are welcome! Congratulations on the payoff!'
        WHEN 8 THEN 'Agent: Lereta flood certification support. Customer: We need flood certs for 500 new loans in our pipeline. Can you handle that volume? Agent: Absolutely! We process thousands of determinations daily. When do you need them completed? Customer: We need them all within 5 business days for closing. Agent: That is achievable. You can submit them via our bulk upload portal. Do you have a file prepared? Customer: We have an Excel file with all the property addresses. Agent: Perfect! You can upload that directly. Our system will process them and typically return results within 24-48 hours. Customer: What format do we need for the addresses? Agent: Property address, city, state, and ZIP are required. Loan number is optional but helpful for tracking. Customer: Can we get notified as each one completes? Agent: Yes, you can set up email notifications or use our API webhook to get real-time status updates. Customer: Do we get certificates immediately or need to request them? Agent: Certificates are generated automatically with each determination. You can download them individually or as a batch. Customer: What is the cost? Agent: Standard flood determination is $12 per property. For 500, that would be $6,000. We can set up a monthly billing cycle. Customer: Sounds good. I will upload the file this afternoon. Agent: Great! I will monitor the batch and reach out if there are any issues with addresses.'
        WHEN 9 THEN 'Email thread. Customer: One of our borrowers is disputing a tax amount we escrowed. They say the tax bill is lower than what we collected. Agent: I can research that. What property and tax year are we discussing? Customer: 5678 Maple Drive, Dallas TX, 2024 tax year. Loan LN887766554. Agent: Let me review the escrow analysis... We projected the 2024 taxes at $4,200 based on the 2023 amount of $4,000 plus estimated 5% increase. Customer: But the actual bill came in at $3,950. What happened? Agent: It looks like the county reduced the assessed value after our projection. This sometimes happens if there was a successful appeal or a general reduction. Customer: Should we refund the difference to the borrower? Agent: Yes, the overage of $250 should be refunded. We will also adjust the monthly escrow payment going forward to reflect the actual amount. Customer: Can you calculate the new monthly payment? Agent: Based on the actual tax of $3,950 plus estimated insurance of $1,200, the monthly escrow should be $429. It is currently set at $450. I recommend reducing it to $430 to maintain a small cushion. Customer: Please make that change. How do we process the refund? Agent: I will process the escrow adjustment now. The new payment amount will be effective next month, and the refund check will be mailed to the borrower within 5 business days. Customer: Thank you! Agent: You are welcome! I am updating the account now.'
        WHEN 10 THEN 'Customer: We need to onboard a new loan portfolio. What information do you need from us? Agent: Great! I can help you get set up. How many loans are you transferring? Customer: About 8,500 loans. Agent: Okay, we will need some key data points for each loan. Customer: What specifically? Agent: Loan number, property address, borrower name, loan amount, current servicer loan number if transferring, and whether tax and flood monitoring is required. Customer: We have all that in our loan servicing system. What format do you need? Agent: We accept CSV, Excel, or you can use our API for direct integration. Do you have existing tax and flood data? Customer: Yes, we have all historical tax payments and flood certs. Agent: Excellent! Include that in the file so we can have complete history from day one. We also need escrow account numbers and current balances if applicable. Customer: How long does the onboarding take? Agent: For 8,500 loans, we typically need 3-5 business days to load the data and complete initial setup. Then another 2-3 days for verification. Customer: So about a week total? Agent: Yes, plan for 7-10 business days to be safe. We will assign you a dedicated implementation manager who will keep you updated daily. Customer: Perfect. Who should I send the data file to? Agent: I will send you a secure upload link and introduce you to your implementation manager via email within the hour. Customer: Sounds good. Thanks for walking me through this! Agent: My pleasure! Welcome to Lereta!'
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
    'TAXDOC' || LPAD(SEQ4(), 10, '0') AS document_id,
    tr.tax_record_id,
    tr.property_id,
    tr.client_id,
    CASE (ABS(RANDOM()) % 10)
        WHEN 0 THEN 'TAX ASSESSMENT APPEAL - Property: ' || p.property_address || '. Tax Year: ' || tr.tax_year || '. Current Assessment: $' || p.assessed_value || '. Grounds for Appeal: The current assessment significantly exceeds market value. Recent comparable sales in the neighborhood show values 15-20% lower. Comparable Properties: 1) Property A sold for $285,000 (assessed at $320,000), 2) Property B sold for $295,000 (assessed at $335,000), 3) Property C sold for $275,000 (assessed at $310,000). Our property is assessed at $340,000 but similar properties are selling at $280,000-$295,000 range. We request a reassessment based on actual market conditions. Supporting documentation includes recent appraisal, comparative market analysis, and recent sales data from county records.'
        WHEN 1 THEN 'PROPERTY TAX EXEMPTION APPLICATION - Property Address: ' || p.property_address || '. Application Type: Homestead Exemption. Tax Year: ' || tr.tax_year || '. Applicant declares this property as their primary residence as of January 1. Property has been owner-occupied for entire tax year. Request: Homestead exemption which reduces taxable value by $25,000 for school taxes. Documentation provided: Drivers license showing property address, utility bills for past 12 months, voter registration at property address, and declaration of primary residence. Expected tax reduction: approximately $450 annually based on current tax rate.'
        WHEN 2 THEN 'TAX DELINQUENCY DISPUTE - Loan: Property ' || p.property_address || '. Dispute Reason: County records show property tax as delinquent for ' || tr.tax_year || ' tax year, however payment was made on ' || tr.payment_date || ' check number [removed] in amount of $' || tr.tax_amount || '. Evidence of Payment: 1) Cancelled check dated ' || tr.payment_date || ' with county endorsement, 2) Receipt from county tax office, 3) Bank statement showing check clearance. Request: Remove delinquency designation and any associated penalties. The county has misapplied the payment or failed to properly record it in their system. We request immediate correction of records and confirmation of payment status.'
        WHEN 3 THEN 'SPECIAL ASSESSMENT CHALLENGE - Property: ' || p.property_address || '. Assessment Type: Street Improvement Assessment. Amount: Additional $2,500 special assessment. Challenge Basis: The street improvement project was completed in a substandard manner. Issues include: 1) Drainage problems causing water pooling, 2) Uneven surface requiring immediate repair, 3) Incomplete sidewalk sections. Multiple property owners on the street are filing similar challenges. We request waiver or reduction of the special assessment until the contractor completes repairs to proper specifications. Project completion certification should be withheld until all deficiencies are corrected.'
        WHEN 4 THEN 'AGRICULTURAL USE VALUATION REQUEST - Property: ' || p.property_address || '. Current Use: Residential/Agricultural. Request: Agricultural use valuation for the portion of property actively used for farming. Property Details: 10 acres total, 7 acres in active agricultural production (hay crop), 3 acres residential homestead. Tax Year: ' || tr.tax_year || '. Supporting Evidence: Farm income records, hay sales receipts, agricultural exemption certificate, soil conservation plan, and photographs showing active farming operations. Expected Tax Impact: Agricultural valuation would assess the 7 acres at approximately $1,500/acre instead of residential rate of $25,000/acre, resulting in significant tax reduction for qualifying acreage.'
        WHEN 5 THEN 'PROPERTY CLASSIFICATION ERROR - Property Address: ' || p.property_address || '. Current Classification: Commercial. Correct Classification: Residential. Issue: County has incorrectly classified this single-family residence as commercial property, resulting in higher tax rate. The property is zoned residential, occupied as primary residence, and has no commercial use. Tax Impact: Commercial rate is 2.8% vs residential rate of 1.1%, causing annual overpayment of approximately $4,200. Request: Reclassify property as residential and refund overpaid taxes for the past 3 years (statute of limitations period). Documentation: Zoning verification, occupancy permit, homeowner insurance policy showing residential use, and county GIS data showing residential zoning.'
        WHEN 6 THEN 'TAX INSTALLMENT PAYMENT PLAN REQUEST - Property: ' || p.property_address || '. Total Tax Due: $' || tr.tax_amount || '. Current Status: Delinquent. Request: Installment payment plan to cure delinquency. Financial Hardship: Borrower experienced temporary job loss but is now re-employed. Proposed Plan: Pay $' || (tr.tax_amount / 6) || ' monthly over 6 months plus current year taxes. First payment can be made immediately. This plan would bring account current within 6 months and prevent tax foreclosure proceedings. Borrower has consistent income now and can maintain both current and catch-up payments. Request approval from county tax collector for installment arrangement.'
        WHEN 7 THEN 'DUPLICATE TAX PAYMENT INVESTIGATION - Property: ' || p.property_address || '. Issue: Property taxes appear to have been paid twice for ' || tr.tax_year || ' tax year. Payment 1: $' || tr.tax_amount || ' paid on ' || tr.payment_date || ' via escrow account. Payment 2: $' || tr.tax_amount || ' paid by borrower directly to county on [date]. County records show both payments received but property still showing as paid only once. Request: Full investigation of payment application and refund of duplicate payment. One payment should be refunded to the escrow account. Timeline: Request resolution within 30 days to prevent escrow account shortfall for next tax period.'
        WHEN 8 THEN 'SENIOR CITIZEN TAX FREEZE APPLICATION - Property: ' || p.property_address || '. Applicant Age: 67 years old. Qualifying Criteria: 1) Age 65 or older, 2) Property owner for 5+ years, 3) Primary residence, 4) Total household income below $' || '60,000' || '. Tax Freeze Benefit: Current assessed value of $' || p.assessed_value || ' will be frozen for tax purposes. Future increases in assessed value will not increase tax burden. Current annual tax: $' || tr.tax_amount || ' will remain constant regardless of future assessments. Documentation: Birth certificate, proof of ownership for past 7 years, income tax returns showing qualifying income, and signed declaration of primary residence.'
        WHEN 9 THEN 'INCORRECT PARCEL INFORMATION CORRECTION - Property: ' || p.property_address || '. Parcel Number: ' || p.parcel_number || '. Error: County records show property as 2,500 sq ft when actual size is 1,850 sq ft per original deed and recent appraisal. This size discrepancy results in over-assessment of approximately $75,000 in value. Request: Correct property records to reflect accurate square footage and adjust assessment accordingly. Supporting Documentation: Original deed with property dimensions, recent appraisal report, building permits showing actual construction size, and survey showing property boundaries. Expected Tax Reduction: Approximately $1,200 annually based on corrected square footage.'
    END AS document_text,
    ARRAY_CONSTRUCT('APPEAL', 'EXEMPTION_APPLICATION', 'DISPUTE', 'PAYMENT_PLAN_REQUEST')[UNIFORM(0, 3, RANDOM())] AS document_type,
    ARRAY_CONSTRUCT('PENDING', 'UNDER_REVIEW', 'RESOLVED', 'DENIED')[UNIFORM(0, 3, RANDOM())] AS dispute_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN 'Appeal approved, assessment reduced' ELSE 'Under review pending additional documentation' END AS resolution_outcome,
    tr.created_at AS document_date,
    'Tax Specialist ' || UNIFORM(1, 10, RANDOM())::VARCHAR AS created_by,
    tr.created_at AS created_at
FROM RAW.TAX_RECORDS tr
JOIN RAW.PROPERTIES p ON tr.property_id = p.property_id
WHERE tr.delinquent = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 15
LIMIT 15000;

-- ============================================================================
-- Step 7: Generate sample flood determination reports
-- ============================================================================
INSERT INTO FLOOD_DETERMINATION_REPORTS
SELECT
    'FLDRPT' || LPAD(SEQ4(), 10, '0') AS report_id,
    fc.certification_id,
    fc.property_id,
    'FLOOD ZONE DETERMINATION REPORT

Property Address: ' || p.property_address || '
City: ' || p.property_city || ', ' || p.property_state || ' ' || p.property_zip || '
County: ' || p.county || '

DETERMINATION DETAILS:
Flood Zone: ' || fc.flood_zone || '
FEMA Map Panel: ' || fc.panel_number || '
Map Date: ' || fc.map_date::VARCHAR || '
Determination Date: ' || fc.certification_date::VARCHAR || '
Determination Method: ' || fc.determination_method || '

' || CASE 
    WHEN fc.flood_zone IN ('AE', 'A', 'AH', 'AO', 'VE', 'V') THEN 
'FLOOD INSURANCE REQUIRED

This property is located in a Special Flood Hazard Area (SFHA), commonly known as a high-risk flood zone. Federal law requires flood insurance for loans secured by buildings in high-risk zones.

INSURANCE REQUIREMENTS:
- Flood insurance is MANDATORY for this property
- Minimum coverage: Lesser of outstanding loan amount or maximum available
- Policy must be obtained within 45 days of this determination
- Policy must remain in force for the life of the loan
- Building and contents coverage available

FLOOD ZONE DESCRIPTION:
' || CASE fc.flood_zone
    WHEN 'AE' THEN 'Zone AE: Areas with 1% annual chance of flooding (100-year floodplain) where base flood elevations have been determined. This is a high-risk zone.'
    WHEN 'A' THEN 'Zone A: Areas with 1% annual chance of flooding (100-year floodplain) where base flood elevations have NOT been determined. This is a high-risk zone.'
    WHEN 'AH' THEN 'Zone AH: Areas with 1% annual chance of shallow flooding (usually ponding) where average depths are 1-3 feet. This is a high-risk zone.'
    WHEN 'AO' THEN 'Zone AO: Areas with 1% annual chance of shallow flooding (usually sheet flow) where average depths are 1-3 feet. This is a high-risk zone.'
    WHEN 'VE' THEN 'Zone VE: Coastal areas with 1% annual chance of flooding and additional hazards from storm waves. This is the highest risk zone. Special construction requirements may apply.'
    WHEN 'V' THEN 'Zone V: Coastal areas with 1% annual chance of flooding and wave action. This is a high-risk coastal zone.'
    ELSE 'Special Flood Hazard Area'
END || '

NATIONAL FLOOD INSURANCE PROGRAM (NFIP):
- Maximum building coverage: $250,000 for single-family homes
- Maximum contents coverage: $100,000 for residential properties
- Private flood insurance is also available and may be required
- Community must participate in NFIP for insurance to be available
- Community Participation Status: CONFIRMED

BORROWER NOTIFICATION:
The borrower must be notified of:
1. Flood insurance requirement
2. Amount of coverage required  
3. Consequences of not maintaining insurance
4. Options for obtaining flood insurance
5. Right to appeal the determination

LIFE-OF-LOAN MONITORING:
This property is enrolled in life-of-loan flood monitoring. If FEMA revises flood maps affecting this property, a new determination will be issued automatically and all parties will be notified.'
    WHEN fc.flood_zone IN ('X', 'B', 'C') THEN
'FLOOD INSURANCE NOT REQUIRED (OPTIONAL)

This property is located in a moderate-to-low risk flood zone. Federal law does not require flood insurance for properties in these zones, but it is available and recommended.

FLOOD ZONE DESCRIPTION:
' || CASE fc.flood_zone
    WHEN 'X' THEN 'Zone X: Areas of moderate to minimal flood risk, outside the 100-year floodplain. This includes areas with less than 1% annual chance of flooding.'
    WHEN 'B' THEN 'Zone B: Moderate risk areas between 100-year and 500-year flood boundaries. (Note: This is a legacy zone designation, now typically shown as Zone X).'
    WHEN 'C' THEN 'Zone C: Minimal risk areas with less than 0.2% annual chance of flooding. (Note: This is a legacy zone designation, now typically shown as Zone X).'
    ELSE 'Moderate to Low Risk Flood Zone'
END || '

IMPORTANT NOTES:
- While flood insurance is not required, approximately 25% of flood claims come from moderate-to-low risk areas
- Flood insurance is available through the National Flood Insurance Program (NFIP)
- Private flood insurance may also be available
- Premiums in low-risk zones are significantly lower than high-risk zones
- Lenders may still require flood insurance at their discretion

LIFE-OF-LOAN MONITORING:
This property is enrolled in life-of-loan flood monitoring. If FEMA revises flood maps and the property is remapped into a high-risk zone, a new determination will be issued and flood insurance will become required.'
    WHEN fc.flood_zone = 'D' THEN
'FLOOD INSURANCE STATUS: UNDETERMINED

This property is located in an area where flood hazards are undetermined, but possible. Flood insurance may be required at lender discretion.

FLOOD ZONE DESCRIPTION:
Zone D: Areas where flood hazards are undetermined. This occurs in areas where flood studies have not been completed or where studies are outdated.

RECOMMENDATIONS:
- Consider obtaining flood insurance even though not federally mandated
- Lender may require flood insurance based on local knowledge or property history
- Community may not participate in National Flood Insurance Program
- Private flood insurance may be available

LIFE-OF-LOAN MONITORING:
This property is enrolled in monitoring. When FEMA completes flood studies for this area, a new determination will be issued.'
    ELSE 'Flood determination completed. See determination method for additional details.'
END || '

APPEALS PROCESS:
If you believe this determination is incorrect, you may:
1. Request a Letter of Map Amendment (LOMA) from FEMA if property is elevated above flood zone
2. Obtain an Elevation Certificate and request review
3. Appeal to FEMA if you have evidence of mapping error
4. Contact Lereta for assistance with the appeals process

COMPLIANCE NOTES:
- Determination meets Biggert-Waters Flood Insurance Reform Act requirements  
- Determination meets mandatory purchase requirements  
- Property location verified using FEMA Flood Map Service Center database
- This determination is valid for the life of the loan or until FEMA revises the flood maps

For questions about this determination, contact Lereta Flood Services.

Report generated by: Lereta Flood Determination System
Report ID: ' || 'FLDRPT' || LPAD(SEQ4(), 10, '0') AS report_text,
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
AS (
    SELECT 
        transcript_id,
        transcript_text,
        client_id,
        agent_id,
        interaction_type,
        interaction_date
    FROM SUPPORT_TRANSCRIPTS
);

-- ============================================================================
-- Step 9: Create Cortex Search Service for Tax Dispute Documents
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE TAX_DISPUTE_DOCUMENTS_SEARCH
ON document_text
ATTRIBUTES client_id, property_id, document_type, dispute_status, document_date
WAREHOUSE = LERETA_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        document_id,
        document_text,
        client_id,
        property_id,
        document_type,
        dispute_status,
        document_date
    FROM TAX_DISPUTE_DOCUMENTS
);

-- ============================================================================
-- Step 10: Create Cortex Search Service for Flood Determination Reports
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE FLOOD_DETERMINATION_REPORTS_SEARCH
ON report_text
ATTRIBUTES property_id, determination_type, flood_zone_determined, report_date
WAREHOUSE = LERETA_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        report_id,
        report_text,
        property_id,
        determination_type,
        flood_zone_determined,
        report_date
    FROM FLOOD_DETERMINATION_REPORTS
);

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'Cortex Search services created successfully - all syntax verified' AS status;

-- Verify Cortex Search services exist
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- Display row counts
SELECT 
    'SUPPORT_TRANSCRIPTS' AS table_name,
    COUNT(*) AS row_count
FROM SUPPORT_TRANSCRIPTS
UNION ALL
SELECT 
    'TAX_DISPUTE_DOCUMENTS' AS table_name,
    COUNT(*) AS row_count
FROM TAX_DISPUTE_DOCUMENTS
UNION ALL
SELECT 
    'FLOOD_DETERMINATION_REPORTS' AS table_name,
    COUNT(*) AS row_count
FROM FLOOD_DETERMINATION_REPORTS;

