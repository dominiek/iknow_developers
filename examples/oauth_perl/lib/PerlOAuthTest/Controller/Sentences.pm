package PerlOAuthTest::Controller::Sentences;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

PerlOAuthTest::Controller::Sentences - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 create 

=cut

sub create : Local {
    my ( $self, $c ) = @_;

    my $id = $c->req->param('item_id');
    $c->stash->{item} = $c->model('Iknow')->item($id);
    
    if ( $c->req->method eq 'POST' ) {      
      my $consumer = $c->oauth_consumer;
      my $res = $consumer->request(
        method => 'POST', 
        url    => $c->model('Iknow')->{api_url} . q{/sentences},
        token  => $c->session->{access_token},
        params => {
          'sentence[text]' => $c->req->param('sentence'),
          item_id => $c->req->param('item_id'),
        },
      );
      
      if ($res->is_success) {
        $c->flash->{message} = q{Sentence successfully saved!};
        $c->res->redirect($c->uri_for('/'));
      }
      else {
        my $status = $res->header('status');
        if ($status =~ /^40[01]/) {
          my $auth_header = $res->header('WWW-Authenticate');
          if ($auth_header && $auth_header =~ /^OAuth/) {
            $c->flash->{error} = q{Access token may be expired, get request-token and authorize again};
          }
          else {
            $c->flash->{error} = qq{Unknown $status error ocurred: } . $res->content;
          }
        }
        else {
          $c->flash->{error} = qq{Unknown $status error ocurred: } . $res->content;
        }
        $c->stash->{sentence} = $c->req->param('sentence');
      }
    }

    $c->stash->{template} = 'sentences/create.tt';
}

=head1 AUTHOR

Kim Ahlström

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
