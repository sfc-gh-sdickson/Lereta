# Lereta Snowflake Engagement - Strategic Analysis

Based on meeting transcript from November 5, 2025

---

## **What We Know:**

### Business Context
- **Company:** Lereta (title/real estate industry, competing with CoreLogic)
- **Goal:** Data modernization to create revenue-generating data products
- **Timeline:** Phase 1 starts early December 2025 (6 weeks), Phase 2 mid-January to June/July 2026 (4-6 months)
- **Budget Driver:** Private equity ownership pushing for modernization to increase company value for sale

### Current Pain Points
- **Architecture:** 160TB SQL Server EDW (8TB PSA with 13.7B records)
- **Complexity:** Maximum complexity with disparate systems, SSIS packages, mainframe dependencies
- **Technical Debt:** SSRS/SSAS being deprecated, no clear path forward
- **Team Size:** Only 2 data engineers + 1 lead (Ryan) - severely understaffed
- **Culture Issue:** "Everything is important" mindset has paralyzed progress for 10 years

### Key Stakeholders & Priorities
- **Mitch (CTO):** Big Snowflake proponent, wants ML/AI, data products, revenue generation
- **Suzanne Powell:** Heads data enablement team, consolidating data functions
- **Katie:** Involved in decision-making
- **Ryan (Lead):** Technical leader who pushes back appropriately, focused on simplification
- **Team:** Robert Liu, Jimmy Pan (senior data engineers), Nader (scrum master), Travis (product owner)

### Decision Already Made
- **KPMG selected** as migration partner (beat out West Monroe, Seven Rivers)
  - Contract value: **$1,020,000** (KPMG investing $118K-128K)
  - Net client cost: ~$892K-902K
  - Duration: 20-22 weeks starting December 1, 2025
- **Snowflake chosen** over alternatives (already decided)
- **Atacama** selected for data governance (training happening now, live in 3 weeks)
- **Business Critical Edition** - they know they need the top tier

### Technical Requirements
- **Critical Data Elements (CDEs):** Focus on 3 domains - Agency, Customer, Loan
- **Data Currency:** 90%+ daily refresh, some 8x/day for critical data
- **Client Reporting:** 20-25 external customers need SLA reporting
- **Integration:** Mainframe (moving to Linux containers), SQL Server, Azure SQL (Elevate/LorettaNet), Oracle (limited)
- **No Spark:** Explicitly want native Snowflake, no complex transformations

### Cost Understanding
- **Storage:** ~$8,800/year (32TB after compression) - this resonated well
- **Not concerned about storage costs** after hearing the numbers
- **Multi-year contract preferred** for best pricing
- **Credits model understood** and appreciated

---

## **KPMG Proposal Details:**

### Contract Overview
- **Total Investment:** $1,020,000 over 20-22 weeks
- **KPMG Alliance Investment:** $118K-128K (Snowflake Architect at no cost)
- **Net Client Cost:** ~$892K-902K
- **Start Date:** December 1, 2025
- **Payment Terms:** 30 days net; Phase 1 milestone-based, Phase 2 monthly
- **Out-of-Pocket Expenses:** Up to 15% of professional fees
- **Project Sponsor:** Suzanne Powell (Chief Transformation Officer)

### Phase 1: Rapid Assessment, Roadmap & Design (6 weeks - $300K)

**Duration:** Week 1-6 (Dec 1 - Mid-January 2026)

**Key Activities:**
- **Mobilization**
  - Program kickoff and stakeholder alignment
  - Gather existing artifacts (max 30 documents reviewed)
  - Schedule max 8 discovery interviews (majority by week 2)
  - Develop detailed project plan

- **Current State Assessment**
  - Data profiling and inventory
  - Database architecture, ETL, and data warehousing assessment
  - Metadata registries and enterprise interfaces review
  - Security, observability, and API integrations assessment
  - Migration volume and pattern analysis

- **Roadmap Development**
  - Gap analysis (current vs. future state)
  - Initiative blueprints with timelines and dependencies
  - Prioritized implementation roadmap

- **Foundations & Design**
  - **Data Management Workstream:**
    - Tactical Data Governance Operating Model
    - Coordination with Atacama Professional Services
    - Data Migration functional requirements
  
  - **Snowflake Workstream:**
    - Onboard/customize Snowflake accelerators
    - Design Snowflake architecture
    - Establish guardrails, roles, permissions, access controls
    - Identify critical datasets for pilot

