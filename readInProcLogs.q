runTimes:`filePath`analytic`startTime`endTime`dataStart`dataEnd`timeUsed`spaceUsed`memUsedBefore`memUsedAfter`heapBefore`heapAfter xcol ([]`symbol$();`symbol$();`timestamp$();`timestamp$();`timestamp$();`timestamp$();`long$();`long$();`long$();`long$();`long$();`long$());


filePath:"C:\\OnDiskDB\\correctLogs2\\";
filePaths:hsym`$filePath,/:{x where x like "*procLogae*"}system"dir /B ",filePath;
1#1_read0[filePaths[0]];

{[x;t]
    /.debug.readin:(`time`x`t)!(.z.P;x;t);
    lg:33_'1_read0[x];
    {
        /.debug.upsert:(`time`x`y`z)!(.z.P;x;y;z);
        y insert z,value x
    }[;t;x]each lg;

}[;`runTimes]each filePaths;





update freq:?[engine like "*_1";1;?[engine like "*_5";5;?[engine like "*_10";10;0]]] from
update engine:(`$last each "\\"vs/:string[filePath]),endTimeSecond:`second$endTime,executionTime:endTime-startTime,timeUsedMins:{x%60000}timeUsed,minDataLag:endTime-dataEnd,maxDataLag:endTime-dataStart,memUsedDuring:memUsedAfter-memUsedBefore,heapUsedDuring:heapAfter-heapBefore from `runTimes;



select lc:count i,firstLogTime:min startTime,lastLogTime:max endTime,maxExecutionTime:max[executionTime],maxTimeUsed:{x%1000}max[timeUsed],maxSpaceUsed:{x%1000000}max[spaceUsed],mostMinDataLag:max[minDataLag],mostMaxDataLag:max[maxDataLag],maxMemUsedDuring:max[memUsedDuring],maxHeapUsedDuring:max[heapUsedDuring] by freq,engine,analytic from runTimes where filePath like "*Logs2*"


select from runTimes where engine=`procLogaeID4_1

\ts 0Np

select filePath,analytic,endTimeSecond,timeUsedMins,spaceUsed from runTimes1 where filePath like "*aeRT4*",i=(last;i)fby 60 xbar endTime.second



1+1



/psuedocode
get list of orderIDs
these are ordered sequentially, so need to shuffle them
count them up
create list of 1000 members
determine how many orderIDs to be assigned to them - make it normally distributed



.stat.bm:{
    if[count[x] mod 2;'`length];
    x:2 0N#x;
    r:sqrt -2f*log x 0;
    theta:2f*acos[-1]*x 1;
    x: r*cos theta;
    x,:r*sin theta;
    x
};


somewhatNormallyDistributedInts:floor 10*{x+abs min[x]}.stat.bm 10000?1f;
somewhatNormallyDistributedIntsCumSum:sums somewhatNormallyDistributedInts;
indexWhereAllOrdersAssigned:somewhatNormallyDistributedIntsCumSum binr 5000;
somewhatNormallyDistributedInts[indexWhereAllOrdersAssigned]-:somewhatNormallyDistributedIntsCumSum[indexWhereAllOrdersAssigned]-5000
sum (indexWhereAllOrdersAssigned+1)#somewhatNormallyDistributedInts


somewhatNormallyDistributedIntsCumSum
5#somewhatNormallyDistributedInts
5#somewhatNormallyDistributedIntsCumSum


x:.stat.bm 20?1f
floor 100*x+abs min[x]


system"c 25 300";

system"l sym.q";
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

if[1=count exec distinct date from dxOrderPublic_file;
   update date:.z.D,transactTime:("P"$string[.z.D],/:10_/:string[transactTime]) from `dxOrderPublic_file;
 ];

`date`transactTime`eventID xasc `dxOrderPublic_file;



.stat.bm:{
    if[count[x] mod 2;'`length];
    x:2 0N#x;
    r:sqrt -2f*log x 0;
    theta:2f*acos[-1]*x 1;
    x: r*cos theta;
    x,:r*sin theta;
    x
};

