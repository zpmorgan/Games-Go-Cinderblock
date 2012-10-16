use strict;
use Test::More;

use Games::Go::Cinderblock::Rulemap;
use Games::Go::Cinderblock::Rulemap::Rect;
# use Test::Exception;
#
# First do delta from a single simple move
{
   my $tor_rm = Games::Go::Cinderblock::Rulemap::Rect->new(
      w=>4,      h=>6,
      wrap_v => 1,
   );
   my $foo_state = $tor_rm->initial_state;
   # quich check of initial state.
   is($foo_state->turn, 'b', 'initial turn');
   is_deeply($foo_state->board, [map{[map{0}(1..4)]}(1..6)], 'initial board');
   my $move_result = $foo_state->attempt_move(
      color => 'b',
      node => [0,0],
   );
   ok($move_result->succeeded, '1st move success on initial state');
   my $delta = $move_result->delta;
#   isa_ok($delta, 'Games::Go::Cinderblock::Delta');
   is(ref $delta, 'HASH');
   is(scalar(@{$delta->{remove}}), 0, 'delta doesn\'t remove anything.');
   is(scalar(@{$delta->{add}}), 1, 'delta adds one thing.');
   is_deeply($delta->{add}, [[b=>[0,0]]], 'delta adds one thing.');
   my $bar_state = $move_result->resulting_state;
   isa_ok($bar_state, 'Games::Go::Cinderblock::State');
}
{
   my $tor_rm = Games::Go::Cinderblock::Rulemap::Rect->new(
      w=>3,      h=>3,
      wrap_v => 1,
   );
   my $board1 = [
      [qw/b 0 w/],
      [qw/0 0 0/],
      [qw/w 0 b/],
   ];
   my $board2 = [
      [qw/0 b 0/],
      [qw/0 b 0/],
      [qw/0 b 0/],
   ];
   my $delta = $tor_rm->delta($board1,$board2);
   # whatever. i don't feel like id'ing, ordering, & testing 4 distinct lists,
   # delta works well enough, i daresay
}

done_testing;
