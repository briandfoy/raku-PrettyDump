=begin pod

=head1 NAME

PrettyDump - represent a Perl 6 data structure in a human readable way

=head1 SYNOPSIS

    use PrettyDump;

    my $ds = { a => 1 };

    my $pretty = PrettyDump.new(
    	after-opening-brace => True
    	);
    say $pretty.dump: $ds; # '{:a(1)}'

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

This module started as L<Pretty::Printer> from Jeff Goff,

=head1 COPYRIGHT

=head1 LICENSE

This module is available under the Artistic License 2.0. A copy of
this license should have come with this distribution in the LICENSE
file.

=end pod

use v6;

###############################################################################


class PrettyDumper {
	has Str $.pre-item-spacing       = "\n";
	has Str $.post-item-spacing      = "\n";

	has Str $.pre-separator-spacing  = '';
	has Str $.intra-group-spacing    = '';
	has Str $.post-separator-spacing = ' ';

	has Str $.indent                 = "\t";

	method indent-string($str,$depth)
		{
		return $str unless $.indent-style ne '';

		my $leading = $.indent-style xx $depth;
		my @lines = $str.split( "\n" );
		@lines.map: { $_ = $leading ~ $_ };
		return @lines.join( "\n" );
		}

	method Pair($ds,$depth)
		{
		my $str = ':';
		given $ds.value.WHAT
			{
			when Bool
	 			{
				$str ~= '!' unless $ds.value;
				$str ~= $ds.key
				}
			default
				{
				$str ~= $ds.key;
				$str ~= '(';
				$str ~= self._pp($ds.value,0).trim;
				$str ~= ')';
				}
			}
		return $str;
		}

	method Hash($ds,$depth)
		{
		my $str = '${';
		$str ~= self._structure($ds,$depth);
		$str ~= '}';
		return $str;
		}

	method Array($ds,$depth)
		{
		my $str = '$[';
		$str ~= self._structure($ds,$depth);
		$str ~= ']';
		return $str;
		}

	method List($ds,$depth)
		{
		my $str = '$(';
		$str ~= self._structure($ds,$depth);
		$str ~= ')';
		return $str;
		}

	method _structure($ds,$depth)
		{
		my $str;
		if @($ds).elems
			{
			$str ~= $.pre-item-spacing;
			$str ~= join(
				$.pre-separator-spacing ~
				',' ~
				$.post-separator-spacing,
				map { self._pp($_,$depth+1) }, sort @($ds)
			);
			$str ~= $.post-item-spacing;
			}
		else
			{
			$str ~= $.intra-group-spacing;
			}
		return $str;
		}

	method Map($ds,$depth)
		{
		my $str = qq/Map.new(/;
		for $ds.pairs -> $pair {
			$str ~= "\n" ~ self.Pair($pair,$depth+1);
			}
		$str ~= ")";
		return self.indent-string($str,$depth+1);
		}

	method Match($ds,$depth)
		{
		my $str = Q/Match.new(/;
		my $hash = {
			ast  => $ds.made,
			to   => $ds.to,
			from => $ds.from,
			orig => $ds.orig,
			hash => $ds.hash,
			list => $ds.list,
			};

		$str ~= self.Hash( $hash, $depth+1 );
		$str ~= ')';
		return self.indent-string($str,$depth);
		}

	method _pp($ds,$depth)
		{
		my Str $str;
		given $ds.WHAT
			{
			# be very careful here. Check more derived types first.
			when Match   { $str ~= self.Match($ds,$depth) }
			when Hash    { $str ~= self.Hash($ds,$depth)  }
			when Array   { $str ~= self.Array($ds,$depth) }
			when Map     { $str ~= self.Map($ds,$depth) }
			when List    { $str ~= self.List($ds,$depth) }
			when Pair    { $str ~= self.Pair($ds,$depth)  }
			when Str     { $str ~= $ds.perl }
			when Numeric { $str ~= ~$ds }
			when Nil     { $str ~= q{Nil} }
			when Any     { $str ~= q{Any} }
			}
		return self.indent-string($str,$depth);
		}

	method pp($ds)
		{
		return self._pp($ds,0);
		}
	}
