use Test::More;
use Convert::NLS_DATE_FORMAT;

our %tests = (
    'YYYY-MM-DD HH24:MI:SS TZR'    => '%Y-%m-%d %H:%M:%S %Z',
    'YYYY-MM-DD HH24:MI:SS TZHTZM' => '%Y-%m-%d %H:%M:%S %z',
    'YYYY-MM-DD HH24:MI:SS'        => '%Y-%m-%d %H:%M:%S',
    'YYYY-MM-DD HH:MI:SS pm'       => '%Y-%m-%d %I:%M:%S %P',
    'yyyy-mm-dd hh:mi:ss pm'       => '%Y-%m-%d %I:%M:%S %P',
    'YYYY-MM-DD HH:MI:SS PM'       => '%Y-%m-%d %I:%M:%S %p',
    'DD Mon YYYY'                  => '%d %b %Y',
    'DD-MON-RR'                    => '%d-%b-%y', # default NLS_DATE_FORMAT
    'DD-MON-RR HH.MI.SSXFF AM'     => '%d-%b-%y %I.%M.%S.%6N %p', # default NLS_TIMESTAMP_FORMAT
    'DD-MON-RR HH.MI.SSXFF AM TZR' => '%d-%b-%y %I.%M.%S.%6N %p %Z', # default NLS_TIMESTAMP_TZ_FORMAT
    'Day, DD Month, YYYY'          => '%A, %d %B, %Y',
    'YYYY - Q'                     => '%Y - %{quarter}',
    'DD-MON-RR HH.MI.SSXFF9 AM'    => '%d-%b-%y %I.%M.%S.%9N %p',
    'DD-MON-RR HH.MI.SSXFF6 AM'    => '%d-%b-%y %I.%M.%S.%6N %p',
    'DD-MON-RR HH.MI.SSXFF AM'     => '%d-%b-%y %I.%M.%S.%6N %p',
    'DD-MON-RR HH.MI.SSXFF3 AM'    => '%d-%b-%y %I.%M.%S.%3N %p',
);

plan tests => scalar(keys %tests) + 3;

pass; # If we made it this far, we're ok.

while (my ($nls, $strf) = each %tests) {
    is Convert::NLS_DATE_FORMAT::oracle2posix($nls) => $strf, $nls;
}

is Convert::NLS_DATE_FORMAT::oracle2posix( 'YEAR-MM-DD"T"HH24:MI:SS' ),
    'YEAR-%m-%dT%H:%M:%S', "using YEAR";

is Convert::NLS_DATE_FORMAT::oracle2posix( 'YYYY-MM-DD"T"HH24:MI:SS' ),
    '%Y-%m-%dT%H:%M:%S', "escaped character";
