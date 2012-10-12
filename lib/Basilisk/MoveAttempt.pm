package Basilisk::MoveAttempt;
use Moose;

has rulemap => (
   isa => 'Basilisk::Rulemap',
   is => 'ro', #shouldn't change.
   required => 1,
);
has basis_state=> (
   is => 'ro',
   required => 1,
   isa => 'Basilisk::State',
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