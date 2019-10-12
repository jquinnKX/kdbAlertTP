/q childTick.q SRC [DST] [-p 4444/6666] [-o h]
system"l ",(src:first .z.x,enlist"sym"),".q"

/parent keeps log
/logfile:hopen hsym`$raze[system["echo $HOME/kdbAlertTP/processLogs/tickProcLog"]];
/.log.out:{x y,"\n"}[logfile;];
/.log.out["log started at ",string[.z.P]];

\l u.q
\d .u
ld:{if[not type key L::`$(-10_string L),string x;.[L;();:;()]];i::j::-11!(-2;L);if[0<=type i;-2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";exit 1];hopen L};
tick:{init[];if[not min(`transactTime`sym~2#key flip value@)each t;'`timesym];@[;`sym;`g#]each t;d::.z.D;if[l::count y;L::`$":",y,"/",x,10#".";l::ld d]};

endofday:{end d;d+:1;if[l;hclose l;l::0(`.u.ld;d)]};
ts:{if[d<x;if[d<x-1;system"t 0";'"more than one day?"];endofday[]]};
\t 100
if[system"t";
    .z.ts:{pub'[t;value each t];@[`.;t;@[;`sym;`g#]0#];i::j;ts .z.D};
    upd:{[t;x]
        if[not -12=type first first x;if[d<"d"$a:.z.P;.z.ts[]];a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
        t insert x;
        if[l;
            l enlist (`upd;t;x);
            j+:1
        ];
    }
 ];

if[not system"t";
    system"t 1000";
    .z.ts:{ts .z.D};
    upd:{[t;x]
        ts"d"$a:.z.P;
        if[not -12=type first first x;a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
        f:key flip value t;
        pub[t;$[0>type first x;enlist f!x;flip f!x]];
        if[l;
            l enlist (`upd;t;x);
            i+:1
        ];
    }
 ];

\d .
upd:.u.upd;
.u.tick[src;.z.x 1];


/subscribe to parent
/ get the ticker plant and history ports, defaults are 5000,5001
/.u.x:.z.x,(count .z.x)_(":5000";":5001");

/ end of day: save, clear, hdb reload
/.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};
.u.end:{};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(hopen `$":","localhost:5000")"(.u.sub[`;`];`.u `i`L)";


\
 globals used
 .u.w - dictionary of tables->(handle;syms)
 .u.i - msg count in log file
 .u.j - total msg count (log file plus those held in buffer)
 .u.t - table names
 .u.L - tp log filename, e.g. `:./sym2008.09.11
 .u.l - handle to tp log file
 .u.d - date

/test
>q tick.q
>q tick/ssl.q

/run
>q tick.q sym  .  -p 5010	/tick
>q tick/r.q :5010 -p 5011	/rdb
>q sym            -p 5012	/hdb
>q tick/ssl.q sym :5010		/feed
