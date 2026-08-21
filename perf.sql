-- =============================================
-- W1 index on foreign key in tasks table
-- =============================================

CREATE INDEX ON tasks(project_id);

-- =============================================
-- W2 index on status and assigne_id in tasks table
-- =============================================

CREATE INDEX ON tasks(status);


CREATE INDEX ON tasks(assignee_id);


CREATE INDEX ON task_tags(tag_id);

-- =============================================
-- C1 Realistic multi-statement transaction
-- =============================================
 BEGIN;


UPDATE tasks
SET assignee_id = 5
WHERE assignee_id = 4
    AND project_id = 2;


DELETE
FROM project_members
WHERE user_id = 4
    AND project_id = 2;


COMMIT;

-- =============================================
-- C2 Rollback transaction
-- =============================================

SELECT count(*)
FROM tasks
WHERE assignee_id = 5;


SELECT count(*)
FROM project_members
WHERE user_id = 2
    AND project_id = 1;

BEGIN;


UPDATE tasks
SET assignee_id = 5
WHERE assignee_id = 2;


DELETE
FROM project_members
WHERE user_id = 2
    AND project_id = 1;


ROLLBACK;


SELECT count(*)
FROM tasks
WHERE assignee_id = 5;


SELECT count(*)
FROM project_members
WHERE user_id = 2
    AND project_id = 1;

-- =============================================
-- C3 and X2 EXPLAIN ANALYZE
-- =============================================

INSERT INTO tasks (title, description, status, priority, project_id, assignee_id, due_date)
SELECT 'Bulk task ' || g,
       'synthetic load-test row', (ARRAY['todo',
                                         'in_progress',
                                         'done']::task_status[])[1 + floor(random()*3)], 1 + floor(random()*5),
                                                                                         1 + floor(random()*3),
                                                                                         CASE
                                                                                             WHEN random() < 0.9 THEN 1 + floor(random()*6)
                                                                                             ELSE NULL
                                                                                         END,
                                                                                         CURRENT_DATE + (floor(random()*60) - 30) * INTERVAL '1 day'
FROM generate_series(1, 100000) g;


INSERT INTO task_tags (task_id, tag_id)
SELECT id,
       1 + floor(random()*6)
FROM tasks
WHERE id > 15 ON CONFLICT DO NOTHING;

ANALYZE;

-- Pair 1: tasks(assignee_id)

DROP INDEX IF EXISTS tasks_assignee_id_idx;

ANALYZE;

-- BEFORE
EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE assignee_id = 3;


CREATE INDEX tasks_assignee_id_idx ON tasks(assignee_id);

ANALYZE;

-- AFTER
EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE assignee_id = 3;

-- Pair 2: task_tags(tag_id)

DROP INDEX IF EXISTS task_tags_tag_id_idx;

ANALYZE;

-- BEFORE
EXPLAIN ANALYZE
SELECT tasks.*
FROM tasks
JOIN task_tags ON tasks.id = task_tags.task_id
WHERE task_tags.tag_id = 4;


CREATE INDEX task_tags_tag_id_idx ON task_tags(tag_id);

ANALYZE;

-- AFTER
EXPLAIN ANALYZE
SELECT tasks.*
FROM tasks
JOIN task_tags ON tasks.id = task_tags.task_id
WHERE task_tags.tag_id = 4;

-- =============================================
-- X1 Composite Index Before/After EXPLAIN
-- =============================================
 EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE project_id = 1
    AND status = 'todo';

EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE project_id = 1;

EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE status = 'todo';


CREATE INDEX ON tasks(project_id, status);

EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE project_id = 1
    AND status = 'todo';

EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE project_id = 1;

EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE status = 'todo';