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
use Components::ShowEmail;

my $screen;
my $state = 0;
my $login_screen;
my $edit_pop3_screen;
my $edit_smtp_screen;
my $email_list_screen_frame;
my $send_email_screen_frame;
my $show_email_screen_frame;

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
  my $id = $_[1];

  $login_screen && $login_screen->packForget();
  $edit_pop3_screen && $edit_pop3_screen->packForget();
  $edit_smtp_screen && $edit_smtp_screen->packForget();
  $send_email_screen_frame && $send_email_screen_frame->packForget();
  $show_email_screen_frame && $show_email_screen_frame->packForget();
  $email_list_screen_frame && $email_list_screen_frame->packForget();

  given ($_[0]) {
    when (0) {
      show_login_screen();
    }
    when (1) {
      show_edit_smtp();
    }
    when (2) {
      show_main_list_screen();
    }
    when (3) {
      show_send_email_screen();
    }
    when (4) {
      show_edit_pop3();
    }
    when (5) {
      show_email_screen($id);
    }
    default {
    }
  }

  $state = $_[0];
}

sub show_edit_smtp {
  $edit_smtp_screen = $mw->Frame(-background => "lightgrey")->pack(
    -ipadx => 20,
    -ipady => 20,
    -anchor => "center",
    -expand => 1
  );

  my $header = $edit_smtp_screen->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => 'Edit your SMTP configuration',
    -font => $header_font
  )->pack(-pady => 40, -fill => 'both', -side => 'top');

  #display input form
  my ($host_input, $username_input, $password_input, $port_input,
    $email_input) = InputForm::display_form(
    $mw, $edit_smtp_screen, $main_font,
    $main_font_bold, $host_smtp, $username_smtp,
    $password_smtp, $port_smtp, $email_smtp
    );

  #display submit button
  my $log_in
    = $edit_smtp_screen->Frame(-background => "lightgrey")
    ->pack(-ipady => 10);
  $log_in->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Save",
    -font => $main_font_bold,
    -command => sub {
      update_smtp_config(
        $host_input->get(), $username_input->get(),
        $password_input->get(), $port_input->get(),
        $email_input->get()
      );
      switch_screen(2);
    }
  )->pack(
    -pady => 40,
    -ipadx => 50,
    -ipady => 5,
    -side => "bottom"
  );
}

sub update_smtp_config {
  my $host = $_[0];
  my $username = $_[1];
  my $password = $_[2];
  my $port = $_[3];
  my $email = $_[4];

  $main::host_smtp = $host;
  $main::username_smtp = $username;
  $main::email_smtp = $email;
  $main::password_smtp = $password;
  $main::port_smtp = $port;
}

sub show_edit_pop3 {
  $edit_pop3_screen = $mw->Frame(-background => "lightgrey")->pack(
    -ipadx => 20,
    -ipady => 20,
    -anchor => "center",
    -expand => 1
  );

  my $header = $edit_pop3_screen->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => 'Edit your POP3 configuration',
    -font => $header_font
  )->pack(-pady => 40, -fill => 'both', -side => 'top');

  #display input form
  my ($host_input, $username_input, $password_input, $port_input)
    = InputForm::display_form(
    $mw, $edit_pop3_screen, $main_font,
    $main_font_bold, $host_pop3, $username_pop3,
    $password_smtp, $port_pop3, ''
    );

  #display submit button
  my $log_in
    = $edit_pop3_screen->Frame(-background => "lightgrey")
    ->pack(-ipady => 10);
  $log_in->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Save and log in",
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

sub show_email_screen {
  my $id = $_[0];

  $show_email_screen_frame = $mw->Frame(-background => "lightgrey")->pack(
    -ipadx => 600,
    -ipady => 400,
  );

  ShowEmail::display_show_email($show_email_screen_frame, $email_smtp,
    \&handle_cancel, $main_font, $main_font_bold, \@emails, $id);

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
  $nr++;
  print("Delete: $nr\n");

  $main::pop3->Delete($nr);
  $main::pop3->close();
  undef @emails;
  log_in(
    $main::host_pop3, $main::username_pop3,
    $main::password_pop3, $main::port_pop3
  );
}

sub handle_reply_to {
  my $nr = $_[0];
  $nr++;

  print("Reply to: $nr\n");
}

sub handle_click {
  my $nr = $_[0];

  print("Show msg: $nr\n");
  switch_screen(5, $nr);
}

sub handle_edit_pop3 {
  print("Edit pop\n");
  switch_screen(4);
}

sub handle_edit_smtp {
  print("Edit smtp\n");
  switch_screen(1);
}

sub handle_show_send_screen {
  print("Show send screen\n");
  switch_screen(3);
}

sub handle_reload {
  print("Reload\n");
  $main::pop3->close();
  undef @emails;
  log_in(
    $main::host_pop3, $main::username_pop3,
    $main::password_pop3, $main::port_pop3
  );
}

sub handle_log_out {
  print("Log out\n");
  $pop3->close();
  undef @emails;

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
  switch_screen(2);
}

sub handle_send {
  my $send_to = $_[0];
  my $subject = $_[1];
  my $body = $_[2];

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
      From => $main::email_smtp,
      Subject => $subject,
    ],
    body => $body,
  ) or die 'Unable to create email';

  sendmail($email, {transport => $transport});
  print("Send\n");
  switch_screen(2);
}

sub fetch_emails {
  for (my $i = 1; $i <= $main::pop3->Count(); $i++) {
    my $mail = $main::pop3->HeadAndBody($i);
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

