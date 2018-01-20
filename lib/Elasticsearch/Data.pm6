use v6.c;
unit class Elasticsearch::Data:ver<0.0.2>;

=begin pod

=head1 NAME

Elasticsearch::Data - Sends hash to a elasticsearch url

=head1 SYNOPSIS

  use Elasticsearch::Data;
  my $elasticsearch = Elasticsearch::Data.new(url => "http://elasticsearch:9200", index => "tests");
  $elasticsearch.post({ date => "2018-01-20T19:46:59Z", name => "test", status => "failed"});

=head1 DESCRIPTION

Elasticsearch::Data is a wrapper to send data to a elasticsearch instance.

=head1 AUTHOR

wbiker <wbiker@gmx.at>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 wbiker

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

use JSON::Fast;
use LWP::Simple;

subset Url of Str where * ~~ /^ "http" | "https"/;

has Url $.url is required;
has $.index is required;
has $.user-agent = LWP::Simple.new;
has $.type = "items";

method post(:%data) {
    die "post() parameter data must be set" unless %data;

    my $json = to-json %data, :!pretty;

    my $url = $!url ~ "/" ~ $!index ~ "/" ~ $!type;

    my %headers = ( 'Content-Type' => 'application/json' );
    my $response = $!user-agent.post($url, %headers, $json);

    if $response {
      $response = from-json $response;
      if $response<_shards><successful> == 1 {
        return $response;
      }
    }

    die $response;
}
