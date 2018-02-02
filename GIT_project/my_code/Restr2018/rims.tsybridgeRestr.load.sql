/*
CREATE TABLE tmp.tSybridgeCreditRestr(
    CPNC char(6),
    DLID numeric(15,0),
    RefContract char(25),

    EOS_DLR char(14),
    EOB_DLP char(3),
    BOS_ND char(21),

    BalStart numeric(15,2),
    BalAll numeric(15,2),

    BalBody     numeric(15,2) default 0,--тело
    BalPrc      numeric(15,2) default 0,--проценты
    BalCom      numeric(15,2) default 0,--комиссия
    BalFine     numeric(15,2) default 0,--пеня

    Bank char(2),
    branch char(4),
    TLCODE char(2),
    BOS_PR_S char(1),
    BIS char(1),
    CType char(10),
    Gr char(5),
    currency char(3),
    ExAge integer,
    ClientID unsigned int,
    RestructDTM date,
    flImplPledge        varchar(1),
    primary key (DLID, CPNC, Bank)
);
commit;
create hg index cpnc_i on tmp.tSybridgeCreditRestr(cpnc);
create hg index dlid_i on tmp.tSybridgeCreditRestr(dlid);
create hg index EOS_DLR_i on tmp.tSybridgeCreditRestr(EOS_DLR);
create lf index branch_i on tmp.tSybridgeCreditRestr(branch);
create lf index bnmn_i on tmp.tSybridgeCreditRestr(Bank);

grant select on tmp.tSybridgeCreditRestr to dn290906gas; commit;
*/

truncate table tmp.tSybridgeCreditRestr; commit;

insert into tmp.tSybridgeCreditRestr
location 'q3tower.q3tower' packetsize 4096
{
select 
    CPNC,
    DLID,
    RefContract,
    EOS_DLR,
    EOB_DLP,
    BOS_ND,
    BalStart,
    BalAll,
    BalBody,
    BalPrc,
    BalCom ,
    BalFine,
    Bank,
    branch,
    TLCODE,
    BOS_PR_S,
    BIS,
    CType,
    Gr, 
    currency,
    ExAge,
    ClientID,
    RestructDTM,
    flImplPledge 
from dn030490rdj.tSybridgeCredit
};
commit;