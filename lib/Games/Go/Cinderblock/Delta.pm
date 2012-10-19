package Games::Go::Cinderblock::Delta;
use Moose;

#use overload
#   '!' => \&reverse,

has rulemap => (
   isa => 'Games::Go::Cinderblock::Rulemap',
   is => 'ro', #shouldn't change.
   required => 1,
);
#changes to board.
# format: {remove => {b => \@nodes}}
has _board => (
   isa => 'HashRef',
   is => 'ro',
   required => 0,
   predicate => 'diff_board',
);
#changes to turn.
# format: {before=>'w', after=>'b'}
has _turn => (
   isa => 'HashRef',
   is => 'ro',
   required => 0,
   predicate => 'diff_turn',
);
#changes to caps.
# format: {w => {before=>3, after=>5}}
has _captures => (
   isa => 'HashRef',
   is => 'ro',
   required => 0,
   predicate => 'diff_captures',
);

sub board{
   my $self = shift;
   die 'no color' if shift;
   return $self->_board;
}
sub turn{
   my $self = shift;
   return unless $self->diff_turn;
   return $self->_turn
}
sub captures{
   my ($self,$color) = @_;
   return unless $self->diff_captures;
   if($color){ return $self->_captures->{$color} }
   return $self->_captures;
}

sub board_addition{
   my $self = shift;
   my $color = shift;
   if($color){
      return $self->_board->{add}{$color}
   }
   return $self->_board->{add};
}
sub board_removal{
   my $self = shift;
   my $color = shift;
   if($color){
      return $self->_board->{remove}{$color}
   }
   return $self->_board->{remove};
}

sub to_structure{
   my $self = shift;
   my %struct;
   if($self->diff_board){
      $struct{board} = $self->_board;
   }
   if($self->diff_turn){
      $struct{turn} = $self->_turn;
   }
   if($self->diff_captures){
      $struct{captures} = $self->_captures;
   }
   return \%struct;
}


1;
