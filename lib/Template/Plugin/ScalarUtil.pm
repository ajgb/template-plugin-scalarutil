package Template::Plugin::ScalarUtil;
# ABSTRACT: Scalar::Util plugin for Template-Toolkit

use strict;
use warnings;

use base qw( Template::Plugin );

use Scalar::Util qw();

=head1 SYNOPSIS

    [% USE ScalarUtil %]

    # blessed
    [% ScalarUtil.blessed(EXPR) ? 'blessed' : 'not blessed' %]

    # dualvar
    [% SET dv = ScalarUtil.dualvar( 5, "Hello" ) %]
    [% SET num = dv + 7 %]
    [% SET string = dv _ " world!" %]
    [% num == string.length ? "correct" : "ups" %]

    # isvstring
    [% ScalarUtil.isvstring(vstring) ? 'is vstring' : 'is not vstring' %]

    # looks_like_number
    [% ScalarUtil.looks_like_number('Infinity') ? 'number' : 'not number' %]

    # openhandle
    [% ScalarUtil.openhandle(FH) ? "opened" : "not opened" %]

    # refaddr
    [% ScalarUtil.refaddr(EXPR) %]

    # reftype
    [% ScalarUtil.reftype(EXPR) %]

    # tainted
    [% ScalarUtil.tainted(EXPR) %]

=head1 DESCRIPTION

Use L<Scalar::Util> functions in your templates.

=method blessed

    [%
        IF ScalarUtil.blessed(EXPR);
            EXPR.method(args);
        END;
    %]

Returns the name of the package if C<EXPR> is a blessed reference.

=method dualvar

    [% SET dv = ScalarUtil.dualvar( num, string ) %]

Returns a scalar that has the value C<num> in a numeric context and the value
C<string> in a string context.

=method isvstring

    [%
        USE vstring = format('%vd');
        USE string = format('%s');

        IF ScalarUtil.isvstring(EXPR);
            vstring(EXPR);
        ELSE;
            string(EXPR);
        END;
    %]

Returns true if C<EXPR> was coded as vstring;

=method looks_like_number

    [% IF ScalarUtil.looks_like_number(EXPR) %]
        [% EXPR %] looks like number
    [% END %]

Returns true if perl thinks C<EXPR> is a number.

=method openhandle

    [% IF ScalarUtil.openhandle(FH) %]
        FH is an opened filehandle
    [% END %]

Returns C<FH> if it is opened filehandle, C<undef> otherwise.

=method refaddr

    [% ScalarUtil.refaddr(EXPR) %]

Returns internal memory address of the C<EXPR> if it is a reference, C<undef>
otherwise.

=method reftype

    [% SWITCH ScalarUtil.reftype(EXPR) %]
        [% CASE 'ARRAY' %]
            [% EXPR.size %]
        [% CASE 'HASH' %]
            [% EXPR.list.size %]
    [% END %]

Returns the type of the C<EXPR> if it is a reference, C<undef> otherwise.

=method tainted

    [% IF ScalarUtil.tainted(EXPR) %]
        EXPR is tainted
    [% END %]

Returns true if C<EXPR> is tainted.

=head1 NOTES

Please note that following methods were B<NOT> implemented due to the nature
of TT's stash.

=over 4

=item * isweak

=item * readonly

=item * set_prototype

=item * weaken

=back

=head1 SEE ALSO

L<Scalar::Util>

=cut

{
    no strict 'refs';

    do {
        my $func = $_;

        my $call = Scalar::Util->can($func)
            or die "$func not exported by Scalar::Util";

        *{__PACKAGE__ ."::$func"} = sub {
            shift @_;

            $call->(@_);
        }
    } for qw(
        blessed dualvar reftype tainted
        openhandle refaddr isvstring looks_like_number
    );

};

1;
