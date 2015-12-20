use v6;
use Pretty::Printer;
use Test;

plan 0;

my $p = Pretty::Printer.new;

is $p.pp(Nil), q<Nil>, q<Empty call works.>;
is $p.pp(Any), q<Any>, q<You can call it with (Any)thing.>;

subtest sub {
  is $p.pp(False),    q<False>,    q<False works.>;
  is $p.pp(True),     q<True>,     q<True works.>;
  is $p.pp(0),        q<0>,        q<0 works.>;
  is $p.pp(1),        q<1>,        q<1 works.>;
  is $p.pp(1.234),    q<1.234>,    q<1.234 works.>;
  is $p.pp(1.234-2i), q<1.234-2i>, q<1.234-2i works.>;
  is $p.pp(''),       q<"">,       q<Empty strings quotify.>;
  is $p.pp(""),       q<"">,       q<Even interpolated strings.>;
}, 'scalar';

subtest sub {
  is $p.pp( [] ),    q<$[]>,    q<Empty arrayref works>;
  is $p.pp( [Any] ), q<$[Any]>, q<As does an arrayref with an empty element>;
  is $p.pp( [1] ),   q<$[1]>,   q<Or even one with a single scalar.>;
  is $p.pp( [[]] ),  q<$[]>,    q<Empty arrayrefs flatten>;
  is $p.pp( [{}] ),  q<$[]>,    q<As do empty blocks.>;
}, 'arrayref';

subtest sub {
  is $p.pp( {} ), q<${}>, q<Empty hashref works>;
  is $p.pp( {a=>Any} ), q<${:a(Any)}>, q<As does a hashref with a single item>;
  is $p.pp( {a=>[]} ), q<${:a($[])}>, q<And a hashref with an embedded reference.>;
}, 'hashref';

# vim: ft=perl6
