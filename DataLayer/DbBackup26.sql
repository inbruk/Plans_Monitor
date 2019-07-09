--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

-- Started on 2019-07-09 08:28:31

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
-- TOC entry 219 (class 1255 OID 16831)
-- Name: fnDictionaryValueCount(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fnDictionaryValueCount"(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  cnt integer := 0;
BEGIN
  SELECT COUNT(*) INTO cnt 
  FROM "tblDictionaryValue" AS TDV
  WHERE TDV."Dictionary" = $1 AND TDV."Position" = $2;

  RETURN cnt; 
END;
$_$;


ALTER FUNCTION public."fnDictionaryValueCount"(integer, integer) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 16840)
-- Name: fnTriInsUpd_tblAudit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fnTriInsUpd_tblAudit"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE 
      cnt integer;
    BEGIN

        -- Проверяем субъект аудита в аудите

        cnt := "fnDictionaryValueCount"( 
            3, -- Внимание !!! Это ид словаря - Субъект аудита
            NEW."AuditObject" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом cубъекта аудита';
            RETURN NULL;
        END IF;

        IF cnt > 1 THEN
            RAISE EXCEPTION 'Словарь с cубъектами аудита поврежден - неуникальные записи';
            RETURN NULL;
        END IF;

        -- Проверяем статус проведения мониторинга

        cnt := "fnDictionaryValueCount"( 
            4, -- Внимание !!! Это ид словаря - Статус проведения мониторинга
            NEW."MonitoringProgressStatus" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом cубъекта аудита';
            RETURN NULL;
        END IF;

        IF cnt > 1 THEN
            RAISE EXCEPTION 'Словарь с cубъектами аудита поврежден - неуникальные записи';
            RETURN NULL;
        END IF;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION public."fnTriInsUpd_tblAudit"() OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 16832)
-- Name: fnTriInsUpd_tblAuditLog_Action(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fnTriInsUpd_tblAuditLog_Action"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE 
      cnt integer;
    BEGIN

        -- Проверяем действие в аудите лога

        cnt := "fnDictionaryValueCount"( 
            1, -- Внимание !!! Это ид словаря - Действие в логе аудита.
            NEW."Action" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом действия лога аудита';
            RETURN NULL;
        END IF;

        IF cnt > 1 THEN
            RAISE EXCEPTION 'Словарь с действиями лога аудита поврежден - неуникальные записи';
            RETURN NULL;
        END IF;

        -- Проверяем экран в аудите лога

        cnt := "fnDictionaryValueCount"( 
            2, -- Внимание !!! Это ид словаря - Экран в логе аудита.
            NEW."Screen" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом экрана лога аудита';
            RETURN NULL;
        END IF;

        IF cnt > 1 THEN
            RAISE EXCEPTION 'Словарь с экранами лога аудита поврежден - неуникальные записи';
            RETURN NULL;
        END IF;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION public."fnTriInsUpd_tblAuditLog_Action"() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 24602)
-- Name: fnTriInsUpd_tblCorrectiveAction(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fnTriInsUpd_tblCorrectiveAction"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE 
      cnt integer;
    BEGIN

        -- Проверяем Отметка Объекта проверки о выполнении мероприятия

        cnt := "fnDictionaryValueCount"( 
            8, -- Внимание !!! Это ид словаря - Отметка Объекта проверки о выполнении мероприятия
            NEW."EvaluationCheckMarkOnCA" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом отметки объекта проверки о выполнении в корр. мероприятии';
            RETURN NULL;
        END IF;

        -- Проверяем оценки эффективности выполнения мероприятия 

        cnt := "fnDictionaryValueCount"( 
            9, -- Внимание !!! Это ид словаря - Оценка эффективности выполнения мероприятия
            NEW."CorrectiveActionEffectEvaluation" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом оценки эффективности выполнения в корр. мероприятии';
            RETURN NULL;
        END IF;

        -- Проверяем Статус выполнения корректирующего мероприятия

        cnt := "fnDictionaryValueCount"( 
            10, -- Внимание !!! Это ид словаря -  Статус выполнения корректирующего мероприятия
            NEW."CorrectiveActionState" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом статуса выполнения корр. мероприятия';
            RETURN NULL;
        END IF;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION public."fnTriInsUpd_tblCorrectiveAction"() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 24648)
-- Name: fnTriInsUpd_tblEmailTemplate(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fnTriInsUpd_tblEmailTemplate"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE 
      cnt integer;
    BEGIN

        -- Проверяем Отметка Объекта проверки о выполнении мероприятия

        cnt := "fnDictionaryValueCount"( 
            11, -- Внимание !!! Это ид словаря - Отметка Объекта проверки о выполнении мероприятия
            NEW."Type" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом отметки объекта проверки о выполнении в корр. мероприятии';
            RETURN NULL;
        END IF;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION public."fnTriInsUpd_tblEmailTemplate"() OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 24598)
-- Name: fnTriInsUpd_tblRemark(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fnTriInsUpd_tblRemark"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE 
      cnt integer;
    BEGIN

        -- Проверяем бизнес процесс в замечании

        cnt := "fnDictionaryValueCount"( 
            5, -- Внимание !!! Это ид словаря - Бизнес процесс
            NEW."BusinessProcess" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с не существующим ид-ом бизнес процесса';
            RETURN NULL;
        END IF;

        -- Проверяем итоговый уровень оценки в замечании

        cnt := "fnDictionaryValueCount"( 
            6, -- Внимание !!! Это ид словаря - Итоговый уровень оценки замечания
            NEW."TotalAssessmentLevel" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с несуществующим итоговым уровнем оценки замечания';
            RETURN NULL;
        END IF;

        -- Проверяем тип замечания

        cnt := "fnDictionaryValueCount"( 
            7, -- Внимание !!! Это ид словаря - Тип замечания
            NEW."RemarkType" -- Внимание !!! Это ид элемента словаря 
        );

        IF cnt = 0 THEN
            RAISE EXCEPTION 'Попытка создать запись с несуществующим типом замечания';
            RETURN NULL;
        END IF;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION public."fnTriInsUpd_tblRemark"() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 206 (class 1259 OID 16572)
-- Name: tblAudit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblAudit" (
    "Id" integer NOT NULL,
    "Name" character varying(256) NOT NULL,
    "AuditObject" integer,
    "VerificationPeriodStart" timestamp with time zone NOT NULL,
    "VerificationPeriodStop" timestamp with time zone NOT NULL,
    "GroundForVerification" character varying(4192) NOT NULL,
    "parPlanScheduleOfControlEvent" character varying(16) NOT NULL,
    "filePlanScheduleOfControlEvent	" character varying(256),
    "numLocalRegulatory" character varying(256) NOT NULL,
    "fileLocalRegulatory" character varying(256),
    "VerificationPeriod" character varying(16) NOT NULL,
    "VerificationTermStart" timestamp with time zone NOT NULL,
    "VerficationTermEnd" character varying NOT NULL,
    "ResponsibleEmployee" integer NOT NULL,
    "NumberAndDateLocRegPrepare" character varying(128),
    "NumberAndDateLocRegAcceptance" character varying(128),
    "CAPMonitoringCompletedOnDate" timestamp with time zone,
    "NextCAPMonitoringDate" timestamp with time zone,
    "AuditSubject" integer NOT NULL,
    "MonitoringProgressStatus" integer NOT NULL,
    "CAPMonitoringCompleteDate" timestamp with time zone,
    "AuditSuperviser" integer
);


ALTER TABLE public."tblAudit" OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16503)
-- Name: tblAuditLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblAuditLog" (
    "Id" integer NOT NULL,
    "Time" timestamp with time zone NOT NULL,
    "User" integer NOT NULL,
    "Screen" integer NOT NULL,
    "Action" integer NOT NULL,
    "Description" character varying(2048) NOT NULL
);


ALTER TABLE public."tblAuditLog" OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 16459)
-- Name: tblAuditObject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblAuditObject" (
    "Id" integer NOT NULL,
    "Name" character varying(256) NOT NULL
);


ALTER TABLE public."tblAuditObject" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16739)
-- Name: tblCorrectiveAction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblCorrectiveAction" (
    "Id" integer NOT NULL,
    "Audit" integer NOT NULL,
    "Corrective Action" character varying(128) NOT NULL,
    "ExecutiveOfficerFirstName" character varying(64) NOT NULL,
    "ExecutiveOfficerLastName" character varying(64) NOT NULL,
    "ExecutiveOfficerPatronymic" character varying(64) NOT NULL,
    "PlannedResultOfCorrectiveAction" character varying(256) NOT NULL,
    "CADevelopmentEvaluation" character varying(2048),
    "NotDevelopmentCAComment" character varying(4096),
    "EvaluationAccordRecomForPrepOfCA" character varying(4096),
    "EvalAccordRecomForPrepOfCAComment" character varying(4096),
    "CAInAccordOrderOfVerifObject" character varying(4096),
    "FactPeriodOfCAExecution" character varying(64),
    "EvaluationCheckMarkOnCA" integer,
    "ReportImplementOfTheApprovedCA" character varying(4096),
    "CorrectiveActionState" integer,
    "CorrectiveActionStateComment" character varying(2048),
    "ConclusionCorrectiveActionEffectEvaluation" character varying(2048),
    "CorrectiveActionEffectEvaluation" integer,
    "UsedRecommendationInPCA" boolean,
    "CommentOnUsedRecommendationInPCA" character varying(2048),
    "EvaluationOfPostControlNeed" character varying(2048),
    "MonitoringOfficerFirstName" character varying(64),
    "MonitoringOfficerLastName" character varying(64),
    "MonitoringOfficerPatronymic" character varying(64),
    "Note" character varying(4096),
    "PlannedExecutionDate" timestamp with time zone NOT NULL,
    "CorrectiveActionType" integer NOT NULL
);


ALTER TABLE public."tblCorrectiveAction" OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16791)
-- Name: tblDictionary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblDictionary" (
    "Id" integer NOT NULL,
    "Name" character varying(128) NOT NULL,
    "EngName4Code" character varying(1024)
);


ALTER TABLE public."tblDictionary" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16800)
-- Name: tblDictionaryValue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblDictionaryValue" (
    "Name" character varying(128) NOT NULL,
    "EngName4Code" character varying(1024),
    "Position" integer NOT NULL,
    "Dictionary" integer NOT NULL
);


