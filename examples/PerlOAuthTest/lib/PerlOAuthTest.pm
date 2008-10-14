package PerlOAuthTest;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a YAML file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory

use OAuth::Lite::Consumer;

use Catalyst qw(
  -Debug
  ConfigLoader
  Static::Simple
  Session 
  Session::State::Cookie
  Session::Store::File
  Unicode
);

our $VERSION = '0.01';

# Configure the application. 
#
# Note that settings in perloauthtest.yml (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'PerlOAuthTest' );

# Start the application
__PACKAGE__->setup;

sub oauth_consumer {
  my $c = shift;
  my $oauth = $c->config->{oauth};
  
  my $consumer = OAuth::Lite::Consumer->new(
    consumer_key       => $oauth->{consumer_key},
    consumer_secret    => $oauth->{consumer_secret},
    site               => $oauth->{site},
    request_token_path => $oauth->{site} . $oauth->{request_token_path},
    access_token_path  => $oauth->{site} . $oauth->{access_token_path},
    authorize_path     => $oauth->{authorize_url},
  );
  
  return $consumer;
}

=head1 NAME

PerlOAuthTest - Catalyst based application

=head1 SYNOPSIS

    script/perloauthtest_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<PerlOAuthTest::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Kim Ahlström

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
