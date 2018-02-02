--tower
create table #tRefTypesAll(
    bank char(2),
    Complex char(10),
    CType char(4),
    gr char(5)
);

insert into #tRefTypesAll
location 'RIMS.RIMS'
{
    select distinct bank, complex, ctype, gr from REF.tRefTypesRestruct
};


--P48
set temporary option On_error = 'Continue';
drop table dn030490rdj.restruct_p48;
set temporary option On_error = 'Stop';

create table dn030490rdj.restruct_p48(
    CType       char(4),
    Gr          char(5),
    DateStart   date,
    DateEnd     date,
    RefContract char(25) primary key,
    FIID        char(4),
    ContractID  unsigned bigint,
    MainFIID    char(4),
    Branch      char(4),
    bank        char(2),
    Currency    char(3), 
    CurrencyISO char(3), 
    ClientID    numeric(10),
    INN         char(12),
    ExAge       numeric(10) default 0,

    RATE numeric(5,2),
    RATEFINE numeric(5,2),

    balCredit numeric(15,2) default 0, -- Тело кредита
    balCreditPay numeric(15,2) default 0, -- Тело кредита к оплате
    balPCredit numeric(15,2) default 0, -- Просроченное тело кредита
    balPrcNach numeric(15,2) default 0, -- Начисленные %
    balPrcNachPay numeric(15,2) default 0, -- Начисленные % к оплате
    balPrcNachPros numeric(15,2) default 0, -- Начисленные % на просроченное тело
    balPrcNachProsPay numeric(15,2) default 0, -- Начисленные % на просроченное тело к оплате
    balPrcPros numeric(15,2) default 0, -- Просроченные %
    balPrcSomn numeric(15,2) default 0, -- Сомнительные %
    
    balCreditOvr numeric(15,2) default 0, -- Тело кредита
    balCreditPayOvr numeric(15,2) default 0, -- Тело кредита к оплате
    balPCreditOvr numeric(15,2) default 0, -- Просроченное тело кредита

    -- balprc:
    balPrcNachOvr numeric(15,2) default 0, -- Начисленные %                            
    balPrcNachPayOvr numeric(15,2) default 0, -- Начисленные % к оплате                  
    balPrcNachProsOvr numeric(15,2) default 0, -- Начисленные % на просроченное Тело   
    balPrcNachProsPayOvr numeric(15,2) default 0, -- Начисленные % на просроченное тело к оплате    
    balPrcProsOvr numeric(15,2) default 0, -- Просроченные %  
    balPrcSomnOvr numeric(15,2) default 0, -- Сомнительные %  
    
    -- balCom:
    BalanceCE1OrgPay numeric(15,2) default 0, -- Комиссия к оплате + balcom
    BalanceCE2Org numeric(15,2) default 0, -- Просроченная комиссия + balcom
    BalanceCE3Org numeric(15,2) default 0, -- Сомнительная комиссия + balcom

    BalFine numeric(15,2) default 0, -- Штраф по МКПБ + balcom

    flAssetOff  char(1) default 'B',
    GroupRisk char(2),
    BalDate date,
    LimDate date,
    ExSum   decimal(15,2),
    Bal     decimal(15,2),
    BalPrc  decimal(15,2),
    balBody  decimal(15,2),
    Lim     decimal(15,2),
    balcom  decimal(15,2),
    balall  decimal(15,2)
);
create hg index i1 on dn030490rdj.restruct_p48(ClientID);
create hg index i2 on dn030490rdj.restruct_p48(FIID);
create hg index i3 on dn030490rdj.restruct_p48(ContractID);
create hg index i4 on dn030490rdj.restruct_p48(MainFIID);
create hg index i5 on dn030490rdj.restruct_p48(INN);
create hg index i6 on dn030490rdj.restruct_p48(Ctype);
create hg index i7 on dn030490rdj.restruct_p48(Bank);
create hg index i8 on dn030490rdj.restruct_p48(ExAge);



--select * from dn030490rdj.restruct_p48


insert into dn030490rdj.restruct_p48(RefContract)
select distinct t1.refcontract
from SAMSON_BO.tContract as t1
join #tRefTypesAll as t2 on t2.CType = t1.ContractType 
                        and t2.Complex='P48' 
                        and t2.Bank = 'PB'
join SAMSON_BO.tContractInfo as t3 on t3.RefContract=t1.RefContract
left join OPER.C8PF as t4 on t4.EC8_R030 = t1.Currency
left join OPER.CAPF as t5 on t5.ECA_BRNM = t1.branch
where t1.State in('O','A','R','D','Z','U')-- состояние договора - открыто;
and t5.BBN_BNMN = 'PB'
and t1.branch <> 'DNWL';




