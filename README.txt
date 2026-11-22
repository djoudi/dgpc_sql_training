DGPC SQL/PostgreSQL training - synthetic lab dataset
1. Install PostgreSQL and create a dedicated empty database dgpc_training (e.g. createdb -U postgres dgpc_training).
2. Run: psql -U postgres -d dgpc_training -v ON_ERROR_STOP=1 -f 01_setup.sql
3. In pgAdmin, connect to dgpc_training and query tables with schema prefix dgpc.
4. Give learners 02_diagnostic.sql and 03_day1_exercises.sql; keep 04_instructor_solutions.sql private.
5. Never run 01_setup.sql in production: it DROPS training schema tables.
6. Dataset is entirely synthetic, not operational DGPC data.
