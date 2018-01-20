use v6.c;
use Test;
use Elasticsearch::Data;

plan 3;

class UserAgentMock {
    has $.successful = True;

    method post($url, $headers, $json) {
        if $!successful {
            return '{ "_shards": { "successful": 1 }}'
        }

        return '{ something_happened => 1 }';
    }
}

my $elasticsearch = Elasticsearch::Data.new(url => "http://localhost:9200", index => "tmp", user-agent => UserAgentMock.new);
my $response = $elasticsearch.post(data => {wolf => "ich", date => DateTime.now.Str});
is $response, {_shards => { successful => 1 }}, "Post works";

$elasticsearch = Elasticsearch::Data.new(url => "http://localhost:9200", index => "tmp", user-agent => UserAgentMock.new(successful => False));
dies-ok { $elasticsearch.post(data => {wolf => "ich", date => DateTime.now.Str}) }, "Dies when posting data failed.";

$elasticsearch = Elasticsearch::Data.new(url => "http://localhost:9200", index => "tmp", user-agent => UserAgentMock.new());
dies-ok { $elasticsearch.post() }, "Dies when post parameter data not set";
