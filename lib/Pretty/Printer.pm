=begin pod

=head1 Pretty::Printer

C<Pretty::Printer> pretty-prints a Perl6 data structure.

=head1 Synopsis

    use Pretty::Printer < pp >;

    my $ds = { a => 1 };

    my $pp = Pretty::Printer.new( after-opening-brace => True );
    $p.pp( $ds );

    say pp $ds;

=head1 Documentation

Print your data structures with a bit more space than your average .gist or .perl output. Also (with any luck) lets you see the hidden trailing commas that hide at the end of the .gist output.

The C<pp> function/method will B<always> attempt to return a string, so please dn't be surprised when passing in the C<Nil> object and C<'(Nil)'> return the same string. It's intended purely for debugging purposes, not serialization. If you require that types remain intact, then you're looking at the wrong module.

=end pod

use v6;

###############################################################################

#`(
class 	AST 	Abstract representation of a piece of source code
class 	Any 	Thing/object
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
class 	IO::Path 	File or directory path
class 	IO::Pipe 	Buffered inter-process string or binary stream
role 	IO::Socket 	Network socket
class 	IO::Socket::Async 	Asynchronous TCP socket
class 	IO::Socket::INET 	TCP Socket
class, class 	IO::Spec 	Platform specific operations on file and directory paths
class 	IO::Spec::Cygwin 	Platform specific operations on file and directory paths for Cygwin
class 	IO::Spec::Unix 	Platform specific operations on file and directory paths for POSIX
class 	IO::Spec::Win32 	Platform specific operations on file and directory paths for Windows
class 	Instant 	Specific moment in time
class 	Int 	Integer (arbitrary-precision)
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
class 	Metamodel::ClassHOW 	Metaobject representing a Perl 6 class.
role 	Metamodel::Finalization 	Metaobject supporting object finalization
role 	Metamodel::MROBasedMethodDispatch 	Metaobject that supports resolving inherited methods
role 	Metamodel::MethodContainer 	Metaobject that supports storing and introspecting methods
role 	Metamodel::MultipleInheritance 	Metaobject that supports multiple inheritance
role 	Metamodel::Naming 	Metaobject that supports named types
class 	Metamodel::Primitives 	Metaobject that supports low-level type operations
role 	Metamodel::PrivateMethodContainer 	Metaobject that supports private methods
role 	Metamodel::RoleContainer 	Metaobject that supports holding/containing roles
role 	Metamodel::Trusting 	Metaobject that supports trust relations between types
class 	Method 	Member function
class 	Mix 	Immutable collection of distinct objects with Real weights
class 	MixHash 	Mutable collection of distinct objects with Real weights
role 	Mixy 	Collection of distinct objects with Real weights
class 	Mu 	The root of the Perl 6 type hierarchy.
class 	Nil 	Absence of a value
class 	Num 	Floating-point number
role 	Numeric 	Number or object that can act as a number
class 	ObjAt 	Unique identification for an object
class 	Pair 	Key/value pair
class 	Parameter 	Element of a
class 	Pod::Block 	Block in a Pod document
class 	Pod::Block::Code 	Verbatim code block in a Pod document
class 	Pod::Block::Named 	Named block in a Pod document
class 	Pod::Block::Para 	Paragraph in a Pod document
class 	Pod::Item 	Item in a Pod enumeration list
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
class 	X::Anon::Augment 	Compilation error due to augmenting an anonymous package
class 	X::Anon::Multi 	Compilation error due to declaring an anonymous multi
class 	X::Assignment::RO 	Exception thrown when trying to assign to something read-only
class 	X::Attribute::NoPackage 	Compilation error due to declaring an attribute outside of a package
class 	X::Attribute::Package 	Compilation error due to declaring an attribute in an ineligible package
class 	X::Attribute::Undeclared 	Compilation error due to an undeclared attribute
class 	X::Augment::NoSuchType 	Compilation error due to augmenting a non-existing type
class 	X::Bind 	Error due to binding to something that is not a variable or container
class 	X::Bind::NativeType 	Compilation error due to binding to a natively typed variable
class 	X::Bind::Slice 	Error due to binding to a slice
class 	X::Channel::ReceiveOnClosed 	Error due to calling
class 	X::Channel::SendOnClosed 	Error due to calling
role 	X::Comp 	Common role for compile-time errors
class 	X::Composition::NotComposable 	Compilation error due to composing an ineligible type
class 	X::Constructor::Positional 	Error due to passing positional arguments to a default constructor
class 	X::ControlFlow 	Error due to calling a loop control command in an ineligible scope
class 	X::ControlFlow::Return 	Error due to calling return outside a routine
class 	X::Declaration::Scope 	Compilation error due to a declaration with an ineligible scope
class 	X::Declaration::Scope::Multi 	Compilation error due to declaring a multi with an ineligible scope
class 	X::Does::TypeObject 	Error due to mixing into a type object
class 	X::Eval::NoSuchLang 	Error due to specifying an unknown language for EVAL
class 	X::Export::NameClash 	Compilation error due to exporting the same symbol twice
role 	X::IO 	IO related error
class 	X::IO::Chdir 	Error while trying to change the working directory
class 	X::IO::Chmod 	Error while trying to change file permissions
class 	X::IO::Copy 	Error while trying to copy a file
class 	X::IO::Cwd 	Error while trying to determine the current working directory
class 	X::IO::Dir 	Error while trying to get a directory's contents
class 	X::IO::Mkdir 	Error while trying to create a directory
class 	X::IO::Rename 	Error while trying to rename a file or directory
class 	X::IO::Rmdir 	Error while trying to remove a directory
class 	X::IO::Unlink 	Error while trying to remove a file
class 	X::Inheritance::NotComposed 	Error due to inheriting from a type that's not composed yet
class 	X::Inheritance::Unsupported 	Compilation error due to inheriting from an ineligible type
class 	X::Method::InvalidQualifier 	Error due to calling a qualified method from an ineligible class
class 	X::Method::NotFound 	Error due to calling a method that isn't there
class 	X::Method::Private::Permission 	Compilation error due to calling a private method without permission
class 	X::Method::Private::Unqualified 	Compilation error due to an unqualified private method call
class 	X::Mixin::NotComposable 	Error due to using an ineligible type as a mixin
class 	X::NYI 	Error due to use of an unimplemented feature
class 	X::NoDispatcher 	Error due to calling a dispatch command in an ineligible scope
class 	X::Numeric::Real 	Error while trying to coerce a number to a Real type
role 	X::OS 	Error reported by the operating system
class 	X::Obsolete 	Compilation error due to use of obsolete syntax
class 	X::OutOfRange 	Error due to indexing outside of an allowed range
class 	X::Package::Stubbed 	Compilation error due to a stubbed package that is never defined
class 	X::Parameter::Default 	Compilation error due to an unallowed default value in a signature
class 	X::Parameter::MultipleTypeConstraints 	Compilation error due to a parameter with multiple type constraints
class 	X::Parameter::Placeholder 	Compilation error due to an unallowed placeholder in a signature
class 	X::Parameter::Twigil 	Compilation error due to an unallowed twigil in a signature
class 	X::Parameter::WrongOrder 	Compilation error due to passing parameters in the wrong order
class 	X::Phaser::Multiple 	Compilation error due to multiple phasers of the same type
class 	X::Phaser::PrePost 	Error due to a false return value of a PRE/POST phaser
class 	X::Placeholder::Block 	Compilation error due to a placeholder in an ineligible block
class 	X::Placeholder::Mainline 	Compilation error due to a placeholder in the mainline
role 	X::Pod 	Pod related error
role 	X::Proc::Async 	Exception thrown by
class 	X::Proc::Async::AlreadyStarted 	Error due to calling
class 	X::Proc::Async::CharsOrBytes 	Error due to tapping the same
class 	X::Proc::Async::MustBeStarted 	Error due to interacting with a
class 	X::Proc::Async::OpenForWriting 	Error due to writing to a read-only
class 	X::Proc::Async::TapBeforeSpawn 	Error due to tapping a Proc::Async stream after spawning its process
class 	X::Promise::CauseOnlyValidOnBroken 	Error due to asking why an unbroken promise has been broken.
class 	X::Redeclaration 	Compilation error due to declaring an already declared symbol
class 	X::Role::Initialization 	Error due to passing an initialization value to an ineligible role
class 	X::Sequence::Deduction 	Error due to constructing a sequence from ineligible input
class 	X::Signature::NameClash 	Compilation error due to two named parameters with the same name
class 	X::Signature::Placeholder 	Compilation error due to placeholders in a block with a signature
class 	X::Str::Numeric 	Error while trying to coerce a string to a number
class 	X::StubCode 	Runtime error due to execution of stub code
role 	X::Syntax 	Syntax error thrown by the compiler
class 	X::Syntax::Augment::Role 	Compilation error due to augmenting a role
class 	X::Syntax::Augment::WithoutMonkeyTyping 	Compilation error due to augmenting a type without `MONKEY-TYPING`
class 	X::Syntax::Comment::Embedded 	Compilation error due to a malformed inline comment
class 	X::Syntax::Confused 	Compilation error due to unrecognized syntax
class 	X::Syntax::InfixInTermPosition 	Compilation error due to an infix in term position
class 	X::Syntax::Malformed 	Compilation error due to a malformed construct (usually a declarator)
class 	X::Syntax::Missing 	Compilation error due to a missing piece of syntax
class 	X::Syntax::NegatedPair 	Compilation error due to passing an argument to a negated colonpair
class 	X::Syntax::NoSelf 	Compilation error due to implicitly using a `self` that is not there
class 	X::Syntax::Number::RadixOutOfRange 	Compilation error due to an unallowed radix in a number literal
class 	X::Syntax::P5 	Compilation error due to use of Perl 5-only syntax
class 	X::Syntax::Regex::Adverb 	Compilation error due to an unrecognized regex adverb
class 	X::Syntax::Regex::SolitaryQuantifier 	Compilation error due to a regex quantifier without preceding atom
class 	X::Syntax::Reserved 	Compilation error due to use of syntax reserved for future use
class 	X::Syntax::Self::WithoutObject 	Compilation error due to invoking `self` in an ineligible scope
class 	X::Syntax::Signature::InvocantMarker 	Compilation error due to a misplaced invocant marker in a signature
class 	X::Syntax::Term::MissingInitializer 	Compilation error due to declaring a term without initialization
class 	X::Syntax::UnlessElse 	Compilation error due to an `unless` clause followed by `else`
class 	X::Syntax::Variable::Match 	Compilation error due to declaring a match variable
class 	X::Syntax::Variable::Numeric 	Compilation error due to declaring a numeric symbol
class 	X::Syntax::Variable::Twigil 	Compilation error due to an unallowed twigil in a declaration
class 	X::Temporal 	Error related to DateTime or Date
class 	X::Temporal::Truncation 	Error while trying to truncate a Date or DateTime
class 	X::TypeCheck 	Error due to a failed type check
class 	X::TypeCheck::Assignment 	Error due to a failed type check during assignment
class 	X::TypeCheck::Binding 	Error due to a failed type check during binding
class 	X::TypeCheck::Return 	Error due to a failed typecheck during `return`
class 	X::TypeCheck::Splice 	Compilation error due to a macro trying to splice a non-AST value
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
				$str = '{';
				$str ~= ($!newline-after-hash-start ?? "\n" !! ' ');
				$str ~= join(
					',' ~
					($!newline-between-hash-pairs ?? "\n" !! ' '),
					map { self.pp($_) }, @($ds)
				);
				$str ~= ($!newline-before-hash-end ?? "\n" !! ' ');
				$str ~= '}';
				return $str;
				}
			when Array
				{
				$str = '$[';
				$str ~= ($!newline-after-array-start ?? "\n" !! ' ');
				$str ~= join(
					',' ~
					($!newline-between-array-items ?? "\n" !! ' '),
					map { self.pp($_) }, @($ds)
					#@($ds)
				);
				$str ~= ($!newline-before-array-end ?? "\n" !! ' ');
				$str ~= ']';
				return $str;
				}
			when Pair
				{
				$str ~= ':';
				$str ~= $ds.key;
				$str ~= '(';
				$str ~= ($!whitespace-after-pair-value-start ?? ' ' !! '');
				$str ~= self.pp($ds.value);
				$str ~= ($!whitespace-before-pair-value-end ?? ' ' !! '');
				$str ~= ')';
				}
			when Str { $str = $ds }
			when Int { $str = ~$ds }
			when Nil { $str = '(Nil)' }
			when Any { $str = '(Any)' }
			}
return $str;
		}
	}

# vim: ft=perl6
