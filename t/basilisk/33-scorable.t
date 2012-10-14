use Test::More;
use warnings; use strict;

use Basilisk::Rulemap;
{
   # plane, 5x3.
   my $rulemap = Basilisk::Rulemap::Rect->new(
      h=>2, w=>5,
   );
   my $board = [
      [qw/0 w 0 b b/],
      [qw/0 w w b 0/],
   ];
   my $state_to_score = Basilisk::State->new(
      rulemap  => $rulemap,
      turn => 'b',
      board => $board,
   );
   my $scorable = $state_to_score->scorable;
   isa_ok($scorable, 'Basilisk::Scorable', 'we have a scorable!');
   ok($scorable->state == $state_to_score,
      'state is preserved as basis for scorable..');
   is( $scorable->dead('b')->count, 0, 'empty b dead nodeset initially');
   is( $scorable->dead('w')->count, 0, 'empty b dead nodeset initially');
   is( $scorable->territory('b')->count, 1, '1 b terr nodeset initially');
   is( $scorable->territory('w')->count, 2, '2 b terr nodeset initially');
   # toggle the rightmost b stone's life/death status.
   #$scorable->transanimate([0,4]);
}

done_testing;
