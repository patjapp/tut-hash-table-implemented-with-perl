#!/usr/bin/env perl
use 5.018;
use strict;
use warnings;

package Hash;


sub new {
    my $self          = shift;
	my $no_of_buckets = 7;
    $self = {
        no_of_buckets => $no_of_buckets,
		no_of_keys    => 0,
    	buckets       => [ map {[]} 1..$no_of_buckets ],
    };
    bless  $self;
    return $self;
}


sub store {
    my ($self, $key, $value) = @_;
    my $buckets              = $self->{buckets};
    my ($bucket, $entry)     = lookup($self, $key);
    
    if (defined $bucket) {
        # $key already exists---update value
        $buckets->[$bucket][$entry][1] = $value;
    }
    else {
        # new $key---push into a bucket
        $bucket = hash($self, $key) % @$buckets;
        push @{ $buckets->[$bucket] }, [ $key, $value ];
		$self->{no_of_keys}++;
    }

    return $self;
}


sub fetch {
    my ($self, $key)     = @_;
    my $buckets          = $self->{buckets};
    my ($bucket, $entry) = lookup($self, $key);
    
    return $buckets->[$bucket][$entry][1] if defined $bucket;
    return undef;
}


sub hash {
    my ($self, $key) = @_;
    my $hash = 0;
    foreach (split //, $key) {
        $hash += ord($_);
    }
    return $hash;
}


sub lookup {
    my ($self, $key)  = @_;
    my $buckets       = $self->{buckets};                   # reference to the bucket container
    my $bucket        = hash($self, $key) % @$buckets;      # bucket index: [0, @$buckets)
    my $no_of_entries = @{ $buckets->[$bucket] };           # number of entries within the bucket: 0, 1, 2, …
    my $entry         = 0;                                  # start value

    if ($no_of_entries >0) {
        # look for the correct entry inside the bucket
        while ( $buckets->[$bucket][$entry][0] ne $key ) {
            if (++$entry ==$no_of_entries) {
                $bucket = $entry = undef;
                last;
            }
        }
    }
    else {
        # the relevant bucket was empty, so the key doesn't exist
        $bucket = $entry = undef;
    }

    return ($bucket, $entry);
}


sub getNoOfBuckets {
	shift->{no_of_buckets}
}


sub getNoOfKeys {
	shift->{no_of_keys}
}


sub exists {
	my ($self, $key) = @_;
	my ($bucket, $entry) = lookup($self, $key);
	return defined $bucket;
}


1;
