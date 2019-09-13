#!/bin/bash
#q
#echo healthcheck
#../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 00:00:20 -removeLogFile 1b -experimentName healthcheck
#
#
echo Test1Run1
../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -removeLogFile 0b -experimentName Test1Run1
echo Test2Run1
../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -replayLogFileOnly 1b -removeLogFile 1b -experimentName Test2Run1
echo Test1Run2
../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -removeLogFile 0b -experimentName Test1Run2
echo Test2Run2
../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -replayLogFileOnly 1b -removeLogFile 1b -experimentName Test2Run2
#echo Test1Run3
#../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -removeLogFile 0b -experimentName Test1Run3
#echo Test2Run3
#../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -replayLogFileOnly 1b -removeLogFile 1b -experimentName Test2Run3
#
#
#echo Test3Run1
#../q/l64/q startUp.q -createMemberIDs 1b -replayFinishTime 04:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b -experimentName Test3Run1
#echo Test3Run2
#../q/l64/q startUp.q -createMemberIDs 1b -replayFinishTime 04:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b -experimentName Test3Run2
#echo Test3Run3
#../q/l64/q startUp.q -createMemberIDs 1b -replayFinishTime 04:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b -experimentName Test3Run3
#
#
#echo Test 4
#../q/l64/q startUp.q -createMemberIDs 1b -replayFinishTime 12:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b -experimentName Test4
#
#
#
#IGNORE
#
#
#echo Test 4b
#../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 0 -removeLogFile 1b -experimentName test4run2
#echo Test 5aetry
#../q/l64/q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 4 -removeLogFile 1b -experimentName test5run1retry
#echo Test 5b