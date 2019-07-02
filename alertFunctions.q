.ae.getRowsInTimeWindow:{[windows;sourceTable;lookupTable]

    /.debug.getRowsInTimeWindow:(`windows`sourceTable`lookupTable)!(windows;sourceTable;lookupTable);

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:exec rowsMatchingSym from ?[sourceTable;();0b;{x!x}enlist`sym] lj ?[lookupTable;();{x!x}enlist`sym;(enlist`rowsMatchingSym)!(enlist`i)];

    rowsMatchingSym@' where each rowsMatchingSym within' firstRowInWindow,'lastRowInWindow

 };

.ae.orderToTrade_getRows:{[windows;data;lookupTable]

    /.debug.orderToTrade_getRows:(`windows`data`lookupTable)!(windows;data;lookupTable);
    
    rowsInWindow:.ae.getRowsInTimeWindow[windows;data;lookupTable];

    data:update 
        orderCount:count each rowsInWindow,
        totalOrderQty:sum each lookupTable[`originalQuantity]@/:rowsInWindow,
        totalOrderValue:sum each (lookupTable[`originalQuantity]@/:rowsInWindow)*lookupTable[`limitPrice]@/:rowsInWindow,
        orderCountsPerSide:count each' group each lookupTable[`side]@/:rowsInWindow,
        bestBidAsk:{(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)}'[lookupTable[`side]@/:rowsInWindow;lookupTable[`limitPrice]@/:rowsInWindow]
    from data;

    lookupTradeTable:dxTradePublic;

    rowsInWindow:.ae.getRowsInTimeWindow[windows;data;lookupTradeTable];

    data:update tradeCount:count each rowsInWindow,totalTradeQty:sum each lookupTradeTable[`quantity]@/:rowsInWindow,totalTradeValue:sum each (lookupTradeTable[`quantity]@/:rowsInWindow)*lookupTradeTable[`price]@/:rowsInWindow  from data;

    :data

 };


.ae.orderToTrade_getRowsWithWJ:{[windows;data;lookupTable]

    /.debug.orderToTrade_getRowsWithWJ:(`windows`data`lookupTable)!(windows;data;lookupTable);
    
    rowsInWindow:exec rowsInWindow from (cols[data],`rowsInWindow) xcol 
            wj1[
                windows;
                `sym`transactTime;
                data;
                (
                    `sym`transactTime xasc select sym,transactTime,rn:i from lookupTable;
                    (::;`rn)
                )
             ];

    data:update 
        orderCount:count each rowsInWindow,
        totalOrderQty:sum each lookupTable[`originalQuantity]@/:rowsInWindow,
        totalOrderValue:sum each (lookupTable[`originalQuantity]@/:rowsInWindow)*lookupTable[`limitPrice]@/:rowsInWindow,
        orderCountsPerSide:count each' group each lookupTable[`side]@/:rowsInWindow,
        bestBidAsk:{(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)}'[lookupTable[`side]@/:rowsInWindow;lookupTable[`limitPrice]@/:rowsInWindow]
    from data;

    lookupTable:dxTradePublic;

    rowsInWindow:exec rowsInWindow from (cols[data],`rowsInWindow) xcol 
            wj1[
                windows;
                `sym`transactTime;
                data;
                (
                    `sym`transactTime xasc select sym,transactTime,rn:i from lookupTable;
                    (::;`rn)
                )
             ];

    data:update tradeCount:count each rowsInWindow,totalTradeQty:sum each lookupTable[`quantity]@/:rowsInWindow,totalTradeValue:sum each (lookupTable[`quantity]@/:rowsInWindow)*lookupTable[`price]@/:rowsInWindow  from data;

    :data

 };

.ae.orderToTrade_getRows_lowMem:{[windows;data;lookupTable]
    
    rowsInWindow:{x@' where each x within' y,'z}[;lookupTable[`transactTime] binr windows[0];lookupTable[`eventID] bin data[`eventID]]exec rowsMatchingSym from ?[data;();0b;{x!x}enlist`sym] lj ?[lookupTable;();{x!x}enlist`sym;(enlist`rowsMatchingSym)!(enlist`i)];

    data:update 
        orderCount:count each rowsInWindow,
        totalOrderQty:sum each lookupTable[`originalQuantity]@/:rowsInWindow,
        totalOrderValue:sum each (lookupTable[`originalQuantity]@/:rowsInWindow)*lookupTable[`limitPrice]@/:rowsInWindow,
        orderCountsPerSide:count each' group each lookupTable[`side]@/:rowsInWindow,
        bestBidAsk:{(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)}'[lookupTable[`side]@/:rowsInWindow;lookupTable[`limitPrice]@/:rowsInWindow]
    from data;

    lookupTable:dxTradePublic;

    rowsInWindow:{x@' where each x within' y,'z}[;lookupTable[`transactTime] binr windows[0];lookupTable[`eventID] bin data[`eventID]]exec rowsMatchingSym from ?[data;();0b;{x!x}enlist`sym] lj ?[lookupTable;();{x!x}enlist`sym;(enlist`rowsMatchingSym)!(enlist`i)];

    data:update tradeCount:count each rowsInWindow,totalTradeQty:sum each lookupTable[`quantity]@/:rowsInWindow,totalTradeValue:sum each (lookupTable[`quantity]@/:rowsInWindow)*lookupTable[`price]@/:rowsInWindow  from data;

    :data

 };



.ae.getRowsInTimeWindow_cutoff1:{[windows;sourceTable;lookupTable]

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:exec rowsMatchingSym from ?[sourceTable;();0b;{x!x}enlist`sym] lj ?[lookupTable;();{x!x}enlist`sym;(enlist`rowsMatchingSym)!(enlist`i)];

    leftCutOff:rowsMatchingSym binr'firstRowInWindow;
    rightCutOff:(count each rowsMatchingSym)-1+rowsMatchingSym bin'lastRowInWindow;
    (leftCutOff)_'neg[rightCutOff]_'rowsMatchingSym
   
 };



.ae.orderToTrade_getRows_cutoff1:{[windows;data;lookupTable]

    rowsInWindow:.ae.getRowsInTimeWindow_cutoff1[windows;data;lookupTable];

    data:update 
        orderCount:count each rowsInWindow,
        totalOrderQty:sum each lookupTable[`originalQuantity]@/:rowsInWindow,
        totalOrderValue:sum each (lookupTable[`originalQuantity]@/:rowsInWindow)*lookupTable[`limitPrice]@/:rowsInWindow,
        orderCountsPerSide:count each' group each lookupTable[`side]@/:rowsInWindow,
        bestBidAsk:{(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)}'[lookupTable[`side]@/:rowsInWindow;lookupTable[`limitPrice]@/:rowsInWindow]
    from data;

    lookupTradeTable:dxTradePublic;

    rowsInWindow:.ae.getRowsInTimeWindow_cutoff1[windows;data;lookupTradeTable];

    data:update tradeCount:count each rowsInWindow,totalTradeQty:sum each lookupTradeTable[`quantity]@/:rowsInWindow,totalTradeValue:sum each (lookupTradeTable[`quantity]@/:rowsInWindow)*lookupTradeTable[`price]@/:rowsInWindow  from data;

    :data

 };


.ae.getRowsInTimeWindow_cutoff1G:{[windows;sourceTable;lookupTable]

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:exec rowsMatchingSym from ?[sourceTable;();0b;{x!x}enlist`sym] lj `sym xgroup select sym,rowsMatchingSym:i from lookupTable;

    leftCutOff:rowsMatchingSym binr'firstRowInWindow;
    rightCutOff:(count each rowsMatchingSym)-1+rowsMatchingSym bin'lastRowInWindow;
    (leftCutOff)_'neg[rightCutOff]_'rowsMatchingSym
   
 };



.ae.orderToTrade_getRows_cutoff1G:{[windows;data;lookupTable]

    rowsInWindow:.ae.getRowsInTimeWindow_cutoff1G[windows;data;lookupTable];

    data:update 
        orderCount:count each rowsInWindow,
        totalOrderQty:sum each lookupTable[`originalQuantity]@/:rowsInWindow,
        totalOrderValue:sum each (lookupTable[`originalQuantity]@/:rowsInWindow)*lookupTable[`limitPrice]@/:rowsInWindow,
        orderCountsPerSide:count each' group each lookupTable[`side]@/:rowsInWindow,
        bestBidAsk:{(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)}'[lookupTable[`side]@/:rowsInWindow;lookupTable[`limitPrice]@/:rowsInWindow]
    from data;

    lookupTradeTable:dxTradePublic;

    rowsInWindow:.ae.getRowsInTimeWindow_cutoff1G[windows;data;lookupTradeTable];

    data:update tradeCount:count each rowsInWindow,totalTradeQty:sum each lookupTradeTable[`quantity]@/:rowsInWindow,totalTradeValue:sum each (lookupTradeTable[`quantity]@/:rowsInWindow)*lookupTradeTable[`price]@/:rowsInWindow  from data;

    :data

 };





.ae.getRowsInTimeWindow_cutoff2:{[windows;sourceTable;lookupTable]

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:?[lookupTable;enlist(in;`sym;enlist distinct[sourceTable[`sym]]);{x!x}enlist`sym;(`rows`count)!(`i;(count;`i))]@/:sourceTable[`sym];

    leftCutOff:rowsMatchingSym[`rows] binr'firstRowInWindow;
    rightCutOff:(0^rowsMatchingSym[`count])-1+rowsMatchingSym[`rows] bin'lastRowInWindow;
    (leftCutOff)_'neg[rightCutOff]_'rowsMatchingSym[`rows]   
 };


.ae.orderToTrade_getRows_cutoff2:{[windows;data;lookupTable]

    /.debug.orderToTrade_getRows_cutoff2:(`windows`data`lookupTable)!(windows;data;lookupTable);
    
    rowsInWindow:.ae.getRowsInTimeWindow_cutoff2[windows;data;lookupTable];

    data:update 
        orderCount:count each rowsInWindow,
        totalOrderQty:sum each lookupTable[`originalQuantity]@/:rowsInWindow,
        totalOrderValue:sum each (lookupTable[`originalQuantity]@/:rowsInWindow)*lookupTable[`limitPrice]@/:rowsInWindow,
        orderCountsPerSide:count each' group each lookupTable[`side]@/:rowsInWindow,
        bestBidAsk:{(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)}'[lookupTable[`side]@/:rowsInWindow;lookupTable[`limitPrice]@/:rowsInWindow]
    from data;

    lookupTradeTable:dxTradePublic;

    rowsInWindow:.ae.getRowsInTimeWindow_cutoff2[windows;data;lookupTradeTable];

    data:update tradeCount:count each rowsInWindow,totalTradeQty:sum each lookupTradeTable[`quantity]@/:rowsInWindow,totalTradeValue:sum each (lookupTradeTable[`quantity]@/:rowsInWindow)*lookupTradeTable[`price]@/:rowsInWindow  from data;

    :data

 };


.ae.getRowsInTimeWindow_cutoff2G:{[windows;sourceTable;lookupTable]

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:group[exec sym from lookupTable]@/:sourceTable[`sym];

    leftCutOff:rowsMatchingSym binr'firstRowInWindow;
    rightCutOff:(count each rowsMatchingSym)-1+rowsMatchingSym bin'lastRowInWindow;
    (leftCutOff)_'neg[rightCutOff]_'rowsMatchingSym
 };