update dn030490rdj.restruct_p48
set
    t1.CType = t2.CType,
    t1.Gr = t2.Gr,
    t1.DateStart = t3.DateCreate,
    t1.MainFIID = t3.MainFIID,   
    t1.Branch = t11.Branch,
    t1.Bank = t5.BBN_BNMN,
    t1.Currency = t11.Currency,
    t1.CurrencyISO = t4.EC8_CCY,
    t1.ClientID = t3.CLID,
    t1.INN = t3.INN,
    t1.FIID = t11.FIID,
    t1.ContractID = t11.ContractID,
    t1.GroupRisk = t3.GroupRisk
from dn030490rdj.restruct_p48 as t1
join SAMSON_BO.tContract as t11 on t11.RefContract = t1.RefContract
join #tRefTypesAll as t2 on t2.CType = t11.ContractType 
                        and t2.Complex='P48' 
                        and t2.Bank = 'PB'
join SAMSON_BO.tContractInfo as t3 on t3.RefContract=t1.RefContract
left join OPER.C8PF as t4 on t4.EC8_R030 = t11.Currency
left join OPER.CAPF as t5 on t5.ECA_BRNM = t11.branch
where t5.BBN_BNMN = 'PB'
;--Исключаются активы по картам на бранче  DNWL (продажа внешним коллекторам)
commit;

 
update dn030490rdj.restruct_p48
set t1.ExAge = Days
from dn030490rdj.restruct_p48 as t1
join BUREAU.Expiration_p48 as t2 on t2.RefContract = t1.RefContract
;
commit;

/*
-- удаляем тех, у кого просрочки нет и это не штраф
delete dn030490rdj.restruct_p48 as t1
from dn030490rdj.restruct_p48 as t1
left join #tRefTypesAll as t2 on t2.CType = t1.CType 
                             and t2.Complex='P48' 
                             and t2.Bank = t1.Bank
where t1.ExAge < 1 
and t2.CType is NULL
and t1.CType not in ('SHTR','SHTN');--штрафы попадают все
commit;
*/

update dn030490rdj.restruct_p48
set t1.ClientID = coalesce(t2.CLientID, t1.Clientid)
from dn030490rdj.restruct_p48 as t1
join rimsLoader.tCards as t2 
on t2.RefContract = t1.RefContract;
commit;


-- удаляем клиентов без айди
delete 
from dn030490rdj.restruct_p48
where isnull(ClientID, 0) = 0;
commit;


--update dn030490rdj.restruct_p48 set RATE = null, RATEFINE = null;
update dn030490rdj.restruct_p48
set t1.RATE = t3.Rate, -- Процентная ставка по договору  
    t1.RATEFINE = t3.RatePros  -- Процентная ставка по просрочке   
from dn030490rdj.restruct_p48 as t1
join SAMSON_REP.repSaldoCredit as t3 on t3.RefContract = t1.RefContract
                                    and t3.DateODB = (select max(DateODB) from SAMSON_REP.repSaldoCredit)
                                    and t3.SubTypeCredit like '1%';

update dn030490rdj.restruct_p48
set 
    t1.balCredit = isnull(t3.balCredit,0),   -- Тело кредита
    t1.balCreditPay = isnull(t3.balCreditPay,0),     -- Тело кредита к оплате
    t1.balPCredit = isnull(t3.balPCredit,0),     -- Просроченное тело кредита
    t1.balPrcNach = isnull(t3.balPrcNach,0),     -- Начисленные %
    t1.balPrcNachPay = isnull(t3.balPrcNachPay,0),   -- Начисленные % к оплате
    t1.balPrcNachPros = isnull(t3.balPrcNachPros,0),     -- Начисленные % на просроченное тело
    t1.balPrcNachProsPay = isnull(t3.balPrcNachProsPay,0),   -- Начисленные % на просроченное тело  к оплате
    t1.balPrcPros = isnull(t3.balPrcPros,0),     -- Просроченные %
    t1.balPrcSomn = isnull(t3.balPrcSomn,0)      -- Сомнительные %
