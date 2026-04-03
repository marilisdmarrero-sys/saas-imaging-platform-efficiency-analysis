-- Imaging platforms reference table
CREATE TABLE imaging_platforms (
  platform_id SERIAL PRIMARY KEY,
  platform_name VARCHAR(100), -- Ambra, PowerShare, LifeImage, Nucleus, CD
  platform_type VARCHAR(50)   -- SaaS, physical
);

-- Facility knowledge base
CREATE TABLE facilities (
  facility_id SERIAL PRIMARY KEY,
  facility_name VARCHAR(150),
  address VARCHAR(200),
  phone_number VARCHAR(20),
  medical_records_contact VARCHAR(100),
  radiology_contact VARCHAR(100),
  platform_id INT REFERENCES imaging_platforms(platform_id),
  third_party_portal VARCHAR(100),
  last_updated_date DATE,
  updated_by VARCHAR(100)
);

-- Cases
CREATE TABLE cases (
  case_id SERIAL PRIMARY KEY,
  case_number VARCHAR(50),
  date_opened DATE,
  date_assigned DATE,
  status VARCHAR(50) -- active, completed, delayed, closed
);

-- Imaging requests per case per facility
CREATE TABLE imaging_requests (
  request_id SERIAL PRIMARY KEY,
  case_id INT REFERENCES cases(case_id),
  facility_id INT REFERENCES facilities(facility_id),
  department_contacted VARCHAR(50), -- medical_records, radiology, both
  request_type VARCHAR(50),         -- report, images, both
  platform_known_at_request BOOLEAN -- was platform already in facility database?
);

-- Retrieval log
CREATE TABLE retrieval_log (
  log_id SERIAL PRIMARY KEY,
  request_id INT REFERENCES imaging_requests(request_id),
  retrieval_method VARCHAR(50),  -- SaaS, CD
  date_requested DATE,
  date_received DATE,
  turnaround_days INT,           -- calculated from dates
  delay_reason VARCHAR(200),     -- wrong label, USPS, no response, etc.
  status VARCHAR(50)             -- received, pending, delayed, failed
);

ALTER TABLE cases ADD COLUMN consultation_date DATE;
