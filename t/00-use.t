use strict;
use Test::More ;

use Basilisk::Rulemap;
use Basilisk::Rulemap::Rect;
use Basilisk::NodeSet;

my $rect_rm = Basilisk::Rulemap::Rect->new(
   w=>4,
   h=>4,
);
isa_ok($rect_rm, 'Basilisk::Rulemap', 'rect_rm is.');


my $board = [
   [qw/0 w b 0/],
   [qw/w w b b/],
   [qw/w w b 0/],
   [qw/0 w b 0/],
];
my $foo_state = Basilisk::State->new(
   board => $board,
   turn => 'b',
   rulemap => $rect_rm,
);
isa_ok($foo_state, 'Basilisk::State');


done_testing;
