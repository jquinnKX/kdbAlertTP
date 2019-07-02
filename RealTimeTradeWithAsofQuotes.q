/The purpose of this script is as follows:1.Demonstrate how custom real-time subscribers can be created in q2.In this example, create an efficient engine for calculating theprevalent quotes as of trades in real-time.This removes the need for ad-hoc invocations of the aj function.3.In this example, this subscriber also maintains its own binary log filefor replay purposes.This replaces the standard tickerplant log file replay functionality.\

show "RealTimeTradeWithAsofQuotes.q";

/sample usage
/q tick/RealTimeTradeWithAsofQuotes.q -tp localhost:5000 -syms MSFT.O IBM.N GS.N

default:`tp`syms!("::5000";"");
\default command line arguments -tp is location of tickerplant. syms are the symbols we wish to subscribe to

args:.Q.opt .z.x /transform incoming cmd line arguments into a dictionary

args:`$default,args /upsert args into default
args[`tp] : hsym first args[`tp]

\e 1 /drop into debug mode if running in foreground AND errors occur (for debugging purposes)

if[not "w"=first string .z.o;system "sleep 1"];

/initialize schemas for custom real-time subscriber

InitializeSchemas:`trade`quote!({[x]`TradeWithQuote insert update bid:0n,bsize:0N,ask:0n,asize:0N from x};{[x]`LatestQuote upsert select by sym from x});

/intra-day update functions
/Trade Update
/1. Update incoming data with latest quotes
/2. Insert updated data to TradeWithQuote table
/3. Append message to custom logfile

updTrade:{[d]d:d lj LatestQuote;`TradeWithQuote insert d;LogfileHandle enlist (`replay;`TradeWithQuote;d);};

/Quote Update 
/1. Calculate latest quote per sym for incoming data
/2. Update LatestQuote table

updQuote:{[d] `LatestQuote upsert select by sym from d; };

/upd dictionary will be triggered upon incoming update from tickerplant
upd:`trade`quote!(updTrade;updQuote);

/end of day function -triggered by tickerplant at EOD
.u.end:{
/close the connection to the old log file
hclose LogfileHandle;
/create the new logfile
logfile::hsym `$"RealTimeTradeWithAsofQuotes_",string .z.D;
/Initialise the new log file
.[logfile;();:;()];
LogfileHandle::hopen logfile;
{delete from x}each tables `. /clear out tables
};

aj