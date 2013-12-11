#!/usr/bin/env perl
# Este programa ejecuta algo que devuelva un numero y lo grafica en la consola
# Ejemplo para probar: consoleg.pl 'sleep 1; echo $(( $RANDOM % 100 ))' 100
# Con un pipe: graficar la cantidad de memoria libre:
#  vmstat -n 1 | awk '{print $4; fflush()}' | consoleg.pl - 1000000

use POSIX qw(strftime);
use strict; use warnings;
my $debug = 0;
my $cmd = shift @ARGV || die "Usage: $0 command"; # Comando a ejecutar
my $max = shift @ARGV || 500;                     # Maximo valor posible

# This is a hack to enable reading from stdin, if cmd is a dash. 
# head -1 will read one line from stdin each time its executed.
$cmd = "head -1" if $cmd eq "-";

# Console width and height
my ($row,$col) = split(" ",  qx"stty size</dev/tty 2>/dev/null"); 

print "Rows: $row; Cols: $col\n" if $debug;
$col = $col - 22 - length($max);
my $values_per_hash = $max / $col;  # How many values needed to print one hash

while ($_ = qx/$cmd/) {                    # (which gives one number as output)
    my $numhashes = $_ / $values_per_hash; # num of hashes to print
    $numhashes = $col if $numhashes > $col;# cant print more than $col hashes
    #$numhashes = $numhashes - 22 - length($max);
    print "col: $col, numhashes: $numhashes, " .
          "values_per_hash: $values_per_hash\n" if $debug;
    print strftime("[%y/%m/%d %H:%M:%S] ", localtime(time)); # print date
    print "#" x $numhashes;                # print hashes
    print " $_";                           # print the value
}

