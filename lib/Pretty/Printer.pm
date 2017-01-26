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

The various settings work like this:

=over 1

=item intra-group-spacing

Defines the spacing inserted inside (empty) C<${}> and C<$[]> constructs.

=cut

=item pre-item-spacing

The spacing inserted just after the opening brace or bracket of non-empty C<${}> and C<$[]> constructs.

=cut

=item post-item-spacing

The spacing inserted just before the close brace or bracket of non-empty C<${}> and C<$[]> constructs.

=cut

=item pre-separator-spacing

The spacing inserted just before the comma separator of non-empty C<${}> and C<$[]> constructs.

=cut

=item post-separator-spacing

The spacing inserted just after the comma separator of non-empty C<${}> and C<$[]> constructs.

=cut

=back

=end pod

use v6;

###############################################################################

class Pretty::Printer
	{
	has Str $.pre-item-spacing = '';
	has Str $.pre-separator-spacing = '';
	has Str $.intra-group-spacing = '';
	has Str $.post-separator-spacing = ' ';
	has Str $.post-item-spacing = '';

	has Str $.indent-style = '';

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

# vim: ft=perl6
