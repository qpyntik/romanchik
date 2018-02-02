create table #ClientId (ClientID bigint primary key); 
commit;

insert into #ClientId 
location 'LPAR_1.lpar1' PACKETSIZE 10240 
{ 
select Clientid from RimsLoader.PreCollect_source
}; 
commit;

update TMP.tPreCollecttest20180119
    set Reason=trim(Reason)+'r'
from TMP.tPreCollecttest20180119 as t1
join #ClientId as t2 on t1.Clientid = t2.ClientID; 
commit;



update TMP.tPreCollecttest20180119
set score = t2.score
from TMP.tPreCollecttest20180119 as t1 
join score.scTransF as t2 on t1.Clientid = t2.ClientID
			      and t2.bank = t1.bank		--add 2017-01-25
where t2.DT = dateformat(today(), 'yyyy-mm-15'); 
commit; 


update  TMP.tPreCollecttest20180119
set firstdefault = 1 
from  TMP.tPreCollecttest20180119 as t1 
join LPAR1.DEFAULT_DATA_RP as t2 on t1.refcontract = t2.rep_ref
where t2.rep_fl_d1 = '1'; 
commit;


Update TMP.tPreCollecttest20180119
set fl_effr ='firstpay'
from TMP.tPreCollecttest20180119 as t1
join (
    select distinct t1.RefContract
    --t1.ClientId
    from TMP.tPreCollecttest20180119 as t1
    join RM.tCards as t2 on t1.RefContract =t2.RefContract
    --t1.ClientID=t2.ClientID
    where FirstBreakDate >=dateadd(mm,-1,ymd(year(today()),month(today()),01))
    and FirstBreakDate <=ymd(year(today()),month(today()),01)
    and bal <>0
    and t2.gr in ('UNI','UN_M','GOLD')
      ) as t2 on t1.RefContract =t2.RefContract
      --t1.ClientId = t2.ClientID 
     -- and t1.bank!='MP'	-- remove 2017-11-08. Reason: only PB
	and t1.bank= 'PB'	-- add 2017-11-08. Reason: only PB
and t1.fl_effr is null;
commit;


Update TMP.tPreCollecttest20180119
set fl_effr ='secondpay'
where fl_secondpay = 1;
commit;


--new since 2016-05-20 http://rimsweb.pb.ua/tm2/index.php#/mainTaskTable?id=5978

Update TMP.tPreCollecttest20180119
set fl_effr = case 
		when fl_restr= 1 then 'restr1'
		when fl_restr= 2 then 'restr2'
		when fl_restr= 3 then 'restr3'
		when fl_restr= 4 then 'restr4'
		when fl_restr= 5 then 'restr5'
		when fl_restr= 6 then 'restr6'
		when fl_restr= 7 then 'restr7'
		when fl_restr= 8 then 'restr8'
		when fl_restr= 9 then 'restr9'
		when fl_restr= 10 then 'restr10'
		when fl_restr= 11 then 'restr11'
		when fl_restr= 12 then 'restr12'
	      end
from TMP.tPreCollecttest20180119
--where bank !='MP'	-- remove 2017-11-08. Reason: only PB
where bank= 'PB'	-- add 2017-11-08. Reason: only PB
and fl_effr is null;
commit;


Drop table #ClientId;
commit;