**Deliverables:**
1. Engagement Kickoff & Plan (schedule, meetings, roles/responsibilities)
2. Current-State Maturity & Impact Assessment (gaps, risks, scorecard)
3. Executive Summary with presentation
4. Prioritized Business Outcome Roadmap (vision, initiatives, timelines, value)
5. Executive Presentation & Business Case
6. Migration Governance Operating Model
7. Data Migration Playbook
8. Architectural Diagram (current to target-state)
9. Snowflake Technical Diagram (detailed configuration)

**Milestone Payments:**
- $150K at Week 3 milestone
- $150K at Week 6 milestone

### Phase 2: Initial Enablement (14-16 weeks - $630K-720K)

**Duration:** Week 7-22 (Mid-January - May 2026)

**Scope:** To be finalized during Phase 1 based on 1-2 prioritized use cases

**Key Activities:**
- **Data Management Enablement Workstream:**
  - Identify strategic pilot use cases
  - Conduct data profiling for pilot datasets
  - Prepare Critical Data Element (CDE) glossary
  - Stakeholder validation sessions for CDEs
  - Translate business rules into functional DQ rules
  - Onboard metadata into Atacama Catalog
  - Configure observability and DQ rules in Atacama
  - Execute DQ rules and document remediation activities

- **Snowflake Enablement Workstream:**
  - Provision Cloud environment and prerequisites
  - Migrate legacy EDW data to Bronze/Silver/Gold layers
  - Construct ETL/ELT pipelines for data ingestion
  - Develop data processing logic and data hygiene
  - Develop semantic layer and configure data visualization
  - Setup cross-account access
  - **Activate GenAI** using Cortex Analyst, Copilot, and out-of-box products
  - Conduct testing, validation, and gather stakeholder feedback

**Representative Deliverables:**
1. Data profiling assessment and recommendations report
2. Critical Data Element (CDE) business glossary
3. Functional Data Quality rules for Atacama DQ
4. Pilot Snowflake environment (provisioned and configured)
5. Working data products for pilot use cases

**Payment:**
- $45K-50K per week (varies by week: $45K/week baseline, $50K/week with full offshore team)
- Monthly invoicing

### KPMG Team Structure

**Phase 1 Staffing:**

| Role | Location | FTE % | Notes |
|------|----------|-------|-------|
| Strategy & Oversight | Onshore | 10% | Jonathan Shiery (Partner) |
| Engagement Lead | Onshore | 35% | Gary Torpey |
| Snowflake Enablement Lead | Onshore | 35% | Garrett Flynn / Danielle Beringer |
| **Snowflake Data Architect** | Onshore | 100% | **$48K KPMG investment** |
| Snowflake Enablement Manager | Onshore | 60% | |
| Senior Data Engineer | Onshore | 100% | |
| Data Mgmt. Enablement Manager | Onshore | 50% | |
| Data Mgmt. Enablement Consultant | Onshore | 100% | |
| Data Mgmt. – Offshore | Offshore | 100% | |
| Subject Matter Professional | Onshore | 10% | |

**Phase 2 Staffing (To be finalized):**

| Role | Location | FTE % | Notes |
|------|----------|-------|-------|
| Strategy & Oversight | Onshore | 10% | Reduced oversight |
| Engagement Lead | Onshore | 10% | Reduced from 35% |
| Snowflake Enablement Lead | Onshore | 10% | Reduced from 35% |
| **Snowflake Data Architect** | Onshore | 100% | **Continues at no cost** |
| Snowflake Enablement Manager | Onshore | 50% | |
| Senior Data Engineer | Onshore | 100% | |
| Data Mgmt. Enablement Manager | Onshore | 50% | |
| Data Mgmt. Enablement Consultant | Onshore | 100% | |
| Data Mgmt. – Offshore | Offshore | 100% | |
| Data Eng Mgr. – Offshore | Offshore | 100% | **New for Phase 2** |
| Data Analyst – Offshore | Offshore | 100% | **New for Phase 2** |
| Data Engineer – Offshore | Offshore | 100% | **New for Phase 2** |
| Subject Matter Professional | Onshore | 5% | |

