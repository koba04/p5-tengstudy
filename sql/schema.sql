CREATE TABLE IF NOT EXISTS `user` (
    id                  INTEGER UNSIGNED    NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(30) BINARY  NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT= 'ユーザー';


CREATE TABLE IF NOT EXISTS `item` (
    id                  INTEGER UNSIGNED    NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(30) BINARY  NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT= 'アイテム';

CREATE TABLE IF NOT EXISTS `user_item` (
    id                  INTEGER UNSIGNED    NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id             INTEGER UNSIGNED    NOT NULL,
    item_id           INTEGER UNSIGNED    NOT NULL,
    count               INTEGER UNSIGNED    NOT NULL,
    INDEX      user_item_id (user_id, item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ユーザーアイテム';
