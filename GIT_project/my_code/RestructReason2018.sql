/*
CREATE TABLE RESTR.tReasonNotRestr
(
	DT        			date,
	clientid  			bigint,
	refcontract			char(25),
	Gr 					char(5),
	BalBody 			decimal(15,2),
	RefContractMore1	varchar(1) default 'N',
	IncorrectBranches	varchar(1) default 'N',
	--SYBNotLIFandLIU	varchar(1) default 'N',
	foreighCurrency		varchar(1) default 'N',
	BalBodyMore100000	varchar(1) default 'N',
	BalBodyLess1000		varchar(1) default 'N',
	CodeDead  			varchar(1) default 'N',
	Jur       			varchar(1) default 'N',
	NotResident			varchar(1) default 'N',
	Arest     			varchar(1) default 'N',
	BranchOfCrimea		varchar(1) default 'N',
	ATO       			varchar(1) default 'N',
	AlreadyRestr		varchar(1) default 'N',
	LimitOnZP 			varchar(1) default 'N',
	flImplPledge		varchar(1) default 'N',
	flSecondDeal    	varchar(1) default 'N',
PRIMARY KEY (DT,clientid,refcontract)
);
CREATE HG INDEX ref_hg ON restr.treasonnotrestr(refcontract);
CREATE HG INDEX id_hg ON restr.treasonnotrestr(clientid);
commit;

grant select on RESTR.tReasonNotRestr to dn290906gas; commit;
*/



truncate table RESTR._tClientsPullRestr;

-- загружаем клиентов с задолженностью (P48)
insert into RESTR._tClientsPullRestr (clientid, refcontract, fl)
select clientid, refcontract, 'P48' 
from Restr.restruct_p48 
where clientid is not null
and BalAll <= -100
and Bank = 'PB';
commit;


update RESTR._tClientsPullRestr
set t1.bank = t2.bank,
    t1.branch = t2.branch,
    t1.contractType = t2.cType,
    t1.gr = t2.gr,
    t1.currency = t2.currency,
    t1.BalAll = t2.BalAll,
    t1.BalBody = t2.BalBody,
    t1.ExAge = t2.ExAge
from RESTR._tClientsPullRestr as t1 
join Restr.restruct_p48 as t2 
on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract and t1.fl = 'P48' and t2.BalAll < 0 and t2.Bank = 'PB';
commit;


insert into RESTR._tClientsPullRestr (clientid, refcontract, fl)
select clientid, refcontract, 'SYB' 
from Restr.tsybridgecreditrestr 
where clientid is not null
and BalAll <= -100
and Bank = 'PB';
commit;


update RESTR._tClientsPullRestr
set t1.bank = t2.bank,
    t1.branch = t2.branch,
    t1.contractType = t2.CType,
    t1.gr = t2.gr,
    t1.currency = t2.currency,
    t1.BalAll = t2.BalAll,
    t1.BalBody = t2.BalBody,
    t1.ExAge = t2.ExAge
from RESTR._tClientsPullRestr as t1 
join Restr.tsybridgecreditrestr as t2 
on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract and t1.fl = 'SYB' and t2.BalAll < 0 and t2.Bank = 'PB';
commit;


-- заливаем в справочник отказов по рестре для расчета
insert into RESTR.tReasonNotRestr (DT, clientid, refcontract)
select distinct today(), clientid, refcontract
from RESTR._tClientsPullRestr
;
commit;

-- Удаляем клиентов, которые имеют несколько договоров с задолженностью (любой, в т.ч. и несписанной)
update RESTR.tReasonNotRestr 
set RefContractMore1 = 'Y'
from RESTR.tReasonNotRestr
where clientid in (
    select clientid 
    from RESTR._tClientsPullRestr 
    group by clientid
    having count(RefContract) > 1
);
commit;

update RESTR.tReasonNotRestr
	set t1.gr 		= t2.gr,
		t1.BalBody 	= t2.BalBody,
		t1.BalAll 	= t2.BalAll
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2 
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract;
commit;


-- проставляем флаги по бранчам, которые не на DNHY,DNWG,DNWJ,DNHJ
update RESTR.tReasonNotRestr 
	set t1.IncorrectBranches = 'Y'
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2 
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract 
	and t2.branch not in ('DNHY', 'DNWG', 'DNWJ', 'DNHJ')
    and t2.fl = 'P48';
commit;

/*
-- проставляем флаг, где тип сделки НЕ LIF/LIU
update RESTR.tReasonNotRestr 
	set t1.SYBNotLIFandLIU = 'Y'
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2 
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract 
join Restr.tsybridgecreditrestr as t3 
	on t2.clientid = t3.clientid and t3.refcontract = t2.refcontract
	and t3.EOB_DLP not in ('LIF', 'LIU')
    and t2.fl = 'SYB';
commit;
*/

-- проставляем флаг по валютным договорам
update RESTR.tReasonNotRestr 
	set t1.foreighCurrency = 'Y'
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2 
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract 
	and t2.currency not in ('980', 'UAH');
commit;

