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
   is( $scorable->dead('w')->count, 0, 'empty w dead nodeset initially');
   is( $scorable->territory('b')->count, 1, '1 b terr nodeset initially');
   is( $scorable->territory('w')->count, 2, '2 b terr nodeset initially');
   is( $scorable->dame->count, 1, '1 dame initially');

   # toggle the rightmost b stone's life/death status.
   my $succeeded1 = $scorable->transanimate([0,4]);
   is($succeeded1, 1, 'transanimation succeeded');
   is( $scorable->dead('b')->count, 3, '3 b dead after transanimation');
   is( $scorable->dead('w')->count, 0, 'b transanimated. w unscathed.');
   is( $scorable->territory('b')->count, 0, '0 b terr. Gone from board.');
   is( $scorable->territory('w')->count, 7, '7 w terr nodeset now.');
   is( $scorable->dame->count, 0, 'no dame now; all white\'s.');

   my $succeeded2= $scorable->deanimate([1,2]);
   is($succeeded2, 0, 'deanimation failed, donflict with known terr');

   my $succeeded3 = $scorable->reanimate([1,3]);
   is($succeeded3, 1, 'reanimation succeeded');
   is( $scorable->dead('b')->count, 0, '0 b dead after transanimation');
   is( $scorable->dead('w')->count, 0, 'b reanimated. w still unscathed.');
   is( $scorable->territory('b')->count, 1, '1 b terr; b resurrected.');
   is( $scorable->territory('w')->count, 2, '2 w terr nodeset now.');
   is( $scorable->dame->count, 1, '1 dame again');

   my $succeeded4= $scorable->deanimate([1,2]); #kill w
   is($succeeded4, 1, 'deanimation w now no fail');
   is( $scorable->dame->count, 0, '0 dame. all b\'s');
   is( $scorable->territory('b')->count, 7, '7 b terr, white dead..');
   is( $scorable->territory('w')->count, 0, '0 w terr, white dead..');

   my $succeeded5= $scorable->transanimate([1,3]);
   is($succeeded5, 0, 'transanimate to kill other group fails.');

   my $succeeded6= $scorable->transanimate([1,2]);
   is($succeeded6, 1, 'transanimate to revive. succeeds..');
}

done_testing;
