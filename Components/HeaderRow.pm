package HeaderRow;

use strict;
use warnings;

sub display_header_row {
  my $parent = $_[0];
  my $main_font = $_[1];
  my $main_font_bold = $_[2];
  my $mw = $_[3];

  my $fullwidth = $mw->reqwidth;
  my $subject_width = $fullwidth / 2 * 0.25;

  my $row
    = $parent->Frame(-background => "lightgrey", -borderwidth => 1)->pack(
    -fill => 'x',
    -side => 'top',
    -ipady => 5
    );

  my $one = $row->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => 'From',
    -font => $main_font_bold,
    -width => 20,
    -anchor => 'w'
  )->pack(-side => 'left', -fill => 'x');

  my $two = $row->Label(
    -background => "lightgrey",
    -foreground => 'black',
    -text => 'Subject',
    -font => $main_font_bold,
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
    -text => 'Date',
    -font => $main_font_bold,
    -width => 27,
    -anchor => 'w'
  )->pack(-side => 'left', -fill => 'x');
}

1;