ALTER TABLE public."tblDictionaryValue" OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16555)
-- Name: tblEmailTemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblEmailTemplate" (
    "Id" integer NOT NULL,
    "Type" integer NOT NULL,
    "Template" character varying(8192) NOT NULL,
    "Description" character varying(8192)
);


ALTER TABLE public."tblEmailTemplate" OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16719)
-- Name: tblFileStorage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblFileStorage" (
    "Id" integer NOT NULL,
    "Name" character varying(256) NOT NULL,
    "Extention" character varying(16) NOT NULL,
    "LoadingTime" timestamp with time zone NOT NULL,
    "User" integer NOT NULL,
    "PathToPreview" character varying(256),
    "PathToFile" character varying(256) NOT NULL
);


ALTER TABLE public."tblFileStorage" OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16638)
-- Name: tblRemark; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblRemark" (
    "Id" integer NOT NULL,
    "ReportSubsectionNumber" integer,
    "BusinessProcess" integer NOT NULL,
    "RemarkType" integer NOT NULL,
    "RemarkDescription" character varying,
    "RevealedRemarkReason" character varying,
    "RevealedRemarkConsequences" character varying,
    "QuantitativeAssessmentLossesRealized" bigint,
    "QuantitativeAssessmentPotentialLosses" bigint,
    "QuantitativeAssessmentTotalLoss" bigint,
    "QualitativeAssessment" character varying(4192),
    "ResponsibleAuditor" integer,
    "TotalAssessmentLevel" integer,
    "PersonCMRecommendations" character varying(4192),
    "PageNumber" integer,
    "SectionAttachment" integer,
    "ViolationContent" character varying,
    "ViolationValuation" integer,
    "ResponsibleController" integer,
    "AuditObjectComments" character varying(2048),
    "AuditObjectFinalAssessment" character varying,
    "ViolationsAndDeficienciesCauses" character varying
);


