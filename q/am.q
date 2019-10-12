/q am.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

logfile:hopen hsym`$raze[system["echo $HOME/kdbAlertTP/processLogs/amProcLog"]];
.log.out:{x y,"\n"}[logfile;];
.log.out["log started at ",string[.z.P]];
system"c 25 300";
system"l sym.q";

if[not "w"=first string .z.o;system "sleep 1"];

.am.onDiskTablePath:hsym`$raze[system["echo $HOME/kdbAlertTP/tableImages/"]],"dxAlert_",ssr[;":";""]string[.z.P];

upd:{[t;x]
    /.debug.upd:(`t`x)!(t;x);
    /`updStats upsert ([]time:enlist[.z.p];cnt:count[x];mnt:min[x`transactTime]);
    t upsert x;
    .log.out["Alerts received from engine ",string exec first alertEngine from x];
    .log.out[raze -3!select count i,max orderCount,max totalOrderQty,max totalOrderValue from dxAlert];
    .am.onDiskTablePath set dxAlert;
 };