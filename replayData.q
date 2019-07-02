system"c 25 300";
logfile:hopen hsym`$"C:\\OnDiskDB\\replayProcLog";
.log.out:{x string[.z.P],":-> ",y,"\n"}[logfile;];
.log.out["log started"];
system"l sym.q";
.log.out["starting to read data"];
{[fileDate]
    filePath:(system"cd"),"\\";
    0N!fileDate;
    if[fileDate~`readFromMemory;
        `dxOrderPublic_file set get hsym[`$filePath,"dxOrderPublic_file"];
        if[not `date in cols[`dxOrderPublic_file];
            update date:`date$transactTime from `dxOrderPublic_file;
        ];		
        :()
    ];
    
    /read in order files
    /orderFiles:except[;auctionFiles]system"dir /B ",filePath,"*order_book*",except[string fileDate;"."],"*";
    orderFiles:system"dir /B ",filePath,"*order_book*",except[string fileDate;"."],"*";
    fileColNames:`eventID`date`time`millis`orderID`executionOptions`eventType`sym`orderType`side`limitPrice`originalQuantity`grossNotionalValue`fillPrice`fillQuantity`totalExecQuantity`remainingQuantity`avgPrice;
    desiredCols:`date`transactTime`sym`eventID`orderID`executionOptions`eventType`orderType`side`limitPrice`originalQuantity`grossNotionalValue`fillPrice`fillQuantity`totalExecQuantity`remainingQuantity`avgPrice`sourceFile;
    {[x;y;z;fileColNames;desiredCols]
        0N!`$y,x;
        `dxOrderPublic_file upsert ?[;enlist(=;`date;z);0b;{x!x}desiredCols]update sourceFile:`$x,transactTime:date+time+("T"$"00:00:00.",/:-3#'"000",/:string[millis]) from fileColNames xcol ("JDTJJSSSSSFFFFFFFF";enlist",") 0:`$y,x;
    }[;filePath;fileDate;fileColNames;desiredCols]each orderFiles;
 }each enlist[`readFromMemory];
/enlist[2019.05.24];
 /}each (2019.05.20;2019.05.21;2019.05.22;2019.05.23;2019.05.24;2019.05.25)
.log.out["read in data"];
if[1=count exec distinct date from dxOrderPublic_file;
   update date:.z.D,transactTime:("P"$string[.z.D],/:10_/:string[transactTime]) from `dxOrderPublic_file;
 ];

`date`transactTime`eventID xasc `dxOrderPublic_file;

inputOptions:.Q.opt .z.x;
.stat.bm:{
    if[count[x] mod 2;'`length];
    x:2 0N#x;
    r:sqrt -2f*log x 0;
    theta:2f*acos[-1]*x 1;
    x: r*cos theta;
    x,:r*sin theta;
    x
 };
.log.out "Checking inputOptions";
if[1b~value raze inputOptions[`simulateMembers];
    .log.out "Assigning orderIDs to members";
    /listOfMembers:`$"member",/:string 1+til 5000;
    listOfOrderIDs:exec distinct orderID from dxOrderPublic_file;
    somewhatNormallyDistributedInts:1+abs floor 550+10*.stat.bm 1000000?1f;
    somewhatNormallyDistributedIntsCumSum:sums somewhatNormallyDistributedInts;
    indexWhereAllOrdersAssigned:somewhatNormallyDistributedIntsCumSum binr count[listOfOrderIDs];
    if[indexWhereAllOrdersAssigned=count[somewhatNormallyDistributedIntsCumSum];
        .log.out "ERROR:  Not enough distribution points - try again";
    ];
    numberOfOrdersToAssignToEachMember:(indexWhereAllOrdersAssigned+1)#somewhatNormallyDistributedInts;
    /bump last assigned number down so that a total of count[listOfOrderIDs] are assigned out
    numberOfOrdersToAssignToEachMember[indexWhereAllOrdersAssigned]-:somewhatNormallyDistributedIntsCumSum[indexWhereAllOrdersAssigned]-count[listOfOrderIDs];
    randomOrderIDIndices:neg[count[listOfOrderIDs]]?til count[listOfOrderIDs];
    orderIDIndicesAssignedToEachMember:-1_sums[0,numberOfOrdersToAssignToEachMember] _ randomOrderIDIndices;
    orderIDsAssignedToEachMember:listOfOrderIDs @/:orderIDIndicesAssignedToEachMember;
    orderIDAssignmentTable:`orderID xkey ungroup ([]member:`$"member",/:string[1+til count orderIDsAssignedToEachMember];orderID:orderIDsAssignedToEachMember);
    
    dxOrderPublic_file:update sym:` sv/: (sym,'member) from dxOrderPublic_file lj orderIDAssignmentTable;
    .log.out "Finished assigning orderIDs to members";
 ];


dxTransactionPublic:`transactTime`eventID xasc dxOrderPublic_file uj ((select date,transactTime,sym,eventID,eventType:`Trade,price:fillPrice,quantity:fillQuantity,sourceFile from dxOrderPublic_file where eventType=`Fill,i=(first;i)fby eventID) lj (1!select eventID,buyOrderID:orderID from dxOrderPublic_file where eventType=`Fill,side=`buy)) lj (1!select eventID,sellOrderID:orderID from dxOrderPublic_file where eventType=`Fill,side=`sell);

h:neg hopen`:localhost:5000;

.global.timeToReplayFrom:.z.P;
.global.nextRowNumberToStartReplayingFrom:first dxTransactionPublic[`transactTime] bin enlist[.global.timeToReplayFrom];

/timer function
.z.ts:{
   
    stopTime:.z.P;
    stopRow:first _[.global.nextRowNumberToStartReplayingFrom;dxTransactionPublic[`transactTime]] bin enlist[stopTime];

    `replayLog upsert ([]time:enlist[.z.P];start:.global.nextRowNumberToStartReplayingFrom;stop:.global.nextRowNumberToStartReplayingFrom+stopRow);
   
    {[h;x]
        $[`Trade=x`eventType;
            h(".u.upd";`dxTradePublic;value[cols[.schema.schemas[`dxTradePublic]]#x]);
            h(".u.upd";`dxOrderPublic;value[cols[.schema.schemas[`dxOrderPublic]]#x])
        ];
    }[h;]each (``date)_select from dxTransactionPublic where i within (.global.nextRowNumberToStartReplayingFrom;.global.nextRowNumberToStartReplayingFrom+stopRow);

    .global.nextRowNumberToStartReplayingFrom+:stopRow+1;
 };
.log.out["timer function defined data"];
/trigger timer every 100ms (strike 20 seconds)
\t 100

/.global.nextRowNumberToStartReplayingFrom:0;
/.global.numberOfRowsToReplay:10;
/timer function
/.z.ts:{
/    {[h;x]
/        h(".u.upd";`dxOrderPublic;value[x]);
/    }[h;]each (``date)_select from dxOrderPublic where i within (.global.nextRowNumberToStartReplayingFrom;.global.nextRowNumberToStartReplayingFrom+.global.numberOfRowsToReplay-1);
/    
/    .global.nextRowNumberToStartReplayingFrom+:.global.numberOfRowsToReplay;
/ };
/trigger timer every 100ms (strike 20 seconds)
/\t 10000