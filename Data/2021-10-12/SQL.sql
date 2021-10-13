/* --------------------------------------
Data for Daniil
Version 2021-10-12 
----------------------------------------- */        
select 
r.DateStart as Date, 
c2systems.guid as StrategyId,
systemname as Name,
c2systems.startingcash as StartingCash,
r.Equity,
systemAgeDays.statval as AgeDays,
alpha.statval as Alpha,
beta.statval as Beta,
c2star.statval as C2Star,
cARdefault.statval as AnnReturn, 
correlation_to_sp500.statval as Correlation_SP500, 
dailyMaxLevMax.statval as DailyMaxLevMax,  
dailyMaxLevMean.statval as DailyMaxLevMean, 
deltaequityp30.statval as DeltaEquity30Days,
deltaequityp45.statval as DeltaEquity45Days,  
deltaequityp90.statval as DeltaEquity90Days,  
maxdrawdownPcnt.statval as MaxDrawdownPcnt, 
(select max(worstLossPercentEquity) from maxOpenLossDaily 
		where systemid = r.systemid
		and YYYYMMDD >= cast( date_format( adddate(r.DateStart, INTERVAL -45 DAY),'%Y%m%d') as UNSIGNED)
		and YYYYMMDD <= cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED)
) as maxworstLossPercentEquity045,
(select max(worstLossPercentEquity) from maxOpenLossDaily 
		where systemid = r.systemid
		and YYYYMMDD >= cast( date_format( adddate(r.DateStart, INTERVAL -90 DAY),'%Y%m%d') as UNSIGNED)
		and YYYYMMDD <= cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED)
) as maxworstLossPercentEquity090,
(select max(worstLossPercentEquity) from maxOpenLossDaily 
		where systemid = r.systemid
		and YYYYMMDD >= cast( date_format( adddate(r.DateStart, INTERVAL -180 DAY),'%Y%m%d') as UNSIGNED)
		and YYYYMMDD <= cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED)
) as maxworstLossPercentEquity180,
numtrades.statval as NumTrades,  
pcntMonthsProfit.statval as PcntMonthsProfitable, 
profitFactor.statval as ProfitFactor, 
jSharpe.statval as Sharpe,  
jSortino.statval as Sortino,
jCalmar.statval as Calmar,  
maxddPcnt180days.statval as MaxDrawdownPcnt180days,  
maxddPcnt365days.statval as MaxDrawdownPcnt365days,  
latesttradedaysago.statval as TradeDaysAgo,
shortOptionsCovered.statval as ShortOptionsCovered,
optionpercent.statval as OptionOercent
from ReturnsDataInIntervalsCleanedSkip090 r
join c2systems on c2systems.guid = r.systemid
join historical_stats_modern systemAgeDays on systemAgeDays.systemid=r.systemid and systemAgeDays.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and systemAgeDays.statname='systemAgeDays'
join historical_stats_modern alpha on alpha.systemid=r.systemid and alpha.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and alpha.statname='Alpha'
join historical_stats_modern beta on beta.systemid=r.systemid and beta.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and beta.statname='beta'
left join historical_stats_modern c2star on c2star.systemid=r.systemid and c2star.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and c2star.statname='c2star'
join historical_stats_modern correlation_to_sp500 on correlation_to_sp500.systemid=r.systemid and correlation_to_sp500.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and correlation_to_sp500.statname='correlation_to_sp500'
join historical_stats_modern cARdefault on cARdefault.systemid=r.systemid and cARdefault.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and cARdefault.statname='cARdefault'
join historical_stats_modern dailyMaxLevMax on dailyMaxLevMax.systemid=r.systemid and dailyMaxLevMax.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and dailyMaxLevMax.statname='dailyMaxLevMax'
join historical_stats_modern dailyMaxLevMean on dailyMaxLevMean.systemid=r.systemid and dailyMaxLevMean.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and dailyMaxLevMean.statname='dailyMaxLevMean'

-- Use left join in the following 2 to get systems dead before 180,365 days
left join historical_stats_modern maxddPcnt180days on maxddPcnt180days.systemid=r.systemid and maxddPcnt180days.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and maxddPcnt180days.statname='maxddPcnt180days'
left join historical_stats_modern maxddPcnt365days on maxddPcnt365days.systemid=r.systemid and maxddPcnt365days.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and maxddPcnt365days.statname='maxddPcnt365days'

-- Use left join in the following 3 to get systems dead before 30,45,90 days
left join historical_stats_modern deltaequityp30 on deltaequityp30.systemid=r.systemid and deltaequityp30.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and deltaequityp30.statname='deltaequityp30'
left join historical_stats_modern deltaequityp45 on deltaequityp45.systemid=r.systemid and deltaequityp45.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and deltaequityp45.statname='deltaequityp45'
left join historical_stats_modern deltaequityp90 on deltaequityp90.systemid=r.systemid and deltaequityp90.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and deltaequityp90.statname='deltaequityp90'

join historical_stats_modern maxdrawdownPcnt on maxdrawdownPcnt.systemid=r.systemid and maxdrawdownPcnt.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and maxdrawdownPcnt.statname='maxdrawdownPcnt'
join historical_stats_modern numtrades on numtrades.systemid=r.systemid and numtrades.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and numtrades.statname='numtrades'
join historical_stats_modern pcntMonthsProfit on pcntMonthsProfit.systemid=r.systemid and pcntMonthsProfit.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and pcntMonthsProfit.statname='pcntMonthsProfit'
join historical_stats_modern profitFactor on profitFactor.systemid=r.systemid and profitFactor.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and profitFactor.statname='profitFactor'
join historical_stats_modern jSharpe on jSharpe.systemid=r.systemid and jSharpe.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and jSharpe.statname='jSharpe'
join historical_stats_modern jSortino on jSortino.systemid=r.systemid and jSortino.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and jSortino.statname='jSortino'
join historical_stats_modern jCalmar on jCalmar.systemid=r.systemid and jCalmar.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and jCalmar.statname='jCalmar'
join historical_stats_modern latesttradedaysago on latesttradedaysago.systemid=r.systemid and latesttradedaysago.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and latesttradedaysago.statname='latesttradedaysago'
left join maxOpenLossDaily m on m.systemid=r.systemid and m.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED)
join historical_stats_modern shortOptionsCovered on shortOptionsCovered.systemid=r.systemid and shortOptionsCovered.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and shortOptionsCovered.statname='shortOptionsCovered'
join historical_stats_modern optionpercent on optionpercent.systemid=r.systemid and optionpercent.YYYYMMDD = cast( date_format(r.DateStart,'%Y%m%d') as UNSIGNED) and optionpercent.statname='optionpercent'

where r.DateStart >= "2018-01-08"
--  Without any of the following we get 7 days data
--  and mod( DATEDIFF(r.DateStart, "2017-12-25"), 14) = 0   -- "2017-12-25" is 14 days earlier to have 2018-01-08 in the data
--  and mod( DATEDIFF(r.DateStart, "2017-12-18"), 21) = 0  -- '2017-12-18' is 21 days earlier to have 2018-01-08 in the data
--  and mod( DATEDIFF(r.DateStart, "2017-12-11"), 28) = 0  -- '2017-12-11' is 28 days earlier to have 2018-01-08 in the data
-- and c2systems.guid = 13202557 -- extreme-os for debugging
order by 1, 2
limit 100000;
