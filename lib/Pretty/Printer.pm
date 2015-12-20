=begin pod

=head1 Pretty::Printer

C<Pretty::Printer> pretty-prints a Perl6 data structure.

=head1 Synopsis

    use Pretty::Printer; # Next version will export non-OO version

    my $ds = { a => 1 };

    my $pp = Pretty::Printer.new( after-opening-brace => True );
    say $p.pp( $ds ); # '{:a(1)}'

=head1 Documentation

Print your data structures with a bit more space than your average .gist or .perl output. Also (with any luck) lets you see the hidden trailing commas that hide at the end of the .gist output.

The C<pp> function/method will B<always> attempt to return a string, so please dn't be surprised when passing in the C<Nil> object and C<'(Nil)'> return the same string. It's intended purely for debugging purposes, not serialization. If you require that types remain intact, then you're looking at the wrong module.

=end pod

use v6;

###############################################################################

#`(
class 	AST 	Abstract representation of a piece of source code
class 	Array 	Sequence of itemized values
role 	Associative 	Object that supports looking up values by key
class 	Attribute 	Member variable
class 	Backtrace 	Snapshot of the dynamic call stack
class 	Backtrace::Frame 	Single frame of a
class 	Bag 	Immutable collection of distinct objects with integer weights
class 	BagHash 	Mutable collection of distinct objects with integer weights
role 	Baggy 	Collection of distinct weighted objects
role 	Blob 	Immutable buffer for binary data ('Binary Large OBject')
class 	Block 	Code object with its own lexical scope
class 	Bool 	Logical boolean
role 	Buf 	Mutable buffer for binary data
role 	Callable 	Invocable code object
class 	Capture 	Argument list suitable for passing to a
class 	Channel 	Thread-safe queue for sending values from producers to consumers
class 	Code 	Code object
class 	Complex 	Complex number
class 	Cool 	Value that can be treated as a string or number interchangeably
class 	CurrentThreadScheduler 	Scheduler that blockingly executes code on the current thread
class 	Cursor 	Internal state of the regex engine during parsing
class 	Date 	Calendar date
class 	DateTime 	Calendar date with time
role 	Dateish 	Object that can be treated as a date
class 	Duration 	Length of time
class 	Enum 	Immutable key/value pair
class 	Exception 	Anomalous event capable of interrupting normal control-flow
class 	Failure 	Delayed exception
class 	FatRat 	Rational number (arbitrary-precision)
class, class 	Grammar 	Group of named regexes that form a formal grammar
class 	Hash 	Mapping from strings to itemized values
role 	IO 	Input/output related object
class 	IO::Handle 	Opened file or stream
class 	IO::Notification 	Asynchronous notification for file and directory changes
class 	Instant 	Specific moment in time
role 	Iterable 	Interface for container objects that can be iterated over
role 	Iterator 	Generic API for producing a sequence of values
class 	Junction 	Logical superposition of values
class 	Label 	Tagged location in the source code
class 	List 	Sequence of values
class 	Lock 	Low-level thread locking primitive
class 	Macro 	Compile-time routine
class 	Map 	Immutable mapping from strings to values
class 	Match 	Result of a successful regex match
role 	Metamodel::AttributeContainer 	Metaobject that can hold attributes
role 	Metamodel::C3MRO 	Metaobject that supports the C3 method resolution order
role 	Metamodel::Trusting 	Metaobject that supports trust relations between types
class 	Method 	Member function
class 	Mix 	Immutable collection of distinct objects with Real weights
class 	MixHash 	Mutable collection of distinct objects with Real weights
role 	Mixy 	Collection of distinct objects with Real weights
class 	Mu 	The root of the Perl 6 type hierarchy.
class 	Num 	Floating-point number
role 	Numeric 	Number or object that can act as a number
class 	ObjAt 	Unique identification for an object
class 	Pair 	Key/value pair
class 	Parameter 	Element of a
class 	Pod::Block 	Block in a Pod document
class 	Pod::Block::Code 	Verbatim code block in a Pod document
role 	Positional 	Object that supports looking up values by index
role 	PositionalBindFailover 	Failover for binding an Iterable to a Positional
class 	Proc 	Running process (filehandle-based interface)
class 	Proc::Async 	Running process (asynchronous interface)
class 	Proc::Status 	Status of a running process
class 	Promise 	Status/result of an asynchronous computation
class 	Proxy 	Item container with custom storage and retrieval
role 	QuantHash 	Collection of objects represented as hash keys
class 	Range 	Interval of ordered values
class 	Rat 	Rational number (limited-precision)
role 	Rational 	Number stored as numerator and denominator
role 	Real 	Non-complex number
class 	Regex 	String pattern
class 	Routine 	Code object with its own lexical scope and `return` handling
role 	Scheduler 	Scheme for automatically assigning tasks to threads
class 	Seq 	An iterable, lazy sequence of values
class 	Set 	Immutable collection of distinct objects
class 	SetHash 	Mutable collection of distinct objects
role 	Setty 	Collection of distinct objects
class 	Signature 	Parameter list pattern
class 	Slip 	A kind of List that automatically flattens into an outer container
class 	Stash 	Table for "our"-scoped symbols
class 	Str 	String of characters
role 	Stringy 	String or object that can act as a string
class 	Sub 	Subroutine
class 	Submethod 	Member function that is not inherited by subclasses
class 	Supplier 	Live
class 	Supply 	Asynchronous data stream with multiple subscribers
class 	Tap 	Subscription to a
class 	Temporal 	Time-related functions
class 	Thread 	Concurrent execution of code (low-level)
class 	ThreadPoolScheduler 	Scheduler that distributes work among a pool of threads
class 	Variable 	Object representation of a variable for use in traits
class 	Version 	Module version descriptor
class 	Whatever 	Placeholder for an unspecified value/argument
class 	WhateverCode 	Code object constructed by Whatever-currying
class 	X::AdHoc 	Error with a custom error message
class 	X::Undeclared 	Compilation error due to an undeclared symbol
class 	int 	Integer (native storage; machine precision)
)

