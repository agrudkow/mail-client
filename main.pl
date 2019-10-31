#!/usr/bin/perl -w  
use Tk;
use strict;
use warnings;
use Tk::Table;
use Tk::DialogBox;
use Tk::Font;

use feature 'switch';
use feature 'say';
use feature 'state';

use v5.22.1;

use Components::InputForm;
use Components::EmptyLine;
use Components::EmailList;
use Components::HeaderRow;
use Components::EmailListScreen;

my $screen;
my $state = 0;
my $login_screen;
my $email_list_screen_frame;

my $host_pop3 = 'mion.elka.pw.edu.pl';
my $username_pop3 = 'agrudkow';
my $password_pop3 = '*';
my $port_pop3 = 995;

my $host_smtp = 'mion.elka.pw.edu.pl';
my $email_smtp = 'A.Grudkowski@stud.elka.pw.edu.pl';
my $username_smtp = 'agrudkow';
my $password_smtp = '*';
my $port_smtp = '587';

my $main_font;
my $main_font_bold;
my $header_font;

# Take top and the bottom - now implicit top is in the middle
my $mw = MainWindow->new;
$mw->geometry("1200x800");
$mw->title("Mail Client");
$mw->configure(-background => "lightgrey");

# Create fonts
$main_font = $mw->fontCreate(-family => 'courier', -size => 14);
$main_font_bold
  = $mw->fontCreate(-family => 'courier', -size => 14, -weight => 'bold');
$header_font = $mw->fontCreate(-family => 'courier', -size => 22);

show_login_screen();

MainLoop;

sub switch_screen {
  state $prev_state = 1;

  given ($_[0]) {
    when (0) {
      $email_list_screen_frame && $email_list_screen_frame->packForget();
      show_login_screen();
    }
    when (1) {$login_screen && $login_screen->packForget();}
    when (2) {
      $login_screen && $login_screen->packForget();
      show_main_list_screen();
    }
    when (3) {
      $email_list_screen_frame && $email_list_screen_frame->packForget();
    }
    default {
    }
  }

  $prev_state = $state;
  $state = $_[0];
  say $state;
}

sub show_main_list_screen {
  $email_list_screen_frame = $mw->Frame(-background => "grey")->pack(
    -ipadx => 600,
    -ipady => 400,
  );

  my %pop3 = (
    host => $host_pop3,
    username => $username_pop3,
    password => $password_pop3,
    port => $port_pop3
  );
  my %smtp = (
    host => $host_smtp,
    username => $username_smtp,
    password => $password_smtp,
    port => $port_smtp,
    email => $email_smtp
  );

  EmailListScreen::display_email_list_screen(
    $mw, $email_list_screen_frame, \%pop3,
    \%smtp, $main_font, $main_font_bold,
    \&handle_delete, \&handle_reply_to, \&handle_click
  );
}

sub show_login_screen {

  #define frame for screen
  $login_screen = $mw->Frame(-background => "lightgrey")->pack(
    -ipadx => 20,
    -ipady => 20,
    -anchor => "center",
    -expand => 1
  );

  my $header = $login_screen->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => 'Log in to your POP3 host',
    -font => $header_font
  )->pack(-pady => 40, -fill => 'both', -side => 'top');

  #display input form
  my ($host_input, $username_input, $password_input, $port_input)
    = InputForm::display_form($mw, $login_screen, $main_font,
    $main_font_bold);

  #display submit button
  my $log_in
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $log_in->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Login",
    -font => $main_font_bold,
    -command => sub {
      connect_pop3(
        $host_input->get(), $username_input->get(),
        $password_input->get(), $port_input->get()
      );
    }
  )->pack(
    -pady => 40,
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
  say $username;
  say $password;
  say $port;
  switch_screen(2);
}

sub handle_delete {
  my $nr = $_[0];
  print("Delete: $nr\n");
}

sub handle_reply_to {
  my $nr = $_[0];
  print("Reply to: $nr\n");
}

sub handle_click {
  my $nr = $_[0];
  print("Show msg: $nr\n");
}

