#!/usr/bin/perl
# extract features
# produce a simple CSV of path, dynamic, static, libs
use Text::CSV;
use LddMiner;
use strict;

my $csv = Text::CSV->new( { eol => $/ } );
my $fd = *STDOUT;
my @cols = qw(path static dynamic);
#$csv->column_names(  @cols  );

# expect executable ala find
while(my $executable = <STDIN>) {
    chomp($executable);
    my $exe = LddMiner::extract_executable($executable);

    $exe->{static} = ($exe->{static})?1:0;
    $exe->{dynamic} = ($exe->{dynamic})?1:0;

    my @row = map { $exe->{$_} } @cols;
    #warn @{$exe->{libs}};
    $csv->print( $fd, [@row, @{$exe->{libs}} ] );
}
