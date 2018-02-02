-- таблица с клиентами по новой рестре
create table tmp.testRestrNew20171115 
(
clientid    int not null,
refcontract varchar(20),
branch      varchar(5),
gr          varchar(10),
currency    varchar(3),
BalAll      decimal(15,2)
);
commit;

create table #P48
(
clientid    int not null,
refcontract varchar(20),
branch      varchar(5),
gr          varchar(10),
currency    varchar(3),
BalAll      decimal(15,2)
);
commit;

-- загружаем клиентов, у которых только 1 договор с задолженностью (P48)
insert into #P48 (clientid)
select clientid 
from RM.tCards 
where BalAll < 0
group by clientid
having count(RefContract) = 1;
commit;


update #P48
set t1.refcontract = t2.refcontract,
    t1.branch = t2.branch,
    t1.gr = t2.gr,
    t1.currency = t2.currency,
    t1.BalAll = t2.BalAll
from #P48 as t1 
join RM.tCards as t2 
on t1.clientid = t2.clientid and t2.BalAll < 0;
commit;


delete from #P48
where branch not in ('DNHY', 'DNWG', 'DNWJ', 'DNHJ');
commit;

delete from #P48
where currency not in ('980');
commit;

delete from #P48
where balall > -1000; commit;

delete from #P48
where balall < -100000; commit;


-- заливаем в таблицу клиентов из P48 
insert into tmp.testRestrNew20171115
select * from #P48;
commit;

update tmp.testRestrNew20171115
set currency = 'UAH'
where currency is not null;

UPDATE tmp.testRestrNew20171115
SET currency = replace(currency, '980', 'UAH');
commit;

---------------------------------------------------
---------------------------------------------------

create table #SYB
(
clientid    int not null,
refcontract varchar(20),
branch      varchar(5),
gr          varchar(10),
currency    varchar(3),
BalAll      decimal(15,2)
);
commit;

-- загружаем клиентов, у которых только 1 договор с задолженностью (SYB)
insert into #SYB (clientid)
select clientid 
from RM.tSybridgeCredit 
where BalAll < 0
group by clientid
having count(RefContract) = 1;
commit;


update #SYB
set t1.refcontract = t2.refcontract,
    t1.branch = t2.branch,
    t1.gr = t2.gr,
    t1.currency = t2.currency,
    t1.BalAll = t2.BalAll
from #SYB as t1 
join RM.tSybridgeCredit as t2 
on t1.clientid = t2.clientid and t2.BalAll < 0;
commit;


delete from #SYB
where currency not in ('UAH');
commit;

delete from #SYB 
where balall > -1000; commit;

delete from #SYB 
where balall < -100000; commit;

delete #SYB
from #SYB as t1 
join RM.tSybridgeCredit as t2
    on t1.clientid = t2.clientid and t1.refcontract = t2.refcontract
where t2.EOB_DLP not in ('LIF', 'LIU');
commit;

-- заливаем в таблицу клиентов из SYB 
insert into tmp.testRestrNew20171115
select * from #SYB;
commit;
-----------------------------------------------------
-----------------------------------------------------