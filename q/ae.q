/q ae1.q -procName ae1_X -freq 0D00:0X -p N
.proc.inputOptions:.Q.opt .z.x;
.proc.name:`$raze .proc.inputOptions[`procName];

logfile:hopen hsym`$raze[system["echo $HOME/kdbAlertTP/processLogs/procLog"]],string .proc.name;
.log.out:{x string[.z.P],":-> ",y,"\n"}[logfile;];
.log.out["log started at ",string[.z.P]];

if[not "w"=first string .z.o;system "sleep 1"];
system"c 25 300";

.ae.intradayFrequency:value raze .proc.inputOptions[`freq];
.ae.executionPoint:$[.ae.intradayFrequency>0D;`intraday;`realTime];
.ae.replayStartTime:value raze .proc.inputOptions[`replayStartTime];
.ae.nextIntradayTransactionTimeRunPoint:.ae.replayStartTime+.ae.intradayFrequency;
.ae.lastEventAnalysed:0;

.ae.alertFunction:`$raze .proc.inputOptions[`alertFunction];

system"l sym.q";

.ae.statsTablePath:hsym`$raze[system["echo $HOME/kdbAlertTP/statsTables/statsTable_"]],string[.proc.name];
.ae.statsTablePath set dxStats;
.ae.testStartTime:value raze .proc.inputOptions[`testStartTime];

.proc.portNumberIncrement:0^first["J"$.proc.inputOptions[`portNumberIncrement]];
.ae.alertMonitorHandle:neg hopen`$"::",string[9999+.proc.portNumberIncrement];

system"l alertFunctions.q";

upd:{[t;x]
    /.debug.upd:(`t`x)!(t;x);
    /`updStats upsert ([]time:enlist[.z.p];cnt:count[x];mnt:min[x`transactTime]);
    t insert x;
    if[0=type x;x:enlist cols[t]!x;];
    .ae.alert_upd[t;x];
    if[count dxAlert;
        .ae.alertMonitorHandle("upd";`dxAlert;select from dxAlert where i=(first;i)fby eventID);
        delete from `dxAlert;
    ];
 };

.ae.alert_upd:{[t;x]
    endOfReplay:(&/)(t=`dxReplayStatus;`replayFinished=first[x[`sym]]);
    if[(t=`dxOrderPublic) or endOfReplay;
        if[or[.ae.executionPoint=`realTime;and[.ae.executionPoint=`intraday;or[last[x`transactTime]>=.ae.nextIntradayTransactionTimeRunPoint;endOfReplay]]];
            if[endOfReplay and .ae.executionPoint=`realTime;.log.out["Engine Finished"];`dxReplayStatus insert (.z.P;`engineFinished);:()];
            if[endOfReplay;.log.out["End Of Replay - Analysing last intraday buckets"];];
            startTime:.z.P;
            wBefore:.Q.w[];

            `dataToAnalyse set $[.ae.executionPoint=`realTime;
                [
                    select transactTime,sym,eventID,orderID,executionOptions,eventType,orderType from x where eventType=`Place
                ];
                [
                    select transactTime,sym,eventID,orderID,executionOptions,eventType,orderType from dxOrderPublic where 
                        eventID>.ae.lastEventAnalysed,
                        not[executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel")]
                        or (executionOptions in `$("fill-or-kill";"immediate-or-cancel";"maker-or-cancel"))
                        and not ({`Place`Cancel~x};eventType)fby ([]orderID;transactTime),
                        transactTime<.ae.nextIntradayTransactionTimeRunPoint-0D00:00:10*not endOfReplay,
                        eventType=`Place
                ]
            ];
            if[not count dataToAnalyse;:`noDataToAnalyse];
            .log.out["Analysing data from ",string[first dataToAnalyse[`transactTime]]," to ",string[last dataToAnalyse[`transactTime]]];
            tsvector:$[.ae.alertFunction like "*oneAtATime*";
                system"ts:20 .ae.alertFunction[;.ae.executionPoint] peach dataToAnalyse";
                system"ts:20 .ae.alertFunction[dataToAnalyse;.ae.executionPoint]"
            ];
            endTime:.z.P;
            wAfter:.Q.w[];

            .ae.statsTablePath upsert cols[dxStats]!(.ae.testStartTime;`$first "_"vs string .proc.name;.ae.intradayFrequency;.ae.alertFunction;startTime;endTime;min[dataToAnalyse`transactTime];max[dataToAnalyse`transactTime];tsvector[0];tsvector[1];wBefore`used;wAfter`used;wBefore`heap;wAfter`heap);

            .ae.lastEventAnalysed:last[dataToAnalyse`eventID];
            .ae.nextIntradayTransactionTimeRunPoint+:.ae.intradayFrequency;
            if[endOfReplay;.log.out["Engine Finished"];`dxReplayStatus insert (.z.P;`engineFinished)];
        ];
    ];
 };

/ get the ticker plant and history ports, defaults are 5000,5001
.u.x:("localhost:",string[5000+.proc.portNumberIncrement];"localhost:",string[5001+.proc.portNumberIncrement]);

/ end of day: save, clear, hdb reload
/.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};
.u.end:{};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";