-- Insert imaging platforms
INSERT INTO imaging_platforms (platform_name, platform_type) VALUES
('Ambra', 'SaaS'),
('PowerShare', 'SaaS'),
('LifeImage', 'SaaS'),
('Nucleus', 'SaaS'),
('CD', 'physical');

-- Insert facilities
INSERT INTO facilities (facility_name, address, phone_number, medical_records_contact, radiology_contact, platform_id, third_party_portal, last_updated_date, updated_by) VALUES
('Houston Methodist Hospital', '6565 Fannin St, Houston TX', '713-441-0000', 'Jane Doe', 'Dr. Smith', 1, NULL, '2021-11-15', 'Marilis'),
('Memorial Hermann TMC', '6411 Fannin St, Houston TX', '713-704-4000', 'Carlos Ruiz', 'Dr. Patel', 2, NULL, '2021-12-01', 'Sara'),
('St. Luke Health System', '6720 Bertner Ave, Houston TX', '832-355-1000', 'Ana Lopez', 'Dr. Chen', 3, NULL, '2022-01-10', 'Marilis'),
('Texas Medical Center Radiology', '1 Medical Center Blvd, Houston TX', '713-791-1414', 'Tom Harris', 'Dr. Rivera', 4, NULL, '2022-02-14', 'Mike'),
('Kelsey-Seybold Clinic', '2727 W Holcombe Blvd, Houston TX', '713-442-0000', 'Lisa Park', 'Dr. Johnson', 1, NULL, '2022-03-05', 'Sara'),
('CHI St. Luke Baylor', '1 Baylor Plaza, Houston TX', '713-798-4951', 'Maria Torres', 'Dr. Williams', 2, NULL, '2022-01-20', 'Marilis'),
('HCA Houston Healthcare', '2801 S Macgregor Way, Houston TX', '713-566-5000', 'John Lee', NULL, NULL, 'MedRelease Pro', '2022-02-28', 'Mike'),
('UTHealth Houston', '6431 Fannin St, Houston TX', '713-500-0000', 'Sandra Kim', NULL, NULL, 'ChartSwap', '2022-03-15', 'Sara'),
('Baylor St. Luke Medical', '6624 Fannin St, Houston TX', '713-791-2011', NULL, NULL, NULL, NULL, '2021-11-30', 'Marilis'),
('Cypress Fairbanks Medical', '10655 Steepletop Dr, Houston TX', '281-890-4285', NULL, NULL, NULL, NULL, '2022-01-05', 'Mike');

-- Insert cases
INSERT INTO cases (case_number, date_opened, date_assigned, status) VALUES
('2MD-001', '2021-11-01', '2021-11-02', 'completed'),
('2MD-002', '2021-11-03', '2021-11-04', 'completed'),
('2MD-003', '2021-11-08', '2021-11-09', 'completed'),
('2MD-004', '2021-11-10', '2021-11-11', 'completed'),
('2MD-005', '2021-11-15', '2021-11-16', 'completed'),
('2MD-006', '2021-11-17', '2021-11-18', 'completed'),
('2MD-007', '2021-11-22', '2021-11-23', 'completed'),
('2MD-008', '2021-11-24', '2021-11-25', 'completed'),
('2MD-009', '2021-11-29', '2021-11-30', 'completed'),
('2MD-010', '2021-12-01', '2021-12-02', 'completed'),
('2MD-011', '2021-12-06', '2021-12-07', 'completed'),
('2MD-012', '2021-12-08', '2021-12-09', 'completed'),
('2MD-013', '2021-12-13', '2021-12-14', 'completed'),
('2MD-014', '2021-12-15', '2021-12-16', 'completed'),
('2MD-015', '2021-12-20', '2021-12-21', 'completed'),
('2MD-016', '2022-01-03', '2022-01-04', 'completed'),
('2MD-017', '2022-01-05', '2022-01-06', 'completed'),
('2MD-018', '2022-01-10', '2022-01-11', 'completed'),
('2MD-019', '2022-01-12', '2022-01-13', 'delayed'),
('2MD-020', '2022-01-17', '2022-01-18', 'completed'),
('2MD-021', '2022-01-19', '2022-01-20', 'completed'),
('2MD-022', '2022-01-24', '2022-01-25', 'delayed'),
('2MD-023', '2022-01-26', '2022-01-27', 'completed'),
('2MD-024', '2022-01-31', '2022-02-01', 'completed'),
('2MD-025', '2022-02-02', '2022-02-03', 'completed'),
('2MD-026', '2022-02-07', '2022-02-08', 'delayed'),
('2MD-027', '2022-02-09', '2022-02-10', 'completed'),
('2MD-028', '2022-02-14', '2022-02-15', 'completed'),
('2MD-029', '2022-02-16', '2022-02-17', 'delayed'),
('2MD-030', '2022-02-21', '2022-02-22', 'completed');

