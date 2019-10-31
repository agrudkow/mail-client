package ReplyToEmail;

use strict;
use warnings;

sub display_reply_to_email {
  my $reply_to_email_screen_frame = $_[0];

  my $smtp = $_[1];

  my $handle_reply_to = $_[2];
  my $handle_cancel = $_[3];
  my $main_font = $_[4];
  my $main_font_bold = $_[5];
  my $id = $_[6];

  my $email_smtp = $smtp->{email};

  my $body;

  # empty line
  EmptyLine::display_empty_line($reply_to_email_screen_frame);

  $reply_to_email_screen_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Reply message:",
    -font => $main_font_bold,
    -anchor => 'w'
  )->pack(-side => 'top', -fill => 'x');

  $body = $reply_to_email_screen_frame->Text(
    -background => "lightgrey",
    -foreground => 'black',
    -font => $main_font,
  )->pack(-side => 'top', -fill => 'x');

  my $send_button = $reply_to_email_screen_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Reply",
    -font => $main_font_bold,
    -command => sub {
      $handle_reply_to->($id, $body->get('1.0', 'end-1c'));
    }
  )->pack(-padx => 5, -side => "right");

  my $cancel_button = $reply_to_email_screen_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Cancel",
    -font => $main_font_bold,
    -command => sub {$handle_cancel->()}
  )->pack(-padx => 5, -side => "left");

  return ($body);
}

1;
