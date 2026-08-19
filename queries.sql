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

SELECT status,
       count(*)
FROM tasks
GROUP BY status;

-- ============================================================
-- Q3 Users with the number of tasks assigned to them
-- ============================================================

SELECT users.name,
       COUNT(tasks.id)
FROM users
LEFT JOIN tasks ON tasks.assignee_id = users.id
GROUP BY users.name;

-- ============================================================
-- Q4 All tasks that carry a given tag name
-- ============================================================

SELECT tasks.title,
       tasks.description,
       tasks.due_date,
       tasks.status
FROM tasks
JOIN task_tags ON tasks.id = task_tags.task_id
JOIN tags ON task_tags.tag_id = tags.id
WHERE tags.name = 'urgent';

-- ============================================================
-- Q5 All overdue tasks
-- ============================================================

SELECT tasks.title,
       tasks.due_date,
       tasks.status,
       users.name AS assignee_name
FROM tasks
LEFT JOIN users ON tasks.assignee_id = users.id
WHERE due_date < CURRENT_DATE
    AND status <> 'done';

-- ============================================================
-- Q6 Top 3 users by number of tasks 'done'
-- ============================================================

SELECT users.name,
       COUNT(tasks.id) AS done_task_count
FROM users
JOIN tasks ON tasks.assignee_id = users.id
WHERE tasks.status = 'done'
GROUP BY users.name
ORDER BY COUNT(tasks.id) DESC
LIMIT 3;

-- ============================================================
-- Q7 Projects that have no tasks
-- ============================================================

SELECT projects.id,
       projects.name
FROM projects
WHERE projects.id NOT IN
        (SELECT DISTINCT project_id
         FROM tasks);

-- ============================================================
-- Q8 Average number of tags per task
-- ============================================================

select CAST(COUNT (task_tags.task_id) AS FLOAT) / COUNT (DISTINCT tasks.id) AS average_tags_per_task
FROM tasks
LEFT JOIN task_tags ON tasks.id = task_tags.task_id

-- ============================================================
-- Q9 Number of comments per task
-- ============================================================
select tasks.id AS task_id, COUNT(comments.id) AS comment_count 
FROM tasks
LEFT JOIN comments ON tasks.id = comments.task_id
GROUP BY tasks.id
ORDER BY COUNT(comments.id) DESC;