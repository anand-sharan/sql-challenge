
-- Please execute below schema sql to create the SQL challenge schema in postgress pgAdmin
-- The below schema query is re runable any number of times however each time this will drop all objects and re-create
-- PLEASE ENSURE that user is not impact by any data loss due to re-running of schema creation script

-- sql_challenge_db schemata

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Drop existing objects and re-create schema
--

DROP TABLE IF EXISTS department_manager_junction;
DROP TABLE IF EXISTS department_employee_junction;
DROP TABLE IF EXISTS salary;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS title;
DROP FUNCTION IF EXISTS last_updated;

--
-- Name: last_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION last_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END $$;


ALTER FUNCTION public.last_updated() OWNER TO postgres;




--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE department (
    dept_no     varchar(6)           CONSTRAINT department_pkey PRIMARY KEY UNIQUE NOT NULL ,
    dept_name   varchar(255)         NOT NULL,
    activebool  boolean DEFAULT true NOT NULL,
    create_date date DEFAULT ('now'::text)::date NOT NULL,
    last_update timestamp with time zone DEFAULT now()
);

ALTER TABLE department OWNER TO postgres;

--
-- Name: title; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE title (
    title_id    varchar(6)           CONSTRAINT title_pkey PRIMARY KEY UNIQUE NOT NULL,
    title       varchar(255)         NOT NULL,
    activebool  boolean DEFAULT true NOT NULL,
    create_date date DEFAULT ('now'::text)::date NOT NULL,
    last_update timestamp with time zone DEFAULT now()
);

ALTER TABLE title OWNER TO postgres;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE employee (
    emp_no       integer      UNIQUE NOT NULL,
    emp_title_id varchar(6)   NOT NULL,
    birth_date   date         NOT NULL,
    first_name   varchar(255) NOT NULL,
    last_name    varchar(255) NOT NULL,
    sex          varchar(6)   NOT NULL,
    hire_date    date         NOT NULL,
    activebool   boolean DEFAULT true NOT NULL,
    create_date  date DEFAULT ('now'::text)::date NOT NULL,
    last_update  timestamp with time zone DEFAULT now(),
    CONSTRAINT employee_title_id_fkey FOREIGN KEY (emp_title_id) REFERENCES title(title_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

ALTER TABLE employee OWNER TO postgres;

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (emp_no, emp_title_id);


--
-- Name: department_manager_junction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE department_manager_junction (
    dept_no       varchar(6) UNIQUE NOT NULL,
    emp_no        integer    UNIQUE NOT NULL,
    activebool    boolean DEFAULT true NOT NULL,
    create_date   date DEFAULT ('now'::text)::date NOT NULL,
    last_update   timestamp with time zone DEFAULT now(),
    CONSTRAINT department_manager_junction_dept_no_fkey FOREIGN KEY (dept_no) REFERENCES department(dept_no) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT department_manager_junction_emp_no_fkey FOREIGN KEY (emp_no)  REFERENCES employee(emp_no)    ON UPDATE CASCADE ON DELETE RESTRICT
);

ALTER TABLE department_manager_junction OWNER TO postgres;

ALTER TABLE ONLY department_manager_junction
    ADD CONSTRAINT department_manager_junction_pkey PRIMARY KEY (dept_no, emp_no);

--
-- Name: department_employee_junction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE department_employee_junction (
    dept_no       varchar(6) UNIQUE NOT NULL,
    emp_no        integer    UNIQUE NOT NULL,
    activebool    boolean DEFAULT true NOT NULL,
    create_date   date DEFAULT ('now'::text)::date NOT NULL,
    last_update   timestamp with time zone DEFAULT now(),
    CONSTRAINT department_employee_junction_dept_no_fkey FOREIGN KEY (dept_no) REFERENCES department(dept_no),
    CONSTRAINT department_employee_junction_emp_no_fkey FOREIGN KEY (emp_no)  REFERENCES employee(emp_no) ON UPDATE CASCADE ON DELETE RESTRICT
);

ALTER TABLE department_employee_junction OWNER TO postgres;

ALTER TABLE ONLY department_employee_junction
    ADD CONSTRAINT department_employee_junction_pkey PRIMARY KEY (dept_no, emp_no);

--
-- Name: salary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE salary (
    emp_no        integer      CONSTRAINT salary_pkey PRIMARY KEY,
    salary        numeric      NOT NULL,
    activebool    boolean DEFAULT true NOT NULL,
    create_date   date DEFAULT ('now'::text)::date NOT NULL,
    last_update   timestamp with time zone DEFAULT now(),
    CONSTRAINT salary_emp_no_fkey FOREIGN KEY (emp_no)  REFERENCES employee(emp_no) ON UPDATE CASCADE ON DELETE RESTRICT
);

ALTER TABLE salary OWNER TO postgres;

--
-- Name: idx_employee_first_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_first_name ON employee USING btree (first_name);

--
-- Name: idx_employee_last_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_employee_last_name ON employee USING btree (last_name);

--
-- Name: idx_fk_employee_emp_title_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_employee_emp_title_id ON employee USING btree (emp_title_id);


--
-- Name: idx_fk_department_manager_junction_dept_no_emp_no Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_department_manager_junction_dept_no_emp_no ON department_manager_junction USING btree (dept_no, emp_no);


--
-- Name: idx_fk_department_employee_junction_dept_no_emp_no; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_department_employee_junction_dept_no_emp_no ON department_employee_junction USING btree (dept_no, emp_no);

--
-- Name: idx_fk_salary_emp_no; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_salary_emp_no ON salary USING btree (emp_no);

--
-- Name: department last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON department FOR EACH ROW EXECUTE PROCEDURE last_updated();

--
-- Name: title last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON title FOR EACH ROW EXECUTE PROCEDURE last_updated();

--
-- Name: employee last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON employee FOR EACH ROW EXECUTE PROCEDURE last_updated();

--
-- Name: department_manager_junction last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON department_manager_junction FOR EACH ROW EXECUTE PROCEDURE last_updated();

--
-- Name: department_employee_junction last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON department_employee_junction FOR EACH ROW EXECUTE PROCEDURE last_updated();

--
-- Name: salary last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON salary FOR EACH ROW EXECUTE PROCEDURE last_updated();

