package Liquid::Error;
{
    use Carp qw[];
    use strict;
    use warnings;
    sub message { return $_[0]->{'message'} }
    sub fatal   { return $_[0]->{'fatal'} }

    sub new {
        my ($class, $args, @etc) = @_;
        $args
            = {message => (@etc ? sprintf($args, @etc) : $args)
               || 'Unknown error'}
            if $args
                && !(ref $args && ref $args eq 'HASH');
        $args->{'fatal'} = defined $args->{'fatal'} ? $args->{'fatal'} : 0;
        Carp::longmess() =~ m[^.+?\n\t(.+)]s;
        $args->{'message'} = $class . ': ' . $args->{'message'} . $1;
        return bless $args, $class;
    }

    sub raise {
        my ($self) = @_;
        $self = ref $self ? $self : $self->new($_[1]);
        die $self->message if $self->fatal;
        warn $self->message;
    }
    sub render { return sprintf '[%s] %s', ref $_[0], $_[0]->message; }
    { package Liquid::ArgumentError;   our @ISA = qw'Liquid::Error' }
    { package Liquid::ContextError;    our @ISA = qw'Liquid::Error' }
    { package Liquid::FilterNotFound;  our @ISA = qw'Liquid::Error' }
    { package Liquid::FileSystemError; our @ISA = qw'Liquid::Error' }
    { package Liquid::StandardError;   our @ISA = qw'Liquid::Error' }
    { package Liquid::SyntaxError;     our @ISA = qw'Liquid::Error' }
    { package Liquid::StackLevelError; our @ISA = qw'Liquid::Error' }
}
1;
