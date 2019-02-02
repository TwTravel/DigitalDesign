li %0, $0
li %2, $10
or %4, %4, %4
li %3, $20
li %5, $1
sw %2, %0
label: or %4, %4, %4
li %2, $10
lw %0, %2
bz %3, label3
addi %0, %0, $1
sub %3, %3, %5
j label2
label3: sub %0, %0, %5
bnz %0, label2
li %3, $20 
label2: sw %2, %0
or %4, %4, %4
break
or %4, %4, %4
or %4, %4, %4
j label