ALTER TABLE public."tblRemark" OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16464)
-- Name: tblUser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblUser" (
    "Id" integer NOT NULL,
    "FirstName" character varying(64) NOT NULL,
    "LastName" character varying(64) NOT NULL,
    "Patronymic" character varying(64) NOT NULL,
    "Login" character varying(32) NOT NULL,
    "PasswordSalt" character varying(32) NOT NULL,
    "PasswordHash" character varying(32),
    "AccessGranted" boolean NOT NULL,
    "EMail" character varying(254) NOT NULL,
    "Role" integer NOT NULL,
    "VerificationObject" integer
);


ALTER TABLE public."tblUser" OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 16402)
-- Name: tblUserRole; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tblUserRole" (
    "Id" integer NOT NULL,
    "Name" character varying(64) NOT NULL,
    "Comment" character varying(256) NOT NULL,
    "IsAuditOjectRestricted" boolean
);


ALTER TABLE public."tblUserRole" OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16511)
-- Name: tbl_audit_log_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."tblAuditLog" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."tbl_audit_log_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 198 (class 1259 OID 16457)
-- Name: tbl_controlled_society_Id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."tblAuditObject" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."tbl_controlled_society_Id_seq1"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 205 (class 1259 OID 16558)
-- Name: tbl_email_template_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."tblEmailTemplate" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."tbl_email_template_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 201 (class 1259 OID 16467)
-- Name: tbl_user_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."tblUser" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."tbl_user_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 197 (class 1259 OID 16417)
-- Name: tbl_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."tblUserRole" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tbl_user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 24682)
-- Name: vwAudit; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."vwAudit" AS
 SELECT tau."Id",
    tau."Name",
    tau."VerificationPeriodStart",
    tau."VerificationPeriodStop",
    tau."GroundForVerification",
    tau."parPlanScheduleOfControlEvent",
    tau."filePlanScheduleOfControlEvent	",
    tau."numLocalRegulatory",
    tau."fileLocalRegulatory",
    tau."VerificationPeriod",
    tau."VerificationTermStart",
    tau."VerficationTermEnd",
    tau."NumberAndDateLocRegPrepare",
    tau."NumberAndDateLocRegAcceptance",
    tau."CAPMonitoringCompletedOnDate",
    tau."NextCAPMonitoringDate",
    tau."AuditSubject",
    tau."MonitoringProgressStatus",
    tau."CAPMonitoringCompleteDate",
    tao."Id" AS "AuditObjectId",
    tao."Name" AS "AuditObjectName",
    tre."Id" AS "ResponsibleEmployeeId",
    tre."FirstName" AS "ResponsibleEmployeeFirstName",
    tre."LastName" AS "ResponsibleEmployeeLastName",
    tre."Patronymic" AS "ResponsibleEmployeePatronymic",
    tre."EMail" AS "ResponsibleEmployeeEmail",
    tas."Id" AS "AuditSuperviserId",
    tas."FirstName" AS "AuditSuperviserFirstName",
    tas."LastName" AS "AuditSuperviserLastName",
    tas."Patronymic" AS "AuditSuperviserPatronymic",
    tas."EMail" AS "AuditSuperviserEmail"
   FROM (((public."tblAudit" tau
     LEFT JOIN public."tblAuditObject" tao ON ((tau."AuditObject" = tao."Id")))
     LEFT JOIN public."tblUser" tre ON ((tau."ResponsibleEmployee" = tre."Id")))
     LEFT JOIN public."tblUser" tas ON ((tau."AuditSuperviser" = tas."Id")));


