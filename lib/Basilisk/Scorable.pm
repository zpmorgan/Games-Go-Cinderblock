package Basilisk::Scorable;
use Moose;
# Basilisk::Scorable,
# * original Basilisk had death masks & territory masks.
# * B::Scorable should encapsulate that, 
#   & have methods to derive score from caps, deads, & territory

has dead_nodes => (
   isa => 'ArrayRef',
   is => 'ro',
   default => sub{[]},
);
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

sub transanimate_node{
   my ($self, $node) = @_;
   my $stone = $self->state->stone_at_node($node);
   return unless $stone;
   my $deanimate = $self->aliveness_at_node($node);
   if($deanimate){
      $self->rulemap->floodfill();
      
   }
   else{

   }
};

sub territory{}
# sub dead_stones{}
sub territory_board{}
sub dead_stones_board{}
1;

