use v6;
use Pretty::Printer;
use Test;

plan 6;

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
  is $p.pp( {} ),       q<${}>, q<Empty hashref works>;
  is $p.pp( {a=>Any} ), q<${:a(Any)}>, q<As does a hashref with a single item>;
  is $p.pp( {a=>[]} ),  q<${:a($[])}>, q<And a hashref with an embedded reference.>;
}, 'hashref';

subtest sub {

  subtest sub {
    my $q = Pretty::Printer.new(
      intra-group-spacing => "\n",
      pre-item-spacing => "\n",
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
      intra-group-spacing => "\n",
      post-item-spacing => "\n",
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
      intra-group-spacing => "\n",
      pre-item-spacing => "\n",
      post-separator-spacing => "\n",
      post-item-spacing => "\n",
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
    is $q.pp( {1=>2,3=>4} ), q:to/EOF/.chomp, q<And multiple items.>;
${
:1(2),
:3(4)
}
EOF
  }, 'Newlines galore';

  subtest sub {
    my $q = Pretty::Printer.new(
      intra-group-spacing => "\n",
      pre-item-spacing => ' ',
      post-separator-spacing => "\n   ",
      post-item-spacing => "\n ",
    );
    is $q.pp( {1=>2,3=>4} ), q:to/EOF/.chomp, q<And multiple items.>;
${ :1(2),
   :3(4)
 }
EOF
  }, 'Sample of better formatting';

  subtest sub {
    my $q = Pretty::Printer.new(
      intra-group-spacing => "\n",
      pre-item-spacing => ' ',
      post-separator-spacing => "\n   ",
      post-item-spacing => "\n "
    );
    is $q.pp( {1=>2,3=>{4=>5}} ), q:to/EOF/.chomp, q<And multiple items.>;
${ :1(2),
   :3(${ :4(5)
 })
 }
EOF
  }, 'Sample of better formatting';

}, 'Alternate formatting';

# vim: ft=perl6