###############################################################################

class Pretty::Printer
	{
	has $!newline-after-array-start = False;
	has $!newline-between-array-items = False;
	has $!newline-before-array-end = False;

	has $!newline-after-hash-start = False;
	has $!newline-between-hash-pairs = False;
	has $!newline-before-hash-end = False;

	has $!whitespace-after-pair-value-start = False;
	has $!whitespace-before-pair-value-end = False;
	method pp($ds)
		{
		my Str $str;
		given $ds.WHAT
			{
			when Hash
				{
				$str = '${';
				$str ~= ($!newline-after-hash-start ?? "\n" !! '');
				$str ~= join(
					',' ~
					($!newline-between-hash-pairs ?? "\n" !! ' '),
					map { self.pp($_) }, sort @($ds)
				);
				$str ~= ($!newline-before-hash-end ?? "\n" !! '');
				$str ~= '}';
				return $str;
				}
			when Array
				{
				$str = '$[';
				$str ~= ($!newline-after-array-start ?? "\n" !! '');
				$str ~= join(
					',' ~
					($!newline-between-array-items ?? "\n" !! ' '),
					map { self.pp($_) }, @($ds)
					#@($ds)
				);
				$str ~= ($!newline-before-array-end ?? "\n" !! '');
				$str ~= ']';
				return $str;
				}
			when Pair
				{
				$str ~= ':';
				given $ds.value.WHAT
					{
					when Bool
						{
						if !$ds.value
							{
							$str ~= '!'
							}
						$str ~= $ds.key
						}
					default
						{
						$str ~= $ds.key;
						$str ~= '(';
						$str ~= ($!whitespace-after-pair-value-start ?? ' ' !! '');
#if $ds.key eq 'content' { say $ds.value.WHAT }
						$str ~= self.pp($ds.value);
						$str ~= ($!whitespace-before-pair-value-end ?? ' ' !! '');
						$str ~= ')';
						}
					}
				}
			when Str
				{
				$str ~= $ds.perl;
				}
			when Numeric { $str ~= ~$ds }
			when Nil { $str ~= q{Nil} }
			when Any { $str ~= q{Any} }
			}
		return $str;
		}
	}

# vim: ft=perl6
