$[`processStatus in key`.;
    {@[system;ssr["taskkill /PID N /F";"N";string[x]];`]}each exec PID from processStatus where PID<>.z.i;
    {if[not x[0] in key `.;x[0] set @[{hopen[x]};x[1];-1]]}each ((`am;`::999);(`tp;`::5000);(`hdb;`::5002);(`rdb;`::5001);(`aeRT1;`::5003);(`aeRT2;`::5004);(`aeRT3;`::5005);(`aeRT4;`::5006);(`aeID1_1;`::5007);(`aeID2_1;`::5008);(`aeID3_1;`::5009);(`aeID4_1;`::5010);(`aeID1_5;`::5011);(`aeID2_5;`::5012);(`aeID3_5;`::5013);(`aeID4_5;`::5014);(`aeID1_10;`::5015);(`aeID2_10;`::5016);(`aeID3_10;`::5017);(`aeID4_10;`::5018);(`replay;`::5100))
 ];
/{@[system;ssr["taskkill /PID N /F";"N";string[x]];`]}each "J"$5#'29_'3_system"TASKLIST /FI \"IMAGENAME eq q.exe\"";
system"cd C:\\OnDiskDB";
system"del sym",string[.z.D];
/system"cd C:\\Users\\jason\\Anaconda3\\q\\kdbAlertTP";
show"TASKLIST /FI \"IMAGENAME eq q.exe\"";
tasks:system"TASKLIST /FI \"IMAGENAME eq q.exe\"";
show tasks;
/0N!tasks;
exit[0];





