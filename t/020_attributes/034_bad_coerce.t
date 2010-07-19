use strict;
use warnings;

use Test::More;
BEGIN {
    eval "use Test::Output;";
    plan skip_all => "Test::Output is required for this test" if $@;
}

{
    package Foo;

    use Moose;

    ::stderr_like{ has foo => (
            is     => 'ro',
            isa    => 'Str',
            coerce => 1,
        );
        __PACKAGE__->new( foo => "hlagh" );
        }
        qr/\QYou cannot coerce an attribute (foo) unless its type (Str) has a coercion/,
        'Cannot coerce unless the type has a coercion';

    ::stderr_like{ has bar => (
            is     => 'ro',
            isa    => 'Str',
            coerce => 1,
        );
        __PACKAGE__->new( bar => "hlagh" );
        }
        qr/\QYou cannot coerce an attribute (bar) unless its type (Str) has a coercion/,
        'Cannot coerce unless the type has a coercion - different attribute';

    ::stderr_like{ has hlagh => (
            is     => 'ro',
            isa    => 'HashRef',
            coerce => 1,
        );
        __PACKAGE__->new( hlagh => {} );
        }
        qr/\QYou cannot coerce an attribute (hlagh) unless its type (HashRef) has a coercion/,
        'Cannot coerce unless the type has a coercion - different attribute';
}

done_testing;