ALTER TABLE public."vwAudit" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24672)
-- Name: vwAuditLog; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."vwAuditLog" AS
 SELECT tal."Id",
    tal."Time",
    tu."Id" AS "UserId",
    tu."FirstName" AS "UserFirstName",
    tu."LastName" AS "UserLastName",
    tu."Patronymic" AS "UserPatronymic",
    tsc."Position" AS "ScreenPos",
    tsc."Name" AS "ScreenName",
    tac."Position" AS "ActionPos",
    tac."Name" AS "ActionName",
    tal."Description"
   FROM (((public."tblAuditLog" tal
     LEFT JOIN public."tblUser" tu ON ((tal."User" = tu."Id")))
     LEFT JOIN public."tblDictionaryValue" tsc ON (((tal."Screen" = tsc."Position") AND (tsc."Dictionary" = 2))))
     LEFT JOIN public."tblDictionaryValue" tac ON (((tal."Action" = tac."Position") AND (tac."Dictionary" = 1))));


ALTER TABLE public."vwAuditLog" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24663)
-- Name: vwCorrectiveAction; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."vwCorrectiveAction" AS
 SELECT tca."Id",
    tca."Audit",
    tca."Corrective Action",
    tca."ExecutiveOfficerFirstName",
    tca."ExecutiveOfficerLastName",
    tca."ExecutiveOfficerPatronymic",
    tca."PlannedResultOfCorrectiveAction",
    tca."CADevelopmentEvaluation",
    tca."NotDevelopmentCAComment",
    tca."EvaluationAccordRecomForPrepOfCA",
    tca."EvalAccordRecomForPrepOfCAComment",
    tca."CAInAccordOrderOfVerifObject",
    tca."FactPeriodOfCAExecution",
    tca."EvaluationCheckMarkOnCA",
    tca."ReportImplementOfTheApprovedCA",
    tca."CorrectiveActionState",
    tca."CorrectiveActionStateComment",
    tca."ConclusionCorrectiveActionEffectEvaluation",
    tca."CorrectiveActionEffectEvaluation",
    tca."UsedRecommendationInPCA",
    tca."CommentOnUsedRecommendationInPCA",
    tca."EvaluationOfPostControlNeed",
    tca."MonitoringOfficerFirstName",
    tca."MonitoringOfficerLastName",
    tca."MonitoringOfficerPatronymic",
    tca."Note",
    tca."PlannedExecutionDate",
    tca."CorrectiveActionType"
   FROM (((public."tblCorrectiveAction" tca
     LEFT JOIN public."tblDictionaryValue" tec ON (((tca."EvaluationCheckMarkOnCA" = tec."Position") AND (tec."Dictionary" = 8))))
     LEFT JOIN public."tblDictionaryValue" tce ON (((tca."CorrectiveActionEffectEvaluation" = tce."Position") AND (tce."Dictionary" = 9))))
     LEFT JOIN public."tblDictionaryValue" tas ON (((tca."CorrectiveActionState" = tas."Position") AND (tas."Dictionary" = 10))));


ALTER TABLE public."vwCorrectiveAction" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 24654)
-- Name: vwEmailTemplate; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."vwEmailTemplate" AS
 SELECT tet."Id",
    tet."Template",
    tet."Description",
    ttt."Position" AS "TypePos",
    ttt."Name" AS "TypeName"
   FROM (public."tblEmailTemplate" tet
     LEFT JOIN public."tblDictionaryValue" ttt ON (((tet."Type" = ttt."Position") AND (ttt."Dictionary" = 11))));


ALTER TABLE public."vwEmailTemplate" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 24624)
-- Name: vwUser; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."vwUser" AS
 SELECT "tblUser"."Id",
    "tblUser"."FirstName",
    "tblUser"."LastName",
    "tblUser"."Patronymic",
    "tblUser"."Login",
    "tblUser"."PasswordSalt",
    "tblUser"."PasswordHash",
    "tblUser"."AccessGranted",
    "tblUser"."EMail",
    "tblUser"."VerificationObject",
    "tblUserRole"."Id" AS "RoleId",
    "tblUserRole"."Name" AS "RoleName"
   FROM (public."tblUser"
     LEFT JOIN public."tblUserRole" ON (("tblUser"."Role" = "tblUserRole"."Id")));


ALTER TABLE public."vwUser" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 24638)
-- Name: vwFileStorage; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."vwFileStorage" AS
 SELECT tfs."Id",
    tfs."Name",
    tfs."Extention",
    tfs."LoadingTime",
    tfs."PathToPreview",
    tfs."PathToFile",
    vu."Id" AS "UserId",
    vu."FirstName" AS "UserFirstName",
    vu."LastName" AS "UserLastName",
    vu."Patronymic" AS "UserPatronymic"
   FROM (public."tblFileStorage" tfs
     LEFT JOIN public."vwUser" vu ON ((tfs."User" = vu."Id")));