somewhatNormallyDistributedInts:floor 10*{x+abs min[x]}.stat.bm 10000?1f;
somewhatNormallyDistributedIntsCumSum:sums somewhatNormallyDistributedInts;
indexWhereAllOrdersAssigned:somewhatNormallyDistributedIntsCumSum binr 5000;
somewhatNormallyDistributedInts[indexWhereAllOrdersAssigned]-:somewhatNormallyDistributedIntsCumSum[indexWhereAllOrdersAssigned]-5000
sum (indexWhereAllOrdersAssigned+1)#somewhatNormallyDistributedInts




somewhatNormallyDistributedInts:floor 10*{x+abs min[x]}.stat.bm 10000?1f;


1+abs floor 10+5*.stat.bm 10000?1f

listOfOrderIDs:exec distinct orderID from dxOrderPublic_file;
count[listOfOrderIDs]
2,769,761


/listOfMembers:`$"member",/:string 1+til 5000;
somewhatNormallyDistributedInts:1+abs floor 550+10*.stat.bm 1000000?1f;
somewhatNormallyDistributedIntsCumSum:sums somewhatNormallyDistributedInts;
indexWhereAllOrdersAssigned:somewhatNormallyDistributedIntsCumSum binr count[listOfOrderIDs];
if[indexWhereAllOrdersAssigned=count[somewhatNormallyDistributedIntsCumSum];'"ERROR:  Not enough distribution points - try again"];
numberOfOrdersToAssignToEachMember:(indexWhereAllOrdersAssigned+1)#somewhatNormallyDistributedInts;
/bump last assigned number down so that a total of count[listOfOrderIDs] are assigned out
numberOfOrdersToAssignToEachMember[indexWhereAllOrdersAssigned]-:somewhatNormallyDistributedIntsCumSum[indexWhereAllOrdersAssigned]-count[listOfOrderIDs];
randomOrderIDIndices:neg[count[listOfOrderIDs]]?til count[listOfOrderIDs];
orderIDIndicesAssignedToEachMember:-1_sums[0,numberOfOrdersToAssignToEachMember] _ randomOrderIDIndices;
orderIDsAssignedToEachMember:listOfOrderIDs @/:orderIDIndicesAssignedToEachMember;
orderIDAssignmentTable:`orderID xkey ungroup ([]member:`$"member",/:string[1+til count orderIDsAssignedToEachMember];orderID:orderIDsAssignedToEachMember);

dxOrderPublic_file:update sym:` sv/: (sym,'member) from dxOrderPublic_file lj orderIDAssignmentTable;



select count distinct orderID by sym from dxOrderPublic_file


(1;2;3)_(1;2;3;4;5)

(sums[(0;1;2;4)]) _ x

x:neg[7]?til 7
index	value
0	3
1	0
2	1
3	6
4	2
5	4
6	5





.debug.xy:()
{[x;y]
neg[y]?x[1]


}/[(();(1 2 3 4 5 6));]each (2;4)



d:([]sym:`BTCUSD`LTCUSD;time:(09:00:04;09:00:05);orderID:`4`5);
l:([]sym:`BTCUSD`BTCUSD`LTCUSD;time:(09:00:01;09:00:01;09:00:03);orderID:`1`2`3),d;
timeWindows:(d[`time]-00:00:02;d[`time]);
lookup:update `p#sym from `sym`time xasc l;
wj1[timeWindows;`sym`time;d;(lookup;(count;`orderID);({count each group x};`sym))];


d:([]sym:`BTCUSD;time:(09:00:04;09:00:04);orderID:`4`5;eventID:(4;5);orderStatus:`cancelled);
l:([]sym:`BTCUSD;time:(09:00:01;09:00:01;09:00:03);orderID:`1`2`3;eventID:(1;2;3);orderStatus:`cancelled),d;

([]sym:`BTCUSD;time:(09:00:01;09:00:01;09:00:03);orderID:`1`2`3;eventID:(1;2;3)),d

/define data-to-analyse and lookup tables d and l
        d:update 

{[d;l]
    d,:exec orderCount:count i from l where time within (d[`time]-00:00:02;d[`time]),sym=d[`sym]
}[;lookupTable]each dataJustReceivedInFeedToBeAnalysed