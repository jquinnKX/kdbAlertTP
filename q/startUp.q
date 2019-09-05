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

.proc.portNumberIncrement:0^first["J"$.proc.inputOptions[`portNumberIncrement]];

/make subdirectories if not present
if[not `processLogs in `$system"ls $HOME/kdbAlertTP";system"mkdir $HOME/kdbAlertTP/processLogs";];
if[not `tableImages in `$system"ls $HOME/kdbAlertTP";system"mkdir $HOME/kdbAlertTP/tableImages";];
if[not `statsTables in `$system"ls $HOME/kdbAlertTP";system"mkdir $HOME/kdbAlertTP/statsTables";];
.global.sleepAfterProcess:{system"sleep 1"};
system"c 50 1000";
system"p ",string[55555+.proc.portNumberIncrement];
`processStatus upsert ([]name:enlist`master;port:55555+.proc.portNumberIncrement;handle:0;PID:0".z.i";lastHeartBeatReceived:0Np);

/start alertMonitor
show"Starting Alert Monitor";
system"q am.q -p ",string[9999+.proc.portNumberIncrement];
.global.sleepAfterProcess[];
am:hopen`$"::",string[9999+.proc.portNumberIncrement];
`processStatus upsert ([]name:enlist`alertMonitor;port:9999+.proc.portNumberIncrement;handle:am;PID:am".z.i";lastHeartBeatReceived:0Np);

/start TP
show"Starting TP";
system"q tick.q sym $HOME/kdbAlertTP/OnDiskDB -p ",string[5000+.proc.portNumberIncrement];
.global.sleepAfterProcess[];
tp:hopen`$"::",string[5000+.proc.portNumberIncrement];
`processStatus upsert ([]name:enlist`tp;port:5000+.proc.portNumberIncrement;handle:tp;PID:tp".z.i";lastHeartBeatReceived:0Np);

/start HDB
show"Starting HDB";
system"q hdb.q $HOME/kdbAlertTP/OnDiskDB/sym -p ",string[5001+.proc.portNumberIncrement];
.global.sleepAfterProcess[];
hdb:hopen`$"::",string[5001+.proc.portNumberIncrement];
`processStatus upsert ([]name:enlist`hdb;port:5001+.proc.portNumberIncrement;handle:hdb;PID:hdb".z.i";lastHeartBeatReceived:0Np);

/start RDB
show"Starting RDB";
system"q r.q localhost:",string[5000+.proc.portNumberIncrement]," localhost:",string[5001+.proc.portNumberIncrement]," -p ",string[5002+.proc.portNumberIncrement];
.global.sleepAfterProcess[];
rdb:hopen`$"::",string[5002+.proc.portNumberIncrement];
`processStatus upsert ([]name:enlist`rdb;port:5002+.proc.portNumberIncrement;handle:rdb;PID:rdb".z.i";lastHeartBeatReceived:0Np);

alertEngineNamesAndPortsAndFunctions:(
 ("aeRT1";5003+.proc.portNumberIncrement;".ae.orderToTrade_wj_alert");("aeRT2";5004+.proc.portNumberIncrement;".ae.orderToTrade_wj_eventWindow_alert");("aeRT3";5005+.proc.portNumberIncrement;".ae.orderToTrade_getRows_alert");("aeRT4";5006+.proc.portNumberIncrement;".ae.orderToTrade_oneAtATime_alert");
 ("aeID1_1";5007+.proc.portNumberIncrement;".ae.orderToTrade_wj_alert");("aeID2_1";5008+.proc.portNumberIncrement;".ae.orderToTrade_wj_eventWindow_alert");("aeID3_1";5009+.proc.portNumberIncrement;".ae.orderToTrade_getRows_alert");("aeID4_1";5010+.proc.portNumberIncrement;".ae.orderToTrade_oneAtATime_alert");
 ("aeID1_5";5011+.proc.portNumberIncrement;".ae.orderToTrade_wj_alert");("aeID2_5";5012+.proc.portNumberIncrement;".ae.orderToTrade_wj_eventWindow_alert");("aeID3_5";5013+.proc.portNumberIncrement;".ae.orderToTrade_getRows_alert");("aeID4_5";5014+.proc.portNumberIncrement;".ae.orderToTrade_oneAtATime_alert");
 ("aeID1_10";5015+.proc.portNumberIncrement;".ae.orderToTrade_wj_alert");("aeID2_10";5016+.proc.portNumberIncrement;".ae.orderToTrade_wj_eventWindow_alert");("aeID3_10";5017+.proc.portNumberIncrement;".ae.orderToTrade_getRows_alert");("aeID4_10";5018+.proc.portNumberIncrement;".ae.orderToTrade_oneAtATime_alert"));

if[.global.excludeEachLoopTest;
    alertEngineNamesAndPortsAndFunctions:alertEngineNamesAndPortsAndFunctions where not (alertEngineNamesAndPortsAndFunctions[;0][;4])="4"
 ];

.global.replayStartTime:$[.global.replayDataFromCurrentTime;.z.P;`timestamp$.z.D];
.global.testStartTime:.z.P;

{
    freq:`timespan$`minute$0^"J"$last["_"vs x[0]];
    numberOfSlaves:$[`numberOfSlaves in key .proc.inputOptions;value raze .proc.inputOptions[`numberOfSlaves];0];
    startupCommand:"q -procName ",x[0]," -freq ",string[freq]," -alertFunction ",x[2]," -replayStartTime ",string[.global.replayStartTime]," -testStartTime ",string[.global.testStartTime]," -portNumberIncrement ",string[.proc.portNumberIncrement]," -p ",string[x[1]]," -s ",string[numberOfSlaves];
    show startupCommand;
    system startupCommand;
    .global.sleepAfterProcess[];
    (`$x[0])set hopen`$"::",string[x[1]];    
    `processStatus upsert ([]name:enlist(`$x[0]);port:x[1];handle:get[`$x[0]];PID:get[`$x[0]]".z.i";lastHeartBeatReceived:0Np);
    neg[get`$x[0]]({system"l ae.q"};`);
 }each alertEngineNamesAndPortsAndFunctions;

/start Feedhandler
show"Starting Feed Handler";
$[.global.replayLogFileOnly;
    [
        show"Replaying Log File Only";
    ];
    [
        startUpCommand:"q -p ",string[5100+.proc.portNumberIncrement]," -createMemberIDs ",string[.global.createMemberIDs],"b -replayDataFromCurrentTime ",string[.global.replayDataFromCurrentTime],"b -procName replay -replayFinishTime ",string[.global.replayFinishTime]," -replayLogFileOnly ",string[.global.replayLogFileOnly],"b"," -portNumberIncrement ",string[.proc.portNumberIncrement];
        system[startUpCommand];
        .global.sleepAfterProcess[];
        replay:hopen`$"::",string[5100+.proc.portNumberIncrement];
        `processStatus upsert ([]name:enlist`replay;port:5100+.global.replayLogFileOnly;handle:replay;PID:replay".z.i";lastHeartBeatReceived:0Np);
        neg[replay]({system"l replayData.q"};`);
    ]
 ];

show .z.P;
show processStatus;

.z.ts:{
    @[{neg[x]({neg[.z.w]({[x;y]update lastHeartBeatReceived:.z.P,status:y from `processStatus where handle=x;};x;@[{last[dxReplayStatus[`sym]]};`;`])};x)};;`down]each exec handle from processStatus;
    if[enlist[`engineFinished]~exec distinct status from processStatus where name like "ae*";
        show"All Engines Finished - Shutting Down";
        system"l shutDown.q";  
    ];
 };
system"t 10000";