from dn030490rdj.restruct_p48 as t1
join (
select t1.RefContract,
sum(isnull(t3.balCredit,0)) as balCredit,
sum(isnull(t3.balCreditPay,0)) as balCreditPay,
sum(isnull(t3.balPCredit,0)) as balPCredit,
sum(isnull(t3.balPrcNach,0)) as balPrcNach,
sum(isnull(t3.balPrcNachPay,0)) as balPrcNachPay,
sum(isnull(t3.balPrcNachPros,0)) as balPrcNachPros,
sum(isnull(t3.balPrcNachProsPay,0)) as balPrcNachProsPay,
sum(isnull(t3.balPrcPros,0)) as balPrcPros,
sum(isnull(t3.balPrcSomn,0)) as balPrcSomn
from dn030490rdj.restruct_p48 as t1
join SAMSON_REP.repSaldoCredit as t3 on t3.RefContract = t1.RefContract
                                    and t3.DateODB = (select max(DateODB) from SAMSON_REP.repSaldoCredit)
                                    and t3.SubTypeCredit like '1%'
                                    and t3.State = 'A'
group by t1.RefContract) as t3 on t3.RefContract = t1.RefContract;
commit;

update dn030490rdj.restruct_p48
set t1.balCreditOvr = isnull(t3.balCredit,0),    -- Тело кредита
    t1.balCreditPayOvr = isnull(t3.balCreditPay,0),  -- Тело кредита к оплате
    t1.balPCreditOvr = isnull(t3.balPCredit,0),  -- Просроченное тело кредита
    t1.balPrcNachOvr = isnull(t3.balPrcNach,0),  -- Начисленные %
    t1.balPrcNachPayOvr = isnull(t3.balPrcNachPay,0),    -- Начисленные % к оплате
    t1.balPrcNachProsOvr = isnull(t3.balPrcNachPros,0),  -- Начисленные % на просроченное тело
    t1.balPrcNachProsPayOvr = isnull(t3.balPrcNachProsPay,0),    -- Начисленные % на просроченное тело  к оплате
    t1.balPrcProsOvr = isnull(t3.balPrcPros,0),  -- Просроченные %
    t1.balPrcSomnOvr = isnull(t3.balPrcSomn,0)   -- Сомнительные %
from dn030490rdj.restruct_p48 as t1
join SAMSON_REP.repSaldoCredit as t3 on t3.RefContract = t1.RefContract
                                    and t3.DateODB = (select max(DateODB) from SAMSON_REP.repSaldoCredit)
                                    and t3.SubTypeCredit = '20'
                                    and t3.State = 'A';
commit;

update dn030490rdj.restruct_p48
set 
    t1.BalanceCE1OrgPay = t2.SumAmt
from dn030490rdj.restruct_p48 as t1
join(
select
t1.RefContract,
    sum(isnull(t3.balCredit,0))+
    sum(isnull(t3.balCreditPay,0))+
    sum(isnull(t3.balPCredit,0))+
    sum(isnull(t3.balPrcNach,0))+
    sum(isnull(t3.balPrcNachPay,0))+
    sum(isnull(t3.balPrcNachPros,0))+
    sum(isnull(t3.balPrcNachProsPay,0))+
    sum(isnull(t3.balPrcPros,0))+
    sum(isnull(t3.balPrcSomn,0)) as SumAmt
from dn030490rdj.restruct_p48 as t1
join SAMSON_REP.repSaldoCredit as t3 on t3.RefContract = t1.RefContract
                                    and t3.DateODB = (select max(DateODB) from SAMSON_REP.repSaldoCredit)
                                    and substr(t3.SubTypeCredit, 1, 1) = '3'
                                    and t3.State = 'A'
group by t1.RefContract) as t2 on t2.RefContract = t1.RefContract;
commit;



update dn030490rdj.restruct_p48
set t1.balFine = - (isnull(t2.Amount, 0) - isnull(t2.RealAmount, 0))
from dn030490rdj.restruct_p48 as t1
join samson_fo.tClaimsPenalty as t2 on t2.RefContract=t1.RefContract
                                   and t2.State='R';
commit;

delete 
from dn030490rdj.restruct_p48
where
  balCredit
+ balCreditPay
+ balPCredit
+ balPrcNach
+ balPrcNachPay
+ balPrcNachPros
+ balPrcNachProsPay
+ balPrcPros
+ balPrcSomn

+ balCreditOvr
+ balCreditPayOvr
+ balPCreditOvr
+ balPrcNachOvr
+ balPrcNachPayOvr
+ balPrcNachProsOvr
+ balPrcNachProsPayOvr
+ balPrcProsOvr
+ balPrcSomnOvr

+ BalanceCE1OrgPay
+ BalanceCE2Org
+ BalanceCE3Org >= 0;
commit;

update dn030490rdj.restruct_p48
set t1.DateEnd = t2.DateEnd
from dn030490rdj.restruct_p48 as t1
join SAMSON_REP.repSaldoCredit as t2 on t2.RefContract = t1.RefContract
                                    and t2.DateODB = (select max(DateODB) from SAMSON_REP.repSaldoCredit)
                                    and t2.DateEnd is not null;
