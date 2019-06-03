package RT::Condition::OnCorrespondNotLaw;
use base 'RT::Condition';
use strict;
use warnings;

sub IsApplicable {
    my $self = shift;

    my $email_sender = $self->TransactionObj->CreatorObj->EmailAddress;

    RT::Logger->debug("The creator is: " . $email_sender);

    if ( $email_sender eq RT->Config->Get('RomeEmailSender') ){
        return 0;
    }
    else {
        return 1;
    }
}

1;
