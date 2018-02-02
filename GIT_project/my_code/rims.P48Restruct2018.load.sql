--P48
set temporary option On_error = 'Continue';
drop table Restr.restruct_p48;
set temporary option On_error = 'Stop';

create table Restr.restruct_p48(
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
    balPrcNachOvr numeric(15,2) default 0, -- Начисленные %
    balPrcNachPayOvr numeric(15,2) default 0, -- Начисленные % к оплате
    balPrcNachProsOvr numeric(15,2) default 0, -- Начисленные % на просроченное тело
    balPrcNachProsPayOvr numeric(15,2) default 0, -- Начисленные % на просроченное тело к оплате
    balPrcProsOvr numeric(15,2) default 0, -- Просроченные %
    balPrcSomnOvr numeric(15,2) default 0, -- Сомнительные %
    
    BalanceCE1OrgPay numeric(15,2) default 0, -- Комиссия к оплате
    BalanceCE2Org numeric(15,2) default 0, -- Просроченная комиссия
    BalanceCE3Org numeric(15,2) default 0, -- Сомнительная комиссия

    BalFine numeric(15,2) default 0, -- Штраф по МКПБ

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
create hg index i1 on Restr.restruct_p48(ClientID);
create hg index i2 on Restr.restruct_p48(FIID);
create hg index i3 on Restr.restruct_p48(ContractID);
create hg index i4 on Restr.restruct_p48(MainFIID);
create hg index i5 on Restr.restruct_p48(INN);
create hg index i6 on Restr.restruct_p48(Ctype);
create hg index i7 on Restr.restruct_p48(Bank);
create hg index i8 on Restr.restruct_p48(ExAge);


insert into Restr.restruct_p48
location 'q3tower.q3tower' packetsize 4096
{
select 
    CType       ,
    Gr          ,
    DateStart   ,
    DateEnd     ,
    RefContract ,
    FIID        ,
    ContractID  ,
    MainFIID    ,
    Branch      ,
    bank        ,
    Currency    , 
    CurrencyISO , 
    ClientID    ,
    INN         ,
    ExAge       ,

    RATE        ,
    RATEFINE    ,

    balCredit   ,
    balCreditPay,
    balPCredit,
    balPrcNach,
    balPrcNachPay,
    balPrcNachPros,
    balPrcNachProsPay,
    balPrcPros,
    balPrcSomn,
    
    balCreditOvr,
    balCreditPayOvr,
    balPCreditOvr,
    balPrcNachOvr,
    balPrcNachPayOvr,
    balPrcNachProsOvr,
    balPrcNachProsPayOvr,
    balPrcProsOvr,
    balPrcSomnOvr,

    BalanceCE1OrgPay,
    BalanceCE2Org,
    BalanceCE3Org,

    BalFine,

    flAssetOff,
    GroupRisk,
    BalDate ,
    LimDate ,
    ExSum   ,
    Bal     ,
    BalPrc  ,
    Overdr  ,
    Lim     ,
    balcom  ,
    balall  
from dn030490rdj.restruct_p48
};
commit;

grant select on Restr.restruct_p48 to dn290906gas; commit;