### Key KPMG Contacts

- **Client Relationship Partner:** Jonathan Shiery - Overall engagement quality
- **Client Service Partners:** Garrett Flynn & Danielle Beringer - Engagement quality and satisfaction
- **Engagement Manager:** Gary Torpey - Primary coordinator for all work and deliverables
- **Engagement Staff:** Professionals with necessary skills assigned as appropriate

### Critical Assumptions & Constraints

**Lereta Responsibilities:**
- Timely availability and responsiveness of resources (affects fees)
- Provide secure remote access (VPN if needed)
- Accept/provide feedback on deliverables within 3 business days
- Provide up to 30 artifacts for review by Week 1
- Assign engaged, experienced personnel with:
  - Working knowledge of subject matter
  - Authority to make management decisions
  - Senior position for internal communications
  - Ability to select assumptions and make final decisions
- Responsible for all licensing and consumption costs
- Administer all IT environments (including production)

**KPMG Constraints:**
- Most work performed remotely (onsite as needed)
- Max 8 discovery interviews (majority by week 2)
- Max 30 artifact documents assessed
- English is official language
- 3-day turnaround for deliverable feedback
- Not responsible for third-party software/hardware performance
- Not responsible for data cleansing activities
- Will not act as Lereta management or employee
- Deliverables for internal use only, not suitable for third parties

### RACI Matrices

**Phase 1 Key Activities:**
- KPMG = Responsible for most assessment, design, and roadmap activities
- Lereta = Accountable/Approver
- Lereta = Responsible for IT environment administration
- Lereta = Responsible for identifying stakeholders and providing artifacts

**Phase 2 Key Activities:**
- KPMG = Responsible for data profiling, CDE development, DQ rules, Snowflake implementation
- Lereta = Accountable/Approver for strategic decisions
- Lereta = Consulted on environment provisioning and GenAI activation
- Lereta = Responsible for IT environment administration and strategic use case approval

---

## **What We Don't Know Yet:**

### Technical Unknowns
1. **Warehouse sizing strategy** - Ryan needs to deliver by Monday with his "buckets" approach
2. **Exact warehouse breakdown** - Which workloads go into which compute clusters
3. **Index vs. data breakdown** - Brad needs to provide this for accurate sizing
4. **Mainframe extraction solution** - SQL Gateway to cloud storage via Iceberg tables needs testing
5. **POC use cases** - KPMG will identify 2 in Phase 1, unknown what they'll be
6. **Exact data in scope for migration** - They know it's <20% of total data, need to identify which
7. **OpenFlow testing timeline** - When they'll validate CDC capabilities

### Business Unknowns
8. ~~**Final contract terms**~~ - ✅ **NOW KNOWN:** $1.02M, 20-22 weeks, Dec 1 start
9. **Multi-year Snowflake commitment length** - 1, 2, or 3 years? (Separate from KPMG contract)
10. **Total Snowflake compute budget** - Storage is clear, compute spend unknown
11. **Training headcount** - "~15" but need exact number for fundamentals class
12. **Phase 3 scope** - What gets deferred after Phase 2 and when it comes back
13. **Out-of-scope items** - What KPMG won't handle that might need additional support
14. **Pilot use case selection** - Which 1-2 use cases will KPMG prioritize in Phase 1?
15. **Atacama-KPMG coordination** - How will KPMG work with Atacama PS team?

### Competitive/Risk Unknowns
16. **Board's vendor preferences** - They brought KPMG and others; are there other "board vendors" waiting?
17. **Microsoft relationship status** - How much Microsoft resistance exists?
18. **Databricks consideration** - Was it formally evaluated and rejected, or never considered?
19. **Internal resistance points** - Who might push back on changes (report decommissioning, etc.)?

---

## **Strategic Considerations from KPMG Proposal:**

### Critical Success Factors

**1. Resource Availability is Key**
- ⚠️ **RISK:** "Timely execution directly dependent on availability and responsiveness of Lereta resources"
- **IMPLICATION:** Lereta team availability affects KPMG fees - delays cost money
- **ACTION:** Ensure Ryan, Robert, Jimmy, and key stakeholders are protected from other commitments

