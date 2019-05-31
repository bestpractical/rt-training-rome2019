use strict;
use warnings;
package RT::Training::Rome2019;

our $VERSION = '0.02';

=head1 NAME

RT-Training-Rome2019 - [One line description of module's purpose here]

=head1 DESCRIPTION

[Why would someone install this extension? What does it do? What problem
does it solve?]

=head1 RT VERSION

Works with RT [What versions of RT is this known to work with?]

[Make sure to use requires_rt and rt_too_new in Makefile.PL]

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Training::Rome2019');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 TOPICS

* X custom fields via email

* X REST API

* external custom fields

* X send all transactions in template

* suppress some emails, create custom condition based on custom role

* images in signatures, support HTML sigs with link to img

* X override subject tag parsing

* show more headers based on subject in transaction listing

* script to find users with no tickets

* new ticket from cc

* pull CF value from another ticket

* modify CF based on subject

=head1 MAYBE

* custom values for DNS

* RTIR remove lookup or move to end of line

* show custom fields by default in query builder

=head1 EXTRA

* custom fields grouping error

* unmerge

* docker / automation

=head1 Sending multiple transactions in a reply

    {my $transactions = $Ticket->Transactions;
    while( my $transaction = $transactions->Next ){
        next unless $transaction->Type eq 'Create' or $transaction->Type eq 'Comment';
        $OUT .= $transaction->Content(Type => "text/html");
    }
    }

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=for html <p>All bugs should be reported via email to <a
href="mailto:bug-RT-Training-Rome2019@rt.cpan.org">bug-RT-Training-Rome2019@rt.cpan.org</a>
or via the web at <a
href="http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Training-Rome2019">rt.cpan.org</a>.</p>

=for text
    All bugs should be reported via email to
        bug-RT-Training-Rome2019@rt.cpan.org
    or via the web at
        http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Training-Rome2019

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2019 by Best Practical Solutions, LLC

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