commit;

update dn030490rdj.restruct_p48
set RATE = 22,
    RATEFINE = if isnull(RATEFINE,0) < 22 then 22 else RATEFINE endif
where GR = 'BAD';
commit;


update dn030490rdj.restruct_p48 
set RATE = RATE / 2
where CType in ('PPFT','REPL','EXIT','FORL','LOYL','UPGR','LOY1','MCWS','MCWL','WS55','WS05','INFI','INFA','INFL','MCWF','WS00','FREE'); commit;

update dn030490rdj.restruct_p48 
set RATE = isnull(RATE, 36),
    RATEFINE = isnull(RATEFINE, 36);
    commit;

--select RefContract,RATE,RATEFINE from dn030490rdj.restruct_p48 where RefContract = 'SAMDN08000007876038'
--flAssetOff
/*
B - балансовый актив (не списан, не находится на бранчах для приват-48 по бранчам DNHX, DNHY, DNWH, DNHJ, DNWJ, DNWG,DNWL по сайбриджу со счетами класса 8 и 9)
S - списан за счет страхования по приват-48 бранчи DNHX DNWH, по сайбриджу на клссах 8857*, 8962*, 8852*, 8853*, 8858*, 8859*, 8868*, 8869*
R - списан за счет резервов , приват-48 бранчи   DNHY, DNHJ, DNWJ, DNWG,по сайбридже счете 8 и 9 класса, кроме 8857*, 8962*, 8852*, 8853*, 8858*, 8859*, 8868*, 8869*
если бранч ANHY  - S
если ANHX   -R
*/


update dn030490rdj.restruct_p48 set flAssetOff = 'B' where branch not in('DNHX', 'DNHY', 'DNWH', 'DNHJ', 'DNWJ', 'DNWG', 'DNWL');
update dn030490rdj.restruct_p48 set flAssetOff = 'S' where branch in('DNHX', 'DNWH', 'ANHY');
update dn030490rdj.restruct_p48 set flAssetOff = 'R' where branch in('DNHY', 'DNHJ', 'DNWJ', 'DNWG', 'ANHX', 'TGHX','TGHY');
commit;

delete from dn030490rdj.restruct_p48 where branch in ('TGII', 'TGGX', 'TGH1', 'TGH2');
commit;

--- создание временной таблицы
create table #junior
(
    Refjun char(25),
    RefContract char(25),
    ClientId bigint
);
commit;


---добавление RefContract юниора, RefContract родителя(ист погашения), ID родителя
INSERT INTO #junior
SELECT distinct t6.RefContract, t1.RefContract, t2.ClientID
from    rimsLoader.dn030490rdj.restruct_p48 as t1
join    rimsLoader.tCards as t2 on t2.RefContract = t1.RefContract
join    PAN.tPAN as t3 on t3.PANAcc = t2.PANAcc
join    SAMSON_BO.tRepaymentSources as t4 on t4.PAN = t3.PAN and t4.Status = 'A'
join    SAMSON_BO.tContract as t5 on t5.ContractID = t4.ContractID and t5.FIID = t4.FIID
join    rimsLoader.tCards as t6 on t6.RefContract = t5.RefContract and t6.Gr = 'JUNI'
union
select distinct t6.RefContract, t1.RefContract, t2.ClientID
from    rimsLoader.dn030490rdj.restruct_p48 as t1
join    rimsLoader.tCards as t2 on t2.RefContract = t1.RefContract
join    PAN.tPAN as t3 on t3.PANAcc = t2.PANAcc
join    SAMSON_FO.tContractSources as t4 on t4.PAN = t3.PAN and t4.TypeSource='1'
                                       and t4.State='A'
                                       and t4.type='C'
join rimsLoader.tCards as t6 on t6.RefContract = t4.RefContract and t6.Gr = 'JUNI';
commit;


---удаление карт юниора без источника погашения
DELETE FROM dn030490rdj.restruct_p48
WHERE Gr = 'JUNI' and RefContract not in
(
    SELECT distinct p1.refjun FROM #junior as p1 
    JOIN rimsloader.tCards as p2 
    ON p1.Refjun = p2.RefContract 
    and p2.ClientID <> p1.ClientID
);
commit;

---добавление ID родителя карте юниора для реструктуризации в комплексе
UPDATE  dn030490rdj.restruct_p48 as t1
SET     t1.ClientID = t2.ClientID
FROM    (SELECT distinct p1.refjun, p1.ClientID FROM #junior as p1 JOIN rimsloader.tCards as p2 
         ON p1.Refjun = p2.RefContract and p2.ClientID <> p1.ClientID) as t2
