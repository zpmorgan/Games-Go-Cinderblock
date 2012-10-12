package Basilisk::NodeSet;
use Moose;

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

1;
