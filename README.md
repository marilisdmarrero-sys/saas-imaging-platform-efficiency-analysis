# The Hidden Cost of Imaging Fragmentation
## A Workflow and Data Analysis of SaaS Imaging Platform Efficiency in Healthcare

> Based on real clinical operations experience managing imaging and medical records retrieval across multiple SaaS platforms in a health tech environment.

---

## Project Background

This project was not an academic exercise. It was built from direct operational experience retrieving medical records and imaging diagnostics across multiple SaaS imaging platforms — Ambra, PowerShare (Microsoft), LifeImage, and Nucleus — in a health tech environment supporting specialist second opinion consultations.

The central question this project explores is not whether SaaS imaging platforms work — they do. The question is whether healthcare organizations are getting sufficient operational value to justify the cost and complexity of managing multiple vendors, and what happens when platform coverage breaks down.

---

## The Problem

Electronic Health Records exist. Imaging platforms exist. Yet in practice, retrieving imaging diagnostics remains one of the most manually intensive, time-sensitive, and failure-prone steps in the medical records workflow.

The reason is structural. EHRs are not built to store or render DICOM imaging files natively at scale. SaaS imaging platforms fill that gap — but they introduce their own inefficiencies:

- No centralized directory of which facility uses which platform
- Manual discovery process — staff had to call facilities to confirm platform access
- Inconsistent documentation of platform-facility relationships in the EHR
- No fallback automation when a platform was not available

When platform coverage failed, the fallback was physical — FedEx Express shipping of CDs, with no guarantee the facility would use the prepaid label instead of USPS, adding days of uncontrolled delay to an already time-sensitive case.

Cases had a **5-day SLA** — imaging and records were expected within 5 days of case opening to support specialist consultations. This SLA made SaaS platforms not a preference but an operational necessity.

---

## The Workflow

```
Case opened — imaging needed
        ↓
Call imaging department to request diagnostics
        ↓
Confirm which platform the facility uses
        ↓
Check if organization has access to that platform
        ↓
Platform available → digital retrieval → fast
        ↓
Platform NOT available → generate FedEx Express label
        ↓
Ship label to facility → wait → hope they use Express not USPS
        ↓
CD arrives → process → case moves forward
        ↓
OR facility uses USPS → uncontrolled delay → case at risk
```

For cases involving multiple facilities — patients seen at different health systems — this process ran in parallel across each facility, each potentially using a different platform or requiring a CD. One case could simultaneously be in digital retrieval, CD transit, and active follow-up status, making timeline prediction nearly impossible without centralized tracking.

---

## Key Operational Context

**The 5-Day SLA Problem**

The 5-day SLA was achievable for single-facility cases with documented SaaS access. It became increasingly unrealistic as case complexity grew. Multiple facilities, undocumented platforms, or CD-only facilities each added uncontrollable variables that pushed timelines beyond the SLA regardless of operational efficiency.

A more realistic SLA framework would be:

- Single facility + documented SaaS → 5 days reasonable
- Multi-facility or CD-only → 10-15 days more appropriate
- Unknown platform status → discovery call adds minimum 1-2 days before retrieval even begins

---

## Database Design

To quantify these inefficiencies, I designed a relational PostgreSQL database modeling the imaging retrieval workflow with the following tables:

- `cases` — individual patient cases requiring imaging
- `facilities` — medical facilities where imaging was performed, including documented platform and contact information
- `imaging_platforms` — available platforms and their type (SaaS or physical)
- `imaging_requests` — each retrieval request per case per facility, including department contacted and whether platform was known at time of request
- `retrieval_log` — actual retrieval method used, dates, turnaround time, delay reason, and status

A `consultation_date` field was added to `cases` mid-project after recognizing the original model could measure turnaround time but not patient impact. See Known Limitations section for full context.

---

## Queries & Findings

---

### Query 1 — SaaS vs CD Turnaround Time

**Business question:** What is the average turnaround time for SaaS retrieval compared to CD retrieval?

**Reasoning:** This is the anchor finding. Everything else in the project builds on this number. If SaaS is meaningfully faster than CD, platform coverage gaps have a quantifiable operational cost.

```sql
SELECT retrieval_method,
ROUND(AVG(date_received - date_requested), 1) AS average_turnaround
FROM retrieval_log
WHERE date_received IS NOT NULL
GROUP BY retrieval_method;
```

