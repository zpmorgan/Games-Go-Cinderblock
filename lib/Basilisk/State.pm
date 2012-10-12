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

1;
