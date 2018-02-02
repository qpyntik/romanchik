
drop table if exists dn030490rdj.tSybridgeCredit; commit;

CREATE TABLE dn030490rdj.tSybridgeCredit(
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
create hg index cpnc_i on dn030490rdj.tSybridgeCredit(cpnc);
create hg index dlid_i on dn030490rdj.tSybridgeCredit(dlid);
create hg index EOS_DLR_i on dn030490rdj.tSybridgeCredit(EOS_DLR);
create lf index branch_i on dn030490rdj.tSybridgeCredit(branch);
create lf index bnmn_i on dn030490rdj.tSybridgeCredit(Bank);


--CREATE PULL
insert into dn030490rdj.tSybridgeCredit(CPNC, DLID, BOS_PR_S, Bank, EOB_DLP)
select distinct BOS_CPNC, BDL_DLID, 'A', BBN_BNMN, EOB_DLP
from OPER.DLPB as t1
join OPER.CAPF as t2 on t2.ECA_BRNM = t1.ECA_BRNM
where BOS_PR_S='A' and bos_pr_viz='+'
and BDL_DLID is not NULL
and EOB_DLP in ('LIF', 'LIU')
;
commit;


update dn030490rdj.tSybridgeCredit
set RefContract = rtrim(CPNC) || '@' || DLID;
commit;


update dn030490rdj.tSybridgeCredit
set t1.EOS_DLR = t2.EOS_DLR,
    t1.Branch = t2.ECA_BRNM
from dn030490rdj.tSybridgeCredit as t1
join OPER.DLPB as t2 on t2.BDL_DLID=t1.DLID
                    and t2.BOS_PR_S = t1.BOS_PR_S
                    and t1.EOB_DLP = t2.EOB_DLP
                    and t2.BOS_CPNC=t1.CPNC
join OPER.CAPF as t3 on t3.ECA_BRNM = t2.ECA_BRNM
                    and t3.BBN_BNMN = t1.Bank;
commit;


update dn030490rdj.tSybridgeCredit
set t1.Currency=t2.EDL_CCY,
    t1.BalStart = t2.BDL_BAL_S,
    t1.TLCODE = t2.BTL_TLCODE,
from dn030490rdj.tSybridgeCredit as t1
join OPER.DLPB as t2 on t2.EOS_DLR = t1.EOS_DLR
                    and t2.BOS_CPNC = t1.CPNC
                    and t2.ECA_BRNM = t1.Branch
                     and t2.BOS_PR_S = t1.BOS_PR_S;
commit;

update dn030490rdj.tSybridgeCredit
set t1.BIS=t4.BSC_MN_BIS
from dn030490rdj.tSybridgeCredit as t1
join OPER.DMPB  as t3 on t3.ECA_BRNM = t1.Branch
                     and t3.EOS_DLR  = t1.EOS_DLR
                     and t3.EOB_DLP  = t1.EOB_DLP
join OPER.SCPF  as t4 on t4.BFL_FLMN = t3.BDM_D_FLMN
                     and t4.BSC_ACC  = t3.BDM_D_ACC
                     ;
commit;


update dn030490rdj.tSybridgeCredit
set 
    t1.BalBody = isnull(t2.BalBody,0),
    t1.BalPrc  = isnull(t2.BalPrc,0),
    t1.BalCom  = isnull(t2.BalCom,0),
    t1.BalFine = isnull(t2.BalFine,0)
from dn030490rdj.tSybridgeCredit as t1
join(
select t2.BBN_BNMN, BOS_CPNC, BDL_DLID, 
sum(
isnull(if BMO_D_BAL >0 then 0 else BMO_D_BAL endif, 0)
+isnull(if BMO_T_BAL >0 then 0 else BMO_T_BAL endif, 0)
) as BalBody,
sum(isnull(if BMO_O_BAL >0 then 0 else BMO_O_BAL endif, 0)
+isnull(if BMO_VN_BAL >0 then 0 else BMO_VN_BAL endif, 0)--просроченные проценты(списанные)
+isnull(if BMO_VP_BAL >0 then 0 else BMO_VP_BAL endif, 0)
+isnull(if BMO_P_BAL >0 then 0 else BMO_P_BAL endif, 0)
+isnull(if BMO_N_BAL >0 then 0 else BMO_N_BAL endif, 0)
+isnull(if BMO_N2_BAL >0 then 0 else BMO_N2_BAL endif, 0)
+isnull(if BMO_IN_BAL >0 then 0 else BMO_IN_BAL endif, 0)
+isnull(if BMO_IW_BAL >0 then 0 else BMO_IW_BAL endif, 0)
+isnull(if BMO_S_BAL >0 then 0 else BMO_S_BAL endif, 0)
+isnull(if BMO_S2_BAL >0 then 0 else BMO_S2_BAL endif, 0)
) as BalPrc,
sum(isnull(if BMO_RL_BAL >0 then 0 else BMO_RL_BAL endif, 0)
+isnull(if BMO_VI_BAL >0 then 0 else BMO_VI_BAL endif, 0)--просроч комиссия(списанная)
+isnull(if BMO_L_BAL >0 then 0 else BMO_L_BAL endif, 0)
+isnull(if BMO_L2_BAL >0 then 0 else BMO_L2_BAL endif, 0)
+isnull(if BMO_PL2_BAL >0 then 0 else BMO_PL2_BAL endif, 0)
+isnull(if BMO_RL2_BAL >0 then 0 else BMO_RL2_BAL endif, 0)
+isnull(if BMO_PL_BAL >0 then 0 else BMO_PL_BAL endif, 0)
) as BalCom,
sum(isnull(if t2.BMO_C_BAL >0 then 0 else BMO_C_BAL endif, 0)
+isnull(if t2.BMO_C2_BAL >0 then 0 else BMO_C2_BAL endif, 0)
+isnull(if BMO_CE_BAL >0 then 0 else BMO_CE_BAL endif, 0)
) as BalFine
from OPER.IQ_dlpb_morp as t2
join (
select BBN_BNMN, max(BMO_DAT_OD) as MaxDate 
from oper.IQ_dlpb_morp
group by BBN_BNMN
) as t3 on t3.BBN_BNMN = t2.BBN_BNMN
       and t3.MaxDate = t2.BMO_DAT_OD
group by t2.BBN_BNMN, t2.BOS_CPNC, t2.BDL_DLID) as t2 on t2.BOS_CPNC=t1.CPNC
                                                     and t2.BDL_DLID=t1.DLID
                                                     and t2.BBN_BNMN = t1.Bank;
commit;

update dn030490rdj.tSybridgeCredit
set BalAll = BalBody + BalPrc + BalCom + BalFine;
commit;


update dn030490rdj.tSybridgeCredit
set t1.ExAge=t2.Days
from dn030490rdj.tSybridgeCredit as t1
join BUREAU.Expiration_Syb as t2 on t2.BOS_CPNC=t1.CPNC
                                and t2.BDL_DLID=t1.DLID;
commit;


update dn030490rdj.tSybridgeCredit
set CType=
case 
    when substr(TLCODE, 1, 1) = 'A' then 'AUTO   '
    when BIS = 'M' then 'MICRO  '
    when BIS = 'A' then 'VIP    '
    when (TLCODE in ('FJ', 'FI', 'FH', 'FP') or substr(TLCODE, 1, 1) = 'G') then 'IPOTEKA'
    when BIS in ('2', 'C', 'K', 'N', 'J') then 'JUR    '
    when 
        ((TLCODE in ('PC', 'PK', 'PL', 'PP', 'PS', 'BA', 'BR', 'CR', 'DA', 'DR', 'KA', 'KE', 'KF', 'KL', 'KP', 'KS', 'LL', 'PR', 'TP', 'NN', 'NL', 'NP', 'CD', 'CC')
            or
        substr(TLCODE, 1, 1) in ('R', 'F', 'S'))
            and
        TLCODE Not In ('FI', 'FJ', 'FH', 'FP'))  then 'RASSR  '
end;
commit;


update dn030490rdj.tSybridgeCredit
set CType='OVER'
from dn030490rdj.tSybridgeCredit as t1
join OPER.DLPB as t2 on t2.BDL_DLID=t1.DLID and t2.EOB_DLP in ('LOF', 'LEF', 'LPF', 'LQF');
commit;


update dn030490rdj.tSybridgeCredit
set CType='LIMIT'
from dn030490rdj.tSybridgeCredit as t1
join OPER.DLPB as t2 on t2.BDL_DLID=t1.DLID and t2.EOB_DLP in ('L2F', 'LG1', 'LG2');
commit;


update dn030490rdj.tSybridgeCredit
set CType='RASSR  '
from dn030490rdj.tSybridgeCredit as t1
join OPER.C8PF as t2 on t2.EC8_CCY=t1.Currency
left join SAMSON_REF.tReferenceCurrExch as t3 on t3.Currency = t2.EC8_R030
                                        and t3.BaseCurrency = '980'
                                        and t3.FIID = 'DN00'
                                        and t3.Branch = 'DNH0'
                                        and t3.RateID = 0
                                        and t3.DATEODB = (select max(DateODB) 
                                                          from SAMSON_REF.tReferenceCurrExch
                                                          where FIID = 'DN00')
where t1.CType is NULL
and BIS in ('3', 'R', 'L')
and (BalStart*(t3.SaleRate / t3.Unit))<=25000
and BalStart>0;
commit;


update dn030490rdj.tSybridgeCredit
set t1.Gr = t2.Product
from dn030490rdj.tSybridgeCredit as t1
join NBSM.N2_RefCreditProduct as t2 on t2.ContractDlpType = t1.TLCODE;
commit;


update dn030490rdj.tSybridgeCredit
set t1.ClientID=t2.BGF_CUS_ID
from dn030490rdj.tSybridgeCredit as t1
left join OPER.GFPF as t2 on t2.EGF_CPNC=t1.CPNC
left join OPER.BGPB as t3 on t3.EGF_CPNC=t1.CPNC;
commit;


update dn030490rdj.tSybridgeCredit
set t1.RestructDTM  = t2.BDR_DAT_M
from dn030490rdj.tSybridgeCredit    as t1
join OPER.DRPF              as t2   on t2.BDR_DLID = t1.DLID
                        and t2.BBN_BNMN = t1.Bank
join (select                        
    BDR_DLID, 
    BBN_BNMN,
    
    max(BDR_DAT_M) as max_BDR_DAT_M
      from OPER.DRPF
      group by BDR_DLID, 
    BBN_BNMN
      )                 as t3   on t3.BDR_DLID = t2.BDR_DLID
                        and t3.BBN_BNMN = t2.BBN_BNMN 
                        and t3.max_BDR_DAT_M = t2.BDR_DAT_M;
commit;


update dn030490rdj.tSybridgeCredit
set flImplPledge = 'Y'
from dn030490rdj.tSybridgeCredit as t0
join OPER.DLPB as t1 on t1.BDL_DLID = t0.DLID
                    and t1.BOS_CPNC = t0.CPNC
                    --and t1.BOS_PR_S='A' 
                    and t1.BOS_PR_VIZ='+'
join OPER.ZRPB as t2 on t2.BZR_REF=t1.EOS_DLR
join OPER.ZCPB as t3 on t3.BZC_CMR=t2.BZC_CMR
                    and t3.BZC_OBESP = 'ДЗ'
                    and t3.BZC_PR_S = 'A'
join OPER.ZLPB as t4 on t4.BZC_CMR=t3.BZC_CMR
                    and isnull(t4.BZL_I_STAT,'') not in ('S','B','K','I')
where t0.GR in ('AVTO','GIL','MICR');
commit;