/q aeID2.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q
.proc.name:last[.z.x];
logfile:hopen hsym`$"C:\\OnDiskDB\\procLog",.proc.name;
.log.out:{x string[.z.P],":-> ",y,"\n"}[logfile;];
.log.out["log started at ",string[.z.p]];

if[not "w"=first string .z.o;system "sleep 1"];
system"l alertFunctions.q";
system"c 25 300";

.ae.orderToTrade_wj_eventWindow_alert:{[data]

    windows:(data[`transactTime]-0D00:05;data[`transactTime]);

    lookupTable:update rn:i from select sym,transactTime,eventID,limitPrice,originalQuantity,side from dxOrderPublic where 
        transactTime>=min[data[`transactTime]]-(0D00:05+00:00:10),
        not[executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel")]
        or (executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel"))
        and not ({`Place`Cancel~x};eventType)fby ([]orderID;transactTime),
        eventType=`Place;

    eventWindows:(lookupTable[`eventID]@/:lookupTable[`transactTime] binr windows[0];data[`eventID]);

    data:(cols[data],`orderCount`totalOrderQty`totalOrderValue`orderCountsPerSide`bestBidAsk) xcol 
        wj1[
            eventWindows;
            `sym`eventID;
            data;
            (
                `sym`eventID xasc lookupTable;
                (count;`rn);(sum;`originalQuantity);({sum x*y};`originalQuantity;`limitPrice);({count each group[x]};`side);({(max;min)@''`side xgroup ([]side:`buy`sell,x;price:0.0,0.0,y)};`side;`limitPrice)
            )
         ];

    lookupTable:update rn:i from ?[dxTradePublic;enlist((';~:;<);`transactTime;min[data`transactTime]-0D00:05);0b;({x!x}`sym`transactTime`price`quantity`eventID)];
    eventWindows:(lookupTable[`eventID]@/:lookupTable[`transactTime] binr windows[0];data[`eventID]);

    data:(cols[data],`tradeCount`totalTradeQty`totalTradeValue) xcol 
        wj1[
            eventWindows;
            `sym`eventID;
            data;
            (
                `sym`eventID xasc lookupTable;
                (count;`i);(sum;`quantity);({sum x*y};`quantity;`price)
            )
         ];

    .ae.orderToTrade_checkAgainstThresholds[data];
 };

upd:{[t;x]
    /.debug.upd:(`t`x)!(t;x);
    /`updStats upsert ([]time:enlist[.z.p];cnt:count[x];mnt:min[x`transactTime]);
    t insert x;
 };

.z.ts:{
    startTime:.z.P;
    wBefore:.Q.w[];
    tsvector:system"ts:20 outcome:.ae.orderToTrade_wj_eventWindow_ts[]";
    $[outcome~`noDataToAnalyse;:(); .ae.orderToTrade_wj_eventWindow_lastEventAnalysed:outcome[0]];
    endTime:.z.P;
    wAfter:.Q.w[];
    .log.out -3!(`.ae.orderToTrade_wj_eventWindow_ts;startTime;endTime;outcome[1];outcome[2];tsvector[0];tsvector[1];wBefore`used;wAfter`used;wBefore`heap;wAfter`heap);
    if[count dxATAlert;
        .ae.alertMonitorHandle("upd";`dxATAlert;select from dxATAlert where i=(first;i)fby eventID);
        delete from `dxATAlert;
    ];
 };

.ae.orderToTrade_wj_eventWindow_lastEventAnalysed:0;

.ae.orderToTrade_wj_eventWindow_ts:{

    dataToAnalyse:select transactTime,sym,eventID,orderID,executionOptions,eventType,orderType from dxOrderPublic where 
        eventID>.ae.orderToTrade_wj_eventWindow_lastEventAnalysed,
        not[executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel")]
        or (executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel"))
        and not ({`Place`Cancel~x};eventType)fby ([]orderID;transactTime),
        transactTime<last[dxOrderPublic[`transactTime]]-0D00:00:10,
        eventType=`Place;

    if[not count dataToAnalyse;:`noDataToAnalyse];

    .ae.orderToTrade_wj_eventWindow_alert[dataToAnalyse];
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

