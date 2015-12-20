use v6;
use Pretty::Printer;
use Test;

plan 0;

my $p = Pretty::Printer.new(
  newline-after-array-start => False,
  newline-between-array-items => False,
  newline-before-array-end => False,
  
  newline-after-hash-start => False,
  newline-between-hash-pairs => False,
  newline-before-hash-end => False,
  
  whitespace-after-pair-value-start => False,
  whitespace-before-pair-value-end => False,
);

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

subtest sub {

  subtest sub {
    my $q = Pretty::Printer.new(
      newline-after-array-start => True,
      newline-after-hash-start  => True,
    );
    is $q.pp( [] ),          qq<\$[\n]>,
                             q<Newline after open-bracket>;
    is $q.pp( [1] ),         qq<\$[\n1]>,
                             q<And only between open-bracket and first item>;
    is $q.pp( [1,2] ),       qq<\$[\n1, 2]>,
                             q<Even in the presence of multiple items.>;
    is $q.pp( {} ),          qq<\$\{\n}>,
                             q<Newline after open-brace>;
    is $q.pp( {1=>2 } ),     qq<\$\{\n:1(2)}>,
                             q<And only between open-brace and first item>;
    is $q.pp( {1=>2,3=>4} ), qq<\$\{\n:1(2), :3(4)}>,
                             q<Even in the presence of multiple items.>;
  }, 'beginning newline';
  
  subtest sub {
    my $q = Pretty::Printer.new(
      newline-before-array-end => True,
      newline-before-hash-end  => True,
    );
    is $q.pp( [] ),          qq<\$[\n]>,
                             q<Newline before close-bracket>;
    is $q.pp( [1] ),         qq<\$[1\n]>,
                             q<And only between close-bracket and first item>;
    is $q.pp( [1,2] ),       qq<\$[1, 2\n]>,
                             q<Even in the presence of multiple items.>;
    is $q.pp( {} ),          qq<\$\{\n}>,
                             q<Newline before close-brace>;
    is $q.pp( {1=>2} ),      qq<\$\{:1(2)\n}>,
                             q<And only between close-brace and first item>;
    is $q.pp( {1=>2,3=>4} ), qq<\$\{:1(2), :3(4)\n}>,
                             q<Even in the presence of multiple items.>;
  }, 'ending newline';

  subtest sub {
    my $q = Pretty::Printer.new(
      newline-after-array-start   => True,
      newline-between-array-items => True,
      newline-before-array-end    => True,

      newline-after-hash-start   => True,
      newline-between-hash-pairs => True,
      newline-before-hash-end    => True,
    );
    is $q.pp( [] ),          qq<\$[\n]>,
                             q<Newline before close-bracket>;
    is $q.pp( [1] ),         qq<\$[\n1\n]>,
                             q<And only between close-bracket and first item>;
    is $q.pp( [1,2] ),       qq<\$[\n1,\n2\n]>,
                             q<Even in the presence of multiple items.>;
    is $q.pp( {} ),          qq<\$\{\n}>,
                             q<Newline before close-brace>;
    is $q.pp( {1=>2} ),      qq<\$\{\n:1(2)\n}>,
                             q<And only between close-brace and first item>;
    is $q.pp( {1=>2,3=>4} ), qq<\$\{\n:1(2),\n:3(4)\n}>,
                             q<Even in the presence of multiple items.>;
  }, 'Newlines galore';

}, 'Alternate formatting';

# vim: ft=perl6
