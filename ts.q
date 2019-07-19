a:1;
b:2;
.global.multiply:{x*y}
out:{[a;b]
\ts:20 .global.multiply[a;b]
}[a;b];
show out