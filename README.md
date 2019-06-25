# kdbAlertTP
TP set-up for test Alert Monitor system

This framework is an expansion of the skeleton TP framework available at
https://code.kx.com/v2/wp/building_real_time_tick_subscribers.pdf

It has been built on to replay our cryptocurrency data set with the original timestamp but with today’s date in a live manner.  Each routine and execution-point (e.g. 'intraday 1 minute' + 'wj with timestamps') test was run in it’s own alert engine process.  If running windows, place the contents of kdbAlertTP on gitbut in a single location, point your windows terminal to that location, and run

q startUp.q

All required processes for the test will be auto-started and a process status table (called processStatus) will be available with PID and handle details in that master q process, for example:

name         port  handle PID   lastHeartBeatReceived
-------------------------------------------------------------
master       55555 0      15248 2019.06.25D10:36:09.641313000

alertMonitor 999   604    12776 2019.06.25D10:36:09.643313000

tp           5000  612    11828 2019.06.25D10:36:09.643313000

hdb          5001  624    13804 2019.06.25D10:36:09.643313000

rdb          5002  628    9552  2019.06.25D10:36:09.643313000

aeRT1        5003  632    14528 2019.06.25D10:36:09.643313000

aeRT2        5004  636    12280 2019.06.25D10:36:09.643313000
.
.
.

Data will start replaying in simulated real-time from the replay process and published to the ticker plant process to which all the alert engines are subscribed.  Any alerts that beat the example thresholds are sent to an alert table called dxATAlert in the alertMonitor process.  At any point, to shut down, run 

\l shutDown.q

Each alert engine logs run times in process log files named accordingly kept on C://OnDiskDB.  The repository includes the script readInProcLogs.q to read from these logs and store in a table for aggregation.  This framework can be used to test and compare your own approaches.
