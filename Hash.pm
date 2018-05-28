#!/usr/bin/env perl
use 5.018;
use strict;
use warnings;

package Hash;


sub new {
    my $self = shift;
    $self = {
        buckets => [ [], [], [], [], [], [], [] ],
    };
    bless  $self;
    return $self;
}


sub store {
    my ($self, $key, $value) = @_;
    my $buckets = $self->{buckets};
    my ($bucket, $entry) = (0, 0);
    push @{ $buckets->[$bucket] }, [ $key, $value ];
    return $self;
}


sub fetch {
    my ($self, $key) = @_;
    my $buckets = $self->{buckets};
    my ($bucket, $entry) = (0, 0);
    my $entries = @{ $buckets->[$bucket] }; # number of entries within the bucket: 0, 1, 2, …
    
    while ( $buckets->[$bucket][$entry][0] ne $key ) {
        if (++$entry ==$entries) {
            $bucket = $entry = undef;
            last
        }
    }

    return $buckets->[$bucket][$entry][1] if defined $bucket;
    return undef;
}


1;
