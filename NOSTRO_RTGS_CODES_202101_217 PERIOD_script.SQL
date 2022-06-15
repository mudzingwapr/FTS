--RUN AD-HOC PROCEDURE FOR NEW NOSTRO PAYMENT FOR PERIOD 217/202101
--FIRST TO RUN FOR NEW APPOINTMENTS JAN 2021 from_date=to_date('01-JAN-2021','DD-MON-YYYY') - PAY ALL ARREARS
  set serveroutput on
  DECLARE
    NOSTRO NUMBER(26,2):=0;
    polyg VARCHAR2(1):='N';
    nostro_jan number:=0;    
    nostro_dec number:=0; 
    nostro_nov number:=0;    
    nostro_oct number:=0;
    nostro_sep number:=0;
    nostro_aug number:=0;
    nostro_jul number:=0;
    nostro_jun number:=0;
    d_left date;
    n_jan number;     
    n_dec number; 
    n_nov number;    
    n_oct number;
    n_sep number;
    n_aug number;
    n_jul number;
    n_jun number;
    
    PERID VARCHAR2(10);
    CLMNO VARCHAR2(10);

    function ret_code_exist(code varchar2, categry varchar2) return number is
    f number:=0;
    begin
      select 1 into f from dual where code IN (select pdc_code from ref_pdc_code_types where pen_category=categry);
      return 1;
    exception
    when no_data_found then
      return 0;
    end;
    
  BEGIN
  /*
SELECT distinct SPD_PDC_CODE FROM (SELECT PER_ID,per_left,SPD_FDATE,SPD_CLM_NO,SPD_NID,SPD_BENID,SPD_PER_ID,SPD_PDC_CODE,SPD_CLC_CODE,SPD_CLT_CODE,SPD_PDC_PDT_CODE,SPD_CLM_SERIAL ,
      nvl(c.clm_fdate,to_date('01-MAR-2020','DD-MON-YYYY')) clm_fdate,
      (SELECT MIN(O.SPD_FDATE) FROM PAY_SPAY_DED O WHERE SPD_PER_ID=S.SPD_PER_ID AND O.SPD_PDC_CODE=S.SPD_PDC_CODE AND O.SPD_CLM_NO=S.SPD_CLM_NO AND O.SPD_BENID=S.SPD_BENID) FROM_DATE
      FROM PER_PERSON,PAY_SPAY_DED s,(select clm_no,clm_fdate from clm_claim where clm_no||clm_serial in (select clm_no||minser from (
      select distinct clm_no, MIN(clm_serial) minser from clm_claim group by clm_no))) c WHERE SPD_PER_ID=PER_ID and SPD_clm_no=c.clm_no(+)
      and per_dod is null and nvl(per_suspended,'N') != 'Y' and PER_PAYSTOP is null
      and spd_tdate IS NULL and spd_audit='Y' and spd_updt='Y' AND SPD_AMT > 0.01) 
      where from_date=to_date('01-NOV-2020','DD-MON-YYYY') AND SPD_PDC_CODE IN (SELECT PDC_CODE FROM Ref_Pdc_Code_Types);
*/      
    FOR REC IN (SELECT * FROM (SELECT PER_ID,per_left,SPD_FDATE,SPD_CLM_NO,SPD_NID,SPD_BENID,SPD_PER_ID,SPD_PDC_CODE,SPD_CLC_CODE,SPD_CLT_CODE,SPD_PDC_PDT_CODE,SPD_CLM_SERIAL ,
      nvl(c.clm_fdate,to_date('01-MAR-2020','DD-MON-YYYY')) clm_fdate,
      (SELECT MIN(O.SPD_FDATE) FROM PAY_SPAY_DED O WHERE SPD_PER_ID=S.SPD_PER_ID AND O.SPD_PDC_CODE=S.SPD_PDC_CODE AND O.SPD_CLM_NO=S.SPD_CLM_NO AND O.SPD_BENID=S.SPD_BENID) FROM_DATE
      FROM PER_PERSON,PAY_SPAY_DED s,(select clm_no,clm_fdate from clm_claim where clm_no||clm_serial in (select clm_no||minser from (
      select distinct clm_no, MIN(clm_serial) minser from clm_claim group by clm_no))) c WHERE SPD_PER_ID=PER_ID and SPD_clm_no=c.clm_no(+)
      and per_dod is null and nvl(per_suspended,'N') != 'Y' and PER_PAYSTOP is null
      and spd_tdate IS NULL and spd_audit='Y' and spd_updt='Y' AND SPD_AMT > 0.01) 
      where from_date=to_date('01-JAN-2021','DD-MON-YYYY') AND SPD_PDC_CODE IN (SELECT PDC_CODE FROM Ref_Pdc_Code_Types))  
      -- to add check for previous nostro using the same claim in mpay table to avoid cases when the code has changed
    LOOP
    
      NOSTRO     := 0;
      nostro_jan := 0;
      nostro_dec := 0;
      nostro_nov := 0; 
      nostro_oct := 0;
      nostro_sep := 0;
      nostro_aug := 0;
      nostro_jul := 0;
      nostro_jun := 0;
      n_jan:=0;
      n_dec:=0;
      n_nov:=0;
      n_oct := 0;
      n_sep := 0;
      n_aug := 0;
      n_jul := 0;
      n_jun := 0;
      
      perid:=rec.spd_per_id;
      clmno:=rec.spd_clm_no;
      
    --OWNRIGHTS 30 USD
      if ret_code_exist(REC.SPD_PDC_CODE ,'O') = 1 then
        
          NOSTRO:=2455.72;  
          
          nostro_jan := 1;
          n_jan:=1;
          if rec.clm_fdate<to_date('01-JAN-2021','DD-MON-YYYY') then
            n_dec:=1;     
          end if;          
          if rec.clm_fdate<to_date('01-DEC-2020','DD-MON-YYYY') then
            n_nov:=1;     
          end if;
          if rec.clm_fdate<to_date('01-NOV-2020','DD-MON-YYYY') then
            n_oct:=1;     
          end if;
          if rec.clm_fdate<to_date('01-OCT-2020','DD-MON-YYYY') then
            n_sep:=1;     
          end if;
          if rec.clm_fdate<to_date('01-SEP-2020','DD-MON-YYYY') then        
            n_aug:=1;
          end if;     
          if rec.clm_fdate<to_date('01-AUG-2020','DD-MON-YYYY') then               
            n_jul:=1;
          end if;  
          if rec.clm_fdate<to_date('01-JUL-2020','DD-MON-YYYY') then
             n_jun:=1;          
          end if;

        --CHILDREN PENSION - 5 USD
        elsif ret_code_exist(REC.SPD_PDC_CODE ,'C') = 1 then
        
          NOSTRO:=409.29; 
          
          nostro_jan := 1;
          n_jan:=1;
          if rec.clm_fdate<to_date('01-JAN-2021','DD-MON-YYYY') then
            n_dec:=1;     
          end if;           
          if rec.clm_fdate<to_date('01-DEC-2020','DD-MON-YYYY') then
            n_nov:=1;     
          end if; 
          if rec.clm_fdate<to_date('01-NOV-2020','DD-MON-YYYY') then
            n_oct:=1;     
          end if;        
          if rec.clm_fdate<to_date('01-OCT-2020','DD-MON-YYYY') then
            n_sep:=1;    
          end if; 
          if rec.clm_fdate<to_date('01-SEP-2020','DD-MON-YYYY') then        
            n_aug:=1;
          end if;     
          if rec.clm_fdate<to_date('01-AUG-2020','DD-MON-YYYY') then
            n_jul:=1;
          end if;
          if rec.clm_fdate<to_date('01-JUL-2020','DD-MON-YYYY') then
            n_jun:=1;  
          end if;
 
      --SPOUSES 30/15 USD - CHECK POLYGAMOUS FIRST
      elsif ret_code_exist(REC.SPD_PDC_CODE ,'S') = 1 then
        
          -- CHECK POLYGAMOUS FIRST         
          IF IS_POLYGAMOUS(rec.spd_per_id) = 'Y' THEN
            NOSTRO:=1227.86;
          ELSE
            NOSTRO:=2455.72;
          END IF;
          
          nostro_jan := 1;
          n_jan:=1;
          if rec.clm_fdate<to_date('01-JAN-2021','DD-MON-YYYY') then
            n_dec:=1;     
          end if;          
          if rec.clm_fdate<to_date('01-DEC-2020','DD-MON-YYYY') then
            n_nov:=1;     
          end if; 
          if rec.clm_fdate<to_date('01-NOV-2020','DD-MON-YYYY') then
            n_oct:=1;     
          end if;
          if rec.clm_fdate<to_date('01-OCT-2020','DD-MON-YYYY') then
            n_sep:=1;    
          end if;        
          if rec.clm_fdate<to_date('01-SEP-2020','DD-MON-YYYY') then        
            n_aug:=1;
          end if;             
          if rec.clm_fdate<to_date('01-AUG-2020','DD-MON-YYYY') then
            n_jul:=1;
          end if;          
          if rec.clm_fdate<to_date('01-JUL-2020','DD-MON-YYYY') then
            n_jun:=1;            
          end if;
          
      END IF;
      
      IF NOSTRO > 0 THEN  
        if n_jan > 0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'COVID-19 ALLOWANCE',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        ); 
        end if;       
        if n_dec > 0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS DEC 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        ); 
        end if; 
        if n_nov>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS NOV 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if; 
        if n_oct>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS OCT 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if;        
        if n_sep>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS SEP 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if;
        if n_aug>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS AUG 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if;
        if n_jul>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS JULY 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if;  
        if n_jun>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS JUNE 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if; 
      END IF;
    COMMIT;   
  END LOOP;

