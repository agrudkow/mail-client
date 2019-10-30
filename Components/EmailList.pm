package EmailList;

use strict;
use warnings;
use Tk;
use Tk::Pane;

sub display_email_list {
  my $parent = $_[0];
  my $handle_delete = $_[1];
  my $handle_reply_to = $_[2];

  my $email_list = $parent->Scrolled(
    "Pane",
    Name => 'email_list',
    -scrollbars => 'soe',
    -sticky => 'we',
    -gridded => 'y'
  );
}

1;
