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