ALTER TABLE public."vwFileStorage" OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 24619)
-- Name: vwRemark; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."vwRemark" WITH (security_barrier='false') AS
 SELECT tr."Id",
    tr."ReportSubsectionNumber",
    tr."RemarkType",
    tr."RemarkDescription",
    tr."RevealedRemarkReason",
    tr."RevealedRemarkConsequences",
    tr."QuantitativeAssessmentLossesRealized",
    tr."QuantitativeAssessmentPotentialLosses",
    tr."QuantitativeAssessmentTotalLoss",
    tr."QualitativeAssessment",
    tr."ResponsibleAuditor",
    tr."TotalAssessmentLevel",
    tr."PersonCMRecommendations",
    tr."PageNumber",
    tr."SectionAttachment",
    tr."ViolationContent",
    tr."ViolationValuation",
    tr."AuditObjectComments",
    tr."AuditObjectFinalAssessment",
    tr."ViolationsAndDeficienciesCauses",
    ta."Id" AS "ResponsibleAuditorId",
    ta."FirstName" AS "ResponsibleAuditorFirstName",
    ta."LastName" AS "ResponsibleAuditorLastName",
    ta."Patronymic" AS "ResponsibleAuditorPatronymic",
    tc."Id" AS "ResponsibleControllerId",
    tc."FirstName" AS "ResponsibleControllerFirstName",
    tc."LastName" AS "ResponsibleControllerLastName",
    tc."Patronymic" AS "ResponsibleControllerPatronymic",
    tbp."Position" AS "BusinessProcessPos",
    tbp."Name" AS "BusinessProcessName",
    tbp."Position" AS "TotalAssessmentLevelPos",
    tbp."Name" AS "TotalAssessmentLevelName",
    tbp."Position" AS "RemarkTypePos",
    tbp."Name" AS "RemarkTypeName"
   FROM (((((public."tblRemark" tr
     LEFT JOIN public."tblUser" ta ON ((tr."ResponsibleAuditor" = ta."Id")))
     LEFT JOIN public."tblUser" tc ON ((tr."ResponsibleController" = tc."Id")))
     LEFT JOIN public."tblDictionaryValue" tbp ON (((tr."BusinessProcess" = tbp."Position") AND (tbp."Dictionary" = 5))))
     LEFT JOIN public."tblDictionaryValue" tav ON (((tr."TotalAssessmentLevel" = tav."Position") AND (tav."Dictionary" = 6))))
     LEFT JOIN public."tblDictionaryValue" trt ON (((tr."RemarkType" = trt."Position") AND (trt."Dictionary" = 7))));


ALTER TABLE public."vwRemark" OWNER TO postgres;

--
-- TOC entry 2951 (class 0 OID 16572)
-- Dependencies: 206
-- Data for Name: tblAudit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblAudit" ("Id", "Name", "AuditObject", "VerificationPeriodStart", "VerificationPeriodStop", "GroundForVerification", "parPlanScheduleOfControlEvent", "filePlanScheduleOfControlEvent	", "numLocalRegulatory", "fileLocalRegulatory", "VerificationPeriod", "VerificationTermStart", "VerficationTermEnd", "ResponsibleEmployee", "NumberAndDateLocRegPrepare", "NumberAndDateLocRegAcceptance", "CAPMonitoringCompletedOnDate", "NextCAPMonitoringDate", "AuditSubject", "MonitoringProgressStatus", "CAPMonitoringCompleteDate", "AuditSuperviser") FROM stdin;
\.


--
-- TOC entry 2947 (class 0 OID 16503)
-- Dependencies: 202
-- Data for Name: tblAuditLog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblAuditLog" ("Id", "Time", "User", "Screen", "Action", "Description") FROM stdin;
1	2019-07-04 00:00:00+03	1	1	1	ipugpiupi
2	2019-07-03 00:00:00+03	1	1	1	фвыаафав
3	2019-07-05 00:00:00+03	1	1	1	во
\.


--
-- TOC entry 2944 (class 0 OID 16459)
-- Dependencies: 199
-- Data for Name: tblAuditObject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblAuditObject" ("Id", "Name") FROM stdin;
2	ФГУП Микро
1	ООО Тест
\.


--
-- TOC entry 2954 (class 0 OID 16739)
-- Dependencies: 209
-- Data for Name: tblCorrectiveAction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblCorrectiveAction" ("Id", "Audit", "Corrective Action", "ExecutiveOfficerFirstName", "ExecutiveOfficerLastName", "ExecutiveOfficerPatronymic", "PlannedResultOfCorrectiveAction", "CADevelopmentEvaluation", "NotDevelopmentCAComment", "EvaluationAccordRecomForPrepOfCA", "EvalAccordRecomForPrepOfCAComment", "CAInAccordOrderOfVerifObject", "FactPeriodOfCAExecution", "EvaluationCheckMarkOnCA", "ReportImplementOfTheApprovedCA", "CorrectiveActionState", "CorrectiveActionStateComment", "ConclusionCorrectiveActionEffectEvaluation", "CorrectiveActionEffectEvaluation", "UsedRecommendationInPCA", "CommentOnUsedRecommendationInPCA", "EvaluationOfPostControlNeed", "MonitoringOfficerFirstName", "MonitoringOfficerLastName", "MonitoringOfficerPatronymic", "Note", "PlannedExecutionDate", "CorrectiveActionType") FROM stdin;
\.


