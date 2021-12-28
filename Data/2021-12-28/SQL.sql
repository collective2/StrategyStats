CREATE OR REPLACE VIEW public.historicalstats01view
AS SELECT r.datestart AS date,
    c2systems.systemid AS strategyid,
    c2systems.systemname AS name,
    c2systems.startingcash,
    r.equity,
    systemagedays.statval AS agedays,
    alpha.statval AS alpha,
    beta.statval AS beta,
    c2star.statval AS c2star,
    cardefault.statval AS annreturn,
    correlation_to_sp500.statval AS correlation_sp500,
    dailymaxlevmax.statval AS dailymaxlevmax,
    dailymaxlevmean.statval AS dailymaxlevmean,
    deltaequityp30.statval AS deltaequity30days,
    deltaequityp45.statval AS deltaequity45days,
    deltaequityp90.statval AS deltaequity90days,
    maxdrawdownpcnt.statval AS maxdrawdownpcnt,
    ( SELECT max(maxopenlossdaily.worstlosspercentequity) AS max
           FROM maxopenlossdaily
          WHERE maxopenlossdaily.systemid = r.systemid AND maxopenlossdaily.date >= (r.datestart - '45 days'::interval day) AND maxopenlossdaily.date <= r.datestart::timestamp without time zone) AS maxworstlosspercentequity045,
    ( SELECT max(maxopenlossdaily.worstlosspercentequity) AS max
           FROM maxopenlossdaily
          WHERE maxopenlossdaily.systemid = r.systemid AND maxopenlossdaily.date >= (r.datestart - '90 days'::interval day) AND maxopenlossdaily.date <= r.datestart::timestamp without time zone) AS maxworstlosspercentequity090,
    ( SELECT max(maxopenlossdaily.worstlosspercentequity) AS max
           FROM maxopenlossdaily
          WHERE maxopenlossdaily.systemid = r.systemid AND maxopenlossdaily.date >= (r.datestart - '180 days'::interval day) AND maxopenlossdaily.date <= r.datestart::timestamp without time zone) AS maxworstlosspercentequity180,
    ( SELECT count(*) AS count
           FROM c2ex_trades t
          WHERE t.systemid = r.systemid AND date(t.exittime) <= r.datestart) AS numtrades,
    pcntmonthsprofit.statval AS pcntmonthsprofitable,
    profitfactor.statval AS profitfactor,
    jsharpe.statval AS sharpe,
    jsortino.statval AS sortino,
    jcalmar.statval AS calmar,
    maxddpcnt180days.statval AS maxdrawdownpcnt180days,
    maxddpcnt365days.statval AS maxdrawdownpcnt365days,
    latesttradedaysago.statval AS tradedaysago,
    shortoptionscovered.statval AS shortoptionscovered,
    optionpercent.statval AS optionpercent,
    COALESCE(( SELECT count(*) AS count
           FROM c2ex_trades t
          WHERE t.systemid = r.systemid AND date(t.exittime) <= r.datestart AND t.result > 0::numeric), 0::bigint) AS numtradeswin,
    COALESCE(( SELECT count(*) AS count
           FROM c2ex_signals s
          WHERE s.systemid = r.systemid AND date(s.tradedwhen) <= r.datestart AND (s.action = ANY (ARRAY['STC'::orderaction, 'BTC'::orderaction]))), 0::bigint) AS numexits,
    COALESCE(( SELECT avg(t.result) AS avg
           FROM c2ex_trades t
          WHERE t.systemid = r.systemid AND date(t.exittime) <= r.datestart AND t.result <= 0::numeric), 0::numeric) AS avgtradeloss,
    COALESCE(( SELECT avg(t.result) AS avg
           FROM c2ex_trades t
          WHERE t.systemid = r.systemid AND date(t.exittime) <= r.datestart AND t.result > 0::numeric), 0::numeric) AS avgtradewin,
    expectancy.statval AS expectancy
   FROM returnsdatainintervalscleanedskip090 r
     JOIN c2systems ON c2systems.systemid = r.systemid
     JOIN historical_stats_modern systemagedays ON systemagedays.systemid = r.systemid AND systemagedays.date = r.datestart::timestamp without time zone AND systemagedays.statname::text = 'systemAgeDays'::text
     JOIN historical_stats_modern alpha ON alpha.systemid = r.systemid AND alpha.date = r.datestart::timestamp without time zone AND alpha.statname::text = 'Alpha'::text
     JOIN historical_stats_modern beta ON beta.systemid = r.systemid AND beta.date = r.datestart::timestamp without time zone AND beta.statname::text = 'Beta'::text
     LEFT JOIN historical_stats_modern c2star ON c2star.systemid = r.systemid AND c2star.date = r.datestart::timestamp without time zone AND c2star.statname::text = 'c2star'::text
     JOIN historical_stats_modern correlation_to_sp500 ON correlation_to_sp500.systemid = r.systemid AND correlation_to_sp500.date = r.datestart::timestamp without time zone AND correlation_to_sp500.statname::text = 'correlation_to_sp500'::text
     JOIN historical_stats_modern cardefault ON cardefault.systemid = r.systemid AND cardefault.date = r.datestart::timestamp without time zone AND cardefault.statname::text = 'cARdefault'::text
     JOIN historical_stats_modern dailymaxlevmax ON dailymaxlevmax.systemid = r.systemid AND dailymaxlevmax.date = r.datestart::timestamp without time zone AND dailymaxlevmax.statname::text = 'dailyMaxLevMax'::text
     JOIN historical_stats_modern dailymaxlevmean ON dailymaxlevmean.systemid = r.systemid AND dailymaxlevmean.date = r.datestart::timestamp without time zone AND dailymaxlevmean.statname::text = 'dailyMaxLevMean'::text
     LEFT JOIN historical_stats_modern maxddpcnt180days ON maxddpcnt180days.systemid = r.systemid AND maxddpcnt180days.date = r.datestart::timestamp without time zone AND maxddpcnt180days.statname::text = 'maxddPcnt180days'::text
     LEFT JOIN historical_stats_modern maxddpcnt365days ON maxddpcnt365days.systemid = r.systemid AND maxddpcnt365days.date = r.datestart::timestamp without time zone AND maxddpcnt365days.statname::text = 'maxddPcnt365days'::text
     LEFT JOIN historical_stats_modern deltaequityp30 ON deltaequityp30.systemid = r.systemid AND deltaequityp30.date = r.datestart::timestamp without time zone AND deltaequityp30.statname::text = 'deltaequityp30'::text
     LEFT JOIN historical_stats_modern deltaequityp45 ON deltaequityp45.systemid = r.systemid AND deltaequityp45.date = r.datestart::timestamp without time zone AND deltaequityp45.statname::text = 'deltaequityp45'::text
     LEFT JOIN historical_stats_modern deltaequityp90 ON deltaequityp90.systemid = r.systemid AND deltaequityp90.date = r.datestart::timestamp without time zone AND deltaequityp90.statname::text = 'deltaequityp90'::text
     JOIN historical_stats_modern maxdrawdownpcnt ON maxdrawdownpcnt.systemid = r.systemid AND maxdrawdownpcnt.date = r.datestart::timestamp without time zone AND maxdrawdownpcnt.statname::text = 'maxdrawdownPcnt'::text
     JOIN historical_stats_modern pcntmonthsprofit ON pcntmonthsprofit.systemid = r.systemid AND pcntmonthsprofit.date = r.datestart::timestamp without time zone AND pcntmonthsprofit.statname::text = 'pcntMonthsProfit'::text
     JOIN historical_stats_modern profitfactor ON profitfactor.systemid = r.systemid AND profitfactor.date = r.datestart::timestamp without time zone AND profitfactor.statname::text = 'profitFactor'::text
     JOIN historical_stats_modern jsharpe ON jsharpe.systemid = r.systemid AND jsharpe.date = r.datestart::timestamp without time zone AND jsharpe.statname::text = 'jSharpe'::text
     JOIN historical_stats_modern jsortino ON jsortino.systemid = r.systemid AND jsortino.date = r.datestart::timestamp without time zone AND jsortino.statname::text = 'jSortino'::text
     JOIN historical_stats_modern jcalmar ON jcalmar.systemid = r.systemid AND jcalmar.date = r.datestart::timestamp without time zone AND jcalmar.statname::text = 'jCalmar'::text
     JOIN historical_stats_modern latesttradedaysago ON latesttradedaysago.systemid = r.systemid AND latesttradedaysago.date = r.datestart::timestamp without time zone AND latesttradedaysago.statname::text = 'latesttradedaysago'::text
     JOIN historical_stats_modern shortoptionscovered ON shortoptionscovered.systemid = r.systemid AND shortoptionscovered.date = r.datestart::timestamp without time zone AND shortoptionscovered.statname::text = 'shortOptionsCovered'::text
     JOIN historical_stats_modern optionpercent ON optionpercent.systemid = r.systemid AND optionpercent.date = r.datestart::timestamp without time zone AND optionpercent.statname::text = 'optionpercent'::text
     LEFT JOIN expectancyview expectancy ON expectancy.systemid = r.systemid AND expectancy.date = r.datestart::timestamp without time zone
  WHERE r.datestart >= '2018-01-08 00:00:00'::timestamp without time zone
  ORDER BY r.datestart, c2systems.systemid;