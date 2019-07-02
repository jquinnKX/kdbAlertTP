/system"cd C:\\Users\\jason\\Anaconda3\\q\\kdbAlertTP";
system"c 50 500";
system"p 55555";
`processStatus upsert ([]name:enlist`master;port:55555;handle:0;PID:0".z.i";lastHeartBeatReceived:0Np);

/start alertMonitor
system"q am.q -p 999";
am:hopen`::999;
`processStatus upsert ([]name:enlist`alertMonitor;port:999;handle:am;PID:am".z.i";lastHeartBeatReceived:0Np);

/start TP
system"q tick.q sym C:/OnDiskDB -p 5000";
tp:hopen`::5000;
`processStatus upsert ([]name:enlist`tp;port:5000;handle:tp;PID:tp".z.i";lastHeartBeatReceived:0Np);
/start HDB
system"q hdb.q C:/OnDiskDB/sym -p 5001";
hdb:hopen`::5001;
`processStatus upsert ([]name:enlist`hdb;port:5001;handle:hdb;PID:hdb".z.i";lastHeartBeatReceived:0Np);
/start RDB
system"q r.q localhost:5000 localhost:5001 -p 5002";
rdb:hopen`::5002;
`processStatus upsert ([]name:enlist`rdb;port:5002;handle:rdb;PID:rdb".z.i";lastHeartBeatReceived:0Np);
/start aeRT1
system"q aeRT1.q localhost:5000 localhost:5002 aeRT1 -p 5003";
aeRT1:hopen`::5003;
`processStatus upsert ([]name:enlist`aeRT1;port:5003;handle:aeRT1;PID:aeRT1".z.i";lastHeartBeatReceived:0Np);
/start aeRT2
system"q aeRT2.q localhost:5000 localhost:5002 aeRT2 -p 5004";
aeRT2:hopen`::5004;
`processStatus upsert ([]name:enlist`aeRT2;port:5004;handle:aeRT2;PID:aeRT2".z.i";lastHeartBeatReceived:0Np);
/start aeRT3
system"q aeRT3.q localhost:5000 localhost:5002 aeRT3 -p 5005";
aeRT3:hopen`::5005;
`processStatus upsert ([]name:enlist`aeRT3;port:5005;handle:aeRT3;PID:aeRT3".z.i";lastHeartBeatReceived:0Np);
/start aeRT4
system"q aeRT4.q localhost:5000 localhost:5002 aeRT4 -p 5006";
aeRT4:hopen`::5006;
`processStatus upsert ([]name:enlist`aeRT4;port:5006;handle:aeRT4;PID:aeRT4".z.i";lastHeartBeatReceived:0Np);

intraDayTimerFrequency:string (numSeconds:1000)*(60*numMinutes:1);
/start aeID1_1
system"q aeID1.q localhost:5000 localhost:5002 aeID1_1 -p 5007";
aeID1_1:hopen`::5007;
aeID1_1({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID1_1;port:5007;handle:aeID1_1;PID:aeID1_1".z.i";lastHeartBeatReceived:0Np);
/start aeID2_1
system"q aeID2.q localhost:5000 localhost:5002 aeID2_1 -p 5008";
aeID2_1:hopen`::5008;
aeID2_1({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID2_1;port:5008;handle:aeID2_1;PID:aeID2_1".z.i";lastHeartBeatReceived:0Np);
/start aeID3_1
system"q aeID3.q localhost:5000 localhost:5002 aeID3_1 -p 5009";
aeID3_1:hopen`::5009;
aeID3_1({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID3_1;port:5009;handle:aeID3_1;PID:aeID3_1".z.i";lastHeartBeatReceived:0Np);
/start aeID4_1
system"q aeID4.q localhost:5000 localhost:5002 aeID4_1 -p 5010";
aeID4_1:hopen`::5010;
aeID4_1({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID4_1;port:5010;handle:aeID4_1;PID:aeID4_1".z.i";lastHeartBeatReceived:0Np);

intraDayTimerFrequency:string (numSeconds:1000)*(60*numMinutes:5);
/start aeID1_5
system"q aeID1.q localhost:5000 localhost:5002 aeID1_5 -p 5011";
aeID1_5:hopen`::5011;
aeID1_5({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID1_5;port:5011;handle:aeID1_5;PID:aeID1_5".z.i";lastHeartBeatReceived:0Np);
/start aeID2_5
system"q aeID2.q localhost:5000 localhost:5002 aeID2_5 -p 5012";
aeID2_5:hopen`::5012;
aeID2_5({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID2_5;port:5012;handle:aeID2_5;PID:aeID2_5".z.i";lastHeartBeatReceived:0Np);
/start aeID3_5
system"q aeID3.q localhost:5000 localhost:5002 aeID3_5 -p 5013";
aeID3_5:hopen`::5013;
aeID3_5({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID3_5;port:5013;handle:aeID3_5;PID:aeID3_5".z.i";lastHeartBeatReceived:0Np);
/start aeID4_5
system"q aeID4.q localhost:5000 localhost:5002 aeID4_5 -p 5014";
aeID4_5:hopen`::5014;
aeID4_5({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID4_5;port:5014;handle:aeID4_5;PID:aeID4_5".z.i";lastHeartBeatReceived:0Np);

intraDayTimerFrequency:string (numSeconds:1000)*(60*numMinutes:10);
/start aeID1_10
system"q aeID1.q localhost:5000 localhost:5002 aeID1_10 -p 5015";
aeID1_10:hopen`::5015;
aeID1_10({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID1_10;port:5015;handle:aeID1_10;PID:aeID1_10".z.i";lastHeartBeatReceived:0Np);
/start aeID2_10
system"q aeID2.q localhost:5000 localhost:5002 aeID2_10 -p 5016";
aeID2_10:hopen`::5016;
aeID2_10({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID2_10;port:5016;handle:aeID2_10;PID:aeID2_10".z.i";lastHeartBeatReceived:0Np);
/start aeID3_10
system"q aeID3.q localhost:5000 localhost:5002 aeID3_10 -p 5017";
aeID3_10:hopen`::5017;
aeID3_10({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID3_10;port:5017;handle:aeID3_10;PID:aeID3_10".z.i";lastHeartBeatReceived:0Np);
/start aeID4_10
system"q aeID4.q localhost:5000 localhost:5002 aeID4_10 -p 5018";
aeID4_10:hopen`::5018;
aeID4_10({system"t ",x};intraDayTimerFrequency);
`processStatus upsert ([]name:enlist`aeID4_10;port:5018;handle:aeID4_10;PID:aeID4_10".z.i";lastHeartBeatReceived:0Np);


/start Feedhandler
system"q -p 5100 -simulateMembers 1b";
replay:hopen`::5100;
`processStatus upsert ([]name:enlist`replay;port:5100;handle:replay;PID:replay".z.i";lastHeartBeatReceived:0Np);
neg[replay]({system"l replayData.q"};`);
/TASKLIST /FI "IMAGENAME eq q.exe"
show .z.P;
show processStatus;

.master.onDiskTablePath:hsym`$"C:\\OnDiskDB\\processStatus_",ssr[;":";""]string[.z.P];

.z.ts:{
    {neg[x]({neg[.z.w]({update lastHeartBeatReceived:.z.P from `processStatus where handle=x;};x)};x)}each exec handle from processStatus;
    .master.onDiskTablePath set processStatus;
 };
system"t 10000";