--
-- TOC entry 2955 (class 0 OID 16791)
-- Dependencies: 210
-- Data for Name: tblDictionary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblDictionary" ("Id", "Name", "EngName4Code") FROM stdin;
2	Экран	Screen4AuditLog
1	Действие в логе аудита	Action4AuditLog
3	Субъект аудита	AuditSubject
4	Статус проведения мониторинга	MonitoringProgressStatus
5	Бизнес процесс	BusinessProcess
6	Итоговый уровень оценки замечания	TotalAssessmentLevel
7	Тип замечания	RemarkType
8	Отметка объекта проверки о выполнении мероприятия	EvaluationCheckMarkOnCA
9	Оценка эффективности выполнения мероприятия	CorrectiveActionEffectEvaluation
10	Статус выполнения корректирующего мероприятия 	CorrectiveActionState
11	Тип шаблона почты	EMailTemplateType
\.


--
-- TOC entry 2956 (class 0 OID 16800)
-- Dependencies: 211
-- Data for Name: tblDictionaryValue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblDictionaryValue" ("Name", "EngName4Code", "Position", "Dictionary") FROM stdin;
СВА	SVA	1	3
Пост-контроль для внешних проверок	PostControl4ExternalAudits	2	5
Пост-контроль для внутренних проверок	PostControl4InternalAudits	1	5
Умеренная	Moderate	1	6
Значимая	Significant	2	6
Нарушение	Violation	1	7
Выполнено	Done	1	8
Уведомление об истечении срока исполнения мероприятия	NotificationExpirationTermOfCAPreformance	5	11
Уведомление  о  загрузке  ежеквартального Отчета об исполнении ПКМ	NotificationAboutDnldQuarterlyReportOnPCAPerform	6	11
Загрузка данных	DataLoading	9	1
Отмена загрузки данных	CancelDataLoading	10	1
Отправка	Send	12	1
Блокировка	Lock	13	1
Разблокировка	Unlock	14	1
Восстановление	Restore	15	1
Выгрузка	Unload	16	1
Карточка замечания	RemarkForm	11	2
Главная страница Системы\\ История изменений	MainScreenHistoryOfChanges	3	2
Карточка проверки\\ Общая информация	CAFormCommonInfo	6	2
Карточка проверки \\ логирование отправки уведомлений	AuditFormNotificationSendLogging	5	2
Карточка проверки\\ Основной рабочий экран\\ Статистика	AuditFormStatistics	10	2
Карточка проверки\\ Основной рабочий экран	AuditFormMainScreen	9	2
Карточка проверки\\ Хранилище файлов по проверке\\ Превью	AuditFormFileStoragePreview	8	2
Карточка проверки\\ Хранилище файлов по проверке	AuditFormFileStorage	7	2
Страница авторизации 	AuthorizationScreen	1	2
Главная страница Системы	MainScreen	2	2
Просмотр истории	ViewHistory	6	1
Создание	Create	1	1
Просмотр карточки	Read	2	1
Редактирование	Update	3	1
Просмотр файла	FileView	17	1
Завершен	Статус проведения мониторинга	6	4
Неэффективно	Inefficient	2	9
Вторичная верификация	SecondaryVerification	4	4
Исполнение	Execution	1	10
ДКиУР	DkIUr	2	3
Импортирование	Import	11	1
Критическая	Critical	3	6
Недостаток	Disadvantage	2	7
В стадии исполнения	InProgress	3	8
Не выполнено	NotDone	2	8
Запрос РП на внесение замечаний	Request4AddRemarks	1	11
Эффективно	Effectively	1	9
Запрос ответственному  сотруднику  Объекта проверки на внесение 	Req2RespPersonSubjectAuditor	2	11
Уведомление о приближении срока исполнения мероприятия	NotificationApproachingDateOfCAPreformance	3	11
Уведомление о наступлении срока исполнения мероприятия	NotificationAboutMaturityDateOfCAPreformance	4	11
Удаление	Delete	4	1
Формирование	Formation	1	4
ПКМ сформирован	PCAIsFormed	2	4
Первичная верификация	PrimaryVerification	3	4
Загрузка рабочего экрана	List	5	1
Экспортирование отчета	Export	7	1
Изменение пароля	ChangePassword	8	1
Поиск	Find	18	1
Просмотр файлов	ViewingFiles	19	1
Создание новой учетной записи	CreateNewAccount	20	1
Глобальный поиск	GlobalSearch	4	2
Карточка мероприятия	CorrectiveActionForm	12	2
Доработка	Revision	5	4
Карточка мероприятия\\ Список файлов	CAFormFileList	14	2
Карточка мероприятия\\ Комментарии	CAFormComments	13	2
Администрирование\\ Настройка шаблонов	AdminTemplateTuning	17	2
Администрирование\\ Журнал аудита	AdminAuditLog	16	2
Администрирование\\ Управление пользователями	AdminUserManagement	15	2
Просрочено	Expired	2	10
Первичная верификация	PrimaryVerification	3	10
Вторичная верификация	SecondaryVerification	4	10
Доработка	Revision	5	10
Исполнено в срок	ExecutedOnTime	6	10
Исполнено с нарушением срока	ExecutedInDeadlineViolation	7	10
Отсутствует	Missing	8	10
Не выполнено	NotPerformed	9	10
\.


