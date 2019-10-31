package SendEmail;

use strict;
use warnings;

sub display_send_email {
  my $send_email_screen_frame = $_[0];

  my $smtp = $_[1];

  my $handle_send = $_[2];
  my $handle_cancel = $_[3];
  my $main_font = $_[4];
  my $main_font_bold = $_[5];

  my $email_smtp = $smtp->{email};

  my $send_to;
  my $subject;
  my $body;

  my $from_frame = $send_email_screen_frame->Frame(-background => "lightgrey")
    ->pack(-fill => 'x', -side => 'top');

  $from_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "From:",
    -font => $main_font_bold,
    -width => 12,
    -anchor => 'w'
  )->pack(-side => 'left');

  $from_frame->Entry(
    -background => 'grey',
    -foreground => 'black',
    -font => $main_font,
    -textvariable => \$email_smtp,
    -state => 'disabled',
    -disabledforeground => 'black'
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );

  my $to_frame = $send_email_screen_frame->Frame(-background => "lightgrey")
    ->pack(-fill => 'x', -side => 'top');

  $to_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "To:",
    -font => $main_font_bold,
    -width => 12,
    -anchor => 'w'
  )->pack(-side => 'left');

  $send_to = $to_frame->Entry(
    -background => 'grey',
    -foreground => 'black',
    -font => $main_font,
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );
  $to_frame = $send_email_screen_frame->Frame(-background => "lightgrey")
    ->pack(-fill => 'x', -side => 'top');

  $to_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Subject:",
    -font => $main_font_bold,
    -width => 12,
    -anchor => 'w'
  )->pack(-side => 'left');

  $subject = $to_frame->Entry(
    -background => 'grey',
    -foreground => 'black',
    -font => $main_font,
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );

  # empty line
  EmptyLine::display_empty_line($send_email_screen_frame);

  $send_email_screen_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Text:",
    -font => $main_font_bold,
    -anchor => 'w'
  )->pack(-side => 'top', -fill => 'x');

  $body = $send_email_screen_frame->Text(
    -background => "lightgrey",
    -foreground => 'black',
    -font => $main_font_bold,
  )->pack(-side => 'top', -fill => 'x');

  # $body->insert('end', "To be or not to be...\nThat is the question");

  my $send_button = $send_email_screen_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Send",
    -font => $main_font_bold,
    -command => sub {
      $handle_send->($send_to->get(), $subject->get(),
        $body->get('1.0', 'end-1c'));
    }
  )->pack(-padx => 5, -side => "right");

  my $cancel_button = $send_email_screen_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Cancel",
    -font => $main_font_bold,
    -command => sub {$handle_cancel->()}
  )->pack(-padx => 5, -side => "left");

  return ($send_to, $subject, $body);
}

1;
