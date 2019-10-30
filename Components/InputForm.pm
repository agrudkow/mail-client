package InputForm;

use strict;
use warnings;
use feature 'say';

sub display_form {
  my $mw = $_[0];
  my $login_screen = $_[1];
  my $main_font = $_[2];
  my $main_font_bold = $_[3];

  my $host_input;
  my $username_input;
  my $password_input;
  my $port_input;

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
    -font => $main_font
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
  my $default = 'agrudkow';
  $username_input = $username->Entry(
    -background => 'grey',
    -foreground => 'black',
    -textvariable => \$default,
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
    -font => $main_font
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
    -font => $main_font
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );

  return ($host_input, $username_input, $password_input, $port_input);
}

1;
