--self
SELECT A.*,listagg(pf_type||'-'||pf_body,',') within group (order by pf_type||pf_body) as "PF NUMBER" FROM (
 SELECT "SURNAME","FIRST NAMES","NID","PID","INDEX %AGE","ORGANIZATION","GRADE","REASON","AMOUNT","START DATE","PAYING CODE"  FROM (
   SELECT PER_SURNAME "SURNAME", PER_FNAME "FIRST NAMES", PER_NID "NID", spd_per_id "PID", TO_CHAR(PER_DOB,'DD-MON-YY') "DOB", TO_CHAR(PER_LEFT,'DD-MON-YYYY') "DATE LEFT",
   PER_ORG_CODE "ORGANIZATION", PER_GRD_CODE "GRADE", PER_LSC_CODE "REASON",ROUND(PER_INCPERC,2) "INDEX %AGE", SPD_PDC_CODE "PAYING CODE", SPD_AMT "AMOUNT",SPD_FDATE "START DATE" FROM (
    SELECT SPD_PDC_CODE,spd_per_id,SPD_CLC_CODE,spd_benid, SPD_CLM_NO,SPD_AMT,SPD_FDATE
		  FROM pay_spay_ded, REF_PDCODE 
    where spd_tdate IS NULL
    AND	sPD_PDC_CODE = PDC_CODE
    AND sPD_PDC_PDT_CODE = PDC_PDT_CODE
    AND PDC_PDFLAG='P'
		  AND SPD_PDC_CODE IN (SELECT PDC_CODE FROM REF_PDC_CODE_TYPES WHERE PEN_TYPE='SP' AND PEN_CATEGORY='O')
    ), PER_PERSON
    WHERE spd_per_id=PER_ID
    AND (PER_ORG_CODE IS NULL OR PER_GRD_CODE IS NULL OR NVL(PER_INCPERC,0) = 0 OR PER_LSC_CODE IS NULL)
    and per_dod is null
    and nvl(per_suspended,'N') != 'Y'
    and PER_PAYSTOP is null)) A, FTS_MASTER
    WHERE  "PID"=FTS_MASTER.PER_ID(+) 
    GROUP BY "SURNAME","FIRST NAMES","NID","PID","INDEX %AGE","ORGANIZATION","GRADE","REASON","AMOUNT","START DATE","PAYING CODE";
--spouse    
SELECT A.*,listagg(pf_type||'-'||pf_body,',') within group (order by pf_type||pf_body) as "PF NUMBER" FROM (    
      SELECT "SPOUSE SURNAME","SPOUSE FIRST NAMES","SPOUSE NID","SPOUSE PID","DECEASED PID","DECEASED NID","DECEASED SURNAME","DECEASED FIRST NAMES","INDEX PERCENTAGE","ORG","GRADE","REASON","PAYING CODE","AMT",
    "START DATE"  FROM (
    SELECT D.PER_SURNAME "DECEASED SURNAME", D.PER_FNAME "DECEASED FIRST NAMES", DEP_PER_ID "DECEASED PID", D.PER_NID "DECEASED NID", TO_CHAR(D.PER_DOD,'DD-MON-YY') "DOD", TO_CHAR(D.PER_LEFT,'DD-MON-YYYY') "DATE LEFT",
    S.PER_SURNAME "SPOUSE SURNAME", S.PER_FNAME "SPOUSE FIRST NAMES", spd_per_id "SPOUSE PID", SPD_NID "SPOUSE NID", TO_CHAR(S.PER_DOB,'DD-MON-YY') "SPOUSE DOB",
    D.PER_GRD_CODE "GRADE", D.PER_ORG_CODE "ORG", ROUND(D.PER_INCPERC,2) "INDEX PERCENTAGE",D.PER_LSC_CODE "REASON", SPD_PDC_CODE "PAYING CODE", SPD_AMT "AMT",SPD_FDATE "START DATE" FROM (
    SELECT SPD_PDC_CODE,spd_per_id,SPD_CLC_CODE,SPD_NID, SPD_CLM_NO, SPD_AMT , DEP_PER_ID,SPD_FDATE
		  FROM pay_spay_ded, REF_PDCODE , PER_DEPENDENT
    where spd_tdate IS NULL
    AND	sPD_PDC_CODE = PDC_CODE
    AND sPD_PDC_PDT_CODE = PDC_PDT_CODE
    AND PDC_PDFLAG='P'
    AND spd_per_id = DEP_PERID
    AND DEP_RELATION in ('W')
		  AND SPD_PDC_CODE IN (SELECT PDC_CODE FROM REF_PDC_CODE_TYPES WHERE PEN_TYPE='SP' AND PEN_CATEGORY='S')
    ), PER_PERSON S, PER_PERSON D
    WHERE spd_per_id=S.PER_ID
    AND DEP_PER_ID=D.PER_ID
    AND (D.PER_ORG_CODE IS NULL OR D.PER_GRD_CODE IS NULL OR NVL(D.PER_INCPERC,0) = 0 OR D.PER_LSC_CODE IS NULL)
    and S.per_dod is null
    and nvl(S.per_suspended,'N') !='Y'
    and S.PER_PAYSTOP is null)) A, FTS_MASTER
    WHERE "SPOUSE PID"=FTS_MASTER.PER_ID(+) 
    GROUP BY "DECEASED PID","DECEASED NID","DECEASED SURNAME","DECEASED FIRST NAMES","ORG","GRADE","INDEX PERCENTAGE","REASON","PAYING CODE","AMT",
    "SPOUSE PID","SPOUSE NID","SPOUSE SURNAME","SPOUSE FIRST NAMES","START DATE";
