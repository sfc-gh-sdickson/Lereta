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
8. **Final contract terms** - MSA in progress, not finalized
9. **Multi-year commitment length** - 1, 2, or 3 years?
10. **Total compute budget** - Storage is clear, compute spend unknown
11. **Training headcount** - "~15" but need exact number for fundamentals class
12. **Phase 3 scope** - What gets deferred and when it comes back
13. **Out-of-scope items** - What KPMG won't handle that might need additional support

### Competitive/Risk Unknowns
14. **Board's vendor preferences** - They brought KPMG and others; are there other "board vendors" waiting?
15. **Microsoft relationship status** - How much Microsoft resistance exists?
16. **Databricks consideration** - Was it formally evaluated and rejected, or never considered?
17. **Internal resistance points** - Who might push back on changes (report decommissioning, etc.)?

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

### **This Week:**
1. ✅ Review Ryan's warehouse sizing proposal (Monday deadline)
2. ✅ Connect Sandy's team with KPMG (Diane)
3. ✅ Finalize MSA/contract options (Tom + legal)

### **Before Dec Kickoff:**
4. ✅ Set up initial Snowflake instance for hands-on access
5. ✅ OpenFlow demo/trial
6. ✅ Mainframe extraction POC planning
7. ✅ RSA confirmed and scheduled

### **Phase 1 (Dec-Jan):**
8. ✅ Weekly stakeholder meetings established
9. ✅ Migration specialist embedded with KPMG
10. ✅ POC technical guidance and success criteria defined

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
*Based on meeting transcript: November 5, 2025*

