if[@[{1b~value raze .proc.inputOptions[`removeLogFile]};`;0b];
    system"rm $HOME/kdbAlertTP/OnDiskDB/sym",string[.z.D]
 ];

show"Killing Processes";
system"kill -9 "," "sv string exec PID from processStatus where name<>`master;

system"l summariseStats.q";

exit[0];





