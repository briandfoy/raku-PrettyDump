=begin pod

=head1 NAME

PrettyDump - represent a Perl 6 data structure in a human readable way

=head1 SYNOPSIS

Use is in the OO fashion:

    use PrettyDump;
    my $pretty = PrettyDump.new:
    	after-opening-brace => True
    	;

    my $perl = { a => 1 };
    say $pretty.dump: $perl; # '{:a(1)}'

Or, use its subroutine:

	use PrettyDump qw(pretty-dump);

    my $ds = { a => 1 };

	say pretty-dump( $ds );

	# setting are named arguments
	say pretty-dump( $ds
		:indent("\t")
		);

=head1 DESCRIPTION

This module creates nicely formatted representations of your data
structure for your viewing pleasure. It does not create valid Perl 6
code and is not a serialization tool.

When C<.dump> encounters an object in your data structure, it first
checks for a C<.PrettyDump> method. It that exists, it uses it to
stringify that object. Otherwise, C<.dump> looks for internal methods.
So far, this module handles these types internally:

=item * List

=item * Array

=item * Pair

=item * Map

=item * Hash

=item * Match

=head2 Configuration

You can set some tidy-like settings to control how C<.dump> will
present the data stucture:

=item indent

The default is a tab.

=item intra-group-spacing

The spacing inserted inside (empty) C<${}> and C<$[]> constructs.
The default is the empty string.

=item pre-item-spacing

The spacing inserted just after the opening brace or bracket of
non-empty C<${}> and C<$[]> constructs. The default is a newline.

=item post-item-spacing

The spacing inserted just before the close brace or bracket of
non-empty C<${}> and C<$[]> constructs. The default is a newline.

=item pre-separator-spacing

The spacing inserted just before the comma separator of non-empty
C<${}> and C<$[]> constructs. The default is the empty string.

=item post-separator-spacing

The spacing inserted just after the comma separator of non-empty
C<${}> and C<$[]> constructs.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>.

This module started as L<Pretty::Printer> from Jeff Goff, which you
can find at L<https://github.com/drforr/perl6-pp>

=head1 SOURCE

The repository for this source is in GitHub at L<https://github.com/briandfoy/perl6-PrettyDump>

=head1 COPYRIGHT

=head1 LICENSE

This module is available under the Artistic License 2.0. A copy of
this license should have come with this distribution in the LICENSE
file.

=end pod

use v6;

###############################################################################


class PrettyDump {
	has Str $.pre-item-spacing       = "\n";
	has Str $.post-item-spacing      = "\n";

	has Str $.pre-separator-spacing  = '';
	has Str $.intra-group-spacing    = '';
	has Str $.post-separator-spacing = ' ';

	has Str $.indent                 = "\t";

	method indent-string ( $str, $depth ) {
		return $str unless $.indent ne '';

		my $leading = $.indent xx $depth;
		my @lines = $str.split: "\n";
		@lines.map: { $_ = $leading ~ $_ };
		return @lines.join: "\n";
		}

	method Pair ( $ds, $depth ) {
	put "In pair. Got ", $ds.^name;
	put "key is ", $ds.key;
	my $what = $ds.value.^name;
	put "in Pair, WHAT is $what";
	put "\$what is {$what.^name}";
		my $str = ':';
		given $ds.value.^name {
			when "Bool" {
				$str ~= '!' unless $ds.value;
				$str ~= $ds.key
				}
			when "NQPMu" {
				$str ~= "{$ds.key}(Mu)";
				}
			default {
				$str ~= $ds.key;
				$str ~= '(';
				$str ~= self.dump( $ds.value, 0 ).trim;
				$str ~= ')';
				}
			}
		return $str;
		}

	method Hash ( $ds, $depth ) {
		self.balanced:  '${', '}', $ds, $depth;
		}

	method Array ( $ds, $depth ) {
		self.balanced:  '$[', ']', $ds, $depth;
		}

	method List ( $ds, $depth ) {
		self.balanced:  '$(', ')', $ds, $depth;
		}

	method balanced ( $start, $end, $ds, $depth ) {
		return $start ~ self._structure( $ds, $depth ) ~ $end;
		}

	method _structure ( $ds, $depth ) {
		my $str;
		if @($ds).elems {
			$str ~= $.pre-item-spacing;
			$str ~= join(
				$.pre-separator-spacing ~
				',' ~
				$.post-separator-spacing,
				map { self.dump: $_, $depth+1 }, sort @($ds)
				);
			$str ~= $.post-item-spacing;
			}
		else {
			$str ~= $.intra-group-spacing;
			}
		return $str;
		}

	method Map ( $ds, $depth ) {
		my $str = qq/Map.new(/;
		for $ds.pairs -> $pair {
			$str ~= "\n" ~ self.Pair: $pair, $depth+1;
			}
		$str ~= ")";
		return self.indent-string: $str, $depth+1;
		}

			pos  => $ds.pos,
	method Match ( $ds, $depth ) {
		my $str = Q/Match.new(/;
		my $hash = {
			made => $ds.made,
			to   => $ds.to,
			from => $ds.from,
			orig => $ds.orig,
			hash => $ds.hash,
			list => $ds.list,
			};
		$str ~= self._structure: $hash, $depth+1;
		$str ~= ')';
		return self.indent-string: $str, $depth;
		}

	method Numeric ( $ds, $depth ) { $ds.Str }

	method Str   ( $ds, $depth ) { $ds.perl }
	method Nil   ( $ds, $depth ) { q/Nil/ }
	method Any   ( $ds, $depth ) { q/Any/ }
	method Mu    ( $ds, $depth ) { q/Mu/  }
	method NQPMu ( $ds, $depth ) { q/Mu/  }

	method dump ( $ds, $depth = 0 ) {
		put "In dump. Got ", $ds.^name;
		my Str $str;

		if $ds.can: 'PrettyDump' {
			$str ~= $ds.PrettyDump: self;
			}
		elsif $ds ~~ Numeric {
			$str ~= self.Numeric: $ds, $depth;
			}
		elsif self.can: $ds.^name {
			my $what = $ds.^name;
			$str ~= self."$what"( $ds, $depth );
			}
		else {
			die "Could not handle " ~ $ds.perl;
			}

		return self.indent-string: $str, $depth;
		}

	sub pretty-dump ( $ds,
		:$pre-item-spacing       = "\n",
		:$post-item-spacing      = "\n",
		:$pre-separator-spacing  = '',
		:$intra-group-spacing    = '',
		:$post-separator-spacing = ' ',
		:$indent                 = "\t",
		) is export {
		say "Got: " ~ $ds.^name;
		my $pretty = PrettyDump.new:
			:indent\                 ($indent),
			:pre-item-spacing\       ($pre-item-spacing),
			:post-item-spacing\      ($post-item-spacing),
			:pre-separator-spacing\  ($pre-separator-spacing),
			:intra-group-spacing\    ($intra-group-spacing),
			:post-separator-spacing\ ($post-separator-spacing),
			;

		$pretty.dump: $ds;
		}
	}
