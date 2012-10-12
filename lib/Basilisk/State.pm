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
   my $result = Basilisk::MoveResult->new(
      rulemap => $self->rulemap,
      basis_state => $self,
      move_attempt => \%args,
   );
}

1;
