package TengStudy::DB::Schema;

use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name 'user';
    pk 'id';
    columns qw/id name/;
};

table {
    name 'item';
    pk 'id';
    columns qw/id name/;
};

table {
    name 'user_item';
    pk 'id';
    columns qw/id user_id item_id count/;
};
1;