-- договора с сзадолженностью менее 1 000грн
update RESTR.tReasonNotRestr 
	set t1.BalBodyLess1000 = 'Y'
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2 
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract 
	and t2.BalBody > -1000;
commit;

-- договора с сзадолженностью свыше 100 000 грн
update RESTR.tReasonNotRestr 
	set t1.BalBodyMore100000 = 'Y'
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2 
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract 
	and t2.BalBody <= -100000;
commit;

-- умершие
update RESTR.tReasonNotRestr 
set CodeDead = 'Y'
from RESTR.tReasonNotRestr
where clientid in (
    select t1.clientid
    from RESTR._tClientsPullRestr as t1 
    join RM.tBlackList as t2 
    on t1.clientid = t2.clientid 
    and t2.clkod = 7
);
commit;

-- юр лица
select clientID
         into #jur
         from RM.tClientInfo
         where substring(inn, 8, 1) != ''
         and substring(inn, 9, 1) = ''; commit;  

update RESTR.tReasonNotRestr 
set Jur = 'Y'
from RESTR.tReasonNotRestr
where clientid in (
    select clientid 
    from #jur 
);
commit;

-- нерезиденты

SELECT ClientID
into #nerezid
FROM   rm.tclientinfo
WHERE countryres<>'UA' AND   bank in ('PB');
commit;

update RESTR.tReasonNotRestr 
set NotResident = 'Y'
from RESTR.tReasonNotRestr
where clientid in (
    select clientid 
    from #nerezid 
);
commit;


SELECT ClientID
into #arest
FROM msb.scpf
WHERE BSC_PR_S = 'T';
commit;

update RESTR.tReasonNotRestr 
set Arest = 'Y'
from RESTR.tReasonNotRestr
where clientid in (
    select clientid 
    from #arest 
);
commit;

drop table #nerezid;
drop table #arest;

-- крымские бранчи
create table #CrimeaBranches(branch char(4) primary key); commit;

insert into #CrimeaBranches
select distinct ECA_BRNM
from lpar1.BRNM_DATA_RP
where BBN_BNMN = 'PB'
and ECA_BRNR2 in ('КРЫМСКОЕ РУ (Г. СИМФЕРОПОЛЬ)','СЕВАСТОПОЛЬСКИЙ ФИЛИАЛ');
commit;

insert into #CrimeaBranches values('DNSE'); commit;
insert into #CrimeaBranches values('DNSI'); commit;
insert into #CrimeaBranches values('DNSZ'); commit;

update RESTR.tReasonNotRestr 
	set t1.BranchOfCrimea = 'Y'
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2 
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract 
	join #CrimeaBranches as t3 on t2.Branch = t3.Branch;
commit;

-- флаг зоны АТО
update RESTR.tReasonNotRestr 
set ATO = 'Y'
from RESTR.tReasonNotRestr
where clientid in (
    select t1.clientid
    from RESTR._tClientsPullRestr as t1
    join LPAR1.BRNM_DATA_RP as t2 on t2.ECA_BRNM = t1.branch
    and t2.BBN_BNMN = 'PB'
    and t2.FL_ATO='Y'
);
commit;

update RESTR.tReasonNotRestr 
set ATO = 'Y'
from RESTR.tReasonNotRestr
where clientid in (
    select t1.clientid
    from RESTR._tClientsPullRestr as t1
    join lpar1.CLID_DATA_RP as t2 on t2.rep_clid = t1.clientid
    and t2.BBN_BNMN = 'PB'
    and t2.FL_ATO_CRM='Y'
);
commit;

-- кому уже проводили рестр-ию
update RESTR.tReasonNotRestr 
set t1.AlreadyRestr = 'Y'
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract
	and t2.fl = 'SYB'
join Restr.tsybridgecreditrestr as t3 
	on t3.clientid = t2.clientid and t3.refcontract = t2.refcontract
	and t3.RestructDTM is not null;
commit;

-- по П48
update RESTR.tReasonNotRestr 
set AlreadyRestr = 'Y'
where gr in ('REST','RKST');
commit;

-- договора с  ctype='PDL1' и refcontractplat like 'SAMDP%'
update RESTR.tReasonNotRestr 
set t1.LimitOnZP = 'Y'
from RESTR.tReasonNotRestr as t1 
join RESTR._tClientsPullRestr as t2 
	on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract
	and t2.fl = 'P48'
join Restr.restruct_p48 as t3
	on t3.clientid = t2.clientid and t3.refcontract = t2.refcontract
	and t3.ctype='PDL1'
    and t3.RefContract  like 'SAMDP%';
commit;


-- Исключаем Авто, Ипотеку и Микро, которые имеют хоть один ДЗ со статусом, не равным 'S','B','K','I'
update RESTR.tReasonNotRestr 
	set t1.flImplPledge = 'Y'
from RESTR.tReasonNotRestr as t1 
join Restr.tsybridgecreditrestr as t2 
	on t1.clientid = t2.clientid 
	and t1.refcontract = t2.refcontract
where t2.flImplPledge = 'Y';
commit;

