package TengStudy;

use utf8;
use strict;
use warnings;

use parent 'Class::Data::Inheritable';
use Benchmark;
use List::Util qw/shuffle/;
use TengStudy::DB;

our $VERSION = '0.01';

TengStudy->mk_classdata('db');

sub bench_get_master_data {
    my $class = shift;

    $class->insert_data;

    my $db = TengStudy::DB->new;

    Benchmark::cmpthese(10, {
        'row_class_accessor' => sub {
            my $iter = $db->search('user_item', { user_id => 1 });
            while ( my $user_item = $iter->next ) {
                my $name = $user_item->item->name;
                die "Can't Get Item Name" unless $name;
            }
        },
        'master_data_to_hash' => sub {
            my $user_item_iter = $db->search('user_item', { user_id => 1 });
            my $item_ids = [];
            while ( my $user_item = $user_item_iter->next ) {
                push @$item_ids, $user_item->item_id;
            }
            my $item_iter = $db->search('item', { id => $item_ids});
            while ( my $item = $item_iter->next ) {
                my $name = $item->name;
                die "Can't Get Item Name" unless $name;
            }
            #my $item_info = { map { $_->id => $_ } $db->search('item', { id => $ids})->all };
        },
    });
    $class->db->do(q{ TRUNCATE TABLE user; });
    $class->db->do(q{ TRUNCATE TABLE item; });
    $class->db->do(q{ TRUNCATE TABLE user_item; });
}

sub bench_insert {
    my $class = shift;

    my $db = TengStudy::DB->new;
    $class->db($db);

    $class->db->do(q{ TRUNCATE TABLE user_item; });
    Benchmark::cmpthese(1, {
        insert => sub {
            $class->insert_user_item;
            $class->db->do(q{ TRUNCATE TABLE user_item; });
        },
        fast_insert => sub {
            $class->insert_user_item('fast');
            $class->db->do(q{ TRUNCATE TABLE user_item; });
        },
        bulk_insert => sub {
            $class->insert_user_item('bulk');
            $class->db->do(q{ TRUNCATE TABLE user_item; });
        },
    });
}

sub insert_data {
    my $class = shift;

    my $db = TengStudy::DB->new;
    $class->db($db);
    $class->insert_user;
    $class->insert_item;
    $class->insert_user_item('bulk');
}

sub insert_user {
    my $class = shift;

    print "start user\n";
    my @users;
    for my $user_id ( 1..1000 ) {
        push @users, { name => "ユーザー" . $user_id };
    }
    $class->db->bulk_insert('user', \@users);
}

sub insert_item {
    my $class = shift;

    print "start item\n";
    my @items;
    for my $item_id ( 1..100 ) {
        push @items, { name => "アイテム" . $item_id };
    }
    $class->db->bulk_insert('item', \@items);
}

sub insert_user_item {
    my ($class, $type) = @_;

    $type = '' unless defined $type;

    print "start user_item\n";
    my @user_items;
    for my $user_id ( 1..1000 ) {
        for my $item_id ( 1..100 ) {
            my $count = int rand 100;
            push @user_items, { user_id => $user_id, item_id => $item_id, count => $count };
        }
    }

    my @indexs = shuffle 0..99999;
    my $cnt = 0;
    my @insert;
    for my $index ( @indexs ) {
        if ( $type eq 'bulk') {
            # 10000件ずつ入れる
            push @insert, $user_items[$index];
            if ( $cnt == 10000 && scalar @insert) {
                $class->db->bulk_insert('user_item', \@insert);
                @insert = ();
                $cnt = 0;
            }
            $cnt++;
        } else {
            if ( $type eq 'fast' ) {
                $class->db->fast_insert('user_item', $user_items[$index]);
            } else {
                $class->db->insert('user_item', $user_items[$index]);
            }
        }
    }
    $class->db->bulk_insert('user_item', \@insert) if $type eq 'bulk';
}

1;
__END__

=head1 NAME

TengStudy - Studying O/R Mapper Teng

=head1 SYNOPSIS

  use TengStudy;

=head1 DESCRIPTION

TengStudy is

=head1 METHODS

=head2 bench_get_master_data

benchmark is

                      Rate  row_class_accessor master_data_to_hash
row_class_accessor  14.5/s                  --                -88%
master_data_to_hash  125/s                762%                  --

=head2 bench_insert

benchmark is

            s/iter      insert fast_insert bulk_insert
insert        53.7          --        -53%        -98%
fast_insert   25.1        114%          --        -95%
bulk_insert   1.23       4266%       1942%          --

=head1 AUTHOR

koba04 E<lt>koba0004@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
