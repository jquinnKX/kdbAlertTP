if[@[{1b~value raze .proc.inputOptions[`removeLogFile]};`;0b];
	@[system;"rm $HOME/kdbAlertTP/OnDiskDB/sym",string[.z.D];{show"log not there"}];
 ];

show"Killing Processes";
{@[system;"kill -9 ",string[x];""];}each exec PID from processStatus where name <>`master;

system"l summariseStats.q";

exit[0];





