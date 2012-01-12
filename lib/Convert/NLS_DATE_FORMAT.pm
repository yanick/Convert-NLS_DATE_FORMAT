package Convert::NLS_DATE_FORMAT;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw(oracle2posix posix2oracle) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = '0.03';

our @formats = (
    Q     => '%{quarter}', # quarter number
    WW    => '%U', # week number
    IW    => '%V', # ISO week number
    W     => '', # week in month
    J     => '', # Julian days since 31 Dec 4713BC
    YEAR  => '', # year spelled out
    SYYYY => '%Y', # signed year (BC is negative)
    YYYY  => '%Y', # four digit year
    IYYY  => '%G', # ISO four digit year
    YYY   => '', # last three digits of year
    IYY   => '', # ISO last three digits of year
    YY    => '%y', # last two digits of year
    IY    => '%g', # ISO last two digits of year
    RR    => '%y', # last two digits of year relative to current date
    Month => '%B', # month spelled out
    Mon   => '%b', # three-letter abbreviation month
    MM    => '%m', # month number
    RM    => '', # roman numeral month XXII
    DDD   => '%j', # day of year
    DD    => '%d', # day of month
    Day   => '%A', # day of week spelled out
    Dy    => '%a', # three-letter abbreviation day of week
    D     => '%u', # day of week
    HH24  => '%H', # hours (24)
    HH12  => '%I', # hours (12)
    HH    => '%I', # hours (12)
    MI    => '%M', # minutes
    SSSSS => '', # seconds since midnight
    SS    => '%S', # seconds
    AM    => '%p', # displays AM or PM
    PM    => '%p',
    'A.M.'=> '', # displays A.M. or P.M.
    'P.M.'=> '',
    am    => '%P', # displays am or pm
    pm    => '%P',
    'a.m.'=> '', # displays a.m. or p.m.
    'p.m.'=> '',
    BC    => '', # displays BC or AD
    AD    => '',
    'B.C.'=> '', # displays B.C. or A.D.
    'A.D.'=> '',
    XFF9  => '.%9N', # special case until X can translate to %{decimal}
    XFF6  => '.%6N', # special case until X can translate to %{decimal}
    XFF3  => '.%3N', # special case until X can translate to %{decimal}
    XFF   => '.%6N', # special case until X can translate to %{decimal}
    FF    => '%6N',
    TZHTZM=> '%z', # time zone hour offset from UTC
    TZH   => '%z',
    TZR   => '%Z', # time zone name
    TH    => '', # appends 'st', 'nd', 'rd', 'th'
    Y     => '', # last digit of year
    I     => '', # ISO last digit of year
);

my %formats = generate_formats();

sub oracle2posix {
    # oracle format uses double quotes for
    # escaping
    return join '', 
            map { _oracle2posix( $_ ) } 
            split /(".*?")/, shift;
}

# convert a bit that is either escaped or not
sub _oracle2posix {
    my $string = shift;

    # escaped, strip the quotes and return as-is
    return $string if $string =~ s/^"(.*?)"$/$1/;

    for my $i ( 0..$#formats/2 ) {
        my ( $key, $value ) = @formats[ 2* $i, 2*$i + 1 ];

        $key = qr/$key/i unless $key =~ m/^[ap]m$/i;

        if ( $string =~ /(?<!%)$key/ ) {
            if ( $value ) {
                $string =~ s/(?<!%)$key/$value/g;
            }
            else {
                warn "Oracle format '$key' has no POSIX equivalent\n";
            }
        }
    }

    return $string;
}

sub posix2oracle {
    my $format = shift;
    # regex from DateTime
    $format =~ s/
		    (%{\w+})
	        /
		    $formats{$1} ? $formats{$1} : "\%$1"
	        /sgex;
    # special case for XFF until X can translate to %{decimal}
    $format =~ s/
                    (\.%\d?N)
                /
                    "XFF"
                /sgex;
    # regex from Date::Format
    $format =~ s/
		    (%[%a-zA-Z])
	        /
		    $formats{$1} ? $formats{$1} : "\%$1"
	        /sgex;
    return $format;
}

sub generate_formats {
    my $c = 0;
    my %f = ();
    while (my $nls = $formats[$c++]) {
        my $posix_format = $formats[$c++];
	if ($posix_format) {
	    $f{$posix_format} = $nls;
	}
    }
    $f{'%z'} = 'TZHTZM'; # special case
    return %f;
}

1;
__END__

=head1 NAME

Convert::NLS_DATE_FORMAT - Convert Oracle NLS_DATE_FORMAT <-> strftime Format Strings

=head1 SYNOPSIS

  use Convert::NLS_DATE_FORMAT qw(oracle2posix posix2oracle);
  my $strptime = oracle2posix($NLS_DATE_FORMAT);
  $NLS_DATE_FORMAT = posix2oracle($strftime);

=head1 DESCRIPTION

Convert Oracle's NLS_DATE_FORMAT string into a strptime format string, or
the reverse.

=head2 Functions

=over 4

=item oracle2posix

Takes an Oracle NLS_DATE_FORMAT string and converts it into formatting
string compatible with C<strftime> or C<strptime>.

  my $format = oracle2posix('YYYY-MM-DD HH24:MI:SS'); # '%Y-%m-%d %H:%M:%S'

=item posix2oracle

Takes a C<strftime> or C<strptime> formatting string and converts it
into an Oracle NLS_DATE_FORMAT string. I<It is possible to create strings
which Oracle will not accept as valid NLS_DATE_FORMAT strings.>

  my $format = posix2oracle('%Y-%m-%d %H:%M:%S'); # 'YYYY-MM-DD HH24:MI:SS'

=back

=head2 EXPORT

None by default. C<oracle2posix> and C<posix2oracle> when asked.

=head1 SEE ALSO

L<DateTime::Format::Oracle>.

=head1 AUTHOR

Nathan Gray, E<lt>kolibrie@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005, 2006, 2011 Nathan Gray

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
