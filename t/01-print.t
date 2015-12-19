use v6;
use Pretty::Printer;
use Test;

plan 7;

my $p = Pretty::Printer.new;

#
# XXX Big ol' *GAPING* hole - How to notate lists.
# XXX For the moment, focus on single scalars and references.
#

is $p.pp(Nil), '(Nil)';
is $p.pp('a'), 'a';
is $p.pp('{}'), '{}';
is $p.pp('$a'), '$a';
is $p.pp('{$a++}'), '{$a++}';

subtest sub {
  my $aref = [ 1, 2, 3 ];
  is $p.pp($aref), '$[ 1, 2, 3 ]';
}

subtest sub {
  my $href = { a => 1, b => 2 };
  is $p.pp($href), '{ :a(1), :b(2) }';
}

# vim: ft=perl6
