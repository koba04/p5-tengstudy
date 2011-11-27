use inc::Module::Install;
name 'TengStudy';
all_from 'lib/TengStudy.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
