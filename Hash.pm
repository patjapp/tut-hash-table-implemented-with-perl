#!/usr/bin/env perl
use 5.018;
use strict;
use warnings;

package Hash;


sub new {
    return bless {}, shift;
}


sub store {
    my ($self, $key, $value) = @_;
    return $self;
}


1;
