[![Build Status](https://travis-ci.org/wbiker/Elasticsearch-Data.svg?branch=master)](https://travis-ci.org/wbiker/Elasticsearch-Data)

NAME
====

Elasticsearch::Data - Sends hash to a elasticsearch url

SYNOPSIS
========

    use Elasticsearch::Data;
    my $elasticsearch = Elasticsearch::Data.new(url => "http://elasticsearch:9200", index => "tests");
    $elasticsearch.post({ date => "2018-01-20T19:46:59Z", name => "test", status => "failed"});

DESCRIPTION
===========

Elasticsearch::Data is a wrapper to send data to a elasticsearch instance.

AUTHOR
======

wbiker <wbiker@gmx.at>

COPYRIGHT AND LICENSE
=====================

Copyright 2018 wbiker

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
