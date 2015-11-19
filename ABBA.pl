#!usr/bin/perl
use strict;

die "USAGE: perl $0 filein [bin:default 5000] > fileout" if @ARGV < 1;
my $filein=shift;
my $bin=shift;

open (IN, "gzip -dc $filein|") or die $!;
$bin||=5000;

my %indi; 
$indi{'0'}="east"; $indi{'1'}="south";$indi{'2'}="south";$indi{'3'}="india";$indi{'4'}="india";$indi{'5'}="east";$indi{'6'}="ref";

my %data;
my $n=1;
my @head;
my $chr_tmp="ChrNew1";
while (<IN>){
        my ($id,$tmp) = (split /\t/, )[0, -3];
        my @a=split /\s+/,$tmp;
        my ($chr,$pos)=($1,$2) if($id=~/(\S+)_(\d+)/);
        if($pos>=$n*$bin or $chr ne $chr_tmp){
                print_data();
                #                print join("\t",@head)."\n" if($n==1);
                %data=();
                $n++;
        }
        @{$data{$pos}}=@a;
        $chr_tmp=$chr;        
}
close IN;

#used for south-south-east-india and so on
sub print_data{
        my %tmp;
        my $india="india";
        for(my $H1=0;$H1<=5;$H1++){
                next if($indi{$H1}eq$india);
                for(my $H2=0;$H2<=5;$H2++){
                        next if($H2 == $H1 or $indi{$H1}ne$indi{$H2});
                        for(my $H3=0;$H3<=5;$H3++){
                                next if($H3==$H1 or $H3==$H2 or ($indi{$H3}eq$indi{$H1}) or ($indi{$H3}eq$india));
                                for(my $ref=3;$ref<=4;$ref++){
                                my $flag=join("_",$H1,$H2,$H3,$ref);
                                my ($ABBA,$BABA)=count($H1,$H2,$H3,$ref);
                                $tmp{$flag}{'ABBA'}=$ABBA;
                                $tmp{$flag}{'BABA'}=$BABA;
                                $tmp{$flag}{'D'}= 0;
                                $tmp{$flag}{'D'}=($ABBA-$BABA)/($ABBA+$BABA) if(($ABBA+$BABA)>0);
                            }
                        }
                }
        }
        my @out;
        @head=sort keys %tmp;
        for my $flag(sort keys %tmp){
                #push @out,($tmp{$flag}{'D'},$tmp{$flag}{'ABBA'},$tmp{$flag}{'BABA'});
                push @out,$tmp{$flag}{'D'};
        }
        #my $numof = @head; my $num2 = @out;print "number:$numof\t$num2\n";
        print join("\t",@head)."\n";
#        print join("\t",@out)."\n";
}
###used for south-east-india-ref
#sub print_data{
#        my %tmp;
#        for(my $H1=0;$H1<=5;$H1++){
#                for(my $H2=0;$H2<=5;$H2++){
#                        next if($H2 == $H1 or $indi{$H1}eq$indi{$H2});            
#                        for(my $H3=0;$H3<=5;$H3++){
#                                my $flag=join("_",$H1,$H2,$H3);
#                                next if($H3==$H1 or $H3==$H2 or ($indi{$H3}eq$indi{$H1}) or ($indi{$H3}eq$indi{$H2}));
# #print "$H1\t$H2\t$H3\t$indi{$H1}\t$indi{$H2}\t$indi{$H3}\n";
#                                my ($ABBA,$BABA)=count($H1,$H2,$H3,6);
#                                $tmp{$flag}{'ABBA'}=$ABBA;
#                                $tmp{$flag}{'BABA'}=$BABA;
#                                $tmp{$flag}{'D'}= 0;
#                                $tmp{$flag}{'D'}=($ABBA-$BABA)/($ABBA+$BABA) if(($ABBA+$BABA)>0);
#                        }
#                }
#        }
#        my @out;
#        @head=sort keys %tmp;
#        for my $flag(sort keys %tmp){
#                #push @out,($tmp{$flag}{'D'},$tmp{$flag}{'ABBA'},$tmp{$flag}{'BABA'});
#                push @out,$tmp{$flag}{'D'};
#        }
#        #my $numof = @head; my $num2 = @out;print "number:$numof\t$num2\n";
#        print join("\t",@head)."\n";
##        print join("\t",@out)."\n";
#}
sub count{
        my ($H1,$H2,$H3,$Ref)=@_;
        my ($ABBA,$BABA)=(0,0);
        for my $pos(sort {$a<=>$b} keys %data){
                my @a=@{$data{$pos}};
                my ($h1g,$h2g,$h3g,$ref)=($a[$H1],$a[$H2],$a[$H3],$a[$Ref]);
                next if($h1g eq $ref && $h2g eq $ref);
                $ABBA++ if($h1g eq $ref && $h2g eq $h3g);
                $BABA++ if($h1g eq $h3g && $h2g eq $ref);
        }
        return ($ABBA,$BABA);
}


