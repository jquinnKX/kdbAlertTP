/q aeID4.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q
.proc.name:last[.z.x];
logfile:hopen hsym`$"C:\\OnDiskDB\\procLog",.proc.name;
.log.out:{x string[.z.P],":-> ",y,"\n"}[logfile;];
.log.out["log started at ",string[.z.p]];

if[not "w"=first string .z.o;system "sleep 1"];
system"l alertFunctions.q";
system"c 25 300";

.ae.orderToTrade_oneAtATime_alert:{[data]
    .debug.onedata:data;
    data,:exec
        orderCount:count i,
        totalOrderQty:sum originalQuantity,
        totalOrderValue:sum originalQuantity*limitPrice,
        orderCountsPerSide:enlist count each group side,
        bestBidAsk:enlist[{(max;min)@''`side xgroup ([]side:`buy`sell,x;price:0.0,0.0,y)}[side;limitPrice]]
    from dxOrderPublic where 
        transactTime>=data[`transactTime]-(0D00:05+00:00:10),
        sym=data[`sym],
        not[executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel")]
        or (executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel"))
        and not ({`Place`Cancel~x};eventType)fby ([]orderID;transactTime),
        eventType=`Place,
        transactTime within (data[`transactTime]-0D00:05;data[`transactTime]),eventID<=data[`eventID];

    data,:exec
        tradeCount:count i,
        totalTradeQty:sum quantity,
        totalTradeValue:sum quantity*price
    from dxTradePublic where transactTime within (data[`transactTime]-0D00:05;data[`transactTime]),sym=data[`sym],eventID<=data[`eventID];

    .ae.orderToTrade_checkAgainstThresholds[enlist data];
 };

upd:{[t;x]
    /.debug.upd:(`t`x)!(t;x);
    /`updStats upsert ([]time:enlist[.z.p];cnt:count[x];mnt:min[x`transactTime]);
    t insert x;
 };

.z.ts:{
    startTime:.z.P;
    wBefore:.Q.w[];
    tsvector:system"ts:20 outcome:.ae.orderToTrade_oneAtATime_ts[]";
    $[outcome~`noDataToAnalyse;:();.ae.orderToTrade_oneAtATime_lastEventAnalysed:outcome[0]];
    endTime:.z.P;
    wAfter:.Q.w[];
    .log.out -3!(`.ae.orderToTrade_oneAtATime_ts;startTime;endTime;outcome[1];outcome[2];tsvector[0];tsvector[1];wBefore`used;wAfter`used;wBefore`heap;wAfter`heap);
    if[count dxATAlert;
        .ae.alertMonitorHandle("upd";`dxATAlert;select from dxATAlert where i=(first;i)fby eventID);
        delete from `dxATAlert;
    ];
 };

.ae.orderToTrade_oneAtATime_lastEventAnalysed:0;

.ae.orderToTrade_oneAtATime_ts:{

    dataToAnalyse:select transactTime,sym,orderID,executionOptions,eventType,orderType,eventID from dxOrderPublic where 
        eventID>.ae.orderToTrade_oneAtATime_lastEventAnalysed,
        not[executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel")]
        or (executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel"))
        and not ({`Place`Cancel~x};eventType)fby ([]orderID;transactTime),
        transactTime<last[dxOrderPublic[`transactTime]]-0D00:00:10,
        eventType=`Place;

    if[not count dataToAnalyse;:`noDataToAnalyse];

    .ae.orderToTrade_oneAtATime_alert each dataToAnalyse;
    :(last[dataToAnalyse[`eventID]];first[dataToAnalyse[`transactTime]];last[dataToAnalyse[`transactTime]])
 };

/ get the ticker plant and history ports, defaults are 5000,5001
.u.x:.z.x,(count .z.x)_(":5000";":5001");

/ end of day: save, clear, hdb reload
/.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