END;
/*
DELETE FROM PAY_MPAY_DED WHERE MPD_PERIOD=202011 AND MPD_PDC_CODE='0988' AND MPD_VOUCHER LIKE '%ARR%' AND MPD_PER_ID='MU00003103' IN (
SELECT SPD_PER_ID FROM (SELECT PER_ID,per_left,SPD_FDATE,SPD_CLM_NO,SPD_NID,SPD_BENID,SPD_PER_ID,SPD_PDC_CODE,SPD_CLC_CODE,SPD_CLT_CODE,SPD_PDC_PDT_CODE,SPD_CLM_SERIAL ,
      nvl(c.clm_fdate,to_date('01-MAR-2020','DD-MON-YYYY')) clm_fdate,
      (SELECT MIN(O.SPD_FDATE) FROM PAY_SPAY_DED O WHERE SPD_PER_ID=S.SPD_PER_ID AND O.SPD_PDC_CODE=S.SPD_PDC_CODE AND O.SPD_CLM_NO=S.SPD_CLM_NO AND O.SPD_BENID=S.SPD_BENID) FROM_DATE
      FROM PER_PERSON,PAY_SPAY_DED s,(select clm_no,clm_fdate from clm_claim where clm_no||clm_serial in (select clm_no||minser from (
      select distinct clm_no, MIN(clm_serial) minser from clm_claim group by clm_no))) c WHERE SPD_PER_ID=PER_ID and SPD_clm_no=c.clm_no(+)
      and per_dod is null and nvl(per_suspended,'N') != 'Y' and PER_PAYSTOP is null
      and spd_tdate IS NULL and spd_audit='Y' and spd_updt='Y' AND SPD_AMT > 0.01) 
      where from_date=to_date('01-NOV-2020','DD-MON-YYYY') AND SPD_PDC_CODE ='D_WPEN' );
*/      
      
