package Basilisk::State;
use Moose;
use Basilisk::MoveResult;


# basilisk::state,
# long overdue.
# describes board pos, turn, caps, etc.
# serializable & deserializable.
# doesn't serialize ruleset...; dunno how to handle that. if at all.
has rulemap => (
   is => 'ro',
   isa => 'Basilisk::Rulemap',
   required => 1,
);

has board => (
   isa => 'ArrayRef',
   is => 'rw',
);
has turn => (
   is => 'rw',
   isa => 'Str',
);

sub attempt_move{
   my $self = shift;
   my %args = @_;
   my $success = 1;
   my $attempt = Basilisk::MoveAttempt->new(
      basis_state => $self,
      rulemap => $self->rulemap,
      node => $args{node},
      color => $args{color},
      move_attempt => \%args,
   );
   my $result = $self->rulemap->evaluate_move_attempt($attempt);
   return $result;
}

sub scorable{ #new? args? scorable_from_json?
   my $self = shift;
   my $scorable = Basilisk::Scorable->new(
      state => $self,
      rulemap => $self->rulemap,
   );
}

sub at_node{
   my ($self,$node) = @_;
   return $self->rulemap->stone_at_node($self->board,$node);
}

sub floodfill{
   my ($self, $cond, $progenitor) = @_;
   my $set = $self->nodeset($progenitor);
   my $seen = $self->nodeset($progenitor);
   my @q = $self->adjacent_nodes($progenitor);
   local($_);
   while(@q){
      my $node = shift @q;
      next if $seen->has($node);
      $seen->add($node);
      warn $_;
      $_ = $node;
      next unless $cond->($node);
      $set->add($node);
      push @q, $self->adjacent_nodes($node);
   }
   return $set;
}

=head1 $state->floodfill( $coderef, $node);

To get a chain of white stones starting at $node
    $state->floodfill( $sub{ $_ eq 'w' }, $node);

To get a region of empty space, starting at $node
    $state->floodfill( $sub{ ! $_ }, $node);

=cut

1;
