package App::KwaliteeUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{calc_kwalitee} = {
    v => 1.1,
    summary => 'Calculate kwalitee of a local distribution',
    args => {
        dist => {
            summary => 'Distribution archive file (e.g. tarball) or directory',
            schema => 'pathname*',
            req => 1,
            default => '.',
            description => <<'_',

Although a directory (top-level directory of an extracted Perl distribution) can
be analyzed, distribution Kwalitee is supposed to be calculated on a
distribution archive file (e.g. tarball) because there are metrics like
`extractable`, `extracts_nicely`, `no_pax_headers` which can only be tested on a
distribution archive file. Running this on a directory will result in a
less-than-full score.

_
        },
        raw => {
            schema => 'true*',
        },
    },
};
sub calc_kwalitee {
    require Module::CPANTS::Analyse;

    my %args = @_;

    my $mca = Module::CPANTS::Analyse->new({dist => $args{dist}});
    my $res = $mca->run;

    if ($args{raw}) {
        return [200, "OK", $res];
    } else {
        my $kw = $res->{kwalitee};
        my $num_indicators = %$kw - 1;
        $kw->{'00kwalitee_score'} =
            sprintf("%.2f", ($kw->{kwalitee} / $num_indicators)*100);
        return [200, "OK", $kw];
    }
}

1;
#ABSTRACT: Utilities related to Kwalitee

=head1 DESCRIPTION

This distributions provides the following command-line utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

L<Module::CPANTS::Kwalitee>

L<https://cpants.cpanauthors.org/kwalitee/>

=cut