--SECOND RUN from_date<to_date('01-JAN-2021','DD-MON-YYYY') - PAY ARREARS IF NOT PAID FOR DEC 2020 BACKWARDS     
DECLARE
  NOSTRO NUMBER(26,2):=0;
  polyg VARCHAR2(1):='N';
  nostro_jan number:=0;  
  nostro_dec number:=0; 
  nostro_nov number:=0;  
  nostro_oct number:=0;
  nostro_sep number:=0;
  nostro_aug number:=0;
  nostro_jul number:=0;
  nostro_jun number:=0;
  d_left date;
  n_jan number;  
  n_dec number; 
  n_nov number;  
  n_oct number;
  n_sep number;
  n_aug number;
  n_jul number;
  n_jun number;
  
  PERID VARCHAR2(10);
  CLMNO VARCHAR2(10);
  
    function ret_code_exist(code varchar2, categry varchar2) return number is
    f number:=0;
    begin
      select 1 into f from dual where code IN (select pdc_code from ref_pdc_code_types where pen_category=categry);
      return 1;
    exception
    when no_data_found then
      return 0;
    end;
    
BEGIN
  FOR REC IN (SELECT * FROM (SELECT PER_ID,per_left,SPD_FDATE,SPD_CLM_NO,SPD_NID,SPD_BENID,SPD_PER_ID,SPD_PDC_CODE,SPD_CLC_CODE,SPD_CLT_CODE,SPD_PDC_PDT_CODE,SPD_CLM_SERIAL ,
  nvl(c.clm_fdate,to_date('01-MAR-2020','DD-MON-YYYY')) clm_fdate,
  (SELECT MIN(O.SPD_FDATE) FROM PAY_SPAY_DED O WHERE SPD_PER_ID=S.SPD_PER_ID AND O.SPD_PDC_CODE=S.SPD_PDC_CODE AND O.SPD_CLM_NO=S.SPD_CLM_NO AND O.SPD_BENID=S.SPD_BENID) FROM_DATE
  FROM PER_PERSON,PAY_SPAY_DED s,(select clm_no,clm_fdate from clm_claim where clm_no||clm_serial in (select clm_no||minser from (
  select distinct clm_no, MIN(clm_serial) minser from clm_claim group by clm_no))) c WHERE SPD_PER_ID=PER_ID and SPD_clm_no=c.clm_no(+)
  and per_dod is null and nvl(per_suspended,'N') != 'Y' and PER_PAYSTOP is null
  and spd_tdate IS NULL and spd_audit='Y' and spd_updt='Y' AND SPD_AMT > 0.01) 
  where from_date<to_date('01-JAN-2021','DD-MON-YYYY') AND SPD_PDC_CODE IN (SELECT PDC_CODE FROM Ref_Pdc_Code_Types)) 

  LOOP
  
    NOSTRO     := 0;
    nostro_jan := 0;     
    nostro_dec := 0; 
    nostro_nov := 0;    
    nostro_oct := 0;
    nostro_sep := 0;
    nostro_aug := 0;
    nostro_jul := 0;
    nostro_jun := 0;
    n_jan := 0;    
    n_dec := 0;
    n_nov := 0;
    n_oct := 0;
    n_sep := 0;
    n_aug := 0;
    n_jul := 0;
    n_jun := 0;
    
    perid:=rec.spd_per_id;
    clmno:=rec.spd_clm_no;
    
    --OWNRIGHTS 30 USD
    if ret_code_exist(REC.SPD_PDC_CODE ,'O') = 1 then
      
        NOSTRO:=2455.72;      
        nostro_jan := 1;
        n_jan:=1;
        if rec.clm_fdate<to_date('01-JAN-2021','DD-MON-YYYY') then
          select count(*) into nostro_dec from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202012 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no ;        
          if nostro_dec = 0 then
             n_dec:=1;
          end if;      
        end if;  
        if nostro_dec = 0 then       
          if rec.clm_fdate<to_date('01-DEC-2020','DD-MON-YYYY') then
            select count(*) into nostro_nov from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202011 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no ;        
            if nostro_nov = 0 then
               n_nov:=1;
            end if;      
          end if; 
          if nostro_nov = 0 then
            if rec.clm_fdate<to_date('01-NOV-2020','DD-MON-YYYY') then
              select count(*) into nostro_oct from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202010 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no ;        
              if nostro_oct = 0 then
                 n_oct:=1;
              end if;      
            end if;
            if nostro_oct = 0 then 
            if rec.clm_fdate<to_date('01-OCT-2020','DD-MON-YYYY') then
              select count(*) into nostro_sep from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202009 and mpd_pdc_code='3001' and mpd_clm_no=rec.spd_clm_no ;        
              if nostro_sep = 0 then
                 n_sep:=1;
              end if;      
            end if;
            if  nostro_sep = 0 then 
              if rec.clm_fdate<to_date('01-SEP-2020','DD-MON-YYYY') then        
                select count(*) into nostro_aug from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and mpd_clm_no=rec.spd_clm_no and 
                ((mpd_period=202008 and mpd_voucher like '%ALLOW%') OR (mpd_period=202009 and mpd_voucher like '%ARREAR%AUG%'));          
                if nostro_aug = 0 then -- complete only when was no payments
                    n_aug:=1;
                end if;
              end if;     
              if nostro_aug = 0 then 
                if rec.clm_fdate<to_date('01-AUG-2020','DD-MON-YYYY') then
                  select count(*) into nostro_jul from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and mpd_clm_no=rec.spd_clm_no and 
                        ((mpd_period=202007 and mpd_voucher like '%ALLOW%') OR (mpd_period in (202008,202009) and mpd_voucher like '%ARREAR%JUL%')); 
                  if nostro_jul =0 then                
                    n_jul:=1;
                  end if;
                end if;
                if nostro_jul =0 then   
                  if rec.clm_fdate<to_date('01-JUL-2020','DD-MON-YYYY') then
                    select count(*) into nostro_jun from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and --mpd_clm_no=rec.spd_clm_no and --omitted due summarizing by nostro this month
                          ((mpd_period=202006 and mpd_voucher like '%ALLOW%') OR (mpd_period in (202007,202008,202009) and mpd_clm_no=rec.spd_clm_no and mpd_voucher like '%ARREAR%JUN%'));
                    if nostro_jun=0 then
                      n_jun:=1;  
                    end if;          
                  end if;
                end if;
              end if;
          end if;
          end if;
        end if; 
      end if;
      --CHILDREN PENSION - 5 USD
    ELSif ret_code_exist(REC.SPD_PDC_CODE ,'C') = 1 then
      
        NOSTRO:=409.29;      
        nostro_jan := 1;
        n_jan:=1;
        if rec.clm_fdate<to_date('01-JAN-2021','DD-MON-YYYY') then
          select count(*) into nostro_dec from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202012 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no
          and mpd_benid in (select spd_benid from pay_spay_ded where spd_per_id=rec.spd_per_id and spd_clm_no=rec.spd_clm_no 
          and spd_pdc_code in (select pdc_code from ref_pdc_code_types where pen_category='C'));      
          if nostro_dec = 0 then
             n_dec:=1;
          end if;      
        end if;  
        if nostro_dec = 0 then
          if rec.clm_fdate<to_date('01-DEC-2020','DD-MON-YYYY') then
            select count(*) into nostro_nov from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202011 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no
            and mpd_benid in (select spd_benid from pay_spay_ded where spd_per_id=rec.spd_per_id and spd_clm_no=rec.spd_clm_no 
            and spd_pdc_code in (select pdc_code from ref_pdc_code_types where pen_category='C'));      
            if nostro_nov = 0 then
               n_nov:=1;
            end if;      
          end if; 
          if nostro_nov = 0 then
            if rec.clm_fdate<to_date('01-NOV-2020','DD-MON-YYYY') then
            select count(*) into nostro_oct from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202010 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no
            and mpd_benid in (select spd_benid from pay_spay_ded where spd_per_id=rec.spd_per_id and spd_clm_no=rec.spd_clm_no 
            and spd_pdc_code in (select pdc_code from ref_pdc_code_types where pen_category='C'));      
            if nostro_oct = 0 then
               n_oct:=1;
            end if; 
          end if;
          if nostro_oct = 0 then
          if rec.clm_fdate<to_date('01-OCT-2020','DD-MON-YYYY') then
            select count(*) into nostro_sep from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202009 and mpd_pdc_code='3001' and mpd_clm_no=rec.spd_clm_no
            and mpd_benid in (select spd_benid from pay_spay_ded where spd_per_id=rec.spd_per_id and spd_clm_no=rec.spd_clm_no 
            and spd_pdc_code in (select pdc_code from ref_pdc_code_types where pen_category='C'));        
            if nostro_sep = 0 then
               n_sep:=1;
            end if;      
          end if; 
          
          if nostro_sep = 0 then 
            if rec.clm_fdate<to_date('01-SEP-2020','DD-MON-YYYY') then        
              select count(*) into nostro_aug from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and --mpd_clm_no=rec.spd_clm_no and 
              ((mpd_period=202008 and mpd_voucher like '%ALLOW%') OR (mpd_period=202009 and mpd_voucher like '%ARREAR%AUG%')) 
              and mpd_benid in (select spd_benid from pay_spay_ded where spd_per_id=rec.spd_per_id and spd_clm_no=rec.spd_clm_no 
              and spd_pdc_code in (select pdc_code from ref_pdc_code_types where pen_category='C')) ;          
                if nostro_aug = 0 then -- complete only when was no payments
                    n_aug:=1;
                end if;
              end if;     
            
            if nostro_aug = 0 then
              if rec.clm_fdate<to_date('01-AUG-2020','DD-MON-YYYY') then
                select count(*) into nostro_jul from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and --mpd_clm_no=rec.spd_clm_no and 
                      ((mpd_period=202007 and mpd_voucher like '%ALLOW%') OR (mpd_period in (202008,202009) and mpd_voucher like '%ARREAR%JUL%')) 
                and mpd_benid in (select spd_benid from pay_spay_ded where spd_per_id=rec.spd_per_id and spd_clm_no=rec.spd_clm_no 
                and spd_pdc_code in (select pdc_code from ref_pdc_code_types where pen_category='C')) ; 
                if nostro_jul =0 then                
                  n_jul:=1;
                end if;
              end if;
              if nostro_jul =0 then 
                if rec.clm_fdate<to_date('01-JUL-2020','DD-MON-YYYY') then
                  select count(*) into nostro_jun from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and --mpd_clm_no=rec.spd_clm_no and 
                        ((mpd_period=202006 and mpd_voucher like '%ALLOW%') OR (mpd_period in (202007,202008,202009) and mpd_clm_no=rec.spd_clm_no and mpd_voucher like '%ARREAR%JUN%')) 
                         and mpd_benid in (select spd_benid from pay_spay_ded where spd_per_id=rec.spd_per_id and spd_clm_no=rec.spd_clm_no 
                         and spd_pdc_code in (select pdc_code from ref_pdc_code_types where pen_category='C')) ;
                  if nostro_jun=0 then
                    n_jun:=1;  
                  end if;          
                end if;
              end if;
            end if;
          end if;
         end if;
         end if;
        end if;  
    --SPOUSES 30/15 USD - CHECK POLYGAMOUS FIRST
    ELSIF ret_code_exist(REC.SPD_PDC_CODE ,'S') = 1 then
    -- CHECK POLYGAMOUS FIRST 
      
      IF IS_POLYGAMOUS(rec.spd_per_id) = 'Y' THEN
        NOSTRO:=1227.86;
      ELSE
        NOSTRO:=2455.72;
      END IF;

        nostro_jan := 1;
        n_jan:=1;
        if rec.clm_fdate<to_date('01-JAN-2021','DD-MON-YYYY') then
          select count(*) into nostro_dec from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202012 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no ;        
          if nostro_dec = 0 then
             n_dec:=1;
          end if;      
        end if; 
        if nostro_dec = 0 then       
          if rec.clm_fdate<to_date('01-DEC-2020','DD-MON-YYYY') then
            select count(*) into nostro_nov from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202011 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no ;        
            if nostro_nov = 0 then
               n_nov:=1;
            end if;      
          end if;
          if nostro_nov = 0 then
          if rec.clm_fdate<to_date('01-NOV-2020','DD-MON-YYYY') then
            select count(*) into nostro_oct from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202010 and mpd_pdc_code='0988' and mpd_clm_no=rec.spd_clm_no ;        
            if nostro_oct = 0 then
               n_oct:=1;
            end if;      
          end if;
          if  nostro_oct = 0 then 
          if rec.clm_fdate<to_date('01-OCT-2020','DD-MON-YYYY') then
            select count(*) into nostro_sep from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_period=202009 and mpd_pdc_code='3001' and mpd_clm_no=rec.spd_clm_no ;        
            if nostro_sep = 0 then
               n_sep:=1;
            end if;      
          end if;
          
          if  nostro_sep = 0 then 
            if rec.clm_fdate<to_date('01-SEP-2020','DD-MON-YYYY') then        
              select count(*) into nostro_aug from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and mpd_clm_no=rec.spd_clm_no and 
              ((mpd_period=202008 and mpd_voucher like '%ALLOW%') OR (mpd_period=202009 and mpd_voucher like '%ARREAR%AUG%'));          
              if nostro_aug = 0 then -- complete only when was no payments
                  n_aug:=1;
              end if;
            end if;     
            if nostro_aug = 0 then 
              if rec.clm_fdate<to_date('01-AUG-2020','DD-MON-YYYY') then
                select count(*) into nostro_jul from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and mpd_clm_no=rec.spd_clm_no and 
                      ((mpd_period=202007 and mpd_voucher like '%ALLOW%') OR (mpd_period in (202008,202009) and mpd_voucher like '%ARREAR%JUL%')); 
                if nostro_jul =0 then                
                  n_jul:=1;
                end if;
              end if;
              if nostro_jul =0 then   
                if rec.clm_fdate<to_date('01-JUL-2020','DD-MON-YYYY') then
                  select count(*) into nostro_jun from pay_mpay_ded where mpd_per_id=rec.spd_per_id and mpd_pdc_code='3001' and --mpd_clm_no=rec.spd_clm_no and --omitted due summarizing by nostro this month
                        ((mpd_period=202006 and mpd_voucher like '%ALLOW%') OR (mpd_period in (202007,202008,202009) and mpd_clm_no=rec.spd_clm_no and mpd_voucher like '%ARREAR%JUN%'));
                  if nostro_jun=0 then
                    n_jun:=1;  
                  end if;          
                end if;
              end if;
            end if;
            end if;
        end if;
        end if;
      end if;  
    END IF;
    
      IF NOSTRO > 0 THEN  
        if n_jan > 0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'COVID-19 ALLOWANCE',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        ); 
        end if;       
        if n_dec > 0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS DEC 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        ); 
        end if; 
        if n_nov>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS NOV 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if; 
        if n_oct>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS OCT 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if;        
        if n_sep>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS SEP 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if;
        if n_aug>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS AUG 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if;
        if n_jul>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS JULY 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if;  
        if n_jun>0 then           
           INSERT INTO PAY_MPAY_DED(
                        MPD_CLM_NO,
                        MPD_NID,
                        MPD_BENID,
                        MPD_AMT,
                        MPD_PDC_CODE,
                        MPD_PERIOD,
                        MPD_PAYDAY,
                        MPD_REFNO,
                        MPD_VOUCHER,
                        MPD_CUSER,
                        MPD_CDATE,
                        MPD_PER_ID,
                        MPD_CLC_CODE,
                        MPD_CLT_CODE,
                        MPD_FDATE,
                        MPD_TDATE,
                        MPD_PDC_PDT_CODE,
                        MPD_CLM_SERIAL,
                        SEQ,
                        MPD_AUDIT,
                        MPD_UPDT) 
      
                        VALUES(
                        REC.SPD_CLM_NO,
                        REC.SPD_NID,
                        REC.SPD_BENID,
                        NOSTRO,
                        '0988',
                        202101,
                        '24-JAN-2021',
                        NULL,
                        'ARREARS JUNE 2020',
                        'PENSION',
                        SYSDATE,
                        REC.SPD_PER_ID,
                        REC.SPD_CLC_CODE,
                        REC.SPD_CLT_CODE,
                        '01-JAN-2021',
                        '31-JAN-2021',
                        REC.SPD_PDC_PDT_CODE,
                        REC.SPD_CLM_SERIAL,
                        NULL,
                        'Y',
                        'Y'
                        );  
        end if; 
      END IF;
      
  COMMIT; 
   
