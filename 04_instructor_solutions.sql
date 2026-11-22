-- INSTRUCTOR ONLY: Diagnostic solutions
-- Q1
SELECT * FROM dgpc.interventions WHERE started_at >= '2026-02-01' AND started_at < '2026-03-01' ORDER BY started_at DESC;
-- Q2 / Q3
SELECT u.unit_name, COUNT(i.intervention_id) AS intervention_count FROM dgpc.units u LEFT JOIN dgpc.interventions i ON i.unit_id=u.unit_id GROUP BY u.unit_id,u.unit_name ORDER BY intervention_count DESC;
-- Day 1 solutions
-- A1
SELECT intervention_id,started_at,status FROM dgpc.interventions ORDER BY started_at DESC LIMIT 10;
-- A2
SELECT * FROM dgpc.interventions WHERE response_minutes > 20;
-- A3
SELECT status,COUNT(*) FROM dgpc.interventions GROUP BY status;
-- B1
SELECT i.intervention_id,u.unit_name,t.type_name,i.started_at FROM dgpc.interventions i JOIN dgpc.units u ON u.unit_id=i.unit_id JOIN dgpc.intervention_types t ON t.type_id=i.type_id;
-- B2: same as diagnostic Q2
-- B3
SELECT t.type_name,ROUND(AVG(i.response_minutes),2) AS avg_response FROM dgpc.intervention_types t LEFT JOIN dgpc.interventions i ON i.type_id=t.type_id GROUP BY t.type_id,t.type_name;
-- C1
SELECT u.unit_name,COUNT(i.intervention_id) n FROM dgpc.units u JOIN dgpc.interventions i ON i.unit_id=u.unit_id GROUP BY u.unit_id,u.unit_name HAVING COUNT(i.intervention_id)>80;
-- C2
SELECT date_trunc('month',started_at) month,COUNT(*) n FROM dgpc.interventions GROUP BY 1 ORDER BY n DESC,month LIMIT 1;
-- C3: Count DISTINCT intervention id when joining multiple one-to-many tables
SELECT COUNT(DISTINCT i.intervention_id) AS interventions_count FROM dgpc.interventions i LEFT JOIN dgpc.intervention_agents ia ON ia.intervention_id=i.intervention_id LEFT JOIN dgpc.intervention_vehicles iv ON iv.intervention_id=i.intervention_id;
