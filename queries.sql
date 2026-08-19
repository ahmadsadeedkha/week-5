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

SELECT users.id,
       users.name,
       COUNT(tasks.id)
FROM users
LEFT JOIN tasks ON tasks.assignee_id = users.id
GROUP BY users.id,
         users.name;

-- ============================================================
-- Q4 All tasks that carry a given tag name
-- ============================================================

SELECT tasks.*
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

SELECT users.id,
       users.name,
       COUNT(tasks.id) AS done_task_count
FROM users
JOIN tasks ON tasks.assignee_id = users.id
WHERE tasks.status = 'done'
GROUP BY users.id,
         users.name
ORDER BY done_task_count DESC
LIMIT 3;

-- ============================================================
-- Q7 Projects that have no tasks
-- ============================================================

SELECT projects.*
FROM projects
WHERE NOT EXISTS
        (SELECT 1
         FROM tasks
         WHERE tasks.project_id = projects.id);

-- ============================================================
-- Q8 Average number of tags per task
-- ============================================================

SELECT CAST(COUNT (task_tags.task_id) AS FLOAT) / COUNT (DISTINCT tasks.id) AS average_tags_per_task
FROM tasks
LEFT JOIN task_tags ON tasks.id = task_tags.task_id;

-- ============================================================
-- Q9 Number of comments per task
-- ============================================================

SELECT tasks.id AS task_id,
       COUNT(comments.id) AS comment_count
FROM tasks
LEFT JOIN comments ON tasks.id = comments.task_id
GROUP BY tasks.id
ORDER BY COUNT(comments.id) DESC;

-- ============================================================
-- Q10 Project with its members and their roles
-- ============================================================

SELECT projects.id AS project_id,
       projects.name AS project_name,
       users.name AS member_name,
       project_members.role
FROM projects
LEFT JOIN project_members ON project_members.project_id = projects.id
LEFT JOIN users ON project_members.user_id = users.id
ORDER BY projects.id;

-- ============================================================
-- X1 updated Q6
-- ============================================================
 WITH ranked_users AS
    (SELECT users.name,
            COUNT(tasks.id) AS done_task_count,
            RANK() OVER (
                         ORDER BY COUNT(tasks.id) DESC) AS user_Rank
     FROM users
     JOIN tasks ON tasks.assignee_id = users.id
     WHERE tasks.status = 'done'
     GROUP BY users.id,
              users.name)
SELECT name,
       done_task_count
FROM ranked_users
WHERE user_Rank <= 3;

-- ============================================================
-- X2 updated Q10
-- ============================================================

SELECT projects.id AS project_id,
       projects.name AS project_name,
       COUNT(*) FILTER (
                        WHERE project_members.role = 'owner') AS owners,
       COUNT(*) FILTER (
                        WHERE project_members.role = 'admin') AS admins,
       COUNT(*) FILTER (
                        WHERE project_members.role = 'member') AS members,
       COUNT(*) FILTER (
                        WHERE project_members.role = 'viewer') AS viewers
FROM projects
LEFT JOIN project_members ON projects.id = project_members.project_id
GROUP BY projects.id,
         projects.name
ORDER BY projects.id;