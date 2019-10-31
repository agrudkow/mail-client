package ShowEmail;

use strict;
use warnings;

sub display_show_email {
  my $show_email_screen_frame = $_[0];
  my $email_smtp = $_[1];
  my $handle_exit = $_[2];
  my $main_font = $_[3];
  my $main_font_bold = $_[4];
  my $emails = $_[5];
  my $id = $_[6];

  my $sender = $emails->[$id]{from};
  my $subject = $emails->[$id]{subject};
  my $body = $emails->[$id]{body};



  my $from_frame = $show_email_screen_frame->Frame(-background => "lightgrey")
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
    -textvariable => \$sender,
    -state => 'disabled',
    -disabledforeground => 'black'
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );

  my $to_frame = $show_email_screen_frame->Frame(-background => "lightgrey")
    ->pack(-fill => 'x', -side => 'top');

  $to_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "To:",
    -font => $main_font_bold,
    -width => 12,
    -anchor => 'w'
  )->pack(-side => 'left');

  $to_frame->Entry(
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
  $to_frame = $show_email_screen_frame->Frame(-background => "lightgrey")
    ->pack(-fill => 'x', -side => 'top');

  $to_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Subject:",
    -font => $main_font_bold,
    -width => 12,
    -anchor => 'w'
  )->pack(-side => 'left');

  $to_frame->Entry(
    -background => 'grey',
    -foreground => 'black',
    -font => $main_font,
        -textvariable => \$subject,
    -state => 'disabled',
    -disabledforeground => 'black'
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );

  # empty line
  EmptyLine::display_empty_line($show_email_screen_frame);

  $show_email_screen_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Text:",
    -font => $main_font_bold,
    -anchor => 'w'
  )->pack(-side => 'top', -fill => 'x');

  my $text_box = $show_email_screen_frame->Text(
    -background => "lightgrey",
    -foreground => 'black',
    -font => $main_font,
  )->pack(-side => 'top', -fill => 'x');

  $text_box->insert('end', $body);

  my $cancel_button = $show_email_screen_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Cancel",
    -font => $main_font_bold,
    -command => sub {$handle_exit->()}
  )->pack(-padx => 5, -side => "right");
}

1;
