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