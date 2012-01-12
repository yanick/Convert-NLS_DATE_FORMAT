# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Convert-NLS_DATE_FORMAT.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN {
our %tests = (
    'YYYY-MM-DD HH24:MI:SS TZR'    => '%Y-%m-%d %H:%M:%S %Z',
    'YYYY-MM-DD HH24:MI:SS TZHTZM' => '%Y-%m-%d %H:%M:%S %z',
    'YYYY-MM-DD HH24:MI:SS'        => '%Y-%m-%d %H:%M:%S',
    'YYYY-MM-DD HH:MI:SS pm'       => '%Y-%m-%d %I:%M:%S %P',
    'YYYY-MM-DD HH:MI:SS PM'       => '%Y-%m-%d %I:%M:%S %p',
    'DD Mon YYYY'                  => '%d %b %Y',
    'DD-Mon-RR'                    => '%d-%b-%y', # default NLS_DATE_FORMAT
    'DD-Mon-RR HH.MI.SSXFF PM'     => '%d-%b-%y %I.%M.%S.%6N %p', # default NLS_TIMESTAMP_FORMAT
    'DD-Mon-RR HH.MI.SSXFF PM TZR' => '%d-%b-%y %I.%M.%S.%6N %p %Z', # default NLS_TIMESTAMP_TZ_FORMAT
    'Day, DD Month, YYYY'          => '%A, %d %B, %Y',
    'YYYY - Q'                     => '%Y - %{quarter}',
);
};
BEGIN { plan tests => scalar(keys %tests) + 1 };
use Convert::NLS_DATE_FORMAT;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

while (my ($nls, $strf) = each %tests) {
    ok(Convert::NLS_DATE_FORMAT::posix2oracle($strf), $nls, $strf);
}
