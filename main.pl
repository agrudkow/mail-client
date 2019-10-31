#!/usr/bin/perl -w  
use Tk;
use strict;
use warnings;
use Tk::Table;
use Tk::DialogBox;
use Tk::Font;
use Mail::POP3Client;
use MIME::Parser;
use Email::MIME;
use IO::Handle;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTPS ();
use Email::Simple ();
use Email::Simple::Creator ();

use feature 'switch';
use feature 'say';
use feature 'state';
use Encode qw(decode encode);

use v5.22.1;

use Components::InputForm;
use Components::EmailListScreen;
use Components::EmptyLine;
use Components::SendEmail;

my $screen;
my $state = 0;
my $login_screen;
my $email_list_screen_frame;
my $send_email_screen_frame;

our $pop3;
our $host_pop3;
our $username_pop3;
our $password_pop3;
our $port_pop3 = 995;

# our $smtp;
our $host_smtp;
our $email_smtp;
our $username_smtp;
our $password_smtp;
our $port_smtp = 587;

# emails array
our @emails;
our $emails_ref = \@emails;

my $main_font;
my $main_font_bold;
my $header_font;

# Take top and the bottom - now implicit top is in the middle
my $mw = MainWindow->new;
$mw->geometry("1200x800");
$mw->title("Mail Client");
$mw->configure(-background => "lightgrey");

# Create fonts
$main_font = $mw->fontCreate(-family => 'courier', -size => 12);
$main_font_bold
  = $mw->fontCreate(-family => 'courier', -size => 12, -weight => 'bold');
$header_font = $mw->fontCreate(-family => 'courier', -size => 22);

# Initial screen
show_login_screen();

# show_send_email_screen();

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
      $send_email_screen_frame && $send_email_screen_frame->packForget();
      show_main_list_screen();
    }
    when (3) {
      $email_list_screen_frame && $email_list_screen_frame->packForget();
      show_send_email_screen();
    }
    default {
    }
  }

  $prev_state = $state;
  $state = $_[0];
  say $state;
}

sub show_send_email_screen {
  my %smtp = (
    host => $host_smtp,
    username => $username_smtp,
    password => $password_smtp,
    port => $port_smtp,
    email => $email_smtp
  );

  $send_email_screen_frame = $mw->Frame(-background => "lightgrey")->pack(
    -ipadx => 600,
    -ipady => 400,
  );

  my ($reciever, $subject, $body)
    = SendEmail::display_send_email($send_email_screen_frame, \%smtp,
    \&handle_send, \&handle_cancel, $main_font, $main_font_bold);

}

sub show_main_list_screen {
  $email_list_screen_frame = $mw->Frame(-background => "lightgrey")->pack(
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
    $mw, $email_list_screen_frame,
    \%pop3, \%smtp,
    $main_font, $main_font_bold,
    \&handle_delete, \&handle_reply_to,
    \&handle_click, \&handle_edit_pop3,
    \&handle_edit_smtp, \&handle_show_send_screen,
    \&handle_reload, \&handle_log_out,
    \@emails
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
    = InputForm::display_form(
    $mw, $login_screen,
    $main_font, $main_font_bold,
    'mion.elka.pw.edu.pl', 'agrudkow',
    '5Wf<7bJ', $port_pop3,
    ''
    );

  #display submit button
  my $log_in
    = $login_screen->Frame(-background => "lightgrey")->pack(-ipady => 10);
  $log_in->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Login",
    -font => $main_font_bold,
    -command => sub {
      log_in(
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

sub log_in {
  my $host = $_[0];
  my $username = $_[1];
  my $password = $_[2];
  my $port = $_[3];

  $main::host_pop3 = $host;
  $main::username_pop3 = $username;
  $main::password_pop3 = $password;
  $main::port_pop3 = $port;

  $main::host_smtp = $host;
  $main::username_smtp = $username;
  $main::email_smtp = $username . '@' . $host_smtp;
  $main::password_smtp = $password;


  $main::pop3 = new Mail::POP3Client(
    USER => $main::username_pop3,
    PASSWORD => $main::password_pop3,
    HOST => $main::host_pop3,
    PORT => $main::port_pop3,
    AUTH_MODE => 'PASS',
    USESSL => 1,

    # DEBUG => 1
  );

  if ($pop3->Count() ne -1) {
    fetch_emails();
    switch_screen(2);
  }
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

sub handle_edit_pop3 {
  print("Edit pop3\n");
}

sub handle_edit_smtp {
  print("Edit smtp\n");
}

sub handle_show_send_screen {
  print("Show send screen\n");
  switch_screen(3);
}

sub handle_reload {
  print("Reload\n");
}

sub handle_log_out {
  print("Log out\n");
  $pop3->close();

  $main::host_pop3 = '';
  $main::username_pop3 = '';
  $main::password_pop3 = '';
  $main::port_pop3 = '';

  switch_screen(0);
}

sub handle_log_in {
  print("Log in\n");
}

sub handle_cancel {
  print("Cancel\n");
}

sub handle_send {
  my $send_to = $_[0];
  my $subject = $_[1];
  my $body = $_[2];

  my $smtpserver = 'mion.elka.pw.edu.pl';
  my $smtpport = 587;
  my $smtpuser = 'agrudkow';
  my $smtppassword = '5Wf<7bJ';

  my $transport = Email::Sender::Transport::SMTPS->new(
    { host => $main::host_smtp,
      port => $main::port_smtp,
      ssl => "starttls",
      sasl_username => $main::username_smtp,
      sasl_password => $main::password_smtp,
    }
  ) or die "Unable to connect to POP3 server: " . $! . "\n";

  my $email = Email::Simple->create(
    header => [
      To => $send_to,
      From => $email_smtp,
      Subject => $subject,
    ],
    body => $body,
  ) or die 'Unable to create email';

  sendmail($email, {transport => $transport});
  print("Send\n");
  switch_screen(2);
}

sub fetch_emails {
  for (my $i = $pop3->Count(); $i >= 1; $i--) {
    my $mail = $pop3->HeadAndBody($i);
    my $parser = Email::MIME->new($mail);

    my $from = encode('utf8', $parser->header('From'));
    my $date = encode('utf8', $parser->header('Date'));
    my $subject = encode('utf8', $parser->header('Subject'));
    my $body;
    $parser->walk_parts(
      sub {
        my ($part) = @_;
        return if $part->subparts;
        if ($part->content_type =~ m{text/plain}i) {
          $body = $part->body_str;
        }
      }
    );

    my %msg_data
      = (from => $from, date => $date, subject => $subject, body => $body);
    push(@emails, \%msg_data);
  }
}