**2. Tight Timelines for Deliverables**
- ⚠️ **CONSTRAINT:** 3-day turnaround for feedback or deliverables considered final
- **IMPLICATION:** Lereta must review quickly or lose ability to refine
- **ACTION:** Pre-schedule review sessions, dedicate time for deliverable review

**3. Limited Discovery Window**
- ⚠️ **CONSTRAINT:** Max 8 discovery interviews, majority by Week 2
- **IMPLICATION:** Must identify right people quickly and get them scheduled
- **ACTION:** Suzanne needs to line up stakeholders NOW (before Dec 1)

**4. Artifact Limit**
- ⚠️ **CONSTRAINT:** Max 30 documents reviewed, due by Week 1
- **IMPLICATION:** Must prioritize which artifacts matter most
- **ACTION:** Ryan to curate list of 30 most critical documents immediately

**5. Phase 2 Scope Uncertainty**
- ⚠️ **RISK:** Phase 2 scope "to be finalized during Phase 1"
- **IMPLICATION:** Could be 14 weeks ($630K) or 16 weeks ($720K)
- **ACTION:** Influence pilot use case selection to control scope/cost

### Snowflake Opportunities in Proposal

**1. GenAI Activation is In Scope**
- ✅ Phase 2 includes "Activate GenAI on consumption layer using Cortex Analyst, Copilot"
- **OPPORTUNITY:** Perfect chance to showcase Snowflake Intelligence early
- **ACTION:** Coordinate with KPMG on Tax Companion document analysis use case

**2. Snowflake Architect Provided Free**
- ✅ 100% FTE Snowflake Data Architect for entire engagement ($48K KPMG investment)
- **OPPORTUNITY:** Ensure this is a true Snowflake-aligned architect
- **ACTION:** Sandy to connect with KPMG architect, ensure they're using native patterns

**3. Data Products are Explicit Deliverable**
- ✅ "Implement data cleansing, metadata enrichment, and activate data products"
- **OPPORTUNITY:** Frame pilot around revenue-generating data product
- **ACTION:** Guide use case selection toward client-facing or monetizable output

**4. Cross-Account Access Setup**
- ✅ "Setup cross account access" in Phase 2 scope
- **OPPORTUNITY:** Enable data sharing with clients early
- **ACTION:** Position this for the 20-25 external customer reporting transformation

### Red Flags to Monitor

**1. KPMG Offshore Team Expansion**
- ⚠️ Phase 2 adds 3 new offshore resources (Data Eng Mgr, Data Analyst, Data Engineer)
- **RISK:** Quality control, communication barriers, knowledge transfer
- **MITIGATION:** Sandy's RSA must be deeply embedded to ensure quality

**2. Reduced KPMG Leadership in Phase 2**
- ⚠️ Engagement Lead drops from 35% to 10%, Snowflake Lead drops from 35% to 10%
- **RISK:** Less senior oversight when actual implementation happens
- **MITIGATION:** Snowflake team must increase presence in Phase 2, not decrease

**3. "Not Responsible for Data Cleansing"**
- ⚠️ "KPMG is not responsible for any data cleansing activities"
- **RISK:** Data quality issues could derail migration
- **MITIGATION:** Atacama integration must catch issues early, not during migration

**4. No Third-Party Software Responsibility**
- ⚠️ "KPMG will have no responsibility for performance of any 3rd party software"
- **RISK:** If Snowflake performance issues arise, KPMG may point fingers
- **MITIGATION:** This is where our RSA earns their keep - be the technical authority

**5. Deliverables "Not Suitable for Third Parties"**
- ⚠️ Deliverables are "for internal use of Lereta"
- **RISK:** Can't use KPMG deliverables in board presentations or investor pitches
- **MITIGATION:** Snowflake needs to provide complementary materials that ARE shareable

### Value Capture Opportunities

**1. Influence Pilot Use Case Selection**
- **GOAL:** Drive toward cases that show board-visible value
- **CANDIDATES:**
  - Client SLA reporting (20-25 customers, immediate revenue protection)
  - Tax Companion document analysis (GenAI showcase, efficiency gain)
  - CoreLogic competitive feature (revenue generation angle)

**2. Maximize $118K KPMG Investment**
- **GOAL:** Ensure Snowflake Architect is truly delivering Snowflake-first approach
- **ACTION:** Weekly sync between KPMG architect, Sandy's RSA, and Stephen

