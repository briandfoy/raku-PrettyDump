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

	method Pair($ds)
		{
		my @items = ':';
		given $ds.value.WHAT
			{
			when Bool
	 			{
				@items.push( '!' ) unless $ds.value;
				@items.push( $ds.key );
				}
			default
				{
				@items.push( $ds.key );
				@items.push( '(' );
				@items.push( self.pp($ds.value) );
				@items.push( ')' );
				}
			}
		return join( '', @items );
		}

	method Hash($ds)
		{
		my @items = '${';
		if @($ds).elems
			{
			@items.push( $.pre-item-spacing );
			@items.push(
				join(
				',' ~ $.post-separator-spacing,
				map { self.pp($_) }, sort @($ds)
				)
			);
			@items.push( $.post-item-spacing );
			}
		else
			{
			@items.push( $.intra-group-spacing );
			}
		@items.push( '}' );
		return join( '', @items );
		}

	method Array($ds)
		{
		my @items = '$[';
		if @($ds).elems
			{
			@items.push( $.pre-item-spacing );
			@items.push(
				join(
				',' ~ $.post-separator-spacing,
				map { self.pp($_) }, sort @($ds)
				)
			);
			@items.push( $.post-item-spacing );
			}
		else
			{
			@items.push( $.intra-group-spacing );
			}
		@items.push( ']' );
		return join( '', @items );
		}

	method pp($ds)
		{
		my Str $str;
		given $ds.WHAT
			{
			when Hash    { $str ~= self.Hash($ds) }
			when Array   { $str ~= self.Array($ds) }
			when Pair    { $str ~= self.Pair($ds) }
			when Str     { $str ~= $ds.perl }
			when Numeric { $str ~= ~$ds }
			when Nil     { $str ~= q{Nil} }
			when Any     { $str ~= q{Any} }
			}
		return $str;
		}
	}

# vim: ft=perl6
