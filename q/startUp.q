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
 }each `includeEachLoopTest`replayDataFromCurrentTime`createMemberIDs`replayLogFileOnly;

if[not .global.replayLogFileOnly;
	show"last tick log not needed";
	@[system;"rm $HOME/kdbAlertTP/OnDiskDB/sym",string[.z.D];{show"ok, it's not there"}];
 ];

{
    $[x in key .proc.inputOptions;
        (`$".global.",string[x])set .z.D + value raze .proc.inputOptions[x];
        (`$".global.",string[x])set .z.D + 00:05:00
     ];
 }each enlist`replayFinishTime;

.proc.portNumberIncrement:0^first["J"$.proc.inputOptions[`portNumberIncrement]];
.proc.intradayFrequency:1^first["J"$.proc.inputOptions[`intradayFrequency]];

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

//start TP_childA
/show"Starting TP_childA";
/system"q childTick.q sym $HOME/kdbAlertTP/OnDiskDB -p ",string[4444+.proc.portNumberIncrement];
/.global.sleepAfterProcess[];
/tp_childA:hopen`$"::",string[4444+.proc.portNumberIncrement];
/`processStatus upsert ([]name:enlist`tp_childA;port:4444+.proc.portNumberIncrement;handle:tp_childA;PID:tp_childA".z.i";lastHeartBeatReceived:0Np);

//start TP_childB
/show"Starting TP_childB";
/system"q childTick.q sym $HOME/kdbAlertTP/OnDiskDB -p ",string[6666+.proc.portNumberIncrement];
/.global.sleepAfterProcess[];
/tp_childB:hopen`$"::",string[6666+.proc.portNumberIncrement];
/`processStatus upsert ([]name:enlist`tp_childB;port:6666+.proc.portNumberIncrement;handle:tp_childB;PID:tp_childB".z.i";lastHeartBeatReceived:0Np);

.proc.TP_childAPort:5000;
.proc.TP_childBPort:5000;

alertEngineNamesAndPortsAndFunctions:(
 ("aeRT1";5003+.proc.portNumberIncrement;".ae.orderToTrade_wj_alert";.proc.TP_childAPort);("aeRT2";5004+.proc.portNumberIncrement;".ae.orderToTrade_wj_eventWindow_alert";.proc.TP_childAPort);("aeRT3";5005+.proc.portNumberIncrement;".ae.orderToTrade_getRows_alert";.proc.TP_childAPort);("aeRT4";5006+.proc.portNumberIncrement;".ae.orderToTrade_oneAtATime_alert";.proc.TP_childAPort);
 ("aeID1_1";5007+.proc.portNumberIncrement;".ae.orderToTrade_wj_alert";.proc.TP_childBPort);("aeID2_1";5008+.proc.portNumberIncrement;".ae.orderToTrade_wj_eventWindow_alert";.proc.TP_childBPort);("aeID3_1";5009+.proc.portNumberIncrement;".ae.orderToTrade_getRows_alert";.proc.TP_childBPort);("aeID4_1";5010+.proc.portNumberIncrement;".ae.orderToTrade_oneAtATime_alert";.proc.TP_childBPort);
 ("aeID1_5";5011+.proc.portNumberIncrement;".ae.orderToTrade_wj_alert";.proc.TP_childAPort);("aeID2_5";5012+.proc.portNumberIncrement;".ae.orderToTrade_wj_eventWindow_alert";.proc.TP_childAPort);("aeID3_5";5013+.proc.portNumberIncrement;".ae.orderToTrade_getRows_alert";.proc.TP_childAPort);("aeID4_5";5014+.proc.portNumberIncrement;".ae.orderToTrade_oneAtATime_alert";.proc.TP_childAPort);
 ("aeID1_10";5015+.proc.portNumberIncrement;".ae.orderToTrade_wj_alert";.proc.TP_childBPort);("aeID2_10";5016+.proc.portNumberIncrement;".ae.orderToTrade_wj_eventWindow_alert";.proc.TP_childBPort);("aeID3_10";5017+.proc.portNumberIncrement;".ae.orderToTrade_getRows_alert";.proc.TP_childBPort);("aeID4_10";5018+.proc.portNumberIncrement;".ae.orderToTrade_oneAtATime_alert";.proc.TP_childBPort));

intradayFrequencyDict:(99;0;1;5;10)!(til[16];(0;1;2;3);(4;5;6;7);(8;9;10;11);(12;13;14;15));
alertEngineNamesAndPortsAndFunctions:alertEngineNamesAndPortsAndFunctions[intradayFrequencyDict[.proc.intradayFrequency]];

if[not .global.includeEachLoopTest;
    alertEngineNamesAndPortsAndFunctions:alertEngineNamesAndPortsAndFunctions where not (alertEngineNamesAndPortsAndFunctions[;0][;4])="4"
 ];

.global.replayStartTime:$[.global.replayDataFromCurrentTime;.z.P;`timestamp$.z.D];
.global.testStartTime:.z.P;

show"Starting ",string[count[alertEngineNamesAndPortsAndFunctions]]," Alert Engines:";

{
    freq:`timespan$`minute$0^"J"$last["_"vs x[0]];
    numberOfSlaves:$[`numberOfSlaves in key .proc.inputOptions;value raze .proc.inputOptions[`numberOfSlaves];0];
    startupCommand:"q -procName ",x[0]," -freq ",string[freq]," -alertFunction ",x[2]," -replayStartTime ",string[.global.replayStartTime]," -testStartTime ",string[.global.testStartTime]," -portNumberIncrement ",string[.proc.portNumberIncrement]," -myChildTickerPlant ",string[x[3]]," -p ",string[x[1]]," -s ",string[numberOfSlaves];
    /show " " sv 5#" " vs startupCommand;
	show  startupCommand;
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

startTime:.z.P;
show"startTime = ",string[startTime];
show processStatus;

.global.statsTableWarning:"";

.z.ts:{
    @[{neg[x]({neg[.z.w]({[x;y]update lastHeartBeatReceived:.z.P,status:y from `processStatus where handle=x;};x;@[{last[dxReplayStatus[`sym]]};`;`])};x)};;`down]each exec handle from processStatus;
	if[0D00:30<.z.P-exec last lastHeartBeatReceived from processStatus where name=`replay;
		show"Replay Appears Down - Shutting Down";
		.global.statsTableWarning:"REPLAYDOWN_";
		system"l shutDown.q";
	];
    if[enlist[`engineFinished]~exec distinct status from processStatus where name like "ae*";
        show"All Engines Finished - Shutting Down";
        system"l shutDown.q";  
    ];
 };
system"t 10000";