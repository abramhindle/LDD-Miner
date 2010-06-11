package LddMiner;
use strict;
our $LDD = "/usr/bin/ldd";
sub extract_executable {
    my ($path) = @_;
    my $command = "$LDD \"$path\"";
    my $output = `$command`;
    my $static = ($output =~ /not a dynamic executable/);
    my @libs = ();
    if (!$static) {
        @libs = map {
            lib_of(trim($_));
        } (split( /[\r\n]/ , $output));
    }
    return { 
        path => $path,
        static => $static,
        dynamic => !$static,
        libs    => \@libs,
    };
}
sub lib_of {
    my ($lib,$path_lib) = split(/=>/, $_[0]);
    # remove stuff in
    # "/lib/ld-linux.so.2 (0xb77bf000)"
    my ($lib) = split(/\s+/,$lib);
    return trim($lib);
}
sub trim {
    my ($a) = @_;
    $a =~ s/^\s*//;
    $a =~ s/\s*$//;
    return $a;
}

__DATA__
/usr/bin/aclocal-1.9:
        not a dynamic executable
/usr/bin/aconnect:
        linux-gate.so.1 =>  (0xb787a000)
        libasound.so.2 => /usr/lib/libasound.so.2 (0xb77b0000)
        libm.so.6 => /lib/tls/i686/cmov/libm.so.6 (0xb7763000)
        libdl.so.2 => /lib/tls/i686/cmov/libdl.so.2 (0xb775e000)
        libpthread.so.0 => /lib/tls/i686/cmov/libpthread.so.0 (0xb7745000)
        libc.so.6 => /lib/tls/i686/cmov/libc.so.6 (0xb75e2000)
        librt.so.1 => /lib/tls/i686/cmov/librt.so.1 (0xb75d9000)
        /lib/ld-linux.so.2 (0xb787b000)