--child    
SELECT A.*,listagg(pf_type||'-'||pf_body,',') within group (order by pf_type||pf_body) as "PF NUMBER" FROM (    
      SELECT DISTINCT "SPOUSE SURNAME","SPOUSE FIRST NAMES","SPOUSE NID","SPOUSE PID","DECEASED PID","DECEASED NID","DECEASED SURNAME","DECEASED FIRST NAMES","INDEX PERCENTAGE","ORG","GRADE","REASON","PAYING CODE","AMT",
    "START DATE"  FROM (
    SELECT D.PER_SURNAME "DECEASED SURNAME", D.PER_FNAME "DECEASED FIRST NAMES", DEP_PER_ID "DECEASED PID", D.PER_NID "DECEASED NID", TO_CHAR(D.PER_DOD,'DD-MON-YY') "DOD", TO_CHAR(D.PER_LEFT,'DD-MON-YYYY') "DATE LEFT",
    S.PER_SURNAME "SPOUSE SURNAME", S.PER_FNAME "SPOUSE FIRST NAMES", spd_per_id "SPOUSE PID", SPD_NID "SPOUSE NID", TO_CHAR(S.PER_DOB,'DD-MON-YY') "SPOUSE DOB",
    D.PER_GRD_CODE "GRADE", D.PER_ORG_CODE "ORG", ROUND(D.PER_INCPERC,2) "INDEX PERCENTAGE",D.PER_LSC_CODE "REASON", SPD_PDC_CODE "PAYING CODE", SPD_AMT "AMT",SPD_FDATE "START DATE" FROM (
    SELECT SPD_PDC_CODE,spd_per_id,SPD_CLC_CODE,SPD_NID, SPD_CLM_NO, SPD_AMT , DEP_PER_ID,SPD_FDATE
		  FROM pay_spay_ded, REF_PDCODE , PER_DEPENDENT
    where spd_tdate IS NULL
    AND	sPD_PDC_CODE = PDC_CODE
    AND sPD_PDC_PDT_CODE = PDC_PDT_CODE
    AND PDC_PDFLAG='P'
    AND spd_per_id = DEP_PERID
    AND DEP_RELATION in ('C','G','W','S')
		  AND SPD_PDC_CODE IN (SELECT PDC_CODE FROM REF_PDC_CODE_TYPES WHERE PEN_TYPE='SP' AND PEN_CATEGORY='C')
    ), PER_PERSON S, PER_PERSON D
    WHERE spd_per_id=S.PER_ID
    AND DEP_PER_ID=D.PER_ID
    AND (D.PER_ORG_CODE IS NULL OR D.PER_GRD_CODE IS NULL OR NVL(D.PER_INCPERC,0) = 0 OR D.PER_LSC_CODE IS NULL)
    and S.per_dod is null
    and nvl(S.per_suspended,'N') !='Y'
    and S.PER_PAYSTOP is null)) A, FTS_MASTER
    WHERE "SPOUSE PID"=FTS_MASTER.PER_ID(+) 
    GROUP BY "DECEASED PID","DECEASED NID","DECEASED SURNAME","DECEASED FIRST NAMES","ORG","GRADE","INDEX PERCENTAGE","REASON","PAYING CODE","AMT",
    "SPOUSE PID","SPOUSE NID","SPOUSE SURNAME","SPOUSE FIRST NAMES","START DATE"; 
--minimum
SELECT A.*, listagg(pf_type||'-'||pf_body,',') within group (order by pf_type||pf_body) as "PF NUMBER" FROM (  
select distinct PER_SURNAME "SURNAME",PER_FNAME "FNAME",per_nid NID, spd_per_id PID,ROUND(PER_INCPERC,2) "INDEX %AGE",PER_ORG_CODE ORG,per_grd_code GRADE,spd_amt "AMOUNT",spd_fdate "START DATE",spd_pdc_code "PAYING CODE"--,spd_clm_no "CLAIM NUMBER",spd_benid "BENEFICIARY ID"
from pay_spay_ded,per_person
where per_id=spd_per_id
and spd_tdate is null
AND SPD_PDC_CODE IN (SELECT PDC_CODE FROM REF_PDC_CODE_TYPES WHERE REF_PDC_CODE_TYPES.PEN_CATEGORY ='O') 
and per_dod is null 
and nvl(per_suspended,'N') != 'Y' 
and PER_PAYSTOP is null
and spd_tdate IS NULL 
AND pay_spay_ded.SPD_CLT_CODE = 'SP'
and spd_audit='Y' 
and spd_updt='Y' 
AND SPD_AMT <= 1678.74
and PER_ORG_CODE IN ('ZNA','ZRP','CIO','ZPCS','ZPS')
) A, FTS_MASTER
WHERE PID=FTS_MASTER.PER_ID(+)
GROUP BY SURNAME,FNAME, NID,PID,ORG,GRADE,"INDEX %AGE","AMOUNT","PAYING CODE","START DATE";
    
    