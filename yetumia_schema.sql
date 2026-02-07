--
-- Yetumia — Full database schema (PostgreSQL)
-- Run on yetumiadb (e.g. Hostinger).
--
-- PIVOT TABLE & RELATIONSHIPS:
--   • lexique_swahili is the PIVOT table: it auto-generates UUIDs (id DEFAULT gen_random_uuid()).
--   • Other lexique_* tables (bemba, hemba, luba, sanga, songye, tshiluba) use MANUAL UUIDs:
--     the same id as in lexique_swahili to link the same word/meaning across languages.
--   • Foreign keys enforce that every id in those tables references an existing row in lexique_swahili.
--

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: langues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.langues (
    id uuid NOT NULL,
    nom_langue character varying(100) NOT NULL,
    famille_linguistique character varying(100),
    region character varying(150),
    histoire text
);


ALTER TABLE public.langues OWNER TO postgres;

--
-- Name: lexique_bemba; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lexique_bemba (
    id uuid NOT NULL,
    mot_bemba character varying(150) NOT NULL,
    argot character varying(150),
    exemples_bemba text,
    synonymes_bemba text,
    antonymes_bemba text,
    etymologie text,
    prononciation_api character varying(100),
    notes_culturelles text,
    niveau_langue character varying(50),
    date_ajout timestamp without time zone DEFAULT now(),
    historique_modifications jsonb DEFAULT '{}'::jsonb,
    categorie_semantique character varying(100),
    niveau_difficulte character varying(50)
);


ALTER TABLE public.lexique_bemba OWNER TO postgres;

--
-- Name: lexique_hemba; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lexique_hemba (
    id uuid NOT NULL,
    mot_hemba character varying(150) NOT NULL,
    argot character varying(150),
    exemples_hemba text,
    synonymes_hemba text,
    antonymes_hemba text,
    etymologie text,
    prononciation_api character varying(100),
    notes_culturelles text,
    niveau_langue character varying(50),
    date_ajout timestamp without time zone DEFAULT now(),
    historique_modifications jsonb DEFAULT '{}'::jsonb,
    categorie_semantique character varying(100),
    niveau_difficulte character varying(50)
);


ALTER TABLE public.lexique_hemba OWNER TO postgres;

--
-- Name: lexique_luba; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lexique_luba (
    id uuid NOT NULL,
    mot_luba character varying(150) NOT NULL,
    argot character varying(150),
    exemples_luba text,
    synonymes_luba text,
    antonymes_luba text,
    etymologie text,
    prononciation_api character varying(100),
    notes_culturelles text,
    niveau_langue character varying(50),
    date_ajout timestamp without time zone DEFAULT now(),
    historique_modifications jsonb DEFAULT '{}'::jsonb,
    categorie_semantique character varying(100),
    niveau_difficulte character varying(50)
);


ALTER TABLE public.lexique_luba OWNER TO postgres;

--
-- Name: lexique_sanga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lexique_sanga (
    id uuid NOT NULL,
    mot_sanga character varying(150) NOT NULL,
    argot character varying(150),
    exemples_sanga text,
    synonymes_sanga text,
    antonymes_sanga text,
    etymologie text,
    prononciation_api character varying(100),
    notes_culturelles text,
    niveau_langue character varying(50),
    date_ajout timestamp without time zone DEFAULT now(),
    historique_modifications jsonb DEFAULT '{}'::jsonb,
    categorie_semantique character varying(100),
    niveau_difficulte character varying(50)
);


ALTER TABLE public.lexique_sanga OWNER TO postgres;

--
-- Name: lexique_songye; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lexique_songye (
    id uuid NOT NULL,
    mot_songye character varying(150) NOT NULL,
    argot character varying(150),
    exemples_songye text,
    synonymes_songye text,
    antonymes_songye text,
    etymologie text,
    prononciation_api character varying(100),
    notes_culturelles text,
    niveau_langue character varying(50),
    date_ajout timestamp without time zone DEFAULT now(),
    historique_modifications jsonb DEFAULT '{}'::jsonb,
    categorie_semantique character varying(100),
    niveau_difficulte character varying(50)
);


ALTER TABLE public.lexique_songye OWNER TO postgres;

