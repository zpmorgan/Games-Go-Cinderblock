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

sub nodes{
   my $self = shift;
   return values %{$self->_nodes};
}
sub remove{
   my ($self,$node) = @_;
   my $node_id = $self->rulemap->node_to_id($node);
   delete $self->_nodes->{$node_id};
}
sub add {
   my ($self,$node) = @_;
   my $node_id = $self->rulemap->node_to_id($node);
   $self->_nodes->{$node_id} = $node;
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
   return join ',', keys %{$self->_nodes};
}

sub size{
   my $self = shift;
   return scalar keys %{$self->_nodes};
}
1;
