package Games::Go::Cinderblock::MoveResult;
use Moose;

has move_attempt => (
   isa => 'Games::Go::Cinderblock::MoveAttempt', # Games::Go::Cinderblock::MoveAttempt?
   is => 'ro',
   required => 1,
);

has rulemap => (
   isa => 'Games::Go::Cinderblock::Rulemap',
   is => 'ro', #shouldn't change.
   required => 1,
);
has basis_state=> (
   is => 'ro',
   required => 1,
   isa => 'Games::Go::Cinderblock::State',
);

has resulting_state=> (
   is => 'ro',
   # required if success?
   isa => 'Games::Go::Cinderblock::State',
);
has delta => (
   lazy => 1,
   is => 'ro',
   builder => '_derive_delta',
   isa => 'HashRef', # Games::Go::Cinderblock::Delta
);

has succeeded => (
   isa => 'Bool',
   is => 'ro',
#   lazy => 1,
#   builder => '_determine_success',
   required => 1,
);
has reason => (
   isa => 'Str',
   is => 'ro',
   required => 0,
);

sub _derive_delta{
   my $self = shift;
   return $self->rulemap->delta(
      $self->basis_state->board,
      $self->resulting_state->board,
   );
}

# meh
sub failed{
   my $self = shift;
   return ($self->succeeded ? 0 : 1);
}
1;
