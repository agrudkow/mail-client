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
  my $handle_click = $_[6];
  my $emails = $_[7];

  my $fullheight = $mw->screenheight;

  my $email_list = $parent->Scrolled(
    "Pane",
    Name => 'email_list',
    -height => $fullheight,
    -scrollbars => 'oe',
    -sticky => 'nwse',
    -gridded => 'y',
    -background => "lightgrey"
  );

  $email_list->Frame(-background => "lightgrey");

  $email_list->pack(
    -fill => 'both',
    -side => 'top',
  );

  for (my $i = $main::pop3->Count(); $i >= 1; $i--) {
    my $from = $emails->[$i - 1]{from};
    $from =~ s/<.*>//;
    my $date = $emails->[$i - 1]{date};
    $date =~ s/.*,.//;
    $date =~ s/.[-|+].*//;
    Row::display_row(
      $email_list,
      $from,
      $emails->[$i - 1]{subject},
      $date,
      $handle_reply_to,
      $handle_delete,
      $main_font,
      $main_font_bold,
      $mw,
      ($i - 1),
      $handle_click
    );
  }
}

1;

