package RT::Training::Rome::EmailPlugin;

use strict;
use warnings;

use Role::Basic 'with';
with 'RT::Interface::Email::Role';

sub BeforeDecode {
    my %args = @_;

    # Only run if the message is being routed to the General queue
    return 0 unless $args{Queue}->Id and $args{Queue}->Name eq 'General';

    # Special case:
    # If we have a subject line, can get a ticket id, and the ticket is in Support
    # and the CorrespondAddress for 'General' is in the Cc
    # clear the subject tag from the email Subject so a new ticket will be created.

    my $id = RT::Interface::Email::ExtractTicketId( $args{Message} );

    return 0 unless $id;

    my $ticket = RT::Ticket->new(RT->SystemUser);
    my ($ret, $msg) = $ticket->Load($id);
    RT::Logger->error("Unable to load ticket $id: $msg") unless $ret;
    RT::Logger->debug("Queue for loaded ticket is: " . $ticket->QueueObj->Name) if $ret;

    return 0 unless $ret and $ticket->QueueObj->Name eq 'Support';

    # See if the incoming email had a Cc address
    my $Cc = GetCcAddress($args{Message});
    RT::Logger->debug("got a CC address: $Cc");
    return 0 unless $Cc;

    my $queue = RT::Queue->new(RT->SystemUser);
    my ($queue_ret, $queue_msg) = $queue->LoadByCols( CorrespondAddress => "$Cc" );

    RT::Logger->debug("Loaded a queue for cc address: " . $queue->Name . " $queue_msg") if $queue_ret;
    return 0 unless $queue->Name eq 'General';

    # All conditions met, so remove subject tag from subject line
    my $subject = Encode::decode( "UTF-8", $args{Message}->head->get('Subject') || '' );
    chomp $subject;

    warn "XXX Got through, checking subject $subject";

    $subject =~ s/(.*)\[.+\s+\#\d+\s*\](.*)/$1$2/;
    $args{Message}->head->set('Subject',$subject);
    RT::Logger->debug("XXX New subject is $subject");
    return 0;
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