--
-- TOC entry 2949 (class 0 OID 16555)
-- Dependencies: 204
-- Data for Name: tblEmailTemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblEmailTemplate" ("Id", "Type", "Template", "Description") FROM stdin;
\.


--
-- TOC entry 2953 (class 0 OID 16719)
-- Dependencies: 208
-- Data for Name: tblFileStorage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblFileStorage" ("Id", "Name", "Extention", "LoadingTime", "User", "PathToPreview", "PathToFile") FROM stdin;
\.


--
-- TOC entry 2952 (class 0 OID 16638)
-- Dependencies: 207
-- Data for Name: tblRemark; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblRemark" ("Id", "ReportSubsectionNumber", "BusinessProcess", "RemarkType", "RemarkDescription", "RevealedRemarkReason", "RevealedRemarkConsequences", "QuantitativeAssessmentLossesRealized", "QuantitativeAssessmentPotentialLosses", "QuantitativeAssessmentTotalLoss", "QualitativeAssessment", "ResponsibleAuditor", "TotalAssessmentLevel", "PersonCMRecommendations", "PageNumber", "SectionAttachment", "ViolationContent", "ViolationValuation", "ResponsibleController", "AuditObjectComments", "AuditObjectFinalAssessment", "ViolationsAndDeficienciesCauses") FROM stdin;
\.


--
-- TOC entry 2945 (class 0 OID 16464)
-- Dependencies: 200
-- Data for Name: tblUser; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblUser" ("Id", "FirstName", "LastName", "Patronymic", "Login", "PasswordSalt", "PasswordHash", "AccessGranted", "EMail", "Role", "VerificationObject") FROM stdin;
1	Иван	Иванов	Иванович	ivan	87326321	23082368326	t	ivan@mail.ru	1	\N
\.


--
-- TOC entry 2941 (class 0 OID 16402)
-- Dependencies: 196
-- Data for Name: tblUserRole; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tblUserRole" ("Id", "Name", "Comment", "IsAuditOjectRestricted") FROM stdin;
7	Ответственный сотрудник объекта проверки	Имеет доступ к сущностям только своего объекта проверки	t
1	Администратор	Имеет доступ ко всему в системе. Обычно нужен, чтобы управлять пользователями	f
2	Оператор внутренней проверки	Имеет доступ к необходимым по БП сущностям всех объектов проверки	f
3	Оператор внешней проверки	Имеет доступ к необходимым по БП сущностям всех объектов проверки	f
4	Руководитель проверки	Имеет доступ к необходимым по БП сущностям всех объектов проверки	f
5	Аудитор	Имеет доступ к необходимым по БП сущностям всех объектов проверки	f
6	Контролер	Имеет доступ к необходимым по БП сущностям всех объектов проверки	f
\.


--
-- TOC entry 2962 (class 0 OID 0)
-- Dependencies: 203
-- Name: tbl_audit_log_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."tbl_audit_log_Id_seq"', 5, true);


--
-- TOC entry 2963 (class 0 OID 0)
-- Dependencies: 198
-- Name: tbl_controlled_society_Id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."tbl_controlled_society_Id_seq1"', 1, false);


--
-- TOC entry 2964 (class 0 OID 0)
-- Dependencies: 205
-- Name: tbl_email_template_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."tbl_email_template_Id_seq"', 1, false);


--
-- TOC entry 2965 (class 0 OID 0)
-- Dependencies: 201
-- Name: tbl_user_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."tbl_user_Id_seq"', 1, false);


--
-- TOC entry 2966 (class 0 OID 0)
-- Dependencies: 197
-- Name: tbl_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_user_role_id_seq', 1, false);


--
-- TOC entry 2797 (class 2606 OID 16821)
-- Name: tblDictionaryValue pk_dicvalue; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblDictionaryValue"
    ADD CONSTRAINT pk_dicvalue PRIMARY KEY ("Dictionary", "Position");


--
-- TOC entry 2777 (class 2606 OID 16406)
-- Name: tblUserRole pk_tbl_user_role_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblUserRole"
    ADD CONSTRAINT pk_tbl_user_role_id PRIMARY KEY ("Id");


--
-- TOC entry 2793 (class 2606 OID 16743)
-- Name: tblCorrectiveAction tblCorrectiveAction _pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblCorrectiveAction"
    ADD CONSTRAINT "tblCorrectiveAction _pkey" PRIMARY KEY ("Id");


--
-- TOC entry 2795 (class 2606 OID 16798)
-- Name: tblDictionary tblDictionary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblDictionary"
    ADD CONSTRAINT "tblDictionary_pkey" PRIMARY KEY ("Id");


--
-- TOC entry 2785 (class 2606 OID 24647)
-- Name: tblEmailTemplate tblEmailTemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblEmailTemplate"
    ADD CONSTRAINT "tblEmailTemplate_pkey" PRIMARY KEY ("Id");


--
-- TOC entry 2783 (class 2606 OID 16507)
-- Name: tblAuditLog tbl_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblAuditLog"
    ADD CONSTRAINT tbl_audit_log_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2787 (class 2606 OID 16576)
-- Name: tblAudit tbl_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblAudit"
    ADD CONSTRAINT tbl_audit_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2779 (class 2606 OID 16463)
-- Name: tblAuditObject tbl_controlled_society_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblAuditObject"
    ADD CONSTRAINT tbl_controlled_society_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2791 (class 2606 OID 16723)