END LOOP;
END;


--SUMMARIZE CHILDREN NOSTRO
BEGIN
  FOR REC2 IN (SELECT COUNT(*) CNT,MPD_AMT,MPD_PER_ID,MPD_FDATE,MPD_VOUCHER,MPD_CLM_NO  FROM PAY_MPAY_DED WHERE MPD_PERIOD=202101 AND MPD_PDC_CODE='0988' AND MPD_AMT=409.29
              GROUP BY MPD_PER_ID,MPD_AMT,MPD_FDATE,MPD_CLM_NO,MPD_VOUCHER HAVING COUNT(*) >1)
  LOOP
    UPDATE PAY_MPAY_DED SET MPD_AMT=REC2.CNT*REC2.MPD_AMT WHERE MPD_PERIOD=202101 AND MPD_PER_ID=REC2.MPD_PER_ID AND MPD_PDC_CODE='0988' AND MPD_AMT=409.29 AND MPD_CLM_NO=REC2.MPD_CLM_NO 
    AND MPD_FDATE=REC2.MPD_FDATE AND MPD_VOUCHER=REC2.MPD_VOUCHER AND ROWNUM=1;
    DELETE FROM PAY_MPAY_DED WHERE MPD_PERIOD=202101 AND MPD_PER_ID=REC2.MPD_PER_ID AND MPD_PDC_CODE='0988' AND MPD_FDATE=REC2.MPD_FDATE AND MPD_AMT=409.29 AND  MPD_CLM_NO=REC2.MPD_CLM_NO  
    AND MPD_VOUCHER=REC2.MPD_VOUCHER;
    
    COMMIT;
    
  END LOOP;
