/point console to directory containing this script and run
/q startUp.q

.proc.inputOptions:.Q.opt .z.x;
show"Input Options Are:";
0N!.proc.inputOptions;
{
    $[x in key .proc.inputOptions;
        (`$".global.",string[x])set value raze .proc.inputOptions[x];
        (`$".global.",string[x])set 0b
    ]
 }each `excludeEachLoopTest`replayDataFromCurrentTime`createMemberIDs`replayLogFileOnly;

{
    $[x in key .proc.inputOptions;
        (`$".global.",string[x])set .z.D + value raze .proc.inputOptions[x];
        (`$".global.",string[x])set .z.D + 01:00:00
     ];
 }each enlist`replayFinishTime;

system"c 50 1000";
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

alertEngineNamesAndPortsAndFunctions:(
 ("aeRT1";5003;".ae.orderToTrade_wj_alert");("aeRT2";5004;".ae.orderToTrade_wj_eventWindow_alert");("aeRT3";5005;".ae.orderToTrade_getRows_alert");("aeRT4";5006;".ae.orderToTrade_oneAtATime_alert");
 ("aeID1_1";5007;".ae.orderToTrade_wj_alert");("aeID2_1";5008;".ae.orderToTrade_wj_eventWindow_alert");("aeID3_1";5009;".ae.orderToTrade_getRows_alert");("aeID4_1";5010;".ae.orderToTrade_oneAtATime_alert");
 ("aeID1_5";5011;".ae.orderToTrade_wj_alert");("aeID2_5";5012;".ae.orderToTrade_wj_eventWindow_alert");("aeID3_5";5013;".ae.orderToTrade_getRows_alert");("aeID4_5";5014;".ae.orderToTrade_oneAtATime_alert");
 ("aeID1_10";5015;".ae.orderToTrade_wj_alert");("aeID2_10";5016;".ae.orderToTrade_wj_eventWindow_alert");("aeID3_10";5017;".ae.orderToTrade_getRows_alert");("aeID4_10";5018;".ae.orderToTrade_oneAtATime_alert"));

if[.global.excludeEachLoopTest;
    alertEngineNamesAndPortsAndFunctions:alertEngineNamesAndPortsAndFunctions where not (alertEngineNamesAndPortsAndFunctions[;0][;4])="4"
 ];

.global.replayStartTime:$[.global.replayDataFromCurrentTime;.z.P;`timestamp$.z.D];
.global.testStartTime:.z.P;

{
    freq:`timespan$`minute$0^"J"$last["_"vs x[0]];
    numberOfSlaves:$[`numberOfSlaves in key .proc.inputOptions;value raze .proc.inputOptions[`numberOfSlaves];0];
    startupCommand:"q -procName ",x[0]," -freq ",string[freq]," -alertFunction ",x[2]," -replayStartTime ",string[.global.replayStartTime]," -testStartTime ",string[.global.testStartTime]," -p ",string[x[1]]," -s ",string[numberOfSlaves];
    show startupCommand;
    system startupCommand;
    (`$x[0])set hopen`$"::",string[x[1]];    
    `processStatus upsert ([]name:enlist(`$x[0]);port:x[1];handle:get[`$x[0]];PID:get[`$x[0]]".z.i";lastHeartBeatReceived:0Np);
    neg[get`$x[0]]({system"l ae.q"};`);
 }each alertEngineNamesAndPortsAndFunctions;

/start Feedhandler
$[.global.replayLogFileOnly;
    [
        show"Replaying Log File Only";
    ];
    [
        startUpCommand:"q -p 5100 -createMemberIDs ",string[.global.createMemberIDs],"b -replayDataFromCurrentTime ",string[.global.replayDataFromCurrentTime],"b -procName replay -replayFinishTime ",string[.global.replayFinishTime]," -replayLogFileOnly ",string[.global.replayLogFileOnly],"b";
        system[startUpCommand];
        replay:hopen`::5100;
        `processStatus upsert ([]name:enlist`replay;port:5100;handle:replay;PID:replay".z.i";lastHeartBeatReceived:0Np);
        neg[replay]({system"l replayData.q"};`);
    ]
 ];

show .z.P;
show processStatus;

.master.onDiskTablePath:hsym`$"C:\\OnDiskDB\\processStatus_",ssr[;":";""]string[.z.P];

.z.ts:{
    @[{neg[x]({neg[.z.w]({[x;y]update lastHeartBeatReceived:.z.P,status:y from `processStatus where handle=x;};x;@[{last[dxReplayStatus[`sym]]};`;`])};x)};;`down]each exec handle from processStatus;
    /.master.onDiskTablePath set processStatus;
    if[enlist[`engineFinished]~exec distinct status from processStatus where name like "ae*";
        show"All Engines Finished - Shutting Down";
        system"l shutDown.q";  
    ];
 };
system"t 10000";