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

my $screen;
my $state = 0;
my $login_screen;
my $email_list_screen;

my $host_pop3;
my $username_pop3;
my $password_pop3;
my $port_pop3;

my $host_smtp;
my $username_smtp;
my $password_smtp;
my $port_smtp;

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

# $mw->Button(-text => "Switch screen", -command => sub {switch_screen(0)})
#   ->pack(-ipadx => 40, -side => "bottom");

MainLoop;

sub switch_screen {
  state $prev_state = 1;

  given ($_[0]) {
    when (0) {
      $email_list_screen && $email_list_screen->packForget();
      show_login_screen();
    }
    when (1) {$login_screen && $login_screen->packForget();}
    when (2) {
      $login_screen && $login_screen->packForget();
      show_email_list_screen();
    }
    when (3) {$email_list_screen && $email_list_screen->packForget();}
    default {
    }
  }

  $prev_state = $state;
  $state = $_[0];
  say $state;
}

sub show_email_list_screen {
  $email_list_screen = $mw->Frame(-background => "grey")->pack(
    -ipadx => 600,
    -ipady => 400,
  );

  my $host = 'elka.pw.edu.pl';
  my $username = 'agrudkow';

  # pop3 config
  my $top_bar_pop3
    = $email_list_screen->Frame(-background => "lightgrey")->pack(
    -fill => 'x',
    -side => 'top',
    );

  my $info_host_pop3 = $top_bar_pop3->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "POP3   host: $host",
    -font => $main_font_bold
  )->pack(-side => 'left', -anchor => 'n');

  my $info_username_pop3 = $top_bar_pop3->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "username: $username",
    -font => $main_font_bold
  )->pack(-padx => 40, -side => 'left', -anchor => 'n');

  my $edit_pop3_config_button = $top_bar_pop3->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Edit POP3 configuration",
    -font => $main_font_bold,
    -command => sub {say 'Edit POP3 configuration';}
  )->pack(-side => "right");

  # smtp config
  my $top_bar_smtp
    = $email_list_screen->Frame(-background => "lightgrey")->pack(
    -fill => 'x',
    -side => 'top',
    );

  my $info_host_smtp = $top_bar_smtp->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "SMTP   host: $host",
    -font => $main_font_bold
  )->pack(-side => 'left', -anchor => 'n');

  my $info_username_smtp = $top_bar_smtp->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "username: $username",
    -font => $main_font_bold
  )->pack(-padx => 40, -side => 'left', -anchor => 'n');

  my $edit_smtp_config_button = $top_bar_smtp->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Edit SMTP configuration",
    -font => $main_font_bold,
    -command => sub {say 'Edit SMTP configuration';}
  )->pack(-side => "right");

  # empty line
  EmptyLine::display_empty_line($email_list_screen);

  # butons frame
  my $buttons_frame
    = $email_list_screen->Frame(-background => "lightgrey")->pack(
    -fill => 'x',
    -side => 'top',
    );

  my $send_email_button = $buttons_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Send email",
    -font => $main_font_bold,
    -command => sub {say 'Send email';}
  )->pack(-side => "left");

  my $log_out_button = $buttons_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Log out",
    -font => $main_font_bold,
    -command => sub {switch_screen(0);}
  )->pack(-padx => 20, -side => "left");

  my $refresh_button = $buttons_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Refresh",
    -font => $main_font_bold,
    -command => sub {say 'Refresh';}
  )->pack(-side => "right");

  # empty line
  EmptyLine::display_empty_line($email_list_screen, 10);

  # email list
  my $email_list_frame
    = $email_list_screen->Frame(-background => "lightgrey")->pack(
    -fill => 'both',
    -side => 'top',
    );

  HeaderRow::display_header_row($email_list_frame, $main_font, $main_font_bold, $mw);

  EmailList::display_email_list($mw, $email_list_frame, $main_font,
    $main_font_bold, \&handle_delete, \&handle_reply_to);
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