END;


--ADD INTO ED HISTORY - ALL NOSTRO PAYMENTS
DECLARE
  PID VARCHAR2(20);
  VOUCHER VARCHAR2(40);
  
BEGIN
  FOR REC IN (SELECT MPD_PER_ID, MPD_AMT,MPD_VOUCHER from PAY_MPAY_DED WHERE MPD_PERIOD=202010 AND MPD_PDC_CODE='0988')    
  LOOP
    
    PID:=REC.MPD_PER_ID;
    
    IF REC.MPD_VOUCHER = 'ARREARS JUNE 2020' THEN
      VOUCHER:='FROM 01-JUN-2020 TO 30-JUN-2020';
    ELSIF REC.MPD_VOUCHER = 'ARREARS JULY 2020' THEN
      VOUCHER:='FROM 01-JUL-2020 TO 31-JUL-2020';
    ELSIF REC.MPD_VOUCHER = 'ARREARS AUG 2020' THEN
      VOUCHER:='FROM 01-AUG-2020 TO 31-AUG-2020';
    ELSIF REC.MPD_VOUCHER = 'ARREARS SEP 2020' THEN
     VOUCHER:='FROM 01-SEP-2020 TO 30-SEP-2020';
    ELSE
     VOUCHER:='FROM 01-OCT-2020 TO 31-OCT-2020';
    END IF;
    
    INSERT INTO ED_HISTORY(
    EMPLOYEE_NUMBER,
    EDCODE,
    TYPE,
    AMOUNT,
    REFERENCE,
    TR_COMMENT,
    TR_COMMENT2,
    START_DATE,
    END_DATE,
    PERIOD_NO,
    TPD_AMT,
    YTD_AMT) 
    
    VALUES(REC.MPD_PER_ID,
    988,
    'A',
    REC.MPD_AMT,
    '*',
    'COVID-19 ALLOWANCE',
    VOUCHER,
    '01-OCT-2020',
    '31-OCT-2020',
    214,
    REC.MPD_AMT,
    REC.MPD_AMT
    );
    
    UPDATE ED_HISTORY
    SET TPD_AMT=TPD_AMT+REC.MPD_AMT,
    YTD_AMT=YTD_AMT+REC.MPD_AMT
    WHERE EMPLOYEE_NUMBER=REC.MPD_PER_ID
    AND START_DATE = '01-OCT-20'
    AND PERIOD_NO = 214
    AND EDCODE IN (9005,9970,9990);
    
    COMMIT;
    
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERROR '||PID||'-'|| SQLERRM);
  ROLLBACK;
