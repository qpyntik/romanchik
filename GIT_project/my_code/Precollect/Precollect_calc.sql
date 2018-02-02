set temporary option On_error = 'Continue';
drop table TMP.tPreCollecttest20180119;
set temporary option On_error = 'Stop';

CREATE TABLE TMP.tPreCollecttest20180119
( 
    ClientID      bigint NULL,
    RefContract   char(25) primary key,
    Bank          char(2) NULL,
    ContractType  char(4) NULL,
    Currency      char(3) NULL,
    BalContract   numeric(15,2) NULL,
    BalDuty       numeric(15,2) NULL,
    currencyrate  smallint NULL,
    Productname   char(50) NULL,
    Reason        char(10) NULL,
    branch        char(4) NULL,
    firstdefault  tinyint NULL,
    EAST          tinyint NULL,
    Group_SMS_IVR char(2) NULL,
    CALL_22       tinyint NULL,
    SMS           tinyint NULL,
    IVR_bal       numeric(15,2) NULL,
    IVR           tinyint NULL,
    FP_bal        numeric(15,2) NULL,
    FP            tinyint NULL,
    F0_bal        numeric(15,2) NULL,
    F0            tinyint NULL,
    F_vint        numeric(15,2) NULL,
    Bal_22        numeric(15,2),
    DateCalcBal     date,
    fl_restr      tinyint,
    fl_firstpay   tinyint,
    fl_secondpay  tinyint,
    fl_effr	  char(12),
    score         numeric(10,6) NULL
);
commit;
CREATE LF INDEX Reason_LF ON TMP.tPreCollecttest20180119(Reason);
CREATE HG INDEX clientid_HG ON TMP.tPreCollecttest20180119(ClientID);
CREATE HG INDEX HG_clid_ref ON TMP.tPreCollecttest20180119(ClientID,RefContract);
CREATE LF INDEX bank_LF ON TMP.tPreCollecttest20180119(Bank);
commit;




-- Стартовый пул
insert into TMP.tPreCollecttest20180119(
  Clientid, 
  RefContract, 
  Bank, 
  ContractType, 
  Currency,
  BalContract, 
  BalDuty,
  Branch
)
select Clientid, 
      t1.RefContract, 
      t2.Bank, 
      t1.ContractType, 
      t1.Currency, 
      t1.BalContract, 
      t1.BalDuty,
      t2.Branch
from Credit.CrAllDet as t1
left join RM.tCards as t2 on t1.RefContract=t2.RefContract
where BalContract<0
and BalPrcEx+BalCreditEx>=0
and t2.Bank = 'PB'; -- добавили условие 2017-11-08 "берем только клиентов ПБ" 
commit;


update TMP.tPreCollecttest20180119
    set CurrencyRate = t2.ExRate
from TMP.tPreCollecttest20180119 as t1
join REF.tRefExRates as t2 on t1.Bank = t2.Bank 
                          and t1.Currency = t2.Currency;
commit;


update TMP.tPreCollecttest20180119
    set productname=trim(t2.productname)
from TMP.tPreCollecttest20180119 as t1
join REF.tProduct as t2 on t1.Bank=t2.Bank
                        and t1.ContractType=t2.ContractType;
commit;


update TMP.tPreCollecttest20180119
set Bal_22 = t2.balduty
from TMP.tPreCollecttest20180119 as t1
join credit.cralldet as t2 on t1.refcontract = t2.refcontract;
commit;

-- Проставление дефолта
update TMP.tPreCollecttest20180119
    set Reason='0';
commit;

--Проставление продуктов
update TMP.tPreCollecttest20180119
set Reason=trim(Reason)+'1'
from TMP.tPreCollecttest20180119 as t1
join RM.tCards  as t2 on t1.RefContract=t2.RefContract
--where t2.GR in ('UNI','UN_M','GOLD')
where trim(isnull(productname,'3d3')) not in ('КАРТА УНИВЕРСАЛЬНАЯ','КАРТА УНИВЕРСАЛЬНАЯ GOLD','Карта "Универсальная"','"Универсальная Голд"');
commit;

--add since 2016-05-23
update TMP.tPreCollecttest20180119
set Reason='0'
from TMP.tPreCollecttest20180119 as t1
join RM.tCards as t2 on t1.RefContract = t2.RefContract
where t1.Reason ='01'--что бы убрать дублирование с 1ым этапом;
and t2.GR='REST'; -- 
commit;



--Проставление пустого банка либо Латвии
Update TMP.tPreCollecttest20180119
set Reason = trim(Reason)+'2'
from TMP.tPreCollecttest20180119
where isnull(Bank,'PL')='PL';
commit;

--Проставление в двух банках

Update TMP.tPreCollecttest20180119
set Reason = trim(Reason)+'3'
from TMP.tPreCollecttest20180119 as t1
join (select Clientid
      from TMP.tPreCollecttest20180119
      group by Clientid 
      having count(distinct Bank)>1
    ) as t2 on t1.ClientId = t2.ClientID;
commit;

-- Проставление без идклиента
Update TMP.tPreCollecttest20180119
set Reason = trim(Reason)+'4'
from TMP.tPreCollecttest20180119
where isnull(ClientId,0)=0;
commit;

--Проставление клиентов которые уже на просрочке
update TMP.tPreCollecttest20180119
    set Reason=trim(Reason)+'5'
