.rA.getRowsInTimeWindow:{[TWargs]
    timeInterval:TWargs[`timeInterval];
    sourceTable:TWargs[`sourceTable];
    lookupTable:TWargs[`lookupTable];

    windowStartTimes:sourceTable[`transactTime]-timeInterval;
    firstRowInWindow:1+lookupTable[`transactTime] bin windowStartTimes;
    lastRowInWindow:lookupTable[`eventID] bin sourceTable[`eventID];

    rowsMatchingEntityValue:exec rowsMatchingEntityValue from ?[sourceTable;();0b;{x!x}enlist`sym] lj ?[lookupTable;();{x!x}enlist`sym;(enlist`rowsMatchingEntityValue)!(enlist`i)];

    rowsMatchingEntityValue@' where each rowsMatchingEntityValue within' firstRowInWindow,'lastRowInWindow

 };

.ae.orderToTrade_wj:{[data]

    
    data:select transactTime,sym,eventID,orderID,executionOptions,eventType,orderType from -10#dxOrderPublic where eventType=`Place;
    data:wj[
        (data[`transactTime]-0D00:05;data[`transactTime]);
        `sym`transactTime;
        data;
        (?[dxOrderPublic;enlist(=;`eventType;enlist`Place);0b;({x!x}`sym`transactTime`limitPrice`originalQuantity`side`i)];(count;`i);(sum;`originalQuantity);({sum x*y};`originalQuantity;`limitPrice);({count each group[x]};`side))
     ];

 };