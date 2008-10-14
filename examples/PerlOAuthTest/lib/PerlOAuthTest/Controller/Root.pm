package PerlOAuthTest::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

PerlOAuthTest::Controller::Root - Root Controller for PerlOAuthTest

=head1 DESCRIPTION

Basic demonstration of how to use OAuth to access iKnow! in Perl.

=head1 METHODS

=cut

=head2 default

=cut

sub default : Private {
  my ( $self, $c ) = @_;
  
  $c->stash->{items} = $c->model('Iknow')->items;
}

=head2 login

Redirects you to iKnow! to log in and authorize this application.

=cut

sub login : Global {
  my ( $self, $c ) = @_;
  
  my $consumer = $c->oauth_consumer;
  my $request_token = $consumer->get_request_token;
  $c->session->{request_token} = $request_token;
  $c->response->redirect($consumer->url_to_authorize(
    token        => $request_token,
    callback_url => $c->uri_for('/callback'),
  ));
}

=head2 logout

Deletes the access_token form the session, thereby loggin you out.

=cut

sub logout : Global {
  my ( $self, $c ) = @_;

  undef $c->session->{access_token};
  $c->res->redirect($c->uri_for('/'));
}

=head2 callback

Called by the iKnow! when you have logged in and authorized this application on the iKnow! site.

=cut

sub callback : Global {
  my ( $self, $c ) = @_;
  
  my $consumer = $c->oauth_consumer;
  my $request_token = $c->session->{request_token};
  my $access_token = $consumer->get_access_token(token => $request_token);
  $c->session->{access_token} = $access_token;
  undef $c->session->{request_token};
  $c->res->redirect($c->uri_for('/'));
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Kim Ahlström

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
