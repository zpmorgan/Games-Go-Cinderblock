package Basilisk::NodeSet;
use Moose;

use overload
   '==' => \&test_equality,
   '!=' => \&test_inequality,
   '""' => \&stringify;

has _nodes => (
   isa => 'HashRef',
   is => 'ro',
   default => sub{{}},
);
has rulemap => (
   isa => 'Basilisk::Rulemap',
   is => 'ro', #shouldn't change.
   required => 1,
);

sub copy{
   my $self = shift;
   my %set = %{$self->_nodes};
   return Basilisk::NodeSet->new(
      _nodes => \%set,
      rulemap => $self->rulemap,
   );
}

sub nodes{
   my $self = shift;
   return values %{$self->_nodes};
}
sub remove{
   my $self = shift;
   return unless $_[0];
   if(ref($_[0]) eq 'Basilisk::NodeSet'){
      my $ns = shift;
      for my $nid (keys %{$ns->_nodes}){
         delete $self->_nodes->{$nid}
      }
   }
   else{
      for my $node (@_){
         my $node_id = $self->rulemap->node_to_id($node);
         delete $self->_nodes->{$node_id};
      }
   }
}
sub add { #stones or a nodeset.
   my $self = shift;
   return unless $_[0];
   if(ref($_[0]) eq 'Basilisk::NodeSet'){
      my $ns = shift;
      for my $nid (keys %{$ns->_nodes}){
         $self->_nodes->{$nid} = $ns->_nodes->{$nid};
      }
   }
   else{
      for my $node (@_){
         my $node_id = $self->rulemap->node_to_id($node);
         $self->_nodes->{$node_id} = $node;
      }
   }
}
sub has_node{
   my ($self,$node) = @_;
   my $node_id = $self->rulemap->node_to_id($node);
   return 1 if defined $self->_nodes->{$node_id};
   return 0;
}

sub test_equality{
   my $self = shift;
   my $other = shift;
   Carp::confess unless ref($other) eq 'Basilisk::NodeSet';
   return 0 if scalar(keys %{$self->_nodes}) != scalar(keys %{$other->_nodes});
   for my $key (keys %{$self->_nodes}){
      return 0 unless defined $other->_nodes->{$key};
   }
   return 1;
}
sub test_inequality{
   my $self = shift;
   my $other = shift;
   return 0 if $self == $other;
   return 1;
}

sub stringify{
   my $self = shift;
   return '<' . join( ',', keys %{$self->_nodes}) . '>';
}

sub count{
   my $self = shift;
   return scalar keys %{$self->_nodes};
}

# return an arbitrary element. not random.
sub choose{
   my $self = shift;
   my ($key,$val) = each %{$self->_nodes};
   return $val;
}

sub adjacent{
   my $self = shift;
   my $res = $self->rulemap->nodeset;
   for my $n ($self->nodes){
      my @adj = $self->rulemap->adjacent_nodes($n);
      $res->add(@adj);
   }
   $res->remove($self);
   return $res;
}
sub union{
   my ($self,$other) = @_;
   my $result = $self->rulemap->nodeset;
   for my $n ($self->nodes){
      $result->add($n);
   }
   for my $n ($other->nodes){
      $result->add($n);
   }
   $result
}
sub intersect{
   my ($self,$other) = @_;
   my $result = $self->rulemap->nodeset;
   for my $n ($self->nodes){
      next unless $other->has_node($n);
      $result->add($n);
   }
   $result
}

sub disjoint_split{
   my $self = shift;
   my @disjoints;
   my $remaining = $self->copy;
   while($remaining->count){
      my $choice_node = $remaining->choose;
      my $subset = $self->rulemap->nodeset;#($choice_node);
      my $flood_iter = $self->rulemap->nodeset ($choice_node);
      while($flood_iter->count){
         $subset->add($flood_iter);
         $remaining->remove($flood_iter);
         $flood_iter = $flood_iter->adjacent->intersect($remaining);
      }
      push @disjoints, $subset;
   }
   return @disjoints;
}
1;
