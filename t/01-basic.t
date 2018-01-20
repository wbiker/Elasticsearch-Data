use v6.c;
use Test;
use Elasticsearch::Data;

plan 6;

class UserAgentMock {
    has $.successful = True;

    method post($url, $headers, $json) {
        if $!successful {
            return '{ "_shards": { "successful": 1 }}'
        }

        return '{ something_happened => 1 }';
    }
}

lives-ok { Elasticsearch::Data.new(url => "http://localhost:9200", index => "tmp", user-agent => UserAgentMock.new()) }, "Url with http is fine";

lives-ok { Elasticsearch::Data.new(url => "https://localhost:9200", index => "tmp", user-agent => UserAgentMock.new()) }, "Url with https is fine";

dies-ok { Elasticsearch::Data.new(url => "wrong://localhost:9200", index => "tmp", user-agent => UserAgentMock.new()) }, "Dies when url is not http or https";

my $elasticsearch = Elasticsearch::Data.new(url => "http://localhost:9200", index => "tmp", user-agent => UserAgentMock.new);
my $response = $elasticsearch.post(data => {wolf => "ich", date => DateTime.now.Str});
is $response, {_shards => { successful => 1 }}, "Post works";

$elasticsearch = Elasticsearch::Data.new(url => "http://localhost:9200", index => "tmp", user-agent => UserAgentMock.new(successful => False));
dies-ok { $elasticsearch.post(data => {wolf => "ich", date => DateTime.now.Str}) }, "Dies when posting data failed.";

$elasticsearch = Elasticsearch::Data.new(url => "http://localhost:9200", index => "tmp", user-agent => UserAgentMock.new());
dies-ok { $elasticsearch.post() }, "Dies when post parameter data not set";
