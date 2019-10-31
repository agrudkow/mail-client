package InputForm;

use strict;
use warnings;
use feature 'say';

sub display_form {
  my $mw = $_[0];
  my $login_screen = $_[1];
  my $main_font = $_[2];
  my $main_font_bold = $_[3];
  my $default_host = $_[4];
  my $default_username = $_[5];
  my $default_password = $_[6];
  my $default_port = $_[7];
  my $default_email = $_[8];

  my $host_input;
  my $username_input;
  my $password_input;
  my $port_input;
  my $email_input;

  my $host
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $host->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Host: ",
    -font => $main_font_bold
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );
  $host_input = $host->Entry(
    -background => 'grey',
    -foreground => 'black',
    -font => $main_font,
    -textvariable => \$default_host,
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );

  my $username
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $username->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Username: ",
    -font => $main_font_bold
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );
  $username_input = $username->Entry(
    -background => 'grey',
    -foreground => 'black',
    -textvariable => \$default_username,
    -font => $main_font,
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );

  my $password
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $password->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Passowrd",
    -font => $main_font_bold,
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );
  $password_input = $password->Entry(
    -background => 'grey',
    -foreground => 'black',
    -show => '*',
    -font => $main_font,
    -textvariable => \$default_password,
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );

  my $port_number
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $port_number->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Port number: ",
    -font => $main_font_bold,
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );
  $port_input = $port_number->Entry(
    -background => 'grey',
    -foreground => 'black',
    -font => $main_font,
    -textvariable => \$default_port,
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );

  my $email
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);

  if ($default_email ne '') {
    $port_number->Label(
      -background => "lightgrey",
      -foreground => 'black',
      -text => "Email: ",
      -font => $main_font_bold,
    )->pack(
      -ipadx => 50,
      -ipady => 5,
    );
    $email_input = $email->Entry(
      -background => 'grey',
      -foreground => 'black',
      -font => $main_font,
      -textvariable => \$default_email,
    )->pack(
      -ipadx => 50,
      -ipady => 5,
    );

  }

  return ($host_input, $username_input, $password_input, $port_input, $email_input);
}

1;