END;

--ADJUSTING YTD AMOUNTS FOR OLD 3001
declare
  sm number(26,2):=0;
BEGIN
for rec1 in (select distinct EMPLOYEE_NUMBER FROM ED_HISTORY partition (END_DATE_2020) where EDCODE=3001) loop
  sm:=0;
  FOR REC IN (SELECT EMPLOYEE_NUMBER,AMOUNT,TPD_AMT,PERIOD_NO,rowid FROM ED_HISTORY partition (END_DATE_2020) H 
  WHERE EMPLOYEE_NUMBER=rec1.EMPLOYEE_NUMBER AND EDCODE=3001 ORDER BY EMPLOYEE_NUMBER,period_no) LOOP
    sm:=sm+rec.AMOUNT;
    
    UPDATE ED_HISTORY 
    SET YTD_AMT=sm 
    where EMPLOYEE_NUMBER=REC.EMPLOYEE_NUMBER AND 
    period_no=rec.period_no
    and EDCODE=3001 and rowid=rec.rowid;
    
    COMMIT;
  END LOOP;
end loop;
END;


--EXTRACT NEW APPTS STARTED FROM OCT 2020 + COVID AMOUNTS
SELECT W.*,
(SELECT SUM(MPD_AMT) FROM PAY_MPAY_DED M WHERE M.MPD_PER_ID=W.spd_per_id AND MPD_PDC_CODE='3001' AND MPD_CLM_NO="CLAIM NO" and M.MPD_PDC_PDT_CODE=w.spd_pdc_pdt_code) "NOSTRO USD ALLOWANCE",
(SELECT SUM(MPD_AMT) FROM PAY_MPAY_DED M WHERE M.MPD_PER_ID=W.spd_per_id AND M.MPD_PERIOD=202010 AND MPD_PDC_CODE='0988' AND MPD_CLM_NO="CLAIM NO" AND MPD_VOUCHER='ARREARS JUNE 2020') "ARREARS JUNE 2020",
(SELECT SUM(MPD_AMT) FROM PAY_MPAY_DED M WHERE M.MPD_PER_ID=W.spd_per_id AND M.MPD_PERIOD=202010 AND MPD_PDC_CODE='0988' AND MPD_CLM_NO="CLAIM NO" AND MPD_VOUCHER='ARREARS JULY 2020') "ARREARS JULY 2020",
(SELECT SUM(MPD_AMT) FROM PAY_MPAY_DED M WHERE M.MPD_PER_ID=W.spd_per_id AND M.MPD_PERIOD=202010 AND MPD_PDC_CODE='0988' AND MPD_CLM_NO="CLAIM NO" AND MPD_VOUCHER='ARREARS AUG 2020') "ARREARS AUG 2020",
(SELECT SUM(MPD_AMT) FROM PAY_MPAY_DED M WHERE M.MPD_PER_ID=W.spd_per_id AND M.MPD_PERIOD=202010 AND MPD_PDC_CODE='0988' AND MPD_CLM_NO="CLAIM NO" AND MPD_VOUCHER='ARREARS SEP 2020') "ARREARS SEP 2020",
(SELECT SUM(MPD_AMT) FROM PAY_MPAY_DED M WHERE M.MPD_PER_ID=W.spd_per_id AND M.MPD_PERIOD=202010 AND MPD_PDC_CODE='0988' AND MPD_CLM_NO="CLAIM NO" AND MPD_VOUCHER='COVID-19 ALLOWANCE') "COVID-19 ALLOWANCE"
FROM (
select DISTINCT a.*,PER_NID "NATIONAL ID",PER_SURNAME "SURNAME",PER_FNAME "FIRST NAMES",(select MAX(clm_fdate) from clm_claim where clm_no="CLAIM NO") "CLAIM FROM DATE",
TO_CHAR("PAY FROM DATE",'YYYYMM') "PAY PERIOD"
from (
select spd_per_id ,spd_pdc_code "CODE",spd_clm_no "CLAIM NO",SPD_AMT,spd_pdc_pdt_code,
(SELECT MIN(O.SPD_FDATE) FROM PAY_SPAY_DED O WHERE SPD_PER_ID=S.SPD_PER_ID AND O.SPD_PDC_CODE=S.SPD_PDC_CODE 
AND O.SPD_CLM_NO=S.spd_clm_no AND O.SPD_BENID=S.SPD_BENID) "PAY FROM DATE"
from pay_spay_ded s
where spd_tdate IS NULL 
and spd_audit='Y' 
and spd_updt='Y' 
AND SPD_AMT > 0.01
AND spd_pdc_code in (select pdc_code from REF_PDCODE where PDC_PDFLAG='P')
) A,PER_PERSON P
WHERE P.PER_ID=A.spd_per_id
and per_dod is null 
and nvl(per_suspended,'N') != 'Y' 
and PER_PAYSTOP is null
AND "PAY FROM DATE" >=TO_DATE('01-OCT-2020','DD-MON-YYYY')) W
GROUP BY spd_per_id , "CODE", "CLAIM NO",SPD_AMT,spd_pdc_pdt_code,
 "PAY FROM DATE","NATIONAL ID", "SURNAME", "FIRST NAMES", "CLAIM FROM DATE","PAY PERIOD";
 
