#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;
use Test::Exception;

{
    package Foo;
    use Moose;

    has 'bar' => ( is => 'rw' );

    package Stuffed::Role;
    use Moose::Role;
    use Moose::AttributeHelpers;

    has 'options' => (
        traits => ['Collection::Array'],
        is     => 'ro',
        isa    => 'ArrayRef[Foo]',
    );

    package Bulkie::Role;
    use Moose::Role;
    use Moose::AttributeHelpers;

    has 'stuff' => (
        traits  => ['Collection::Array'],
        is      => 'ro',
        isa     => 'ArrayRef',
        handles => {
            get_stuff => 'get',
        }
    );

    package Stuff;
    use Moose;

    ::lives_ok{ with 'Stuffed::Role';
        } '... this should work correctly';

    ::lives_ok{ with 'Bulkie::Role';
        } '... this should work correctly';
}