**Results:** SaaS platform retrieval averaged **1 day** turnaround while CD retrieval averaged **21 days** — a 20x difference in case processing speed. Given the 5-day consultation SLA, every CD case systematically missed the deadline. This single finding quantifies the operational necessity of SaaS imaging platform access.

---

### Query 2 — Retrieval Method Volume

**Business question:** Which retrieval method is used most frequently — and if SaaS is faster, why is CD still significant?

**Reasoning:** Knowing SaaS is faster doesn't explain why CD is still being used. Volume by method reveals whether platform coverage is sufficient to support the majority of cases.

```sql
SELECT retrieval_method,
COUNT(request_id) AS total_requests
FROM retrieval_log
GROUP BY retrieval_method;
```

**Results:** SaaS retrieval accounted for the majority of requests but by a narrower margin than expected — reflecting incomplete platform coverage across facilities. With only 6 of 10 facilities having documented SaaS platform access, CD retrieval remained a significant operational burden. This finding reinforces that the value of SaaS platforms is directly limited by coverage gaps.

---

### Query 3 — Facilities With No Documented Platform

**Business question:** Which facilities had no SaaS platform documented and were therefore forced to CD retrieval?

**Reasoning:** Before assuming undocumented facilities drive all CD volume, the data needs to confirm which facilities had no platform on record. This led directly to Query 4, which tested whether documented platforms were actually being used.

```sql
SELECT facility_name,
CASE WHEN platform_id IS NULL THEN 'No' ELSE 'Yes' END AS saas_documented
FROM facilities
WHERE platform_id IS NULL;
```

**Results:** 4 out of 10 facilities (40%) had no SaaS imaging platform documented in the facility knowledge base. Every imaging request routed to these facilities defaulted to physical CD retrieval — averaging 21 days turnaround compared to 1 day for SaaS. However, undocumented facilities are not the only source of CD volume — documented platforms do not guarantee digital retrieval.

---

### Query 4 — Documentation Failure

**Business question:** Of the facilities with a documented SaaS platform, did any still result in CD retrieval?

**Reasoning:** Platform documentation does not guarantee platform use. A facility could have Ambra documented but still ship a CD due to staff training gaps, expired access, or operational habit. Assuming documented = used would overstate actual SaaS coverage.

```sql
SELECT f.facility_name, p.platform_name, r.retrieval_method
FROM facilities f
JOIN imaging_platforms p ON p.platform_id = f.platform_id
JOIN imaging_requests i ON i.facility_id = f.facility_id
JOIN retrieval_log r ON r.request_id = i.request_id
WHERE r.retrieval_method = 'CD' AND f.platform_id IS NOT NULL;
```

**Results:** One facility had a SaaS platform documented but still defaulted to CD retrieval. This reveals that platform documentation alone does not guarantee digital retrieval — operational adoption at the facility level is a separate challenge. A documented platform that goes unused provides no turnaround time benefit and creates a false sense of coverage in the knowledge base.

---

### Query 5 — USPS Shipping Failures

**Business question:** Of the CD retrievals, how many were delayed because the facility used USPS instead of FedEx Express?

**Reasoning:** CD retrieval already adds significant delay. When facilities ignored the prepaid FedEx Express label and used USPS instead, that delay became uncontrollable — the operational team had done everything correctly but had no enforcement mechanism.

```sql
SELECT retrieval_method, delay_reason,
COUNT(request_id) AS total_delayed_requests
FROM retrieval_log
WHERE retrieval_method = 'CD' AND delay_reason = 'USPS instead of FedEx'
GROUP BY retrieval_method, delay_reason;
```

**Results:** 5 CD retrieval cases were delayed due to facilities using USPS instead of the prepaid FedEx Express label. These cases experienced the longest turnaround times and represent the highest risk to consultation deadlines — delays caused entirely by factors outside operational control.

---

## Known Limitations & Model Extension

While building this analysis a critical gap emerged: turnaround time tells you how long retrieval took — but not whether that delay actually impacted the patient. To answer that, the data model needed to know when the specialist consultation was scheduled.

A `consultation_date` field was added to the `cases` table to capture the 5-day SLA deadline:

```sql
ALTER TABLE cases ADD COLUMN consultation_date DATE;
UPDATE cases SET consultation_date = date_opened + INTERVAL '5 days';
```

This extension enabled the analysis to connect operational delays directly to patient care impact — transforming a workflow analysis into a patient outcome analysis.