--REMOVE ALL DATA BY CODE
declare
VOUCHER varchar2(40);
begin
  for rec in (select * from pay_mpay_ded where mpd_period=202010 and mpd_pdc_code='0988') loop
    VOUCHER:='*';
    
    IF REC.MPD_VOUCHER = 'ARREARS JUNE 2020' THEN
      VOUCHER:='FROM 01-JUN-2020 TO 30-JUN-2020';
    ELSIF REC.MPD_VOUCHER = 'ARREARS JULY 2020' THEN
      VOUCHER:='FROM 01-JUL-2020 TO 31-JUL-2020';
    ELSIF REC.MPD_VOUCHER = 'ARREARS AUG 2020' THEN
      VOUCHER:='FROM 01-AUG-2020 TO 31-AUG-2020';
    ELSIF REC.MPD_VOUCHER = 'ARREARS SEP 2020' THEN
      VOUCHER:='FROM 01-SEP-2020 TO 30-SEP-2020';
    ELSE
      VOUCHER:='FROM 01-OCT-2020 TO 31-OCT-2020';
    END IF;
   
    if VOUCHER != '*' then
      delete from ed_history where employee_number=rec.mpd_per_id and period_no=214 and edcode=988 and amount=rec.mpd_amt and TR_COMMENT2=VOUCHER and rownum=1;
      if sql%rowcount > 0 then
        delete from pay_mpay_ded where mpd_per_id=rec.mpd_per_id and mpd_period=202010 and mpd_pdc_code='0988' and MPD_VOUCHER=REC.MPD_VOUCHER and mpd_amt=rec.mpd_amt and rownum=1;
        UPDATE ED_HISTORY
          SET TPD_AMT=TPD_AMT-REC.MPD_AMT,
          YTD_AMT=YTD_AMT-REC.MPD_AMT
          WHERE EMPLOYEE_NUMBER=REC.MPD_PER_ID
          AND START_DATE = '01-OCT-20'
          AND PERIOD_NO = 214
          AND EDCODE IN (9005,9970,9990);
      end if;
      commit;
    end if;
  end loop;
