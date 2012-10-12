package Basilisk::MoveResult;
use Moose;

has move_attempt => (
   isa => 'HashRef', # Basilisk::MoveAttempt?
   is => 'ro',
   required => 1,
);

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

has resulting_state=> (
   lazy => 1,
   is => 'ro',
   builder => '_derive_resulting_state',
   isa => 'Basilisk::State',
);
has delta => (
   lazy => 1,
   is => 'ro',
   builder => '_derive_delta',
   isa => 'HashRef', # Basilisk::Delta
);

has succeeded => (
   isa => 'Bool',
   is => 'ro',
   lazy => 1,
   builder => '_determine_success',
);

sub failed{
   my $self = shift;
   return ($self->succeeded ? 0 : 1);
}

sub _derive_delta{}
sub _derive_resulting_state{
   my $self = shift;
   return $self->basis_state;
}
sub _determine_success{
   my $self = shift;
   return 1;
}


1;
