package Basilisk::Scorable;
use Moose;
# Basilisk::Scorable,
# * original Basilisk had death masks & territory masks.
# * B::Scorable should encapsulate that, 
#   & have methods to derive score from caps, deads, & territory

categories:
# Known dead vs. alives. there are no unknown unknowns when it comes to dead groups.
# here are the category a node can be in:
# stone categories:
#   alive
#   dead
#   seki? maybe the stones are alive in seki? dunno how to mark seki.
# stoneless node categories:
#   known_territory
#   derived_territory
#   dame
#   seki territory? later.

# I think that this covers all categories related to score negotiation
#  for different scoring regimes.
#   * chinese rules -- alive stones are a point each.
#   * japanese rules -- no territory in seki.

terminology:
# * animation -- the life/death state of a stone, chain, group, or any (in)?animate object
# * transanimate -- to animate or deanimate something

rules:
# empty regions are initially either dame or derived territory.
# marking a stone as dead has the effect of converting dame/derived to known
#  for the region bounded by stones of the opposite color.
# reanimating dead stones returns its adjacent empty nodes to dame.
# alive stones adjacent to known territory can not be deanimated.

storage:
# each category has a hash attribute in the scorable object.
# they are divided into colors, where each color of that cat has a B::NodeSet.
# the cats are named _alive, _dead, _known_terr, _derived_terr, _dame, maybe _seki later.
# each transanimation initiates a floodfill to discover the boundry of its the region
# bordered by the opposite color.

has rulemap => (
   isa => 'Basilisk::Rulemap',
   is => 'ro', #shouldn't change.
   required => 1,
);
has state => (
   isa => 'Basilisk::State',
   is => 'ro', #shouldn't change.
   required => 1,
);

has _alive => (
   isa => 'HashRef[Basilisk::NodeSet]',
   is => 'ro',
   lazy => 1,
   builder => '_initially_generous_with_life',
);
has _dead => (
   isa => 'HashRef[Basilisk::NodeSet]',
   is => 'ro',
   lazy => 1,
   builder => '_empty_nodesets',
);
has _known_terr => (
   isa => 'HashRef[Basilisk::NodeSet]',
   is => 'ro',
   lazy => 1,
   builder => '_empty_nodesets',
);
has _derived_terr => (
   isa => 'HashRef[Basilisk::NodeSet]',
   is => 'ro',
   lazy => 1,
   builder => '_initial_derived_terr',
);
has _dame => (
   isa => 'Basilisk::NodeSet',
   is => 'ro',
   lazy => 1,
   builder => '_initial_dame',
);

#has _seki => (); #

#based on state, has dame, derived, & alive. that is everything initially.
#this is an attribute so we can initialize these 3 categories at the same time, if needed.
has _initial_cats => (
   is => 'ro',
   isa => 'HashRef', #dame isn't color-separated; the others are.
   lazy => 1,
   builder => '_build_initial_cats',
);

#crawl entire board, putting each node into one of these 3 categories.
sub _build_initial_cats{
   my $self = shift;

   my $remaining_nodes = $self->rulemap->all_nodes_nodeset;
   my %initial_cats = (
      dame => $self->rulemap->nodeset,
      alive => {
         w => $self->rulemap->nodeset,
         b => $self->rulemap->nodeset,
      },
      derived_terr => {
         w => $self->rulemap->nodeset,
         b => $self->rulemap->nodeset,
      },
   );

   my $board = $self->state->board;
   while($remaining_nodes->count){
      my $node = $remaining_nodes->choose;
      my $stone = $self->state->at_node($node);
      if($stone){
         my $cond = sub{ $_ eq $stone};
         my $contiguous = $self->state->floodfill ($cond, $node);
         $remaining_nodes->remove($contiguous);
         $initial_cats{alive}{$stone}->add($contiguous);
      }
      else { #space.
         my $cond = sub{ ! $_ };
         my $contiguous = $self->state->floodfill ($cond, $node);
         my $adjacent = $contiguous->adjacent;
         my @adj_colors = $self->state->colors_in_nodeset($adjacent);;
         if(@adj_colors != 1){
            $initial_cats{dame}->add($contiguous);
         }
         else {
            $initial_cats{derived_terr}{$adj_colors[0]}->add($contiguous);
         }
         $remaining_nodes->remove($contiguous);
      }
   }
   return \%initial_cats;
}
sub _initial_dame{
   my $self = shift;
   return $self->_initial_cats->{dame}
}
sub _initial_derived_terr {
   my $self = shift;
   return $self->_initial_cats->{derived_terr}
}
sub _initially_generous_with_life{
   my $self = shift;
   return $self->_initial_cats->{alive}
}
sub _empty_nodesets{
   my $self = shift;
   return {
      b => $self->rulemap->nodeset,
      w => $self->rulemap->nodeset,
   };
}

#transanimation -- to toggle the status of life/death, reanimate^deanimate

sub transanimate_node{
   my ($self, $node) = @_;
   my $stone = $self->state->stone_at_node($node);
   return unless $stone;
   my $deanimate = $self->aliveness_at_node($node);
   if($deanimate){
      #my $nodeset = $self->rulemap->floodfill(sub{0}, $node);
   }
   else{

   }
};
sub reanimate_node{}
sub deanimate_node{}


# these 4 lines are shtoopid.
# a state is used, and a bunch of nodesets are derived. that is all.
# inc. floodfill algorithms to reanimate/deanimate certain chains / chain-groups
#
#sub territory{}
# sub dead_stones{}
#sub territory_board{}
#sub dead_stones_board{}
#
#->dead(color): return a nodeset of dead stones of color.
#->dead: return a hashref of color => nodeset pairs.
sub dead{
   my ($self,$color) = @_;
   unless ($color){
      return {
         b => $self->dead('b'),
         w => $self->dead('w'),
      };
   }
   #have color.
   return $self->rulemap->nodeset;
}
sub territory{
   my ($self,$color) = @_;
   unless ($color){
      return {
         b => $self->territory('b'),
         w => $self->territory('w'),
      };
   }
   #have color.
   #  die %{$self->_known_terr};
   my $known = $self->_known_terr->{$color};
   die unless $known;
   my $derived = $self->_derived_terr->{$color};
   die unless $derived;
   my $ns = $self->rulemap->nodeset;
   $ns->add($known);
   $ns->add($derived);
   return $ns;
}

1;