end;

--EXTRACT CLAIMS OPENED IN DIFF DATES (SPOUSE AND CHILDREN ADDED LATER ETC)
SELECT SPD_PER_ID,SPD_CLM_NO,FROM_DATE,COUNT(*) FROM (
SELECT PER_ID,per_left,SPD_FDATE,SPD_CLM_NO,SPD_NID,SPD_BENID,SPD_PER_ID,SPD_PDC_CODE,SPD_CLC_CODE,SPD_CLT_CODE,SPD_PDC_PDT_CODE,SPD_CLM_SERIAL,
(SELECT MIN(O.SPD_FDATE) FROM PAY_SPAY_DED O WHERE SPD_PER_ID=S.SPD_PER_ID AND O.SPD_PDC_CODE=S.SPD_PDC_CODE AND O.SPD_CLM_NO=S.SPD_CLM_NO AND O.SPD_BENID=S.SPD_BENID) FROM_DATE
FROM PER_PERSON,PAY_SPAY_DED S WHERE SPD_PER_ID=PER_ID 
and per_dod is null and nvl(per_suspended,'N') != 'Y' and PER_PAYSTOP is null
and spd_tdate IS NULL and spd_audit='Y' and spd_updt='Y' AND SPD_AMT > 0.01 and spd_fdate = to_date('01-JAN-2021','DD-MON-YYYY')
and spd_pdc_code in ('0101','0002','0003','0004','0005','0006','0007','0008','0009','0010','0012','0015','0016',
      '0017','0018','0019','0021','0026','0027','0031','0032','0033','0034','0041','0042','0043',
      '0044','0045','0046','0047','0050','0062','0065','0066','0067','0092','0095','0096','0097',
      '0151','0152','0153','0158','0159','0161','0181','0182','0183','0184','0201','0202','0203',
      '0204','0230','0232','0231','0233','0141','0142','0143','0144','0145','0198','0281',
      '0162','0163','0164','0165','0215','0216','0217','0218','0220','0223','SFRPEN','SFFPEN','0291','0281','0142','SPGRAT','SPREF',
      'P_PEN','VTPEN','PEN','1135','1145','1139','1149','WVPDCD','SFCGRT',
      '1130','1131','1132','1133','1134','1137','1138','1230','1231','1232','1233','1234','1237','1238','1140','1141','1142','1143','1144','1147',
      '1148','1220','1221','1222','1223','1224','1227','1228','IODSM',
      '1136','1236','1146','1246','1190','1120',
      --all ownrights codes adjusted
      'CAAM','0156','1124',
      'IODSA','0196','0195','1294','1293','IECARR','1235',
      '0227','0118','0082','0083','0084','0085','0106','0101','0120','0121',
      '0086','0087','0088','0089','0112','0113','0115','0116','0117',
      '0114','0118','0119','DSPSB','0096','S_CPEN',    
      'P_CPEN',    
      'V_CPEN',    
      '1165','1169','1255','1275','1239','1240','CA_MON',    
      '1160','1161','1162','1163','1164','1167',
      '1248','1249','1250','1251','1252','1253','1254','DODDM',
      '1241','1242','1243','1244','1245','1246','1247',
      '1268','1269','1270','1271','1272','1273','1274',    
      '1166',    
      'D_CPEN','N_CPEN',
      --adjusted children codes
      '0122','0053','0057','0062','0052','0054','0055',
		'0056','0058','0059','0076','0079','0236','0237','0197','0218','0217','0215'
		,'0216','0211','0212','0223','0213','0214','0220','SPAB','SPSB'
		,'S_SPEN','S_SBEN','0174','0173','0172','0175','0176','0178','0177','0050','0071','0072',
    'P_SPEN','V_SPEN','1155','1159','1150','1151','1152','1154','1153','1157','1158',
    '1156','D_WPEN','N_SPEN',
    -- spouses codes adjusted
    '0069'
      ))
      WHERE "FROM_DATE"<to_date('01-JAN-2021','DD-MON-YYYY')
      HAVING COUNT(*)>1
      GROUP BY SPD_PER_ID,SPD_CLM_NO,FROM_DATE;


 
SELECT COUNT(*) FROM PAY_MPAY_DED WHERE MPD_PERIOD=202101 AND MPD_PDC_CODE='0988';--187085
SELECT SUM(MPD_AMT) FROM PAY_MPAY_DED WHERE MPD_PERIOD=202101 AND MPD_PDC_CODE='0988';
--431363272.85
--431404986.272697131594807225579463459173
--432373359.49 PROD
SELECT SUM(MPD_AMT/2455.72*2450.22) FROM PAY_MPAY_DED WHERE MPD_PERIOD=202101 AND MPD_PDC_CODE='0988';
--2450.22 nov
--2455.72 dec

--430459141.67
SELECT COUNT(*) FROM ed_history WHERE pERIOD_no=217 AND edCODE=988;

SELECT COUNT(*),PERIOD_NO,EMPLOYEE_NUMBER,TR_COMMENT FROM ED_HISTORY WHERE PERIOD_NO BETWEEN 210 AND 214 AND EDCODE=3001
GROUP BY PERIOD_NO,EMPLOYEE_NUMBER,TR_COMMENT;
SELECT *FROM ED_HISTORY WHERE EMPLOYEE_NUMBER='BA00000444' AND EDCODE=3001;

select * from ED_HISTORY H WHERE EMPLOYEE_NUMBER='BA00000444' AND EDCODE=3001 ORDER BY EMPLOYEE_NUMBER,period_no;






