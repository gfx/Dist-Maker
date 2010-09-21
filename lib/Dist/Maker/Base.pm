package Dist::Maker::Base;
# config + logger

use Mouse;
use Dist::Maker::Config;

has config => (
    is      => 'ro',
    isa     => 'Dist::Maker::Config',
    lazy    => 1,
    default => sub { Dist::Maker::Config->new() },
    handles => {
        config_data => 'data',
        verbose     => 'verbose',
        load_class  => 'load_class',
    },
);

# logger

sub log :method {
    my $self = shift;
    print STDOUT ">  ", @_ if $self->verbose >= 4;
    return;
}

sub note :method {
    my $self = shift;
    print STDOUT ">> ", @_ if $self->verbose >= 3;
    return;
}

sub warn :method {
    my $self = shift;
    print STDERR "!  ", @_ if $self->verbose >= 2;
    return;
}

sub diag :method {
    my $self = shift;
    print STDERR "!! ", @_ if $self->verbose >= 1;
    return;
}

no Mouse;
__PACKAGE__->meta->make_immutable();