-- Name: tblFileStorage tbl_file_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblFileStorage"
    ADD CONSTRAINT tbl_file_storage_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2789 (class 2606 OID 16645)
-- Name: tblRemark tbl_remark_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblRemark"
    ADD CONSTRAINT tbl_remark_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2781 (class 2606 OID 16473)
-- Name: tblUser tbl_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblUser"
    ADD CONSTRAINT tbl_user_pkey PRIMARY KEY ("Id");


--
-- TOC entry 2810 (class 2620 OID 24597)
-- Name: tblAudit triInsUpd_tblAudit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "triInsUpd_tblAudit" BEFORE INSERT OR UPDATE ON public."tblAudit" FOR EACH ROW EXECUTE PROCEDURE public."fnTriInsUpd_tblAudit"();


--
-- TOC entry 2808 (class 2620 OID 16834)
-- Name: tblAuditLog triInsUpd_tblAuditLog_Action; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "triInsUpd_tblAuditLog_Action" BEFORE INSERT OR UPDATE ON public."tblAuditLog" FOR EACH ROW EXECUTE PROCEDURE public."fnTriInsUpd_tblAuditLog_Action"();


--
-- TOC entry 2812 (class 2620 OID 24607)
-- Name: tblCorrectiveAction triInsUpd_tblCorrectiveAction; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "triInsUpd_tblCorrectiveAction" BEFORE INSERT OR UPDATE ON public."tblCorrectiveAction" FOR EACH ROW EXECUTE PROCEDURE public."fnTriInsUpd_tblCorrectiveAction"();


--
-- TOC entry 2809 (class 2620 OID 24649)
-- Name: tblEmailTemplate triInsUpd_tblEmailTemplate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "triInsUpd_tblEmailTemplate" BEFORE INSERT OR UPDATE ON public."tblEmailTemplate" FOR EACH ROW EXECUTE PROCEDURE public."fnTriInsUpd_tblEmailTemplate"();


--
-- TOC entry 2811 (class 2620 OID 24601)
-- Name: tblRemark triInsUpd_tblRemark; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "triInsUpd_tblRemark" BEFORE INSERT OR UPDATE ON public."tblRemark" FOR EACH ROW EXECUTE PROCEDURE public."fnTriInsUpd_tblRemark"();


--
-- TOC entry 2806 (class 2606 OID 16744)
-- Name: tblCorrectiveAction fk_CorrAction_Audit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblCorrectiveAction"
    ADD CONSTRAINT "fk_CorrAction_Audit" FOREIGN KEY ("Audit") REFERENCES public."tblAudit"("Id");


--
-- TOC entry 2802 (class 2606 OID 16696)
-- Name: tblAudit fk_audit_audit_object; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblAudit"
    ADD CONSTRAINT fk_audit_audit_object FOREIGN KEY ("AuditObject") REFERENCES public."tblAuditObject"("Id");


--
-- TOC entry 2800 (class 2606 OID 16835)
-- Name: tblAuditLog fk_audit_log_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblAuditLog"
    ADD CONSTRAINT fk_audit_log_user FOREIGN KEY ("User") REFERENCES public."tblUser"("Id");


--
-- TOC entry 2801 (class 2606 OID 16683)
-- Name: tblAudit fk_audit_resp_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblAudit"
    ADD CONSTRAINT fk_audit_resp_employee FOREIGN KEY ("ResponsibleEmployee") REFERENCES public."tblUser"("Id");


--
-- TOC entry 2803 (class 2606 OID 24592)
-- Name: tblAudit fk_audit_superviser; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblAudit"
    ADD CONSTRAINT fk_audit_superviser FOREIGN KEY ("AuditSuperviser") REFERENCES public."tblUser"("Id");


--
-- TOC entry 2807 (class 2606 OID 16815)
-- Name: tblDictionaryValue fk_dicvalue_dic; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblDictionaryValue"
    ADD CONSTRAINT fk_dicvalue_dic FOREIGN KEY ("Dictionary") REFERENCES public."tblDictionary"("Id");


--
-- TOC entry 2805 (class 2606 OID 16727)
-- Name: tblRemark fk_remark_resp_contr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblRemark"
    ADD CONSTRAINT fk_remark_resp_contr FOREIGN KEY ("ResponsibleController") REFERENCES public."tblUser"("Id");


--
-- TOC entry 2804 (class 2606 OID 16661)
-- Name: tblRemark fk_remark_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblRemark"
    ADD CONSTRAINT fk_remark_user FOREIGN KEY ("ResponsibleAuditor") REFERENCES public."tblUser"("Id");


--
-- TOC entry 2798 (class 2606 OID 16477)
-- Name: tblUser fk_tbl_user_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblUser"
    ADD CONSTRAINT fk_tbl_user_role FOREIGN KEY ("Role") REFERENCES public."tblUserRole"("Id");


--
-- TOC entry 2799 (class 2606 OID 16536)
-- Name: tblUser fk_tbl_verification_object; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tblUser"
    ADD CONSTRAINT fk_tbl_verification_object FOREIGN KEY ("VerificationObject") REFERENCES public."tblAuditObject"("Id");


-- Completed on 2019-07-09 08:28:32

--
-- PostgreSQL database dump complete
--