-- Insert imaging requests
INSERT INTO imaging_requests (case_id, facility_id, department_contacted, request_type, platform_known_at_request) VALUES
(1, 1, 'radiology', 'images', true),
(2, 2, 'radiology', 'images', true),
(3, 3, 'radiology', 'images', true),
(4, 4, 'radiology', 'images', true),
(5, 5, 'radiology', 'images', true),
(6, 6, 'radiology', 'images', true),
(7, 7, 'medical_records', 'report', false),
(8, 8, 'medical_records', 'report', false),
(9, 9, 'both', 'both', false),
(10, 10, 'both', 'both', false),
(11, 1, 'radiology', 'images', true),
(12, 2, 'radiology', 'images', true),
(13, 3, 'radiology', 'images', true),
(14, 9, 'both', 'both', false),
(15, 10, 'both', 'both', false),
(16, 4, 'radiology', 'images', true),
(17, 5, 'radiology', 'images', true),
(18, 6, 'radiology', 'images', true),
(19, 7, 'medical_records', 'report', false),
(20, 8, 'medical_records', 'report', false),
(21, 1, 'radiology', 'images', true),
(22, 9, 'both', 'both', false),
(23, 2, 'radiology', 'images', true),
(24, 10, 'both', 'both', false),
(25, 3, 'radiology', 'images', true),
(26, 9, 'both', 'both', false),
(27, 4, 'radiology', 'images', true),
(28, 5, 'radiology', 'images', true),
(29, 10, 'both', 'both', false),
(30, 6, 'radiology', 'images', true),
-- Multi-facility cases
(13, 7, 'medical_records', 'report', false),
(15, 1, 'radiology', 'images', true),
(19, 3, 'radiology', 'images', true),
(22, 2, 'radiology', 'images', true),
(26, 10, 'both', 'both', false),
(29, 1, 'radiology', 'images', true);

-- Insert retrieval log
INSERT INTO retrieval_log (request_id, retrieval_method, date_requested, date_received, turnaround_days, delay_reason, status) VALUES
(1, 'SaaS', '2021-11-02', '2021-11-03', 1, NULL, 'received'),
(2, 'SaaS', '2021-11-04', '2021-11-05', 1, NULL, 'received'),
(3, 'SaaS', '2021-11-09', '2021-11-10', 1, NULL, 'received'),
(4, 'SaaS', '2021-11-11', '2021-11-12', 1, NULL, 'received'),
(5, 'SaaS', '2021-11-16', '2021-11-17', 1, NULL, 'received'),
(6, 'SaaS', '2021-11-18', '2021-11-19', 1, NULL, 'received'),
(7, 'CD', '2021-11-23', '2021-11-30', 7, NULL, 'received'),
(8, 'CD', '2021-11-25', '2021-12-02', 7, NULL, 'received'),
(9, 'CD', '2021-11-30', '2021-12-10', 10, 'USPS instead of FedEx', 'received'),
(10, 'CD', '2021-12-02', '2021-12-12', 10, 'USPS instead of FedEx', 'received'),
(11, 'SaaS', '2021-12-07', '2021-12-08', 1, NULL, 'received'),
(12, 'SaaS', '2021-12-09', '2021-12-10', 1, NULL, 'received'),
(13, 'SaaS', '2021-12-14', '2021-12-15', 1, NULL, 'received'),
(14, 'CD', '2021-12-16', '2021-12-23', 7, NULL, 'received'),
(15, 'CD', '2021-12-21', '2021-12-31', 10, 'USPS instead of FedEx', 'received'),
(16, 'SaaS', '2022-01-04', '2022-01-05', 1, NULL, 'received'),
(17, 'SaaS', '2022-01-06', '2022-01-07', 1, NULL, 'received'),
(18, 'SaaS', '2022-01-11', '2022-01-12', 1, NULL, 'received'),
(19, 'CD', '2022-01-13', '2022-01-27', 14, 'no response', 'received'),
(20, 'CD', '2022-01-18', '2022-01-25', 7, NULL, 'received'),
(21, 'SaaS', '2022-01-20', '2022-01-21', 1, NULL, 'received'),
(22, 'CD', '2022-01-25', NULL, NULL, 'no response', 'delayed'),
(23, 'SaaS', '2022-01-27', '2022-01-28', 1, NULL, 'received'),
(24, 'CD', '2022-02-01', '2022-02-11', 10, 'USPS instead of FedEx', 'received'),
(25, 'SaaS', '2022-02-03', '2022-02-04', 1, NULL, 'received'),
(26, 'CD', '2022-02-08', NULL, NULL, 'no response', 'delayed'),
(27, 'SaaS', '2022-02-10', '2022-02-11', 1, NULL, 'received'),
(28, 'SaaS', '2022-02-15', '2022-02-16', 1, NULL, 'received'),
(29, 'CD', '2022-02-17', NULL, NULL, 'USPS instead of FedEx', 'delayed'),
(30, 'SaaS', '2022-02-22', '2022-02-23', 1, NULL, 'received'),
(31, 'CD', '2021-12-14', '2021-12-21', 7, NULL, 'received'),
(32, 'SaaS', '2021-12-21', '2021-12-22', 1, NULL, 'received'),
(33, 'CD', '2022-01-13', '2022-01-20', 7, NULL, 'received'),
(34, 'SaaS', '2022-01-25', '2022-01-26', 1, NULL, 'received'),
(35, 'CD', '2022-02-08', NULL, NULL, 'no response', 'delayed'),
(36, 'SaaS', '2022-02-17', '2022-02-18', 1, NULL, 'received');

