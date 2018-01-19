use v6.c;
unit class Elasticsearch::Data:ver<0.0.1>;

=begin pod

=head1 NAME

Elasticsearch::Data - blah blah blah

=head1 SYNOPSIS

  use Elasticsearch::Data;

=head1 DESCRIPTION

Elasticsearch::Data is ...

=head1 AUTHOR

Wolfgang Banaston <wolfgang.banaston@sophos.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Wolfgang Banaston

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
use JSON::Fast;
use LWP::Simple;

has $.url is required;
has $.index is required;
has $.type = "items";
has $.exitcode;
has $.output;

method post(:%data) {
    my $json = to-json %data, :!pretty;

    my $url = $!url ~ "/" ~ $!index ~ "/" ~ $!type;

    my %headers = ( 'Content-Type' => 'application/json' );
    my $response = LWP::Simple.post($url, %headers, $json);
    if $response {
      $response = from-json $response;
      if $response<_shards><successful> == 1 {
        return $response;
      }
      else {
        die $response;
      }
    }
}
