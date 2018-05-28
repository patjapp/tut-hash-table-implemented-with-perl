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
    $buckets->[$bucket][$entry][1] = $value;
    return $self;
}


sub fetch {
    my ($self, $key) = @_;
    my $buckets = $self->{buckets};
    my ($bucket, $entry) = (0, 0);
    return $buckets->[$bucket][$entry][1];
}


1;