Additionally the 5-day SLA itself was identified as a structural limitation. The SLA assumed ideal conditions — single facility, documented platform, responsive staff. Real cases introduced variables outside operational control that made the SLA unrealistic for complex multi-facility cases regardless of retrieval method.

---

### Query 6 — Consultation Deadline Misses

**Business question:** How many cases missed their 5-day consultation deadline because imaging arrived late or never arrived?

**Reasoning:** Turnaround time differences between retrieval methods are meaningless without understanding their direct impact on patient care. The consultation deadline is the operational SLA — if imaging doesn't arrive before the specialist sees the patient, the consultation is compromised.

```sql
SELECT COUNT(*) AS cases_missed_deadline
FROM cases c
JOIN imaging_requests i ON i.case_id = c.case_id
JOIN retrieval_log r ON r.request_id = i.request_id
WHERE r.date_received > c.consultation_date
OR r.date_received IS NULL;
```

> **Analytical note:** Initial approach attempted to combine COUNT, CASE WHEN, and GROUP BY in a single query. Simplified to a direct COUNT with WHERE filter after recognizing the complexity was unnecessary. In analytics, the simplest query that answers the question is always preferable.

**Results:** 15 cases missed their consultation deadline — either receiving imaging after the consultation date or never receiving it at all. This number requires time context to be meaningful, which led to the next query.

---

### Query 7 — Monthly Deadline Miss Trend

**Business question:** How are missed consultation deadlines distributed across months — and is there a trend over time?

**Reasoning:** A total count of missed deadlines without time context is incomplete. Monthly distribution reveals whether performance was stable, improving, or deteriorating — and whether any single period drove disproportionate failures.

```sql
SELECT TO_CHAR(DATE_TRUNC('month', c.date_opened), 'Month YYYY') AS month,
COUNT(*) AS cases_missed_deadline
FROM cases c
JOIN imaging_requests i ON i.case_id = c.case_id
JOIN retrieval_log r ON r.request_id = i.request_id
WHERE r.date_received > c.consultation_date
OR r.date_received IS NULL
GROUP BY DATE_TRUNC('month', c.date_opened)
ORDER BY month ASC;
```

**Results:** Missed deadlines were distributed at 3-5 cases per month across the analysis period. This analysis is based on a synthetic dataset of 30 cases. In actual operations, case volume ran approximately 20 cases per week — roughly 80 per month. At that volume, 3-5 missed deadlines per month represents a **4-6% miss rate**, which falls within acceptable operational thresholds. However the distribution of those misses by retrieval method determines whether the root cause is addressable.

---

### Query 8 — Missed Deadlines by Retrieval Method

**Business question:** Of the cases that missed their consultation deadline, how many were CD retrievals vs SaaS retrievals?

**Reasoning:** If missed deadlines cluster in one retrieval method, the root cause is identifiable and addressable. This is the most important question in the entire analysis.

```sql
SELECT COUNT(c.case_id) AS total_missed,
SUM(CASE WHEN r.retrieval_method = 'CD' THEN 1 ELSE 0 END) AS cd_cases,
SUM(CASE WHEN r.retrieval_method = 'SaaS' THEN 1 ELSE 0 END) AS saas_cases
FROM cases c
JOIN imaging_requests i ON i.case_id = c.case_id
JOIN retrieval_log r ON r.request_id = i.request_id
WHERE r.date_received > c.consultation_date
OR r.date_received IS NULL;
```

**Results:** All 15 missed consultation deadlines were CD retrieval cases. **SaaS retrieval had a 0% deadline miss rate.** Every missed deadline was directly attributable to CD retrieval, which averaged 21 days against a 5-day SLA. This finding makes the operational case for SaaS platform investment unambiguous.

---

## Conclusion

SaaS imaging platforms were not a preference — they were an operational necessity. The data demonstrates this across every dimension analyzed:

- **20x faster turnaround** — 1 day SaaS vs 21 days CD
- **40% of facilities** had no documented platform, forcing CD fallback
- **Documentation is not adoption** — one facility with a documented platform still defaulted to CD
- **Uncontrollable delays** — 5 cases delayed by facilities ignoring FedEx Express labels
- **100% of missed consultation deadlines** were CD cases — SaaS had a perfect record

The recommendation is clear: expanding SaaS platform coverage and ensuring operational adoption at the facility level is the single highest-impact intervention available to reduce imaging retrieval delays and protect consultation deadlines.

---

## Tools Used
- PostgreSQL v15
- DB Fiddle

## Live Database
[View the full schema and queries on DB Fiddle](#)
