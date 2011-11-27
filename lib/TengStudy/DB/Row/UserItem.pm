package TengStudy::DB::Row::UserItem;

use strict;
use warnings;
use parent 'Teng::Row';

use TengStudy::DB;

sub item {
    my $self = shift;
    my $db = TengStudy::DB->new;
    return $db->single('item', { id => $self->item_id });
}
