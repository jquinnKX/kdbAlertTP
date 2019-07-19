ECHO OFF
cd C:/q/kdbAlertTP
:: ECHO Test 1
:: q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -removeLogFile 0b
:: ECHO Test 2
:: q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -replayLogFileOnly 1b -removeLogFile 1b
:: ECHO Test 3
:: q startUp.q -createMemberIDs 1b -replayFinishTime 04:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b
:: ECHO Test 4
:: q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 0 -removeLogFile 1b
:: ECHO Test 5
:: q startUp.q -createMemberIDs 0b -replayFinishTime 01:00:00 -numberOfSlaves 4 -removeLogFile 1b
ECHO Test 6
q startUp.q -createMemberIDs 1b -replayFinishTime 12:00:00 -replayLogFileOnly 0b -removeLogFile 1b -excludeEachLoopTest 1b
PAUSE