**3. Position for Phase 3**
- **GOAL:** Create momentum for continuation beyond Phase 2
- **ACTION:** Identify "Phase 3 scope" items that Snowflake can solve without KPMG

**4. Training Transition**
- **GOAL:** Move from KPMG enablement to Snowflake training
- **ACTION:** Phase 2 Week 14-16 is perfect time to deliver Snowflake Fundamentals class

---

## **Hypothesis / Plan of Attack:**

### Phase 0 (Now - Early December): **Foundation Setting**
**Hypothesis:** They're committed to Snowflake but need confidence in sizing/cost before contract signing.

**Actions:**
1. **Get Ryan's warehouse sizing by Monday** - Review and provide feedback quickly
2. **Run mainframe extraction POC** - Prove SQL Gateway → Cloud Storage → Snowflake path works
3. **Finalize MSA/contract** - Work with Tom to structure multi-year deal with rollover credits
4. **Set up initial instance** - Even before final contract, get them hands-on
5. **OpenFlow demo** - Show the CDC capabilities that will replace SSIS

### Phase 1 (Dec 2025 - Jan 2026): **Be the Technical Backstop**
**Hypothesis:** KPMG will focus on assessment and POCs; Snowflake needs to ensure technical excellence and prevent anti-patterns.

**Actions:**
1. **RSA embedded with KPMG** - Sandy's team ensures native Snowflake approach (no Spark)
2. **Migration specialist for 6 weeks** - Accelerate patterns that KPMG might not know
3. **Weekly stakeholder meetings** - Ryan, Mitch, Suzanne, Katie + Tom + Stephen
4. **POC selection influence** - Guide toward high-value, demonstrable wins (not just lift-and-shift)
5. **Atacama integration planning** - Ensure governance strategy aligns with Snowflake features

### Phase 2 (Jan - July 2026): **Execution Excellence & Expansion**
**Hypothesis:** Success in Phase 2 will create momentum for Phase 3 and additional use cases.

**Actions:**
1. **Quick wins visible to board** - Cost savings, performance improvements, new capabilities
2. **Client reporting transformation** - Move 20-25 external customers to Power BI/Snowflake Intelligence
3. **Data product pilot** - Help create first revenue-generating data product to compete with CoreLogic
4. **Training delivery** - 15 person fundamentals class, position for certifications
5. **CDE implementation** - Make Agency/Customer/Loan domains exemplary

### Ongoing: **Become Indispensable**
**Hypothesis:** Consistent presence, responsiveness, and value delivery will make Snowflake the partner of choice for all data initiatives.

**Actions:**
1. **Monthly consumption reviews** - Proactive cost management shows we're partners, not vendors
2. **Innovation showcases** - Cortex AI on Tax Companion documents, Zendesk transcription, etc.
3. **Executive briefings** - Keep Mitch/Suzanne excited about what's possible
4. **Community connection** - Snowflake user groups, Summit invites, peer connections

---

## **How to Box Out Competition:**

### Primary Threat: **Microsoft/Databricks**
**Their Play:** "You're already in Azure, why add another platform? Use Databricks + ADF."

**Our Counter:**
1. ✅ **Simplicity already resonated** - They're at "maximum complexity" and want reduction
2. ✅ **Spark explicitly rejected** - Ryan wants native Snowflake, not another complex layer
3. ✅ **Cost transparency** - Microsoft billing opacity already frustrates them
4. ✅ **Speed to value** - "3 months vs. 18 months" story landed well
5. ✅ **OpenFlow vs. ADF** - Show clean CDC without ADF complexity

**Action:** Keep reinforcing "native Snowflake" benefits and simplicity narrative

### Secondary Threat: **Status Quo / Delay**
**Their Play:** Internal resistance: "Let's wait until mainframe migration is done" or "Not ready for this change"

**Our Counter:**
1. ✅ **PE ownership creates urgency** - This isn't optional, it's required for sale
2. ✅ **KPMG already contracted** - Decision is made, train has left the station
3. ✅ **Atacama starting in 3 weeks** - Governance work requires target platform
4. ✅ **SSRS/SSAS deprecated** - Staying put isn't an option

