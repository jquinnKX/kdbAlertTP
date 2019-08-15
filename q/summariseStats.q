filePath:raze[system"echo $HOME/kdbAlertTP/statsTables/"];
folders:{x where x like "statsTable*"}system"ls ",filePath;
filePaths:hsym`$filePath,/:folders;
runTimes:(,/)get each filePaths;
if[not all `testStartTime`replayGap in key `.global;
    .global.testStartTime:exec first transactTime from runTimes where sym=`aeRT1,i=first i;
    .global.replayGap:exec first startTime-dataStart from runTimes where sym=`aeRT1,i=first i;
 ];
update executionTime:endTime-startTime,timeUsedMins:{x%60000}timeUsed,minDataLag:endTime-(dataEnd+.global.replayGap),maxDataLag:endTime-(dataStart+.global.replayGap),memUsedDuring:memUsedAfter-memUsedBefore,heapUsedDuring:heapAfter-heapBefore from `runTimes;
hsym[`$filePath,raze[.proc.inputOptions[`experimentName]],"_runTimes_",15#string[.global.testStartTime] except ":."] set runTimes;


system"cd ",-1_filePath;
system"rm "," "sv folders;

summaryTableName:`$raze[.proc.inputOptions[`experimentName]],"_summary_",15#string[.global.testStartTime] except ":.";
summaryTableName set select firstLogTime:min startTime,lastLogTime:max endTime,maxExecutionTime:max[executionTime],maxTimeUsedSecond:{x%1000}max[timeUsed],maxSpaceUsedMB:{x%1000000}max[spaceUsed],mostMinDataLag:max[minDataLag],mostMaxDataLag:max[maxDataLag],maxMemUsedDuring:max[memUsedDuring],maxHeapUsedDuring:max[heapUsedDuring] by frequency,sym,analytic from runTimes;

/save down as KDB table
hsym[summaryTableName] set get summaryTableName;
/save down as CSV
save hsym[`$string[summaryTableName],".csv"];
show"Done Saving Stats";
system"cd ",raze[system["echo $HOME"]],"/kdbAlertTP";