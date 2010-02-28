#!perl
use strict;
use warnings;

use Test::More;
use Test::Exception;
use Test::Moose;
{
    package MyClass;
    use Moose -strict;

    has foo => (
        is => 'rw',
    );

    has bar => (
        is => 'rw',
        init_arg => undef,
    );

    has baz => (
        is      => 'rw',
        default => 42,
    );

    package MySubClass;
    use Moose;
    extends qw(MyClass);
}

with_immutable {
    foreach my $class(qw(MyClass MySubClass)) {
        lives_and {
            my $o = $class->new(foo => 1);
            isa_ok($o, 'MyClass');
            is $o->baz, 42;
        } 'correc use of the constructor';

        lives_and {
            my $o = $class->new(foo => 1, baz => 10);
            isa_ok($o, 'MyClass');
            is $o->baz, 10;
        } 'correc use of the constructor';


        throws_ok {
            $class->new(foo => 1, hoge => 42);
        } qr/\b hoge \b/xms;

        throws_ok {
            $class->new(foo => 1, bar => 42);
        } qr/\b bar \b/xms, "init_arg => undef";


        throws_ok {
            $class->new(aaa => 1, bbb => 2, ccc => 3);
        } qr/\b aaa \b/xms, $@;

        throws_ok {
            $class->new(aaa => 1, bbb => 2, ccc => 3);
        } qr/\b bbb \b/xms, $@;

        throws_ok {
            $class->new(aaa => 1, bbb => 2, ccc => 3);
        } qr/\b ccc \b/xms, $@;
    }
} qw(MyClass MySubClass);

done_testing;
