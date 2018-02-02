/*
CREATE TABLE Restr.tsybridgecreditrestr
(
    CPNC        char(6),
    DLID        numeric(15,0),
    RefContract char(25),
    EOS_DLR     char(14),
    EOB_DLP     char(3),
    BOS_ND      char(21),
    BalStart    numeric(15,2),
    BalAll      numeric(15,2),
    BalBody     numeric(15,2),
    BalPrc      numeric(15,2),
    BalCom      numeric(15,2),
    BalFine     numeric(15,2),
    Bank        char(2),
    branch      char(4),
    TLCODE      char(2),
    BOS_PR_S    char(1),
    BIS         char(1),
    CType       char(10),
    Gr          char(5),
    currency    char(3),
    ExAge       integer,
    ClientID    unsigned int,
    RestructDTM date,
    flImplPledge    varchar(1),
    flSecondDeal    varchar(1),
PRIMARY KEY (CPNC,DLID,Bank)
);

--index

CREATE LF INDEX branch_i ON Restr.tsybridgecreditrestr(branch);
CREATE LF INDEX bnmn_i ON Restr.tsybridgecreditrestr(Bank);
CREATE HG INDEX dlid_i ON Restr.tsybridgecreditrestr(DLID);
CREATE HG INDEX cpnc_i ON Restr.tsybridgecreditrestr(CPNC);
CREATE HG INDEX EOS_DLR_i ON Restr.tsybridgecreditrestr(EOS_DLR);
commit;

grant select on Restr.tsybridgecreditrestr to dn290906gas; commit;
*/

truncate table Restr.tsybridgecreditrestr; commit;

insert into Restr.tsybridgecreditrestr
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
    flImplPledge,
    flSecondDeal 
from dn030490rdj.tSybridgeCredit
};
commit;