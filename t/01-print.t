use v6;
use Pretty::Printer;
use Test;

plan 7;

my $p = Pretty::Printer.new;

subtest sub {
  is $p.pp(Any),
     q<Any>,
     q<Any>;
  is $p.pp(Nil),
     q<Nil>,
     q<Nil>;
}, 'Types';

subtest sub {
  is $p.pp(''),
     q<"">,
     q<''>;
  is $p.pp(1),
     q<1>,
     q<1>;
  is $p.pp(1.2),
     q<1.2>,
     q<1.2>;
  is $p.pp('a'),
     q<"a">,
     q<'a'>;
  is $p.pp('$a'),
     q<"\$a">,
     q<'$a'>;
  is $p.pp('{}'),
     q<"\{}">,
     q<'{}'>;
  is $p.pp('{$a}'),
     q<"\{\$a}">,
     q<'{$a}'>;
}, 'scalars';

subtest sub {
  my $aref = [ ];
  is $p.pp($aref),
     q<$[]>,
     q<$[]>;
  $aref = [ 1, 2, 3 ];
  is $p.pp($aref),
     q<$[1, 2, 3]>,
     q<$[1, 2, 3]>;
  $aref = [ 'foo', 'bar', 'qux' ];
  is $p.pp($aref),
     q<$["foo", "bar", "qux"]>,
     q<$["foo", "bar", "qux"]>;
}, 'Array references';

subtest sub {
  my $href = {
    foo => 2,
    2 => 'foo',
    3 => [ ],
    4 => Nil
  };
  is $p.pp($href),
     q<${:2("foo"), :3($[]), :4(Any), :foo(2)}>,
     q<${:2("foo"), :3($[]), :4(Any), :foo(2)} - Why 'Any' here?..>;
}, 'Hash references';

#
# XXX Big ol' *GAPING* hole - How to notate lists.
# XXX For the moment, focus on single scalars and references.
#

subtest sub {
  my $ds = 
    { content => [{ }] },
  is $p.pp($ds), q<${:content($[])}>;
  $ds = 
    { content => [{ }, { }] },
  is $p.pp($ds), q<${:content($[${}, ${}])}>;
  $ds = 
    { content => [{ a => [ ] }] },
  is $p.pp($ds), q<${:content($[:a($[])])}>, 'Flattening removes a layer';
  $ds = 
    { type    => 'alternation',
      label   => Nil,
      options => [ ],
      command => [ ],
      content =>
        [{ }] },
  is $p.pp($ds), q<${:command($[]), :content($[]), :label(Any), :options($[]), :type("alternation")}>;
#say $ds.perl;
  $ds = 
    { type    => 'alternation',
      label   => Nil,
      options => [ ],
      command => [ ],
      content =>
        [{ type    => 'concatenation',
           label   => Nil,
           options => [ ],
           command => [ ],
           content =>
             [{ type         => 'nonterminal',
                content      => 'non_digits',
                alias        => Nil,
                modifier     => '+',
                greedy       => True,
                complemented => True }] },
         { type    => 'concatenation',
           label   => 'One',
           options => [ ],
           command => [ ],
           content =>
             [{ type         => 'character class',
                content      => [ '-', '0-9', '\\f', '\\u000d' ],
                alias        => Nil,
                modifier     => '+',
                greedy       => True,
                complemented => True }] }] };
  is $p.pp($ds), q<${:command($[]), :content($[${:command($[]), :content($[:complemented, :modifier("+"), :content("non_digits"), :type("nonterminal"), :greedy, :alias(Any)]), :label(Any), :options($[]), :type("concatenation")}, ${:command($[]), :content($[:complemented, :modifier("+"), :content($["-", "0-9", "\\\f", "\\\\u000d"]), :type("character class"), :greedy, :alias(Any)]), :label("One"), :options($[]), :type("concatenation")}]), :label(Any), :options($[]), :type("alternation")}>;
}, 'complex data structures';

# vim: ft=perl6
