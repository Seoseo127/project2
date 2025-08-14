--------------------------------------------------------
--  파일이 생성됨 - 화요일-7월-01-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table STUDY_TIMER
--------------------------------------------------------

  CREATE TABLE "PROJECT_2"."STUDY_TIMER" 
   (	"USER_ID" VARCHAR2(50), 
	"SUBJECT" VARCHAR2(100), 
	"TOTAL_MINUTES" NUMBER, 
	"TOTAL" NUMBER, 
	"CLEAR" DATE, 
	 FOREIGN KEY ("USER_ID")
	  REFERENCES "PROJECT_2"."USERS" ("USER_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"
--------------------------------------------------------
--  Ref Constraints for Table STUDY_TIMER
--------------------------------------------------------

  ALTER TABLE "PROJECT_2"."STUDY_TIMER" ADD FOREIGN KEY ("USER_ID")
	  REFERENCES "PROJECT_2"."USERS" ("USER_ID") ENABLE
