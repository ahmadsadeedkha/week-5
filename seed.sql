-- Clean existing data to allow clean re-runs
TRUNCATE TABLE comments, task_tags, tags, tasks, project_members, projects, users RESTART IDENTITY CASCADE;

INSERT INTO users (name, email) VALUES
('Alice Smith',   'alice@example.com'),   -- ID 1
('Bob Johnson',   'bob@example.com'),     -- ID 2
('Charlie Brown', 'charlie@example.com'), -- ID 3
('Diana Prince',  'diana@example.com'),   -- ID 4
('Evan Wright',   'evan@example.com'),    -- ID 5
('Fiona Gallagher', 'fiona@example.com'),-- ID 6
('Zayd Khan',     'zayd@example.com');    -- ID 7 (SPECIAL CASE: User with ZERO tasks)

INSERT INTO projects (name, owner_id) VALUES
('Website Redesign', 1),   -- ID 1
('Mobile App V2',    2),   -- ID 2
('Database Migration', 3), -- ID 3
('Empty Project',    1);   -- ID 4 (SPECIAL CASE: Project with ZERO tasks)

INSERT INTO project_members (user_id, project_id, role) VALUES
(1, 1, 'owner'),
(2, 1, 'admin'),
(3, 1, 'member'),
(2, 2, 'owner'),
(4, 2, 'member'),
(5, 2, 'viewer'),
(3, 3, 'owner'),
(6, 3, 'admin');

INSERT INTO tasks (title, description, status, priority, project_id, assignee_id, due_date) VALUES
-- Project 1 tasks
('Design Homepage Wireframe', 'Create Figma mockups for desktop and mobile', 'done', 1, 1, 1, CURRENT_DATE - INTERVAL '10 days'),
('Setup Frontend Framework',  'Initialize Next.js project with Tailwind CSS', 'in_progress', 2, 1, 2, CURRENT_DATE + INTERVAL '5 days'),
('Fix Navigation Bug',        'Mobile menu hamburger click target is off', 'todo', 1, 1, 3, CURRENT_DATE - INTERVAL '3 days'), -- SPECIAL CASE: Overdue (past date & todo)
('Write API Documentation',   'Document REST endpoints for v1 release', 'todo', 4, 1, NULL, CURRENT_DATE + INTERVAL '12 days'),  -- SPECIAL CASE: assignee_id = NULL
('Implement OAuth Login',     'Add Google and GitHub SSO login options', 'in_progress', 2, 1, 2, CURRENT_DATE + INTERVAL '2 days'),

-- Project 2 tasks
('Design DB Schema',          'Draft ER diagram and create migration scripts', 'done', 1, 2, 2, CURRENT_DATE - INTERVAL '15 days'),
('Push Push Notifications',   'Integrate Firebase FCM for mobile alerts', 'todo', 3, 2, 4, CURRENT_DATE - INTERVAL '5 days'),    -- OVERDUE Task 2
('App Store Submission',      'Prepare screenshots and release notes', 'todo', 5, 2, 4, CURRENT_DATE + INTERVAL '20 days'),
('Crashlytics Logging',       'Log unhandled exceptions in production', 'in_progress', 3, 2, 5, CURRENT_DATE + INTERVAL '4 days'),
('Dark Mode Support',         'Add toggle for dark theme support', 'done', 4, 2, 2, CURRENT_DATE - INTERVAL '1 day'),

-- Project 3 tasks
('Postgres Version Upgrade',  'Upgrade DB cluster from v15 to v18', 'in_progress', 1, 3, 3, CURRENT_DATE + INTERVAL '1 day'),
('Index Optimization',        'Add missing foreign key indexes', 'todo', 2, 3, 6, CURRENT_DATE + INTERVAL '6 days'),
('Data Anonymization Script', 'Scrub PII from production dumps for dev', 'done', 3, 3, 3, CURRENT_DATE - INTERVAL '8 days'),
('Backup Validation',         'Test automated nightly restores', 'todo', 1, 3, 6, CURRENT_DATE - INTERVAL '1 day'),             -- OVERDUE Task 3
('Query Performance Audit',   'Analyze slow query logs using EXPLAIN ANALYZE', 'in_progress', 2, 3, 3, CURRENT_DATE + INTERVAL '7 days');

INSERT INTO tags (name) VALUES
('frontend'),   -- ID 1
('backend'),    -- ID 2
('bug'),        -- ID 3
('urgent'),     -- ID 4
('documentation'), -- ID 5
('design');     -- ID 6

INSERT INTO task_tags (task_id, tag_id) VALUES
(1, 1), (1, 6),
(2, 1), (2, 2),
(3, 1), (3, 3), (3, 4),
(4, 5),
(5, 2), (5, 4),
(6, 2), (6, 6),
(7, 2), (7, 3),
(8, 5),
(9, 2), (9, 3),
(11, 2), (11, 4),
(12, 2);

INSERT INTO comments (task_id, author_id, body) VALUES
(1, 1, 'Wireframes are ready for review on Figma.'),
(1, 2, 'Looks great! Approved to start frontend build.'),
(3, 3, 'I am looking into the navigation issue now.'),
(3, 1, 'Please prioritize this as it affects mobile users.'),
(5, 2, 'GitHub SSO is working locally, setting up Google credentials next.'),
(6, 2, 'Database schema approved by team.'),
(7, 4, 'Waiting for FCM key permissions from devops.'),
(11, 3, 'Maintenance window scheduled for tonight.'),
(13, 6, 'Script tested against staging DB successfully.'),
(14, 3, 'Backup restore failed on test cluster - investigating.');