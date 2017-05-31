use v6;
use Test;

constant package-name = 'PrettyDump';
use-ok package-name or bail-out "{package-name} did not compile";
use ::(package-name);
my $class = ::(package-name);

subtest {
	can-ok $class, 'new' or bail-out "{package-name} cannot .new";
	can-ok $class, 'add-handler' or bail-out "{package-name} cannot .add-handler";
	can-ok $class, 'handles' or bail-out "{package-name} cannot .handles";
	can-ok $class, 'dump' or bail-out "{package-name} cannot .dump";
	}, "{package-name} setup";

class TinyClass {
	has $.foo;
	method can ( Str $method ) { False }
	}
my $tiny-class-str = 'TinyClass';
my $tiny-class = ::($tiny-class-str);

subtest {
	is $class.can( $tiny-class-str ).elems, 0, "{package-name} does not handle $tiny-class-str";

	can-ok $tiny-class, 'can';
	is $tiny-class.can( 'Str' ), False, "$tiny-class-str does not do .Str";
	is $tiny-class.can( 'PrettyDump' ), False, "$tiny-class-str does not do .PrettyDump";
	}, "$tiny-class-str setup";

my $p = $class.new;
is $p.handles( $tiny-class-str ), False, "Basic object does not handle $tiny-class-str";

done-testing();