WHERE   t2.refjun = t1.RefContract and t1.Gr = 'JUNI';
commit;


create variable  @MaxDate date; commit; 
set @MaxDate = (select max(DateODB) from SAMSON_REP.repSaldoCredit); commit;

update dn030490rdj.restruct_p48
set
    t1.BalDate = t2.DateODB,
    t1.LimDate = t2.DateODB,
    t1.ExSum = t2.ExSum,
    t1.Bal = t2.sumBody,
    t1.BalPrc = t2.sumPrc,
   -- t1.Overdr = t2.Overdr,
    t1.Lim = t2.Lim
from dn030490rdj.restruct_p48 as t1
join
(
select t2.DateODB, t1.RefContract,
    sum(t2.BalPCredit + t2.balPrcPros + t2.balPrcSomn) as ExSum,
    sum(t1.balCredit + t1.balCreditPay + t1.balPCredit) as sumBody,
   -- sum(t1.balPrcNach + t1.balPrcNachPay + t1.balPrcNachPros + t1.balPrcNachProsPay + t1.balPrcPros + t1.balPrcSomn) as sumPrc,
    sum(isnull(t1.balPrcNachOvr, 0) + isnull(t1.balPrcNachPayOvr, 0) + isnull(balPrcNachProsOvr, 0) + isnull(balPrcNachProsPayOvr, 0) + isnull(balPrcProsOvr, 0) + isnull(balPrcSomnOvr, 0)) as sumPrc,
 --   sum(if t2.SubTypeCredit like '2%' then t2.BalCredit + t2.BalPCredit + t2.BalCreditPay + t2.balPrcNachPay + t2.balPrcNachProsPay else 0 endif) as Overdr,
    max(if t2.SubTypeCredit like '1%' then t2.LimitBalance else 0 endif) as Lim
from dn030490rdj.restruct_p48 as t1
join SAMSON_REP.repSaldoCredit as t2 on t2.RefContract=t1.RefContract
                                    and t2.DateODB = @MaxDate
                                    and t2.State = 'A'
                                    and substr(t2.SubTypeCredit, 1, 1) in ('1', '2')
group by t2.DateODB, t1.RefContract) as t2 on t2.RefContract=t1.RefContract
;
commit;



update dn030490rdj.restruct_p48
set
    t1.balCom = t2.sumCom
from dn030490rdj.restruct_p48 as t1
join(
select t1.RefContract, 
        --sum(t1.balCredit + t1.balCreditPay + t1.balPCredit + t1.balPrcNach + t1.balPrcNachPay + t1.balPrcNachPros + t1.balPrcNachProsPay + t1.balPrcPros + t1.balPrcSomn) as sumCom
        sum(isnull(t1.BalanceCE1OrgPay, 0) + isnull(t1.BalanceCE2Org, 0) + isnull(t1.BalanceCE3Org, 0) + isnull(t1.BalFine, 0)) as sumCom
from dn030490rdj.restruct_p48 as t1
join SAMSON_REP.repSaldoCredit as t3 on t3.RefContract = t1.RefContract
                                    and t3.DateODB = @MaxDate
                                    and substr(SubTypeCredit, 1, 1) = '3'
                                    and t3.State = 'A'
group by t1.RefContract
) as t2 on t2.RefContract = t1.RefContract;
commit;

update dn030490rdj.restruct_p48
set balBody = isnull(balCredit, 0) + isnull(balPCredit, 0) + isnull(balCreditOvr, 0) + isnull(balPCreditOvr, 0);
commit;

update dn030490rdj.restruct_p48
--set balall = isnull(bal, 0)+isnull(balprc, 0)+isnull(balcom, 0)+isnull(balfine, 0);
set balall = 
            balCredit           + 
            balCreditPay        + 
            balPCredit          + 
            balPrcNach          + 
            balPrcNachPay       + 
            balPrcNachPros      + 
            balPrcNachProsPay   +
            balPrcPros          + 
            balPrcSomn          + 
            balCreditOvr        + 
            balCreditPayOvr     + 
            balPCreditOvr       + 
            balPrcNachOvr       +                         
            balPrcNachPayOvr    +                  
            balPrcNachProsOvr   + 
            balPrcNachProsPayOvr + 
            balPrcProsOvr       + 
            balPrcSomnOvr       + 
            BalanceCE1OrgPay    + 
            BalanceCE2Org       + 
            BalanceCE3Org       + 
            BalFine             
commit;
