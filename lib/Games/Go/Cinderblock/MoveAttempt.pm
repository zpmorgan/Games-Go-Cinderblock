package Games::Go::Cinderblock::MoveAttempt;
use Moose;

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

has node => (
   is => 'ro',
   required => 1,
);
has color => (
   is => 'ro',
   required => 1,
   isa => 'Str',
);

1;
