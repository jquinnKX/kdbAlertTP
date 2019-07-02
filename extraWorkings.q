select count[i],min[transactTime],max[transactTime],distinct eventType from dxOrderPublic
select count[i],min[transactTime],max[transactTime],distinct eventType from dxTradePublic
dxTradePublic
dxTradePublic
transactTime	                transactTime1
2019.05.20D11:08:49.956000000	2019.05.20D11:17:42.916000000


reverse dxOrderPublic
count dxOrderPublic
count dxTransactionPublic
select count i by eventType from 600#dxTransactionPublic

600#dxTransactionPublic

.z.i
\taskkill /PID 14828 /F

select `minute$max[transactTime] by eventType from dxOrderPublic
select `minute$max[transactTime] by eventType from dxTradePublic
reverse replayLog

dxTransactionPublic




sourceTable:select from dxOrderPublic where transactTime within {(x-0D00:00:10;x)}exec max transactTime from dxOrderPublic;
lookupTable:select from dxTradePublic where transactTime within {(x-0D00:00:20;x)}exec max transactTime from sourceTable;
count sourceTable
count lookupTable

TWargs:(`sourceTable`lookupTable`timeInterval)!(sourceTable;lookupTable;0D00:00:10)
.rA.getRowsInTimeWindow TWargs

8#sourceTable
6#lookupTable


t:([]sym:3#`ibm;time:10:01:01 10:01:04 10:01:08;price:100 101 105)
t
a:101 103 103 104 104 107 108 107 108;b:98 99 102 103 103 104 106 106 107;
q:update qTime:time from ([]sym:`ibm; time:10:00:58+til 9; ask:a; bid:b)

f:`sym`time
w:-2 1+\:t.time
wj1[w;f;t;(q;(max;`ask);(min;`bid);(min;`qTime))]



/wj[(`second$t[`time]-0D00:14;t[`time]);`sym`time;([]time:09:00:00 09:14:00;sym:`abc);(update qTime:time,rNum:i,b:(1.1;2.2;0Nf;0Nf;0Nf),a:(0Nf;0Nf;3.3;4.4;5.5) from ([]time:08:00:00 08:15:00 08:30:00 08:45:00 09:00:00;sym:`abc);((::;`rNum);(max;`b);(min;`a)))]

wj[(`second$t[`time]-0D00:14;t[`time]);`sym`time;([]time:09:00:00 09:14:00;sym:`abc);(update qTime:time,rNum:i,b:(1.1;2.2;3.3;0Nf;0Nf),a:(0Nf;0Nf;0Nf;4.4;5.5) from ([]time:08:00:00 08:15:00 08:30:00 08:45:00 09:00:00;sym:`abc);((::;`rNum);(max;`b)))]

t2:([]time:09:00:00 09:14:00;sym:`abc)
wj[
    (`second$t2[`time]-0D00:14;t2[`time]);
    `sym`time;
    t2;
    (update qTime:time,rNum:i,b:(1.1;2.2;3.3;4.4;0Nf),a:(0Nf;0Nf;0Nf;0Nf;5.5) from ([]time:08:00:00 08:15:00 08:30:00 08:45:00 09:00:00;sym:`abc);(min;`qTime);(::;`rNum);({0.33*avg[x]};`b);(min;`a))
]


