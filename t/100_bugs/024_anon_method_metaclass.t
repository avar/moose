use strict;
use warnings;
use Test::More tests => 8;

{
    package Ball;
    use Moose;
}

{
    package Arbitrary::Roll;
    use Moose::Role;
}

my $method_meta = Moose::Meta::Class->create_anon_class(
    superclasses => ['Moose::Meta::Method'],
    roles        => ['Arbitrary::Roll'],
);

# For comparing identity without actually keeping $original_meta around
my $original_meta = "$method_meta";

my $method_class  = $method_meta->name;

my $method_object = $method_class->wrap(
    sub { 'ok' },
    associated_metaclass => Ball->meta,
    package_name         => 'Ball',
    name                 => 'bounce',
);

Ball->meta->add_method(bounce => $method_object);

for (1, 2) {
    is(Ball->bounce, 'ok', "method still exists on Ball");
    is(Ball->meta->get_method('bounce')->meta->name, $method_class, "method's package still exists");

    local $TODO = "method seems to be reinitialized" if !$method_meta;

    is(Ball->meta->get_method('bounce')->meta . '', $original_meta, "method's metaclass still exists");
    ok(Ball->meta->get_method('bounce')->meta->does_role('Arbitrary::Roll'), "method still does Arbitrary::Roll");

    undef $method_meta;
};


