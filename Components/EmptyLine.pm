package EmptyLine;

use strict;
use warnings;

sub display_empty_line {
  my $parent = $_[0];
  my $ipady = $_[1] || 20;
  my $background = $_[2] || 'lightgrey';
  
  my $refresh_button_frame
    = $parent->Frame(-background => "$background")->pack(
    -ipady => "$ipady",
    -fill => 'x',
    -side => 'top',
    );
}

1;
