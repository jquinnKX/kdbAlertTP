/q alertMonitor.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

logfile:hopen hsym`$"C:\\OnDiskDB\\amProcLog";
.log.out:{x y,"\n"}[logfile;];
.log.out["log started at ",string[.z.p]];
system"c 25 300";
system"l sym.q";

if[not "w"=first string .z.o;system "sleep 1"];

.am.onDiskTablePath:hsym`$"C:\\OnDiskDB\\dxATAlert_",ssr[;":";""]string[.z.P];

upd:{[t;x]
    /.debug.upd:(`t`x)!(t;x);
    /`updStats upsert ([]time:enlist[.z.p];cnt:count[x];mnt:min[x`transactTime]);
    t upsert x;
    .log.out["Alerts received from engine ",string exec first alertEngine from x];
    .log.out[raze -3!select count i,max orderCount,max totalOrderQty,max totalOrderValue from dxATAlert];
    .am.onDiskTablePath set dxATAlert;
 };

/update cumNumAls:reverse sums reverse numals from select numals:count i by floor[orderCount%1000],floor[totalOrderQty%1000],floor[totalOrderValue%1000] from dxATAlert

/ get the ticker plant and history ports, defaults are 5000,5001
/.u.x:.z.x,(count .z.x)_(":5000";":5001");

/ end of day: save, clear, hdb reload
/.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
/.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
/.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

