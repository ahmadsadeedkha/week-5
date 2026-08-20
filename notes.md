## W1 — Index on tasks(project_id)

Postgres does not automatically index a foreign key column, it only indexes the columns on the referenced side (the primary key). project_id on tasks is a plain column with a FK constraint, so without this index every lookup by project has to scan the whole tasks table.

This serves Q1 ("all tasks for one project"), which filters directly on tasks.project_id = :id. It also helps Q7 ("projects with no tasks"), since its NOT EXISTS subquery filters tasks.project_id = projects.id once per project row.

Note: on the current seed data (15 rows total), EXPLAIN still shows a Seq Scan even with the index in place, the planner correctly judges that scanning 15 rows is cheaper than an index lookup at this size. The index matters once tasks grows large enough that a full scan actually costs more than an index scan; the seed is just too small to demonstrate that difference visually.
