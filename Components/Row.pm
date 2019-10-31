package Row;

use strict;
use warnings;

use feature 'say';

sub display_row {
  my $parent = $_[0];
  my $from = $_[1];
  my $subject = $_[2];
  my $date = $_[3];
  my $handle_reply_to = $_[4];
  my $handle_delete = $_[5];
  my $main_font = $_[6];
  my $main_font_bold = $_[7];
  my $mw = $_[8];
  my $id = $_[9];
  my $handle_click = $_[10];

  my $fullwidth = $mw->reqwidth;
  my $subject_width = $fullwidth / 2 * 0.25;

  my $row = $parent->Frame(
    -background => "lightgrey",
    -relief => 'groove',
    -borderwidth => 1
  )->pack(
    -fill => 'x',
    -side => 'top',
    -ipady => 5
  );

  my $one = $row->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => $from,
    -font => $main_font,
    -width => 20,
    -anchor => 'w'
  )->pack(-side => 'left', -fill => 'x');

  my $two = $row->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => $subject,
    -font => $main_font,
    -anchor => 'w',
    -width => $subject_width,
  )->pack(-side => 'left', -fill => 'x');

  my $buttons_and_date_frame = $row->Frame(-background => "lightgrey")->pack(
    -fill => 'x',
    -side => 'right',
  );

  my $three = $buttons_and_date_frame->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => $date,
    -font => $main_font,
    -width => 15,
    -anchor => 'w'
  )->pack(-side => 'left', -fill => 'x', -padx => 5);

  my $five = $buttons_and_date_frame->Button(
    -background => "red",
    -foreground => 'black',
    -text => "X",
    -font => $main_font_bold,
    -command => sub {$handle_delete->($id)}
  )->pack(-side => 'right', -fill => 'x');

  my $four = $buttons_and_date_frame->Button(
    -background => "lightgrey",
    -foreground => 'black',
    -text => "->",
    -font => $main_font_bold,
    -command => sub {$handle_reply_to->($id)}
  )->pack(-side => 'right', -fill => 'x', -padx => 5);

  $row->bind(
    '<Button-1>',
    sub {
      $handle_click->($id);
    }
  );

  $one->bind(
    '<Button-1>',
    sub {
      $handle_click->($id);
    }
  );

  $two->bind(
    '<Button-1>',
    sub {
      $handle_click->($id);
    }
  );

  $three->bind(
    '<Button-1>',
    sub {
      $handle_click->($id);
    }
  );

}

1;
