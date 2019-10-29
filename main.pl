#!/usr/bin/perl -w  
use Tk;
use strict;
use warnings;
use Tk::Table;
use Tk::DialogBox;

use feature 'switch';
use feature 'say';
use feature 'state';

use v5.22.1;

my $screen;
my $state = 0;
my $login_screen;

my $host_pop3;
my $username_pop3;
my $password_pop3;
my $port_pop3;

my $host_smtp;
my $username_smtp;
my $password_smtp;
my $port_smtp;

# Take top and the bottom - now implicit top is in the middle
my $mw = MainWindow->new;
$mw->geometry("1200x800");
$mw->title("Mail Client");
$mw->Button(-text => "Switch screen", -command => sub {switch_screen()})
  ->pack(-ipadx => 40, -side => "bottom");

MainLoop;

sub switch_screen {
  given ($state) {
    when (0) {show_login_screen();}
    when (1) {$login_screen && $login_screen->packForget();}
    default {
    }
  }

  $state = $state == 1 ? 0 : 1;
  say $state;
}

sub show_login_screen {
  my $host_input;
  my $username_input;
  my $password_input;
  my $port_input;

  $login_screen = $mw->Frame(-background => "lightgrey")->pack(
    -padx => 20,
    -pady => 20,
    -ipadx => 20,
    -ipady => 20,
    -anchor => "center",
    -expand => 1
  );

  my $host
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $host->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Host: "
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );
  $host_input = $host->Entry(-background => 'grey', -foreground => 'black')->pack(
    -ipadx => 50,
    -ipady => 5,
    -fill => "x"
  );

  my $username
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $username->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Username: "
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );
  $username_input = $username->Entry(-background => 'grey', -foreground => 'black')->pack(
    -ipadx => 50,
    -ipady => 5,
  );

  my $password
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $password->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Passowrd"
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );
  $password_input = $password->Entry(
    -background => 'grey',
    -foreground => 'black',
    -show => '*'
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );

  my $port_number
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $port_number->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Port number: "
  )->pack(
    -ipadx => 50,
    -ipady => 5,
  );
  $port_input = $port_number->Entry(-background => 'grey', -foreground => 'black')->pack(
    -ipadx => 50,
    -ipady => 5,
  );

  my $log_in
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $log_in->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Login",
    -command => sub {connect_pop3($host_input->get(), $username_input->get(), $password_input->get(), $port_input->get());}
  )->pack(
    -ipadx => 50,
    -ipady => 5,
    -side => "bottom"
  );
}

sub connect_pop3 {
  my $host = $_[0]; 
  my $username = $_[1]; 
  my $password = $_[2]; 
  my $port = $_[3]; 

  say $host;

}