SELECT retrieval_method,
ROUND(AVG (date_received - date_requested), 1) AS average_turnaround
FROM retrieval_log
WHERE date_received IS NOT NULL
GROUP BY retrieval_method;

SELECT retrieval_method,
COUNT(request_id) AS total_requests
FROM retrieval_log
GROUP BY retrieval_method;

SELECT facility_name,
CASE WHEN platform_id IS NULL THEN 'No' ELSE 'Yes' END
AS saas_documented
FROM facilities
WHERE platform_id IS NULL;

SELECT facility_name, platform_name, retrieval_method
FROM facilities f
JOIN imaging_platforms p ON p.platform_id = f.platform_id
JOIN imaging_requests i ON i.facility_id = f.facility_id
JOIN retrieval_log r ON r.request_id = i.request_id
WHERE r.retrieval_method = 'CD' AND f.platform_id IS NOT NULL;

SELECT retrieval_method, delay_reason,
COUNT(request_id) AS total_delayed_requests
FROM retrieval_log
WHERE retrieval_method = 'CD' AND delay_reason='USPS instead of FedEx'
GROUP BY retrieval_method, delay_reason;

UPDATE cases
SET consultation_date = date_opened + INTERVAL '5 days';

SELECT case_number, date_opened, consultation_date
FROM cases
LIMIT 5;

SELECT COUNT(*) AS cases_missed_deadline
FROM cases c
JOIN imaging_requests i ON i.case_id = c.case_id
JOIN retrieval_log r ON r.request_id = i.request_id
WHERE r.date_received > c.consultation_date
OR r.date_received IS NULL;

SELECT TO_CHAR(DATE_TRUNC('month', c.date_opened), 'Month YYYY') AS month,
COUNT(*) AS cases_missed_deadline
FROM cases c
JOIN imaging_requests i ON i.case_id = c.case_id
JOIN retrieval_log r ON r.request_id = i.request_id
WHERE r.date_received > c.consultation_date
OR r.date_received IS NULL
GROUP BY DATE_TRUNC('month', c.date_opened)
ORDER BY month ASC;

SELECT COUNT(c.case_id) AS cases,
SUM(CASE WHEN r.retrieval_method = 'CD' THEN 1 ELSE 0 END) 
AS cd_cases,
SUM(CASE WHEN r.retrieval_method = 'SaaS' THEN 1 ELSE 0 END) 
AS saas_cases
FROM cases c
JOIN imaging_requests i ON i.case_id = c.case_id
JOIN retrieval_log r ON r.request_id = i.request_id
WHERE r.date_received > c.consultation_date OR r.date_received IS NULL


