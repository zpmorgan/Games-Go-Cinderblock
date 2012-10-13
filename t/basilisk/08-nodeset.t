use strict;
use Test::More;

use Basilisk::Rulemap;
#use Basilisk::Rulemap::Rect;
# use Test::Exception;
#
# First do delta from a single simple move
{
   my $tor_rm = Basilisk::Rulemap::Rect->new(
      w=>4,      h=>5,
      wrap_v => 1, wrap_h => 1,
   );
   my @nodes = $tor_rm->all_nodes;
   my $nodeset_1 = $tor_rm->nodeset(@nodes[-5..-2]);
   my $nodeset_1_same = $tor_rm->nodeset(reverse(@nodes[-5..-2]));
   my $nodeset_2 = $tor_rm->nodeset(@nodes[-4..-1]);
   cmp_ok ($nodeset_1, '==', $nodeset_1_same, 'nodeset init order mattersn\'t');
   cmp_ok ($nodeset_1_same, '==', $nodeset_1, 'nodeset init order mattersn\'t');

   cmp_ok ($nodeset_1_same, '!=', $nodeset_2, 'nodeset init with different nodes !=');
   cmp_ok ($nodeset_2, '!=', $nodeset_1, 'nodeset init with different nodes !=');
}
done_testing;