**Action:** Maintain momentum, celebrate milestones, show progress constantly

### Tertiary Threat: **Wrong Patterns / Failure**
**Their Play:** Poor implementation leads to cost overruns, performance issues, finger-pointing

**Our Counter:**
1. **RSA embedded early** - Prevent anti-patterns before they're built
2. **Migration specialist** - Ensure KPMG uses Snowflake-optimized approaches
3. **Weekly reviews** - Catch issues early
4. **Reference architectures** - Real estate/title industry examples
5. **Tom + Stephen accessibility** - "No abandonment issues" promise kept

**Action:** Over-communicate, over-deliver, be the technical authority

---

## **How Can We Support:**

### Immediate (Next 2 Weeks)
1. **Review Ryan's warehouse sizing** (due Monday) - Stephen to provide feedback
2. **Mainframe extraction POC** - Technical resource to test SQL Gateway → Cloud → Snowflake
3. **Contract finalization** - Tom to work pricing scenarios (1yr, 2yr, 3yr options)
4. **KPMG coordination** - Sandy to connect with their team, share migration patterns
5. **OpenFlow demo/trial** - Get them hands-on quickly

### Phase 1 Support (Dec - Jan)
1. **RSA on-site** - Sandy's team embedded with KPMG and Lereta team
2. **Migration specialist** - 6-week engagement
3. **Weekly check-ins** - Tom + Stephen + Sandy rotation
4. **POC technical guidance** - Help KPMG select and execute winning POCs
5. **Cost modeling tool** - Share the tool Stephen mentioned for consumption projection

### Phase 2 Support (Jan - July)
1. **Training delivery** - Fundamentals class for 15 people
2. **Cortex AI use cases** - Tax Companion document analysis, Zendesk transcription demos
3. **Client reporting templates** - Power BI embedded patterns for external customers
4. **Performance optimization** - Warehouse sizing adjustments as workloads stabilize
5. **Executive briefings** - Quarterly updates to Mitch/Suzanne on innovation opportunities

### Ongoing Support
1. **Monthly consumption reviews** - Proactive anomaly detection and optimization
2. **Quarterly business reviews** - Strategic planning with leadership
3. **Innovation workshops** - Data product ideation, ML use cases
4. **Community engagement** - Summit invitations, user group participation
5. **Peer connections** - Intro to other real estate/title companies using Snowflake

---

## **Who/What Do You Need to Support the Pursuit:**

### Internal Snowflake Resources

**1. Solution Architecture (Critical)**
- **Sandy's RSA** - Embedded for 6+ months, starting Phase 1
- **Migration Specialist** - 6 weeks in Phase 1
- **Industry SA** - Real estate/title reference architectures and peer connections
- **Timeline:** Immediate

**2. Sales (Critical)**
- **Tom (Account Exec)** - Maintain weekly cadence, stakeholder management
- **Stephen (Solution Architect)** - Technical advisor, warehouse sizing review, POC guidance
- **Timeline:** Immediate and ongoing

**3. Professional Services (High Priority)**
- **Training team** - Fundamentals class (15 people), tentatively early 2026
- **Certification support** - Post-training path
- **Timeline:** Q1 2026

**4. Product/Engineering (Medium Priority)**
- **OpenFlow specialist** - Demo and early access if needed
- **Cortex AI specialist** - Document analysis and transcription use cases
- **Timeline:** Phase 1 for demos

**5. Customer Success (Medium Priority)**
- **Consumption analyst** - Monthly reviews and anomaly detection
- **QBR coordinator** - Quarterly executive briefings
- **Timeline:** Post-go-live (Phase 2+)

### External Partner Coordination

**6. KPMG Relationship (Critical)**
- **Sandy's connector** - Diane mentioned, needs to coordinate
- **Joint planning sessions** - Ensure alignment on approach
- **Pattern sharing** - Snowflake best practices and accelerators
- **Timeline:** Immediate (before Dec kickoff)

