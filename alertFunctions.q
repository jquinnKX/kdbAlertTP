.ae.orderToTrade_wj_alert:{[data;executionPoint]

    windows:(data[`transactTime]-0D00:05;data[`transactTime]);

    lookupTable:$[executionPoint=`realTime;
        [
            update rn:i from ?[dxOrderPublic;(((';~:;<);`transactTime;min[data`transactTime]-0D00:05);(=;`eventType;enlist`Place));0b;({x!x}`sym`transactTime`limitPrice`originalQuantity`side)]
        ];
        [
            update rn:i from select sym,transactTime,limitPrice,originalQuantity,side from dxOrderPublic where 
                transactTime>=min[data[`transactTime]]-(0D00:05+00:00:10),
                not[executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel")]
                or (executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel"))
                and not ({`Place`Cancel~x};eventType)fby ([]orderID;transactTime),
                eventType=`Place
        ]
    ];

    data:(cols[data],`orderCount`totalOrderQty`totalOrderValue`orderCountsPerSide`bestBidAsk) xcol 
        wj1[
            windows;
            `sym`transactTime;
            data;
            (
                update `p#sym from `sym`transactTime xasc lookupTable;
                (count;`rn);(sum;`originalQuantity);({sum x*y};`originalQuantity;`limitPrice);({count each group[x]};`side);({(max;min)@''`side xgroup ([]side:`buy`sell,x;price:0.0,0.0,y)};`side;`limitPrice)
            )
         ];

    lookupTable:update rn:i from ?[dxTradePublic;enlist((';~:;<);`transactTime;min[data`transactTime]-0D00:05);0b;({x!x}`sym`transactTime`price`quantity)];

    data:(cols[data],`tradeCount`totalTradeQty`totalTradeValue) xcol 
        wj1[
            windows;
            `sym`transactTime;
            data;
            (
                update `p#sym from `sym`transactTime xasc lookupTable;
                (count;`rn);(sum;`quantity);({sum x*y};`quantity;`price)
            )
         ];

    .ae.orderToTrade_checkAgainstThresholds[data];

 };

.ae.orderToTrade_wj_eventWindow_alert:{[data;executionPoint]

    windows:(data[`transactTime]-0D00:05;data[`transactTime]);

    lookupTable:$[executionPoint=`realTime;
        [
            update rn:i from ?[dxOrderPublic;(((';~:;<);`transactTime;min[data`transactTime]-0D00:05);(=;`eventType;enlist`Place));0b;({x!x}`sym`transactTime`limitPrice`originalQuantity`side`eventID)]
        ];
        [
            update rn:i from select sym,transactTime,eventID,limitPrice,originalQuantity,side from dxOrderPublic where 
                    transactTime>=min[data[`transactTime]]-(0D00:05+00:00:10),
                    not[executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel")]
                    or (executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel"))
                    and not ({`Place`Cancel~x};eventType)fby ([]orderID;transactTime),
                    eventType=`Place
        ]
    ];

    eventWindows:(lookupTable[`eventID]@/:lookupTable[`transactTime] binr windows[0];data[`eventID]);

    data:(cols[data],`orderCount`totalOrderQty`totalOrderValue`orderCountsPerSide`bestBidAsk) xcol 
        wj1[
            eventWindows;
            `sym`eventID;
            data;
            (
                update `p#sym from `sym`eventID xasc lookupTable;
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
                update `p#sym from `sym`eventID xasc lookupTable;
                (count;`i);(sum;`quantity);({sum x*y};`quantity;`price)
            )
         ];

    .ae.orderToTrade_checkAgainstThresholds[data];

 };

.ae.orderToTrade_getRows_alert:{[data;executionPoint]

    windows:(data[`transactTime]-0D00:05;data[`transactTime]);

    lookupTable:$[executionPoint=`realTime;
        [
            ?[dxOrderPublic;(((';~:;<);`transactTime;min[data`transactTime]-0D00:05);(=;`eventType;enlist`Place));0b;({x!x}`sym`transactTime`limitPrice`originalQuantity`side`eventID)]
        ];
        [
            update rn:i from select sym,transactTime,eventID,limitPrice,originalQuantity,side from dxOrderPublic where 
                    transactTime>=min[data[`transactTime]]-(0D00:05+00:00:10),
                    not[executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel")]
                    or (executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel"))
                    and not ({`Place`Cancel~x};eventType)fby ([]orderID;transactTime),
                    eventType=`Place
        ]
    ];

    rowsInWindow:.ae.getRowsInTimeWindow_cutoff1G[windows;data;lookupTable];

    data:update 
        orderCount:count each rowsInWindow,
        totalOrderQty:sum each lookupTable[`originalQuantity]@/:rowsInWindow,
        totalOrderValue:sum each (lookupTable[`originalQuantity]@/:rowsInWindow)*lookupTable[`limitPrice]@/:rowsInWindow,
        orderCountsPerSide:count each' group each lookupTable[`side]@/:rowsInWindow,
        bestBidAsk:{(max;min)@''`side xgroup ([]side:`buy`sell,x;price:0.0,0.0,y)}'[lookupTable[`side]@/:rowsInWindow;lookupTable[`limitPrice]@/:rowsInWindow]
    from data;

    lookupTable:?[dxTradePublic;enlist((';~:;<);`transactTime;min[data`transactTime]-0D00:05);0b;({x!x}`sym`transactTime`price`quantity`eventID)];

    rowsInWindow:.ae.getRowsInTimeWindow_cutoff1G[windows;data;lookupTable];

    data:update tradeCount:count each rowsInWindow,totalTradeQty:sum each lookupTable[`quantity]@/:rowsInWindow,totalTradeValue:sum each (lookupTable[`quantity]@/:rowsInWindow)*lookupTable[`price]@/:rowsInWindow  from data;

    .ae.orderToTrade_checkAgainstThresholds[data];

 };

.ae.orderToTrade_oneAtATime_alert:{[data;executionPoint]

    data,:$[executionPoint=`realTime;
        [
            exec 
                orderCount:count i,
                totalOrderQty:sum[originalQuantity],
                totalOrderValue:sum originalQuantity*limitPrice,
                orderCountsPerSide:enlist count each group side,
                bestBidAsk:enlist[{(max;min)@''`side xgroup ([]side:`buy`sell,x;price:0.0,0.0,y)}[side;limitPrice]]
            from dxOrderPublic where transactTime within (data[`transactTime]-0D00:05;data[`transactTime]),sym=data[`sym],eventType=`Place,eventID<=data[`eventID]
        ];
        [
            exec
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
                transactTime within (data[`transactTime]-0D00:05;data[`transactTime]),eventID<=data[`eventID]
        ]
    ];

    data,:exec 
        tradeCount:count i,
        totalTradeQty:sum quantity,
        totalTradeValue:sum quantity*price
    from dxTradePublic where transactTime within (data[`transactTime]-0D00:05;data[`transactTime]),sym=data[`sym],eventID<=data[`eventID];

    .ae.orderToTrade_checkAgainstThresholds[enlist data];

 };

.ae.orderToTrade_checkAgainstThresholds:{[data]
    /.debug.checkAgainstThresholds:data;
    alerts:select transactTime,sym,alertTime:.z.p,alertEngine:.proc.name,eventID,orderID,executionOptions,eventType,orderType,orderCount,totalOrderQty,totalOrderValue,tradeCount,totalTradeQty,totalTradeValue from data where 
        orderCount>4000,
        totalOrderQty>90000,
        totalOrderValue>10000000,
        tradeCount<15,
        totalTradeQty<9000,
        totalTradeValue<10000;
    if[count alerts;
        `dxAlert upsert alerts
    ];
 };

.ae.getRowsInTimeWindow:{[windows;sourceTable;lookupTable]

    /.debug.getRowsInTimeWindow:(`windows`sourceTable`lookupTable)!(windows;sourceTable;lookupTable);

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:exec rowsMatchingSym from ?[sourceTable;();0b;{x!x}enlist`sym] lj ?[lookupTable;();{x!x}enlist`sym;(enlist`rowsMatchingSym)!(enlist`i)];

    rowsMatchingSym@' where each rowsMatchingSym within' firstRowInWindow,'lastRowInWindow

 };

.ae.getRowsInTimeWindow_cutoff1:{[windows;sourceTable;lookupTable]

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:exec rowsMatchingSym from ?[sourceTable;();0b;{x!x}enlist`sym] lj ?[lookupTable;();{x!x}enlist`sym;(enlist`rowsMatchingSym)!(enlist`i)];

    leftCutOff:rowsMatchingSym binr'firstRowInWindow;
    rightCutOff:(count each rowsMatchingSym)-1+rowsMatchingSym bin'lastRowInWindow;
    (leftCutOff)_'neg[rightCutOff]_'rowsMatchingSym
   
 };

.ae.getRowsInTimeWindow_cutoff1G:{[windows;sourceTable;lookupTable]

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:exec rowsMatchingSym from ?[sourceTable;();0b;{x!x}enlist`sym] lj `sym xgroup select sym,rowsMatchingSym:i from lookupTable;

    leftCutOff:rowsMatchingSym binr'firstRowInWindow;
    rightCutOff:(count each rowsMatchingSym)-1+rowsMatchingSym bin'lastRowInWindow;
    (leftCutOff)_'neg[rightCutOff]_'rowsMatchingSym
   
 };

.ae.getRowsInTimeWindow_cutoff2:{[windows;sourceTable;lookupTable]

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:?[lookupTable;enlist(in;`sym;enlist distinct[sourceTable[`sym]]);{x!x}enlist`sym;(`rows`count)!(`i;(count;`i))]@/:sourceTable[`sym];

    leftCutOff:rowsMatchingSym[`rows] binr'firstRowInWindow;
    rightCutOff:(0^rowsMatchingSym[`count])-1+rowsMatchingSym[`rows] bin'lastRowInWindow;
    (leftCutOff)_'neg[rightCutOff]_'rowsMatchingSym[`rows]   
 };

.ae.getRowsInTimeWindow_cutoff2G:{[windows;sourceTable;lookupTable]

    firstRowInWindow:lookupTable[`transactTime] binr windows[0];
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingSym:group[exec sym from lookupTable]@/:sourceTable[`sym];

    leftCutOff:rowsMatchingSym binr'firstRowInWindow;
    rightCutOff:(count each rowsMatchingSym)-1+rowsMatchingSym bin'lastRowInWindow;
    (leftCutOff)_'neg[rightCutOff]_'rowsMatchingSym
 };