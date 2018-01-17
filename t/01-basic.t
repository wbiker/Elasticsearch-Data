use v6.c;
use Test;
use Elasticsearch::Data;

my $elasticsearch = Elasticsearch::Data.new(url => "http://10.97.98.87:9200", index => "tmp");
$elasticsearch.post(data => {wolf => "ich", date => DateTime.now.Str});

done-testing;
