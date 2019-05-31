package RT::Interface::Email;

use strict;
use warnings;
no warnings qw(redefine);

=head3 ParseTicketId

Takes a string (the email subject) and searches for [subjecttag #id]

For customizations, the L<MIME::Entity> object is passed as the second
argument.

Returns the id if a match is found.  Otherwise returns undef.

=cut

sub ParseTicketId {
    my $Subject = shift;
    my $Entity = shift;

    RT::Logger->debug("Running our local version of Email_Local.pm");

    my $rtname = RT->Config->Get('rtname');
    my $test_name = RT->Config->Get('EmailSubjectTagRegex') || qr/\Q$rtname\E/i;

    # We use @captures and pull out the last capture value to guard against
    # someone using (...) instead of (?:...) in $EmailSubjectTagRegex.
    my $id;
    if ( my @captures = $Subject =~ /\[$test_name\s+\#(\d+)\s*\]/i ) {
        $id = $captures[-1];
    } else {
        foreach my $tag ( RT->System->SubjectTag ) {
            next unless my @captures = $Subject =~ /\[\Q$tag\E\s+\#(\d+)\s*\]/i;
            $id = $captures[-1];
            last;
        }
    }
    return undef unless $id;

    my $Cc = GetCcAddress($Entity);
    RT::Logger->debug("got a CC address: $Cc");

    my $queue = RT::Queue->new(RT->SystemUser);
    $queue->LoadByCols( CorrespondAddress => "$Cc" );

    my $ticket = RT::Ticket->new(RT->SystemUser);
    my ($ret, $msg) = $ticket->Load($id);
    RT::Logger->error("Unable to load ticket $id: $msg") unless $ret;

    if ( $queue and $queue->Id
         and $ticket->QueueObj->Name ne $queue->Name ){
             return undef;
    }
    else {
        $RT::Logger->debug("Found a ticket ID. It's $id");
        return $id;
    }
}

sub GetCcAddress {
    my $Entity = shift;

    my $head = $Entity->head;

    foreach my $header ( 'Cc' ) {
        my $addr_line = Encode::decode( "UTF-8", $head->get($header) ) || next;
        my ($addr) = RT::EmailParser->ParseEmailAddress( $addr_line );
        return $addr->address;
    }
}

1;
