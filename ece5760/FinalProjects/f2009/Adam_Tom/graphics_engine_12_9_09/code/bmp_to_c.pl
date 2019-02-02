#!/usr/bin/perl

use File::Basename;

$bmpFile=$ARGV[0];
$arrayName=$ARGV[1];
$cFile=basename($bmpFile,".bmp").".c";

open(BMP_FILE,"<",$bmpFile) or die "Can't open file '$ARVG[1]'.";
binmode(BMP_FILE);
$numBytes=-s $bmpFile;

open(OUT,">",$cFile) or die "Can't open file 'ARGV[2]' for writing.";

print OUT "const alt_u8 $arrayName"."[$numBytes]={\n";

while(($n=read(BMP_FILE,$data,8))!=0)
{
    @bytes=split(//,$data);
    print OUT "    ";
    for($i=0;$i<$n;$i++)
    {
        print OUT sprintf("0x%02X",ord($bytes[$i]));
        print OUT ", " if $i<$n-1 || $numBytes>8;
    }
    print OUT "\n";
    $numBytes-=$n;
}

print OUT "};";
