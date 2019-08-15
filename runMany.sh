#!/bin/bash
#q
#echo Test 0a
#q startUp.q -createMemberIDs 0b -replayFinishTime 00:05:00 -removeLogFile 1b -experimentName 5minsThread1
#echo Test 1aretry2
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -removeLogFile 0b -experimentName test1run1retry2
#echo Test 2aretry2
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -replayLogFileOnly 1b -removeLogFile 1b -experimentName test2run1retry2
#echo Test 3retry2
#q startUp.q -createMemberIDs 1b -replayFinishTime 04:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b -experimentName test3run1retry2
#echo Test 3b
#q startUp.q -createMemberIDs 1b -replayFinishTime 04:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b -experimentName test3run2
#echo Test 3c
#q startUp.q -createMemberIDs 1b -replayFinishTime 04:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b -experimentName test3run3
#echo Test 4retry2
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 0 -removeLogFile 1b -experimentName test4run1retry2
#echo Test 4b
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 0 -removeLogFile 1b -experimentName test4run2
#echo Test 5aretry
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 4 -removeLogFile 1b -experimentName test5run1retry
#echo Test 5b
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 4 -removeLogFile 1b -experimentName test5run2
#/echo Test 5retry2
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 4 -removeLogFile 1b -experimentName test5run1retry2
#echo Test 5With0Slaves
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 0 -removeLogFile 1b -experimentName 5With0Slaves
#echo Test 5With4Slaves
#q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 4 -removeLogFile 1b -experimentName 5With4Slaves
echo Test 5With4Slaves2
q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 4 -removeLogFile 1b -experimentName 5With4Slaves2
echo Test 5With4Slaves3
q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 4 -removeLogFile 1b -experimentName 5With4Slaves3
#echo Test 6
#q startUp.q -createMemberIDs 1b -replayFinishTime 12:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b -experimentName test6run1