from TMP.tPreCollecttest20180119 as t1
join CREDIT.Expiration_Full as t2 on t1.ClientID = t2.ClientID;
commit;

--Проставление клиентов которые уже есть в движке
update TMP.tPreCollecttest20180119
    set Reason=trim(Reason)+'6'
from TMP.tPreCollecttest20180119 as t1
join ComEng.tEngineResult as t2 on t1.ClientID = t2.ClientID;
commit;



-- Проставление випов
update TMP.tPreCollecttest20180119
    set Reason=trim(Reason)+'v'
from TMP.tPreCollecttest20180119 as t1
join credit.VIP as t2
on t1.ClientID = t2.ClientID
where isVIP='Y';
commit;


-- Признак "умершие"
update TMP.tPreCollecttest20180119
    set Reason=trim(Reason)+'u'
from TMP.tPreCollecttest20180119 as t1
join RM.tBlackList as t2 on t1.clientid=t2.ClientID 
where t2.clkod=7;
commit;

--Признак работающие сотрудники ПБ
update TMP.tPreCollecttest20180119
    set Reason=trim(Reason)+'s'
from TMP.tPreCollecttest20180119 a
join lpar1.EMPLOYEE_DATA_RP b
on a.clientid = b.REP_CLID
where date_uv is null;
commit;

-- убрали клиентов Востока 2018-01-04
delete TMP.tPreCollecttest20180119
from TMP.tPreCollecttest20180119 as t1
join (
      select RefContract 
      from RM.tCards as t1
      join (
	    select distinct ECA_BRNM as branch 
	    from lpar1.BRNM_DATA_RP 
	    where FL_ATO ='Y'
	    ) as t2 
      on t1.Branch=t2.branch
      ) as t2 
on t1.RefContract =t2.RefContract;
commit;


--флаг первого платежа по реструктуризации
--add since 2016-05-20 http://rimsweb.pb.ua/tm2/index.php#/mainTaskTable?id=5978
Update TMP.tPreCollecttest20180119
set fl_restr =1
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t2.char_reference = t1.refcontract
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today()),01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today()),01)
) as t2 on t2.refcontract = t1.refcontract
and t1.bank!='MP';
commit;


Update TMP.tPreCollecttest20180119
set fl_restr =2
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
        --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-1,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-1,01-1)        
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =3
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
        --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-2,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-2,01-1)

) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =4
from TMP.tPreCollecttest20180119 as t1
join (
         select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-3,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-3,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			--add 2016-11-24
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =5
from TMP.tPreCollecttest20180119 as t1
join (
         select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-4,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-4,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			--add 2016-11-24
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =6
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-5,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-5,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			--add 2016-11-24
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;
---add 2017-07-21----------------------------------------------------------------
Update TMP.tPreCollecttest20180119
set fl_restr =7
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-6,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-6,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =8
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-7,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-7,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =9
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-8,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-8,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =10
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-9,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-9,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =11
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-10,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-10,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;

Update TMP.tPreCollecttest20180119
set fl_restr =12
from TMP.tPreCollecttest20180119 as t1
join (
        select distinct t1.refcontract
         --t1.ClientID
        from TMP.tPreCollecttest20180119 as t1
        join restr.restructdeal as t2 on t1.RefContract = t2.CHAR_REFERENCE
        --t1.ClientID = t2.Cust_id
        where date(t2.PROC_DAT_I) >=dateadd(mm,-1,ymd(year(today()),month(today())-11,01))
        and date(t2.PROC_DAT_I) <=ymd(year(today()),month(today())-11,01-1)
        and t1.RefContract = t2.CHAR_REFERENCE			
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP' and fl_restr is null;
commit;
-----------------------------------------------------------------------------------
Update TMP.tPreCollecttest20180119
set fl_restr =0
from TMP.tPreCollecttest20180119 
where fl_restr is null
and bank !='MP';
commit;


--флаг первого платежа по кредитной карте
Update TMP.tPreCollecttest20180119
set fl_firstpay =1
from TMP.tPreCollecttest20180119 as t1
join (
    select distinct t1.refcontract
    from TMP.tPreCollecttest20180119 as t1
    join RM.tCards as t2 on t2.refcontract = t1.refcontract
    --t1.ClientID=t2.ClientID
    where FirstBreakDate >=dateadd(mm,-1,ymd(year(today()),month(today()),01))
    and FirstBreakDate <=ymd(year(today()),month(today()),01)
    and bal <>0
    and t2.gr in ('UNI','UN_M','GOLD')
) as t2 on t2.refcontract = t1.refcontract
--t1.ClientId = t2.ClientID 
and t1.bank!='MP';
commit;

--флаг второго платежа по кредитной карте
select distinct t1.ClientID, t1.Bank, reason, t3.balduty, t1.balduty as balduty1, t1.RefContract 
into tmp.tSecondPay
from TMP.tPreCollecttest20180119 t1 
 join RM.tCards t2 on t1.RefContract = t2.RefContract 
 join credit.CrAllDet t3 on t1.RefContract = t3.RefContract 
where FirstBreakDate >=dateadd(mm,-2,ymd(year(today()),month(today()),01)) 
and FirstBreakDate <=dateadd(mm,-1,ymd(year(today()),month(today()),01)) 
and t3.balduty < case when t1.Bank in ('PB') then -50 end and t1.Bank in ('PB');
commit; 


Update TMP.tPreCollecttest20180119
set fl_secondpay =1
from TMP.tPreCollecttest20180119 as t1