package TengStudy::DB;

use strict;
use warnings;
use parent 'Teng';
__PACKAGE__->load_plugin('BulkInsert');

sub new {
    my $class = shift;

    $class->SUPER::new(
        # use mysql sandbox
        connect_info => [
            'dbi:mysql:database=teng_study;host=localhost;port=5515;mysql_socket=/tmp/mysql_sandbox5515.sock;',
            'msandbox',
            'msandbox',
            { mysql_enable_utf8 => 1},
        ],
    );
}

1;
