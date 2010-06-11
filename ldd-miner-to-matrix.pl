#!/usr/bin/perl
# extract features
# produce a simple CSV of path, dynamic, static, libs
use Text::CSV;
use LddMiner;
use strict;
my $csv_opt = { eol => $/ };

my $csv = Text::CSV->new( $csv_opt );
my $file = $ARGV[0];
open my $fh, "<:encoding(utf8)", $file or die "$file: $!";
my @cols = qw(path static dynamic);
my %h = ();
while ( my $row = $csv->getline( $fh ) ) {
    my @row = @$row;
    my @elms = @row[scalar(@cols)..$#row];
    map { $h{$_}++ } @elms;
}
close($fh);
my @ordered = keys %h;
@ordered = sort { $h{$b} <=> $h{$a} } @ordered;


open my $fh, "<:encoding(utf8)", $file or die "$file: $!";
my $fho = *STDOUT;
my @cols = qw(path static dynamic);
my %h = ();
my $csvo = Text::CSV->new( $csv_opt );
my @cc = @cols;
# comment first line
$csvo->print($fho, [@cc, @ordered]);
while ( my $row = $csv->getline( $fh ) ) {
    my @row = @$row;
    my @colv = @row[0..$#cols];
    my @elms = @row[scalar(@cols)..$#row];
    my %e = ();
    map { $e{$_}++; } @elms;
    my @o = map { defined($e{$_})?1:0 } @ordered;
    $csvo->print( $fho, [@colv, @o ] );
}
close($fh);
close($fho);
