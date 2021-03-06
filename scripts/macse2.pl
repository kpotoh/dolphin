#!/usr/bin/perl -w

%seqs=();
@seqs=();
open (I, "$ARGV[0]");
while (<I>)
{
chomp;
#fasta header
if ($_=~/^>(.*?)$/)
    {
    $name=$1;
    push @seqs, $name;
    }
#fasta sequence
else
    {
    @I=split(//, $_);
    $codonPos=0;
    $codon="";
    @codons=();
    for ($j=0;$j<$#I+1;$j++)
	{
	$codonPos++;
	$codon.=$I[$j];
	if ($codonPos==3)
	    {
	    push @codons, $codon;
	    $codonPos=0;
	    $codon="";
	    }
	}
    @{$seqs{$name}}=@codons;
    $max=$#codons+1;
    }
}
close I;

%nonnuccodons=();
for ($i=0;$i<$max;$i++)
{
foreach $nm (keys %seqs)
    {
    if ($seqs{$nm}[$i]!~/[A-Za-z]/ or $seqs{$nm}[$i]=~/[!\?\.,]/)
	{
	if ($nm=~/OUTGRP/){$seqs{$nm}[$i]="NNN"}
	else {$nonnuccodons{$i}=1}
	}
    }
}

open (O, ">$ARGV[1]");
foreach $seq (@seqs)
{
print O ">$seq\n";
for ($i=0;$i<$max;$i++)
    {
    unless (exists $nonnuccodons{$i}) {print O "$seqs{$seq}[$i]"}
    }
print O "\n";
}
close O;
