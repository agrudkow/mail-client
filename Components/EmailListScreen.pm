package EmailListScreen;

use strict;
use warnings;
use Components::EmptyLine;
use Components::EmailList;
use Components::HeaderRow;

use feature 'say';

sub display_email_list_screen {
  my $mw = $_[0];
  my $email_list_screen = $_[1];

  my $pop3 = $_[2];
  my $smtp = $_[3];

  my $main_font = $_[4];
  my $main_font_bold = $_[5];
  my $handle_delete = $_[6];
  my $handle_reply_to = $_[7];
  my $handle_click = $_[8];
  my $handle_edit_pop3 = $_[9];
  my $handle_edit_smtp = $_[10];
  my $handle_send = $_[11];
  my $handle_reload = $_[12];
  my $handle_log_out = $_[13];
  my $emails = $_[14];

  my $host_pop3 = $pop3->{host};
  my $username_pop3 = $pop3->{username};
  my $password_pop3 = $pop3->{password};
  my $port_pop3 = $pop3->{port};

  my $host_smtp = $smtp->{host};
  my $username_smtp = $smtp->{username};
  my $password_smtp = $smtp->{password};
  my $port_smtp = $smtp->{port};
  my $email_smtp = $smtp->{email};

  # pop3 config
  my $top_bar_pop3
    = $email_list_screen->Frame(-background => "lightgrey")->pack(
    -fill => 'x',
    -side => 'top',
    );

  my $info_host_pop3 = $top_bar_pop3->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "POP3   host: $host_pop3",
    -font => $main_font_bold,
    -width => 33,
    -anchor => 'w'
  )->pack(-side => 'left', -anchor => 'n');

  my $info_username_pop3 = $top_bar_pop3->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "username: $username_pop3",
    -font => $main_font_bold,
    -width => 40,
    -anchor => 'w'
  )->pack(-padx => 40, -side => 'left', -anchor => 'n');

  my $edit_pop3_config_button = $top_bar_pop3->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Edit POP3 configuration",
    -font => $main_font_bold,
    -command => sub {$handle_edit_pop3->()}
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
    -text => "SMTP   host: $host_smtp",
    -font => $main_font_bold,
    -width => 33,
    -anchor => 'w'
  )->pack(-side => 'left', -anchor => 'n');

  my $info_username_smtp = $top_bar_smtp->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "email: $email_smtp",
    -font => $main_font_bold,
    -width => 40,
    -anchor => 'w'
  )->pack(-padx => 40, -side => 'left', -anchor => 'n');

  my $edit_smtp_config_button = $top_bar_smtp->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Edit SMTP configuration",
    -font => $main_font_bold,
    -command => sub {$handle_edit_smtp->()}
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
    -command => sub {$handle_send->()}
  )->pack(-side => "left");

  my $log_out_button = $buttons_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Log out",
    -font => $main_font_bold,
    -command => sub {$handle_log_out->()}
  )->pack(-padx => 20, -side => "left");

  my $refresh_button = $buttons_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "Refresh",
    -font => $main_font_bold,
    -command => sub {$handle_reload->()}
  )->pack(-side => "right");

  # empty line
  EmptyLine::display_empty_line($email_list_screen, 10);

  # email list
  my $email_list_frame
    = $email_list_screen->Frame(-background => "lightgrey")->pack(
    -fill => 'both',
    -side => 'top',
    );
    
  HeaderRow::display_header_row($email_list_frame, $main_font,
    $main_font_bold, $mw);

  EmailList::display_email_list($mw, $email_list_frame, $main_font,
    $main_font_bold, $handle_delete, $handle_reply_to, $handle_click, $emails);
}

1;
