#!/usr/bin/perl
use strict;
use warnings;
use Tk;
use Tk::Table;
my $cols = 5;
my $rows = 20;
my %slct;

# ------------------------------------------------------------------------

sub show_cells {
  print "Selected Cells: ";
  foreach (sort {$a <=> $b} (keys %slct)) {
    printf "%d,%d ", split(/\./, $_);
  }
  print "\n";
}

# ------------------------------------------------------------------------

sub toggle_slct {
  my ($w, $t) = @_;
  my ($row, $col) = $t->Posn($w);
  my $k = sprintf "%d.%02d", $row, $col;
  if ($slct{$k}) {
    $w->configure(-background => 'white');
    print "Row: $row Col: $col unselected\n";
    delete($slct{$k});
  } else {
    $w->configure(-background => 'grey');
    print "Row: $row Col: $col selected\n";
    $slct{$k} = 1;
  }
}

# ------------------------------------------------------------------------

#
# create the main window and frame
#
my $mw = new MainWindow();
$mw->geometry("1200x800");
$mw->title("Mail Client");
my $tableFrame = $mw->Frame(
  -borderwidth => 2,
  -relief => 'raised'
)->pack;
#
# allocate a table to the frame
#
my $table = $tableFrame->Table(
  -columns => 8,
  -rows => 10,
  -fixedrows => 1,
  -scrollbars => 'e',
  -relief => 'raised'
);
#
# column headings
#

my $header_from = $table->Label(
  -text => 'From',
  -width => 20,
  -relief => 'raised'
);

$table->put(0, 1, $header_from);

my $header_subject = $table->Label(
  -text => 'Subject',
  -width => 100,
  -relief => 'raised'
);

$table->put(0, 2, $header_subject);

my $header_date = $table->Label(
  -text => 'Date',
  -width => 20,
  -relief => 'raised'
);

$table->put(0, 3, $header_date);

my $header_reply_to = $table->Label(
  -text => 'Reply to',
  -width => 10,
  -relief => 'raised'
);

$table->put(0, 4, $header_reply_to);

my $header_delete = $table->Label(
  -text => 'Delete',
  -width => 10,
  -relief => 'raised'
);

$table->put(0, 5, $header_delete);
#
# populate the cells and bind an action to each one
#
foreach my $r (1 .. $rows) {
  foreach my $c (1 .. $cols) {
    my $data = $r . "," . $c;
    my $tmp = $table->Label(
      -text => $data,
      -padx => 2,
      -anchor => 'w',
      -background => 'white',
      -foreground => 'black',
      -relief => 'groove'
    );
    # $tmp->bind('<Button>', [\&toggle_slct, $table]);
    $table->put($r, $c, $tmp);
  }
}

  my $tmp = $table->Label(
      -text => 'asdfsadfsdfasdfadfasfasfdasdf',
      -padx => 2,
      -anchor => 'w',
      -background => 'white',
      -foreground => 'black',
      -relief => 'groove'
    );

$table->put(1, 1, $tmp);
$table->pack(-expand => 'yes', -fill => 'both');

MainLoop();
