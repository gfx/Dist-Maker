package Dist::Maker::Name;
use Mouse;
use Mouse::Util::TypeConstraints;

use overload
    '""'     => sub { $_[0]->name },
    fallback => 1;

coerce __PACKAGE__,
    from 'Str', via { __PACKAGE__->new($_) },
;

sub BUILDARGS {
    my $self = shift;
    my $args = (@_ == 1 && ref($_) ne 'HASH')
        ? { parts => [split /(?: :: | -)/xms, $_[0]] }
        : $self->BUILDARGS(@_);
    return $args;
}

has parts => (
    is         => 'ro',
    isa        => 'ArrayRef[Str]',
    required   => 1,
    auto_deref => 1,
);

has dist_name_separator => (
    is       => 'ro',
    isa      => 'Str',
    default  => '-',
);

has module_name_separator => (
    is       => 'ro',
    isa      => 'Str',
    default  => '::',
);

has path_separator => (
    is       => 'ro',
    isa      => 'Str',
    default  => '/',
);

# second-order attributes

has name => (
    is  => 'rw',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my($self) = @_;
        return $self->join( $self->dist_name_separator );
    },
);

has path => (
    is  => 'rw',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my($self) = @_;
        return $self->join( $self->path_separator );
    },
);

has module => (
    is  => 'rw',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my($self) = @_;
        return $self->join( $self->module_name_separator );
    },
);

sub join {
    my($self, $separator) = @_;
    return join($separator, $self->parts);
}

no Mouse::Util::TypeConstraints;
no Mouse;
__PACKAGE__->meta->make_immutable();
__END__

=head1 NAME

Dist::Maker::Name - Distribution/module name abstraction

=cut
