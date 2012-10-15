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
   my $set = $self->rulemap->nodeset($progenitor);
   my $seen = $self->rulemap->nodeset($progenitor);
   my @q = $self->rulemap->adjacent_nodes($progenitor);
   my $unseen = $self->rulemap->nodeset(@q);
   local($_);
   while($unseen->count){
      my $node = $unseen->choose;
      $unseen->remove($node);
      $seen->add($node);
      #next if $seen->has_node($node);
      #$seen->add($node);
      $_ = $node;
      #warn ($_ ? @$_ : '');
      #Carp::confess;
      next unless $cond->($node);
      warn 'met';
      $set->add($node);
      push @q, $self->rulemap->adjacent_nodes($node);
   }
   return $set;
}

=head1 $state->floodfill( $coderef, $node);

To get a chain of white stones starting at $node
    $state->floodfill( $sub{ $_ eq 'w' }, $node);

To get a region of empty space, starting at $node
    $state->floodfill( $sub{ ! $_ }, $node);

=cut

sub grep_nodeset{
   my ($self,$cond,$ns) = @_;
   my $new_ns = $self->rulemap->nodeset;
   local($_);
   for my $node ($ns->nodes){
      my $at = $self->at_node($node);
      $_ = $at;
      if($cond->()){
         $new_ns->add($node);
      }
   }
   return $new_ns;
}

=head2 $state->grep_nodeset(sub{$_ =~ /[wb]}, $nodeset)

Another awkward functional thing.

=cut

sub num_colors_in_nodeset{
   my $self = shift;
   return scalar ($self->colors_in_nodeset(@_));
}
sub colors_in_nodeset{
   my ($self, $nodeset) = @_;
   my %colors;
   for my $node ($nodeset->nodes){
      my $stone = $self->at_node($node);
      next unless $stone;
      $colors{$stone}++;
   }
   return keys %colors;
}

1;