.ae.orderToTrade_getRows_cutoff2G:{[windows;data;lookupTable]

    /.debug.orderToTrade_getRows_cutoff2G:(`windows`data`lookupTable)!(windows;data;lookupTable);
    
    rowsInWindow:.ae.getRowsInTimeWindow_cutoff2G[windows;data;lookupTable];

    data:update 
        orderCount:count each rowsInWindow,
        totalOrderQty:sum each lookupTable[`originalQuantity]@/:rowsInWindow,
        totalOrderValue:sum each (lookupTable[`originalQuantity]@/:rowsInWindow)*lookupTable[`limitPrice]@/:rowsInWindow,
        orderCountsPerSide:count each' group each lookupTable[`side]@/:rowsInWindow,
        bestBidAsk:{(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)}'[lookupTable[`side]@/:rowsInWindow;lookupTable[`limitPrice]@/:rowsInWindow]
    from data;

    lookupTradeTable:dxTradePublic;

    rowsInWindow:.ae.getRowsInTimeWindow_cutoff2G[windows;data;lookupTradeTable];

    data:update tradeCount:count each rowsInWindow,totalTradeQty:sum each lookupTradeTable[`quantity]@/:rowsInWindow,totalTradeValue:sum each (lookupTradeTable[`quantity]@/:rowsInWindow)*lookupTradeTable[`price]@/:rowsInWindow  from data;

    :data

 };



.ae.orderToTrade_wj:{[windows;data;lookupTable]
    
    data:(cols[data],`orderCount`totalOrderQty`totalOrderValue`orderCountsPerSide`bestBidAsk) xcol 
        wj1[
            windows;
            `sym`transactTime;
            data;
            (
                `sym`transactTime xasc ?[dxOrderPublic;enlist(=;`eventType;enlist`Place);0b;({x!x}`sym`transactTime`limitPrice`originalQuantity`side`i)];
                (count;`i);(sum;`originalQuantity);({sum x*y};`originalQuantity;`limitPrice);({count each group[x]};`side);({(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)};`side;`limitPrice)
            )
         ];

    data:(cols[data],`tradeCount`totalTradeQty`totalTradeValue) xcol 
        wj1[
            windows;
            `sym`transactTime;
            data;
            (
                `sym`transactTime xasc dxTradePublic;
                (count;`i);(sum;`quantity);({sum x*y};`quantity;`price)
            )
         ];

    :data

 };

.ae.orderToTrade_wj_passLookupIn:{[windows;data;lookupTable]

    /.debug.orderToTrade_wj_passLookupIn:(`windows`data`lookupTable)!(windows;data;lookupTable);

    data:(cols[data],`orderCount`totalOrderQty`totalOrderValue`orderCountsPerSide`bestBidAsk) xcol 
        wj1[
            windows;
            `sym`transactTime;
            data;
            (
                `sym`transactTime xasc lookupTable;
                (count;`i);(sum;`originalQuantity);({sum x*y};`originalQuantity;`limitPrice);({count each group[x]};`side);({(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)};`side;`limitPrice)
            )
         ];

    data:(cols[data],`tradeCount`totalTradeQty`totalTradeValue) xcol 
        wj1[
            windows;
            `sym`transactTime;
            data;
            (
                `sym`transactTime xasc dxTradePublic;
                (count;`i);(sum;`quantity);({sum x*y};`quantity;`price)
            )
         ];

    :data

 };

.ae.orderToTrade_wj_passLookupIn_pAttribute:{[windows;data;lookupTable]

    /.debug.orderToTrade_wj_passLookupIn:(`windows`data`lookupTable)!(windows;data;lookupTable);

    data:(cols[data],`orderCount`totalOrderQty`totalOrderValue`orderCountsPerSide`bestBidAsk) xcol 
        wj1[
            windows;
            `sym`transactTime;
            data;
            (
                update `p#sym from `sym`transactTime xasc lookupTable;
                (count;`i);(sum;`originalQuantity);({sum x*y};`originalQuantity;`limitPrice);({count each group[x]};`side);({(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)};`side;`limitPrice)
            )
         ];

    data:(cols[data],`tradeCount`totalTradeQty`totalTradeValue) xcol 
        wj1[
            windows;
            `sym`transactTime;
            data;
            (
                update `p#sym from `sym`transactTime xasc dxTradePublic;
                (count;`i);(sum;`quantity);({sum x*y};`quantity;`price)
            )
         ];

    :data

 };


.ae.orderToTrade_wj_passLookupIn_eventWindow:{[windows;data;lookupTable]

    eventWindows:(lookupTable[`eventID]@/:lookupTable[`transactTime] binr windows[0];data[`eventID]);

    data:(cols[data],`orderCount`totalOrderQty`totalOrderValue`orderCountsPerSide`bestBidAsk) xcol 
        wj1[
            eventWindows;
            `sym`eventID;
            data;
            (
                `sym`eventID xasc lookupTable;
                (count;`i);(sum;`originalQuantity);({sum x*y};`originalQuantity;`limitPrice);({count each group[x]};`side);({(max;min)@''`side xgroup ([]side:x,`buy`sell;price:y,0.0,0.0)};`side;`limitPrice)
            )
         ];

    lookupTable:dxTradePublic;
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

    :data

 };
system"l sym.q";
.ae.alertMonitorHandle:neg hopen`::999;

.ae.orderToTrade_checkAgainstThresholds:{[data]
    `dxATAlert upsert select transactTime,sym,alertTime:.z.p,alertEngine:`$.proc.name,eventID,orderID,executionOptions,eventType,orderType,orderCount,totalOrderQty,totalOrderValue,tradeCount,totalTradeQty,totalTradeValue from data where 
        orderCount>4000,
        totalOrderQty>316000,
        totalOrderValue>32040000,
        tradeCount<5,
        totalTradeQty<50,
        totalTradeValue<20;
 };

testCode:{

    
    
    data:select transactTime,sym,eventID,orderID,executionOptions,eventType,orderType from -10#dxOrderPublic where eventType=`Place
    windows:(data[`transactTime]-0D00:05;data[`transactTime]);
    
 count data
 count lookupTable
 delete debug from `.
 delete from `.debug
 key`.debug
 delete rightCutOff,leftCutOff,rowsMatchingSym,lastRowInWindow,firstRowInWindow,lookupTradeTable,rowsInWindow,args,lookupTable,windows,data from `.;

 delete master_tsResults from `.;
 /{
    `data set select transactTime,sym,eventID,orderID,executionOptions,eventType,orderType from dxOrderPublic where transactTime>.z.P-0D00:00:05,eventType=`Place;
    if[not count data;:()];
    `windows set (data[`transactTime]-0D00:05:00;data[`transactTime]);
    `lookupTable set ?[dxOrderPublic;((=;`eventType;enlist`Place);(>;`transactTime;.z.P-0D00:05:05));0b;{x!x}`sym`transactTime`eventID`limitPrice`originalQuantity`side];
    `args set (`windows`sourceTable`lookupTable)!(windows;data;lookupTable);
    `N set 500;
    .debug.data:data;
    delete tsResults from `.;
    runFunc:{[s]baseUsed:.Q.w[]`used;`tsResults upsert {[x;y;z;w]([]N:N;command:enlist[`$y];time:x[0];ts:x[1];used:.Q.w[][`used]-z;heap:.Q.w[]`heap;peak:.Q.w[]`peak;dotQdotWbeforedotQdotWbefore:w;dotQdotWbeforedotQdotWafter:enlist[system"w"])}[;s;baseUsed;enlist[system"w"]]value[ssr[s;"N";string[N]]]};
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_wj_passLookupIn[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_getRows[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_getRows_cutoff1[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_getRows_cutoff2[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_getRows_cutoff1G[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_getRows_cutoff2G[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_getRows_lowMem[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_wj_passLookupIn_pAttribute[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_wj_passLookupIn_eventWindow[windows;data;lookupTable]";
    .Q.gc[];
    runFunc "\\ts:N .ae.orderToTrade_getRowsWithWJ[windows;data;lookupTable]";
    tsResults
 /    `master_tsResults upsert update calculationRound:x from tsResults;
 /}each 1+til 100;
 select count[i],floor[avg[time]],floor[avg[ts]] by command from master_tsResults



     ((.ae.orderToTrade_wj_passLookupIn[windows;data;lookupTable] ~ .ae.orderToTrade_getRows[windows;data;lookupTable];count[data]<>count distinct[.ae.orderToTrade_wj_passLookupIn[windows;data;lookupTable]`transactTime]);
     (.ae.orderToTrade_wj_passLookupIn[windows;data;lookupTable] ~ .ae.orderToTrade_getRows[windows;data;lookupTable]) or count[data]<>count distinct[.ae.orderToTrade_wj_passLookupIn[windows;data;lookupTable]`transactTime];
     .ae.orderToTrade_getRows[windows;data;lookupTable] ~ .ae.orderToTrade_getRows_cutoff1[windows;data;lookupTable];
     .ae.orderToTrade_getRows[windows;data;lookupTable] ~ .ae.orderToTrade_getRows_cutoff2[windows;data;lookupTable];
     .ae.orderToTrade_getRows[windows;data;lookupTable] ~ .ae.orderToTrade_getRows_cutoff1G[windows;data;lookupTable];
     .ae.orderToTrade_getRows[windows;data;lookupTable] ~ .ae.orderToTrade_getRows_cutoff2G[windows;data;lookupTable];
     .ae.orderToTrade_getRows[windows;data;lookupTable] ~ .ae.orderToTrade_getRows_lowMem[windows;data;lookupTable];
     .ae.orderToTrade_getRows[windows;data;lookupTable] ~ .ae.orderToTrade_wj_passLookupIn_pAttribute[windows;data;lookupTable];
     .ae.orderToTrade_getRows[windows;data;lookupTable] ~ .ae.orderToTrade_wj_passLookupIn_eventWindow[windows;data;lookupTable];
     .ae.orderToTrade_getRows[windows;data;lookupTable] ~ .ae.orderToTrade_getRowsWithWJ[windows;data;lookupTable])

 };


