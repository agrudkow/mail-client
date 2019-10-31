package EmailList;

use strict;
use warnings;
use Tk;
use Tk::Pane;
use Components::Row;

use feature 'say';

sub display_email_list {
  my $mw = $_[0];
  my $parent = $_[1];
  my $main_font = $_[2];
  my $main_font_bold = $_[3];
  my $handle_delete = $_[4];
  my $handle_reply_to = $_[5];

  my $fullheight = $mw->screenheight;

  my $email_list = $parent->Scrolled(
    "Pane",
    Name => 'email_list',
    -height => $fullheight,
    -scrollbars => 'oe',
    -sticky => 'nwse',
    -gridded => 'y'
  );

  $email_list->Frame(-background => "lightgrey");

  $email_list->pack(
    -fill => 'both',
    -side => 'top',
  );

  for my $i (1 .. 25) {
    Row::display_row(
      $email_list,
      'Artur',
      'Subjexct csocodscsdsssssssssssssss  ssssssss ddddddddddddddd dddddddddddddddddd dddddddddd',
      '10.10.2010',
      $handle_reply_to,
      $handle_delete,
      $main_font,
      $main_font_bold,
      $mw,
      $i
    );
  }

}

1;