--
-- Name: lexique_swahili; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lexique_swahili (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mot_swahili character varying(255) NOT NULL,
    argot character varying(255),
    traduction_fr text NOT NULL,
    categorie_grammaticale character varying(50) NOT NULL,
    exemples_swahili text,
    exemples_traduction_fr text,
    synonymes_swahili text,
    antonymes_swahili text,
    etymologie text,
    prononciation_api character varying(255),
    notes_culturelles text,
    niveau_langue character varying(50),
    date_ajout timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    historique_modifications jsonb DEFAULT '{}'::jsonb,
    categorie_semantique character varying(50),
    niveau_difficulte character varying(20)
);


ALTER TABLE public.lexique_swahili OWNER TO postgres;

-- Index for search by word
CREATE INDEX IF NOT EXISTS idx_lexique_swahili_mot ON public.lexique_swahili (mot_swahili);

--
-- Name: lexique_tshiluba; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lexique_tshiluba (
    id uuid NOT NULL,
    mot_tshiluba character varying(150) NOT NULL,
    argot character varying(150),
    exemples_tshiluba text,
    synonymes_tshiluba text,
    antonymes_tshiluba text,
    etymologie text,
    prononciation_api character varying(100),
    notes_culturelles text,
    niveau_langue character varying(50),
    date_ajout timestamp without time zone DEFAULT now(),
    historique_modifications jsonb DEFAULT '{}'::jsonb,
    categorie_semantique character varying(100),
    niveau_difficulte character varying(50)
);


ALTER TABLE public.lexique_tshiluba OWNER TO postgres;

--
-- Name: langues langues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.langues
    ADD CONSTRAINT langues_pkey PRIMARY KEY (id);


--
-- Name: lexique_bemba lexique_bemba_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lexique_bemba
    ADD CONSTRAINT lexique_bemba_pkey PRIMARY KEY (id);


--
-- Name: lexique_hemba lexique_hemba_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lexique_hemba
    ADD CONSTRAINT lexique_hemba_pkey PRIMARY KEY (id);


--
-- Name: lexique_luba lexique_luba_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lexique_luba
    ADD CONSTRAINT lexique_luba_pkey PRIMARY KEY (id);


--
-- Name: lexique_sanga lexique_sanga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lexique_sanga
    ADD CONSTRAINT lexique_sanga_pkey PRIMARY KEY (id);


--
-- Name: lexique_songye lexique_songye_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lexique_songye
    ADD CONSTRAINT lexique_songye_pkey PRIMARY KEY (id);


--
-- Name: lexique_swahili lexique_swahili_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lexique_swahili
    ADD CONSTRAINT lexique_swahili_pkey PRIMARY KEY (id);


--
-- Name: lexique_tshiluba lexique_tshiluba_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lexique_tshiluba
    ADD CONSTRAINT lexique_tshiluba_pkey PRIMARY KEY (id);


--
-- Name: lexique_swahili unique_mot_swahili; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lexique_swahili
    ADD CONSTRAINT unique_mot_swahili UNIQUE (mot_swahili, argot);


--
-- Foreign keys: other lexiques reference the pivot (lexique_swahili).
-- Manual UUIDs in these tables must equal an existing lexique_swahili.id.
-- If you apply this to an existing DB, ensure every id in *_bemba, *_hemba, etc. exists in lexique_swahili first.
--
ALTER TABLE ONLY public.lexique_bemba
    ADD CONSTRAINT fk_lexique_bemba_swahili FOREIGN KEY (id) REFERENCES public.lexique_swahili(id);

ALTER TABLE ONLY public.lexique_hemba
    ADD CONSTRAINT fk_lexique_hemba_swahili FOREIGN KEY (id) REFERENCES public.lexique_swahili(id);

ALTER TABLE ONLY public.lexique_luba
    ADD CONSTRAINT fk_lexique_luba_swahili FOREIGN KEY (id) REFERENCES public.lexique_swahili(id);

ALTER TABLE ONLY public.lexique_sanga
    ADD CONSTRAINT fk_lexique_sanga_swahili FOREIGN KEY (id) REFERENCES public.lexique_swahili(id);

ALTER TABLE ONLY public.lexique_songye
    ADD CONSTRAINT fk_lexique_songye_swahili FOREIGN KEY (id) REFERENCES public.lexique_swahili(id);

ALTER TABLE ONLY public.lexique_tshiluba
    ADD CONSTRAINT fk_lexique_tshiluba_swahili FOREIGN KEY (id) REFERENCES public.lexique_swahili(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO yetumia;


--
-- PostgreSQL database dump complete
--
