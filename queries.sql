-- ============================================================
-- Q1 All tasks for one project, ordered by due_date ascending, with NULL due dates last.
-- ============================================================
SELECT * 
FROM tasks 
WHERE tasks.project_id = 1
ORDER BY due_date ASC NULLS LAST;

-- ============================================================
-- Q2 The number of tasks in each status
-- ============================================================
SELECT status, count(*) 
FROM tasks 
GROUP BY status;

-- ============================================================
-- Q3 Users with the number of tasks assigned to them
-- ============================================================
SELECT users.name, COUNT(tasks.id)
FROM users LEFT JOIN tasks ON tasks.assignee_id = users.id
GROUP BY users.id;
