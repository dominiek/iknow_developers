package PerlOAuthTest::Model::Iknow;

use strict;
use warnings;
use base 'Catalyst::Model';
use LWP::UserAgent;
use JSON ();

=head1 NAME

PerlOAuthTest::Model::Iknow - Catalyst Model

=head1 DESCRIPTION

Catalyst iKnow! Model.

=head2 items

Fetches the ten most recent items on iKnow!

=cut

sub items {
  my ($self) = @_;
  return $self->_get_json_data_for(q{/items.json});
}

=head2 items

Fetches info for one specific item

=cut

sub item {
  my ($self, $item_id) = @_;
  return $self->_get_json_data_for(qq{/items/$item_id.json});
}

sub _get_json_data_for {
  my ($self, $url) = @_;

  my $ua = LWP::UserAgent->new;
  my $response = $ua->get($self->{api_url} . $url);
  my $data;
  
  if ($response->is_success) {
    $data = $response->decoded_content;
  }
  else {
    die $response->status_line;
  }
  
  my $json = new JSON;
  my $o = $json->decode($data);
  
  return $o;
}

=head1 AUTHOR

Kim Ahlström

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