**7. Atacama Relationship (Medium Priority)**
- **Integration specialist** - Ensure Snowflake + Atacama work seamlessly
- **Joint use case** - POC that demonstrates governance + platform
- **Timeline:** Phase 1 (they're training now, live in 3 weeks)

### Materials & Collateral

**8. Reference Materials (High Priority)**
- Real estate/title industry case studies
- CoreLogic competitive intelligence
- Cost comparison tools (Snowflake vs. Databricks)
- Migration pattern library
- **Timeline:** Immediate

**9. Demo Environments (Medium Priority)**
- Pre-built Snowflake Intelligence agent example
- Cortex AI document analysis demo
- Power BI embedded template for client reporting
- **Timeline:** Phase 1

### Executive Sponsorship

**10. Snowflake Leadership (Nice to Have)**
- Executive sponsor for Mitch (CTO) - CTO-to-CTO conversation
- Product roadmap briefing - What's coming that helps their use case
- **Timeline:** Phase 1 or after first POC success

---

## **Summary - Critical Next Steps:**

### **IMMEDIATE (Before Dec 1 Kickoff):**
1. ✅ Review Ryan's warehouse sizing proposal
2. ✅ **URGENT:** Suzanne to identify 8 stakeholders for KPMG interviews (need majority by Week 2)
3. ✅ **URGENT:** Ryan to curate 30 critical documents for KPMG review (due Week 1)
4. ✅ Connect Sandy's team with KPMG Snowflake Architect + Gary Torpey
5. ✅ Finalize Snowflake MSA/contract (separate from KPMG)
6. ✅ Set up initial Snowflake instance for hands-on access
7. ✅ OpenFlow demo for Ryan's team
8. ✅ RSA confirmed and scheduled for Dec 1 start

### **Phase 1: Weeks 1-6 (Dec 1 - Mid-January):**
- ✅ **Week 1:** KPMG kickoff, artifacts delivered, interviews scheduled
- ✅ **Week 2:** Complete majority of 8 discovery interviews
- ✅ **Week 3:** $150K milestone payment, current state assessment complete
- ✅ **Weeks 4-5:** Design and roadmap development
- ✅ **Week 6:** $150K milestone payment, all Phase 1 deliverables complete
- ✅ **Snowflake Actions:**
  - Weekly sync: KPMG architect + Sandy's RSA + Stephen
  - Migration specialist engaged (6 weeks)
  - Influence pilot use case selection (Target: Client reporting or Tax Companion)
  - Ensure Atacama-KPMG coordination is working

### **Phase 2: Weeks 7-22 (Mid-January - May 2026):**
- ✅ **Weeks 7-10:** Pilot use case data profiling, CDE development
- ✅ **Weeks 11-14:** Snowflake environment build, data migration to Bronze/Silver/Gold
- ✅ **Weeks 15-18:** ETL/ELT pipelines, GenAI activation (Cortex)
- ✅ **Weeks 19-22:** Testing, validation, stakeholder feedback
- ✅ **Monthly:** KPMG invoicing ($45K-50K/week)
- ✅ **Snowflake Actions:**
  - Increase presence as KPMG leadership decreases
  - Deliver Snowflake Fundamentals training (Week 14-16 ideal)
  - Position Phase 3 scope items
  - Showcase quick wins to Mitch/Suzanne/Board

### **Post-Phase 2 (June 2026+):**
- ✅ Transition from KPMG enablement to Snowflake-led expansion
- ✅ Identify Phase 3 scope (items deferred from Phase 2)
- ✅ Launch additional use cases without KPMG
- ✅ Quarterly business reviews and innovation workshops

---

## **Bottom Line:**

**The deal is won. Now it's about flawless execution and becoming indispensable.**

### Key Success Factors:
- ✅ **Simplicity** - They're drowning in complexity, we're the lifeline
- ✅ **Partnership** - No abandonment issues, always available
- ✅ **Native Snowflake** - No Spark, no ADF, no unnecessary complexity
- ✅ **Quick Wins** - Show value fast to maintain momentum
- ✅ **Innovation** - AI/ML capabilities that CoreLogic doesn't have

### Risk Mitigation:
- 🚨 **KPMG anti-patterns** - RSA embedded to prevent
- 🚨 **Cost overruns** - Monthly reviews and proactive optimization
- 🚨 **Scope creep** - Clear Phase boundaries and deliverables
- 🚨 **Change resistance** - Executive sponsorship and quick wins

---

*Document created: November 13, 2025*  
*Updated with KPMG proposal details: November 13, 2025*  
*Based on meeting transcript: November 5, 2025*

