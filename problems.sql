-- matches least count condition for all tables
SELECT 'users' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'projects', COUNT(*) FROM projects
UNION ALL
SELECT 'project_members', COUNT(*) FROM project_members
UNION ALL
SELECT 'tasks', COUNT(*) FROM tasks
UNION ALL
SELECT 'tags', COUNT(*) FROM tags
UNION ALL
SELECT 'task_tags', COUNT(*) FROM task_tags
UNION ALL
SELECT 'comments', COUNT(*) FROM comments;

-- Insertion Checks
INSERT INTO tasks (title, status, project_id) VALUES ('Test Task', 'blocked', 1);
INSERT INTO tasks (title, priority, project_id) VALUES ('Test Task', 9, 1);
INSERT INTO users (name, email) VALUES ('Ferguson', 'Alice@example.com');
INSERT INTO project_members (user_id, project_id, role) VALUES (1, 1, 'boss');


-- Deleting a project removes its tasks and memberships (cascade verification).
-- 1. Check tasks and members before deletion
SELECT COUNT(*) FROM tasks WHERE project_id = 1;
SELECT COUNT(*) FROM project_members WHERE project_id = 1;

-- 2. Delete project 1
DELETE FROM projects WHERE id = 1;

-- 3. Verify tasks and memberships were automatically deleted (should return 0)
SELECT COUNT(*) FROM tasks WHERE project_id = 1;
SELECT COUNT(*) FROM project_members WHERE project_id = 1;