-- DGPC training: synthetic data only. Run in a dedicated training database.
BEGIN;
CREATE SCHEMA IF NOT EXISTS dgpc;
SET search_path TO dgpc;
DROP TABLE IF EXISTS intervention_vehicles, intervention_agents, interventions, vehicles, agents, intervention_types, units CASCADE;
CREATE TABLE units (unit_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY, unit_name text NOT NULL UNIQUE, wilaya text NOT NULL);
CREATE TABLE agents (agent_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY, full_name text NOT NULL, unit_id integer NOT NULL REFERENCES units(unit_id), grade text NOT NULL);
CREATE TABLE intervention_types (type_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY, type_name text NOT NULL UNIQUE);
CREATE TABLE vehicles (vehicle_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY, code text NOT NULL UNIQUE, unit_id integer NOT NULL REFERENCES units(unit_id), category text NOT NULL);
CREATE TABLE interventions (intervention_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY, unit_id integer NOT NULL REFERENCES units(unit_id), type_id integer NOT NULL REFERENCES intervention_types(type_id), started_at timestamp NOT NULL, ended_at timestamp, response_minutes integer CHECK(response_minutes >= 0), status text NOT NULL CHECK(status IN ('closed','ongoing')), CHECK(ended_at IS NULL OR ended_at >= started_at));
CREATE TABLE intervention_agents (intervention_id integer REFERENCES interventions(intervention_id), agent_id integer REFERENCES agents(agent_id), PRIMARY KEY(intervention_id,agent_id));
CREATE TABLE intervention_vehicles (intervention_id integer REFERENCES interventions(intervention_id), vehicle_id integer REFERENCES vehicles(vehicle_id), PRIMARY KEY(intervention_id,vehicle_id));
INSERT INTO units(unit_name,wilaya) VALUES ('Unité Centre','Alger'),('Unité Est','Alger'),('Unité Ouest','Oran'),('Unité Sud','Blida'),('Unité Réserve','Alger');
INSERT INTO intervention_types(type_name) VALUES ('Incendie'),('Secours'),('Accident routier'),('Inondation');
INSERT INTO agents(full_name,unit_id,grade) SELECT 'Agent fictif '||g, 1+((g-1)%5), CASE WHEN g%3=0 THEN 'Officier' ELSE 'Agent' END FROM generate_series(1,40) g;
INSERT INTO vehicles(code,unit_id,category) SELECT 'V-'||lpad(g::text,3,'0'),1+((g-1)%5),CASE WHEN g%2=0 THEN 'Ambulance' ELSE 'Camion' END FROM generate_series(1,15) g;
INSERT INTO interventions(unit_id,type_id,started_at,ended_at,response_minutes,status)
SELECT 1+((g-1)%4),1+((g-1)%4),timestamp '2026-01-01 08:00:00' + (g*interval '3 hours'),
CASE WHEN g%11=0 THEN NULL ELSE timestamp '2026-01-01 08:00:00' + (g*interval '3 hours') + interval '90 minutes' END,
4+(g%32),CASE WHEN g%11=0 THEN 'ongoing' ELSE 'closed' END
FROM generate_series(1,400) g;
INSERT INTO intervention_agents(intervention_id,agent_id) SELECT intervention_id, 1+((intervention_id-1)%40) FROM interventions;
INSERT INTO intervention_vehicles(intervention_id,vehicle_id) SELECT intervention_id, 1+((intervention_id-1)%15) FROM interventions;
COMMIT;
ANALYZE dgpc.interventions;
