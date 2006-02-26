v 20050820 1
C 37900 66900 1 0 0 pic16F628-1.sym
{
T 38200 70000 5 8 1 1 0 0 1
refdes=U1
T 39200 70000 5 10 1 1 0 0 1
device=PIC16F628A
T 37900 66900 5 10 0 0 0 0 1
footprint=dip18
}
C 41000 71900 1 0 0 5V-plus-1.sym
T 38600 66600 9 10 1 0 0 0 1
X Axis Controller
N 41200 71900 41200 68400 4
N 41200 68400 40600 68400 4
C 37200 68100 1 0 0 gnd-1.sym
T 44600 60900 9 10 1 0 0 0 1
X Axis Module
C 36900 72500 1 270 0 resistor-1.sym
{
T 37200 72300 5 10 1 1 270 0 1
refdes=R1
T 36700 72300 5 10 1 1 270 0 1
value=4.7k
}
N 37000 71600 37000 69600 4
N 37000 69600 37900 69600 4
C 36800 72600 1 0 0 5V-plus-1.sym
N 37000 72600 37000 72500 4
C 44700 71000 1 0 0 4phase-stepper6-1.sym
{
T 44700 73400 5 10 1 1 0 0 1
refdes=U2
}
T 45600 73500 9 10 1 0 0 0 1
X Axis Motor
C 28200 60200 1 0 0 title-A2.sym
T 34000 70500 9 10 1 0 90 0 1
Sync bus connector
T 44600 61300 9 10 1 0 0 0 1
Reprap
C 32000 66900 1 0 0 4N29-1.sym
{
T 33800 68500 5 10 1 1 0 6 1
refdes=U3
}
C 31100 63200 1 0 0 4N29-1.sym
{
T 32900 64800 5 10 1 1 0 6 1
refdes=U4
}
C 31000 62500 1 0 0 gnd-1.sym
C 31900 65800 1 0 0 gnd-1.sym
N 32000 67200 32000 66100 4
N 31100 63500 31100 62800 4
C 31900 70000 1 270 0 resistor-1.sym
{
T 32200 69800 5 10 1 1 270 0 1
refdes=R2
T 31700 69700 5 10 1 1 270 0 1
value=1k
}
C 31000 66100 1 270 0 resistor-1.sym
{
T 31300 65900 5 10 1 1 270 0 1
refdes=R3
T 30800 65800 5 10 1 1 270 0 1
value=1k
}
N 31100 65200 31100 64400 4
N 32000 69100 32000 68100 4
C 30900 66100 1 0 0 5V-plus-1.sym
C 31800 70000 1 0 0 5V-plus-1.sym
N 37300 68400 37900 68400 4
N 40700 69600 40700 68700 4
N 40700 68700 40600 68700 4
N 40600 69000 40700 69000 4
N 40600 69300 40700 69300 4
C 40900 69200 1 0 0 gnd-1.sym
N 40600 69600 41000 69600 4
N 41000 69600 41000 69500 4
C 42900 70800 1 0 0 12V-plus-1.sym
C 36300 64600 1 0 0 12V-plus-1.sym
C 36000 64900 1 0 0 5V-plus-1.sym
N 36200 64600 36200 64900 4
C 35500 64300 1 0 0 gnd-1.sym
N 35900 64600 35600 64600 4
N 40600 67200 42000 67200 4
T 32400 66500 9 10 1 0 0 0 1
Minimum detector
T 31400 62800 9 10 1 0 0 0 1
Maximum detector
N 45300 71000 45300 70700 4
N 46500 70700 46500 71000 4
N 43100 70700 46500 70700 4
N 43100 70700 43100 70800 4
N 34100 68100 37900 68100 4
C 34000 66900 1 0 0 gnd-1.sym
N 34600 64400 33200 64400 4
C 33100 63200 1 0 0 gnd-1.sym
C 42300 65800 1 0 0 EMBEDDEDULN2803-1.sym
[
P 44300 69100 44000 69100 1 0 0
{
T 44100 69150 5 8 1 1 0 0 1
pinnumber=18
T 44100 69150 5 8 0 0 0 0 1
pinseq=18
T 43740 69100 9 8 1 1 0 0 1
pinlabel=1C
}
P 44300 68700 44000 68700 1 0 0
{
T 44100 68750 5 8 1 1 0 0 1
pinnumber=17
T 44100 68750 5 8 0 0 0 0 1
pinseq=17
T 43740 68700 9 8 1 1 0 0 1
pinlabel=2C
}
P 44300 68300 44000 68300 1 0 0
{
T 44100 68350 5 8 1 1 0 0 1
pinnumber=16
T 44100 68350 5 8 0 0 0 0 1
pinseq=16
T 43740 68300 9 8 1 1 0 0 1
pinlabel=3C
}
P 44300 67900 44000 67900 1 0 0
{
T 44100 67950 5 8 1 1 0 0 1
pinnumber=15
T 44100 67950 5 8 0 0 0 0 1
pinseq=15
T 43740 67900 9 8 1 1 0 0 1
pinlabel=4C
}
T 43850 69440 5 10 0 0 0 0 1
device=ULN2803
T 43850 69240 5 10 0 0 0 0 1
footprint=DIP18
T 42600 69540 9 10 1 0 0 0 1
ULN2803
P 42600 69100 42300 69100 1 0 1
{
T 42660 69100 9 8 1 1 0 0 1
pinlabel=1B
T 42450 69150 5 10 1 1 0 0 1
pinnumber=1
T 42450 69150 5 10 0 0 0 0 1
pinseq=1
}
P 42600 68700 42300 68700 1 0 1
{
T 42660 68700 9 8 1 1 0 0 1
pinlabel=2B
T 42400 68750 5 10 1 1 0 0 1
pinnumber=2
T 42400 68750 5 10 0 0 0 0 1
pinseq=2
}
P 42600 68300 42300 68300 1 0 1
{
T 42660 68300 9 8 1 1 0 0 1
pinlabel=3B
T 42400 68350 5 10 1 1 0 0 1
pinnumber=3
T 42400 68350 5 10 0 0 0 0 1
pinseq=3
}
P 42600 67900 42300 67900 1 0 1
{
T 42660 67900 9 8 1 1 0 0 1
pinlabel=4B
T 42400 67950 5 10 1 1 0 0 1
pinnumber=4
T 42400 67950 5 10 0 0 0 0 1
pinseq=4
}
P 42600 67500 42300 67500 1 0 1
{
T 42400 67550 5 10 1 1 0 0 1
pinnumber=5
T 42400 67550 5 10 0 0 0 0 1
pinseq=5
T 42660 67500 9 8 1 1 0 0 1
pinlabel=5B
}
P 42600 67100 42300 67100 1 0 1
{
T 42400 67150 5 10 1 1 0 0 1
pinnumber=6
T 42400 67150 5 10 0 0 0 0 1
pinseq=6
T 42660 67100 9 8 1 1 0 0 1
pinlabel=6B
}
P 42600 66700 42300 66700 1 0 1
{
T 42400 66750 5 10 1 1 0 0 1
pinnumber=7
T 42400 66750 5 10 0 0 0 0 1
pinseq=7
T 42660 66700 9 8 1 1 0 0 1
pinlabel=7B
}
P 42600 66300 42300 66300 1 0 1
{
T 42400 66350 5 10 1 1 0 0 1
pinnumber=8
T 42400 66350 5 10 0 0 0 0 1
pinseq=8
T 42660 66300 9 8 1 1 0 0 1
pinlabel=8B
}
P 44300 67500 44000 67500 1 0 0
{
T 44100 67550 5 8 1 1 0 0 1
pinnumber=14
T 44100 67550 5 8 0 0 0 0 1
pinseq=14
T 43740 67500 9 8 1 1 0 0 1
pinlabel=5C
}
P 44300 67100 44000 67100 1 0 0
{
T 44100 67150 5 8 1 1 0 0 1
pinnumber=13
T 44100 67150 5 8 0 0 0 0 1
pinseq=13
T 43740 67100 9 8 1 1 0 0 1
pinlabel=6C
}
P 44300 66700 44000 66700 1 0 0
{
T 44100 66750 5 8 1 1 0 0 1
pinnumber=12
T 44100 66750 5 8 0 0 0 0 1
pinseq=12
T 43740 66700 9 8 1 1 0 0 1
pinlabel=7C
}
P 44300 66300 44000 66300 1 0 0
{
T 44100 66350 5 8 1 1 0 0 1
pinnumber=11
T 44100 66350 5 8 0 0 0 0 1
pinseq=11
T 43730 66300 9 8 1 1 0 0 1
pinlabel=8C
}
B 42600 65800 1400 3600 3 0 0 0 -1 -1 0 -1 -1 -1 -1 -1
P 42600 65900 42300 65900 1 0 1
{
T 42400 65950 5 10 1 1 0 0 1
pinnumber=9
T 42400 65950 5 10 0 0 0 0 1
pinseq=9
T 42660 65900 9 8 1 1 0 0 1
pinlabel=E
}
P 44300 65900 44000 65900 1 0 0
{
T 44100 65950 5 8 1 1 0 0 1
pinnumber=10
T 44100 65950 5 8 0 0 0 0 1
pinseq=10
T 43590 65900 9 8 1 1 0 0 1
pinlabel=COM
}
]
{
T 44000 69600 5 10 1 1 0 6 1
refdes=U5
}
N 40600 68100 41400 68100 4
N 41400 68100 41400 69100 4
N 41400 69100 42300 69100 4
N 40600 67800 41600 67800 4
N 41600 67800 41600 68700 4
N 41600 68700 42300 68700 4
N 42000 67200 42000 67900 4
N 42000 67900 42300 67900 4
C 42200 65600 1 0 0 gnd-1.sym
N 44300 69100 45000 69100 4
N 45000 69100 45000 71000 4
N 44300 68700 46200 68700 4
N 46800 67900 46800 71000 4
N 46800 67900 44300 67900 4
C 46000 66100 1 180 0 EMBEDDEDzener-1.sym
[
L 45700 65700 45700 66100 3 0 0 0 -1 -1
L 45400 65900 45700 66100 3 0 0 0 -1 -1
L 45400 65900 45700 65700 3 0 0 0 -1 -1
T 45600 65500 5 10 0 0 180 0 1
device=ZENER_DIODE
L 45400 65700 45400 66100 3 0 0 0 -1 -1
P 45100 65900 45300 65900 1 0 0
{
T 45300 65850 5 8 0 1 180 0 1
pinnumber=2
T 45300 65850 5 8 0 0 180 0 1
pinseq=2
}
P 45800 65900 46000 65900 1 0 1
{
T 45900 65850 5 8 0 1 180 0 1
pinnumber=1
T 45900 65850 5 8 0 0 180 0 1
pinseq=1
}
L 45300 65900 45400 65900 3 0 0 0 -1 -1
L 45700 65900 45800 65900 3 0 0 0 -1 -1
L 45400 65700 45500 65700 3 0 0 0 -1 -1
L 45400 66100 45300 66100 3 0 0 0 -1 -1
]
{
T 45700 65600 5 10 1 1 180 0 1
refdes=Z1
T 45400 66200 5 10 1 1 0 0 1
value=15V
}
C 36100 72500 1 270 0 resistor-1.sym
{
T 36400 72300 5 10 1 1 270 0 1
refdes=R4
T 35900 72300 5 10 1 1 270 0 1
value=4.7k
}
N 36200 72600 36200 72500 4
C 36000 72600 1 0 0 5V-plus-1.sym
N 36200 69300 37900 69300 4
N 36200 69300 36200 71600 4
C 34200 70800 1 0 0 EMBEDDEDconnector2-1.sym
[
P 35600 71000 35900 71000 1 0 1
{
T 34550 70950 5 8 1 1 0 0 1
pinnumber=2
T 34550 70950 5 8 0 0 0 0 1
pinseq=2
}
P 35600 71300 35900 71300 1 0 1
{
T 34550 71250 5 8 1 1 0 0 1
pinnumber=1
T 34550 71250 5 8 0 0 0 0 1
pinseq=1
}
L 35600 71300 34700 71300 3 0 0 0 -1 -1
L 35600 71000 34700 71000 3 0 0 0 -1 -1
T 34400 71800 5 10 0 0 0 0 1
device=CONNECTOR_2
B 34200 70800 500 700 3 0 0 0 -1 -1 0 -1 -1 -1 -1 -1
T 34400 72000 5 10 0 0 0 0 1
pins=2
T 34400 72200 5 10 0 0 0 0 1
class=IO
]
{
T 34200 71600 5 10 1 1 0 0 1
refdes=CONN1
}
N 35900 71300 37000 71300 4
N 35900 71000 36200 71000 4
N 46000 65900 47300 65900 4
N 47300 65900 47300 66400 4
C 47100 66400 1 0 0 12V-plus-1.sym
N 44300 65900 45100 65900 4
C 35700 62900 1 270 0 EMBEDDEDconnector4-1.sym
[
P 36200 64300 36200 64600 1 0 1
{
T 36150 63150 5 8 1 1 90 2 1
pinnumber=3
T 36150 63150 5 8 0 0 90 2 1
pinseq=3
}
P 36500 64300 36500 64600 1 0 1
{
T 36450 63150 5 8 1 1 90 2 1
pinnumber=2
T 36450 63150 5 8 0 0 90 2 1
pinseq=2
}
P 35900 64300 35900 64600 1 0 1
{
T 35850 63150 5 8 1 1 90 2 1
pinnumber=4
T 35850 63150 5 8 0 0 90 2 1
pinseq=4
}
L 36500 64300 36500 63400 3 0 0 0 -1 -1
L 36200 64300 36200 63400 3 0 0 0 -1 -1
L 35900 64300 35900 63400 3 0 0 0 -1 -1
T 36600 64700 5 10 0 0 90 2 1
device=CONNECTOR_4
P 36800 64300 36800 64600 1 0 1
{
T 36750 63150 5 8 1 1 90 2 1
pinnumber=1
T 36750 63150 5 8 0 0 90 2 1
pinseq=1
}
L 36800 64300 36800 63400 3 0 0 0 -1 -1
B 35700 62900 1300 500 3 0 0 0 -1 -1 0 -1 -1 -1 -1 -1
T 36800 64700 5 10 0 0 90 2 1
class=IO
T 37000 64700 5 10 0 0 90 2 1
pins=4
]
{
T 37100 62900 5 10 1 1 90 2 1
refdes=CONN2
}
C 39100 62900 1 270 0 EMBEDDEDconnector4-1.sym
[
P 39600 64300 39600 64600 1 0 1
{
T 39550 63150 5 8 1 1 90 2 1
pinnumber=3
T 39550 63150 5 8 0 0 90 2 1
pinseq=3
}
P 39900 64300 39900 64600 1 0 1
{
T 39850 63150 5 8 1 1 90 2 1
pinnumber=2
T 39850 63150 5 8 0 0 90 2 1
pinseq=2
}
P 39300 64300 39300 64600 1 0 1
{
T 39250 63150 5 8 1 1 90 2 1
pinnumber=4
T 39250 63150 5 8 0 0 90 2 1
pinseq=4
}
L 39900 64300 39900 63400 3 0 0 0 -1 -1
L 39600 64300 39600 63400 3 0 0 0 -1 -1
L 39300 64300 39300 63400 3 0 0 0 -1 -1
T 40000 64700 5 10 0 0 90 2 1
device=CONNECTOR_4
P 40200 64300 40200 64600 1 0 1
{
T 40150 63150 5 8 1 1 90 2 1
pinnumber=1
T 40150 63150 5 8 0 0 90 2 1
pinseq=1
}
L 40200 64300 40200 63400 3 0 0 0 -1 -1
B 39100 62900 1300 500 3 0 0 0 -1 -1 0 -1 -1 -1 -1 -1
T 40200 64700 5 10 0 0 90 2 1
class=IO
T 40400 64700 5 10 0 0 90 2 1
pins=4
]
{
T 40500 62900 5 10 1 1 90 2 1
refdes=CONN3
}
C 39700 64600 1 0 0 12V-plus-1.sym
C 39400 64900 1 0 0 5V-plus-1.sym
N 39600 64600 39600 64900 4
C 38900 64300 1 0 0 gnd-1.sym
N 39300 64600 39000 64600 4
N 37900 67500 37400 67500 4
N 37900 67800 36800 67800 4
N 36800 67800 36800 64600 4
N 37400 67500 37400 65900 4
N 40200 65900 37400 65900 4
N 40200 64600 40200 65900 4
T 39200 62500 9 10 1 0 0 0 1
To Y Controller
T 35800 62500 9 10 1 0 0 0 1
To Comms module
N 40600 67500 41800 67500 4
N 41800 67500 41800 68300 4
N 41800 68300 42300 68300 4
N 42300 65900 42300 67500 4
N 46200 71000 46200 68700 4
N 44300 68300 45600 68300 4
N 45600 68300 45600 71000 4
C 44300 67400 1 0 0 nc-right-1.sym
C 44300 67000 1 0 0 nc-right-1.sym
C 44300 66600 1 0 0 nc-right-1.sym
C 44300 66200 1 0 0 nc-right-1.sym
N 37900 68700 34600 68700 4
C 34500 69700 1 270 0 resistor-1.sym
{
T 34800 69500 5 10 1 1 270 0 1
refdes=R5
T 34300 69500 5 10 1 1 270 0 1
value=10k
}
C 34400 69800 1 0 0 5V-plus-1.sym
N 34600 69800 34600 69700 4
N 34600 64400 34600 68800 4
