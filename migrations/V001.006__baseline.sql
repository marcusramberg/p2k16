DROP TABLE IF EXISTS membership_payment_version;
DROP TABLE IF EXISTS membership_payment;
DROP TABLE IF EXISTS membership_version;
DROP TABLE IF EXISTS membership;
DROP TABLE IF EXISTS audit_record_version;
DROP TABLE IF EXISTS audit_record;
DROP TABLE IF EXISTS circle_member_version;
DROP TABLE IF EXISTS circle_member;
DROP TABLE IF EXISTS circle_version;
DROP TABLE IF EXISTS circle;
DROP TABLE IF EXISTS account_version;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS transaction;

DROP TABLE IF EXISTS "transaction";
CREATE TABLE "transaction" (
  id          BIGSERIAL PRIMARY KEY,
  issued_at   VARCHAR(100) NOT NULL,
  remote_addr VARCHAR(100)
);
GRANT SELECT, INSERT ON "transaction" TO "p2k16-web";
GRANT USAGE ON "transaction_id_seq" TO "p2k16-web";

CREATE TABLE account
(
  id                   BIGSERIAL    NOT NULL PRIMARY KEY,

  created_at           TIMESTAMP    NOT NULL,
  updated_at           TIMESTAMP    NOT NULL,

  username             VARCHAR(50)  NOT NULL UNIQUE,
  email                VARCHAR(120) NOT NULL UNIQUE,
  password             VARCHAR(100),
  name                 VARCHAR(100),
  phone                VARCHAR(50),
  reset_token          VARCHAR(50) UNIQUE,
  reset_token_validity TIMESTAMP
);
GRANT ALL ON account TO "p2k16-web";
GRANT ALL ON account_id_seq TO "p2k16-web";

CREATE TABLE account_version
(
  transaction_id     BIGINT       NOT NULL REFERENCES transaction,
  end_transaction_id BIGINT REFERENCES transaction,
  operation_type     INT          NOT NULL,

  id                 BIGSERIAL    NOT NULL,

  created_at         TIMESTAMP    NOT NULL,
  updated_at         TIMESTAMP    NOT NULL,

  username           VARCHAR(50)  NOT NULL,
  email              VARCHAR(120) NOT NULL,
  password           VARCHAR(100),
  name               VARCHAR(100),
  phone              VARCHAR(50),
  reset_token        VARCHAR(50)
);
GRANT INSERT, UPDATE ON account_version TO "p2k16-web";
GRANT ALL ON account_version TO "p2k16-web";

CREATE TABLE circle
(
  id          BIGSERIAL   NOT NULL PRIMARY KEY,

  created_at  TIMESTAMP   NOT NULL,
  created_by  BIGINT      NOT NULL REFERENCES account,
  updated_at  TIMESTAMP   NOT NULL,
  updated_by  BIGINT      NOT NULL REFERENCES account,

  NAME        VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(50) NOT NULL UNIQUE
);
GRANT ALL ON circle TO "p2k16-web";
GRANT ALL ON circle_id_seq TO "p2k16-web";

CREATE TABLE circle_version
(
  transaction_id     BIGINT      NOT NULL REFERENCES transaction,
  end_transaction_id BIGINT REFERENCES transaction,
  operation_type     INT         NOT NULL,

  id                 BIGSERIAL   NOT NULL,

  created_at         TIMESTAMP   NOT NULL,
  created_by         BIGINT      NOT NULL,
  updated_at         TIMESTAMP   NOT NULL,
  updated_by         BIGINT      NOT NULL,

  name               VARCHAR(50) NOT NULL,
  description        VARCHAR(50) NOT NULL
);
GRANT INSERT, UPDATE ON circle_version TO "p2k16-web";
GRANT ALL ON circle_version TO "p2k16-web";

CREATE TABLE circle_member
(
  id         BIGSERIAL NOT NULL PRIMARY KEY,

  created_at TIMESTAMP NOT NULL,
  created_by BIGINT    NOT NULL REFERENCES account,
  updated_at TIMESTAMP NOT NULL,
  updated_by BIGINT    NOT NULL REFERENCES account,

  circle     INTEGER   NOT NULL REFERENCES circle,
  account    INTEGER   NOT NULL REFERENCES account,
  UNIQUE (circle, account)
);
GRANT ALL ON circle_member TO "p2k16-web";
GRANT ALL ON circle_member_id_seq TO "p2k16-web";

CREATE TABLE circle_member_version
(
  transaction_id     BIGINT    NOT NULL REFERENCES transaction,
  end_transaction_id BIGINT REFERENCES transaction,
  operation_type     INT       NOT NULL,

  id                 BIGINT    NOT NULL,

  created_at         TIMESTAMP NOT NULL,
  created_by         BIGINT    NOT NULL,
  updated_at         TIMESTAMP NOT NULL,
  updated_by         BIGINT    NOT NULL,

  circle             INTEGER   NOT NULL,
  account            INTEGER   NOT NULL
);
GRANT INSERT, UPDATE ON circle_member_version TO "p2k16-web";
GRANT ALL ON circle_member_version TO "p2k16-web";

CREATE TABLE audit_record
(
  id         BIGSERIAL    NOT NULL PRIMARY KEY,

  created_at TIMESTAMP    NOT NULL,
  created_by BIGINT       NOT NULL REFERENCES account,
  updated_at TIMESTAMP    NOT NULL,
  updated_by BIGINT       NOT NULL REFERENCES account,

  timestamp  TIMESTAMP    NOT NULL,
  object     VARCHAR(100) NOT NULL,
  action     VARCHAR(100) NOT NULL
);
GRANT ALL ON audit_record TO "p2k16-web";
GRANT ALL ON audit_record_id_seq TO "p2k16-web";

CREATE TABLE audit_record_version
(
  transaction_id     BIGINT       NOT NULL REFERENCES transaction,
  end_transaction_id BIGINT REFERENCES transaction,
  operation_type     INT          NOT NULL,

  id                 BIGSERIAL    NOT NULL,

  created_at         TIMESTAMP    NOT NULL,
  created_by         BIGINT       NOT NULL,
  updated_at         TIMESTAMP    NOT NULL,
  updated_by         BIGINT       NOT NULL,

  timestamp          TIMESTAMP    NOT NULL,
  object             VARCHAR(100) NOT NULL,
  action             VARCHAR(100) NOT NULL
);
GRANT INSERT, UPDATE ON audit_record_version TO "p2k16-web";
GRANT ALL ON audit_record_version TO "p2k16-web";

CREATE TABLE membership
(
  id               BIGSERIAL NOT NULL PRIMARY KEY,

  created_at       TIMESTAMP NOT NULL,
  created_by       BIGINT    NOT NULL REFERENCES account,
  updated_at       TIMESTAMP NOT NULL,
  updated_by       BIGINT    NOT NULL REFERENCES account,

  first_membership TIMESTAMP NOT NULL,
  start_membership TIMESTAMP NOT NULL,
  fee              INTEGER   NOT NULL
);
GRANT ALL ON membership TO "p2k16-web";
GRANT ALL ON membership_id_seq TO "p2k16-web";

CREATE TABLE membership_version
(
  transaction_id     BIGINT    NOT NULL REFERENCES transaction,
  end_transaction_id BIGINT REFERENCES transaction,
  operation_type     INT       NOT NULL,

  id                 BIGSERIAL NOT NULL,

  created_at         TIMESTAMP NOT NULL,
  created_by         BIGINT    NOT NULL,
  updated_at         TIMESTAMP NOT NULL,
  updated_by         BIGINT    NOT NULL,

  first_membership   TIMESTAMP NOT NULL,
  start_membership   TIMESTAMP NOT NULL,
  fee                INTEGER   NOT NULL
);
GRANT INSERT, UPDATE ON membership_version TO "p2k16-web";
GRANT ALL ON membership_version TO "p2k16-web";

CREATE TABLE membership_payment
(
  id           BIGSERIAL     NOT NULL PRIMARY KEY,

  created_at   TIMESTAMP     NOT NULL,
  created_by   BIGINT        NOT NULL REFERENCES account,
  updated_at   TIMESTAMP     NOT NULL,
  updated_by   BIGINT        NOT NULL REFERENCES account,

  stripe_id    VARCHAR(50)   NOT NULL UNIQUE,
  start_date   TIMESTAMP     NOT NULL,
  end_date     TIMESTAMP     NOT NULL,
  amount       NUMERIC(8, 2) NOT NULL,
  payment_date TIMESTAMP
);
GRANT ALL ON membership_payment TO "p2k16-web";
GRANT ALL ON membership_payment_id_seq TO "p2k16-web";

CREATE TABLE membership_payment_version
(
  transaction_id     BIGINT        NOT NULL REFERENCES transaction,
  end_transaction_id BIGINT REFERENCES transaction,
  operation_type     INT           NOT NULL,

  id                 BIGSERIAL     NOT NULL,

  created_at         TIMESTAMP     NOT NULL,
  created_by         BIGINT        NOT NULL,
  updated_at         TIMESTAMP     NOT NULL,
  updated_by         BIGINT        NOT NULL,

  membership         VARCHAR(50)   NOT NULL,
  start_date         TIMESTAMP     NOT NULL,
  end_date           TIMESTAMP     NOT NULL,
  amount             NUMERIC(8, 2) NOT NULL,
  payment_date       TIMESTAMP
);
GRANT INSERT, UPDATE ON membership_payment_version TO "p2k16-web";
GRANT ALL ON membership_payment_version TO "p2k16-web";

DO $$
DECLARE
  admins_id             BIGINT;
  door_id               BIGINT;
  super_id              BIGINT;
  foo_id                BIGINT;
  shopbot_id            BIGINT;
  shopbot_admin_id      BIGINT;
  laser_cutter_id       BIGINT;
  laser_cutter_admin_id BIGINT;
BEGIN
  DELETE FROM circle_member;
  DELETE FROM circle;
  DELETE FROM account;

  INSERT INTO account (created_at, updated_at, username, email, name, phone, password) VALUES
    (current_timestamp, current_timestamp, 'super', 'super@example.org', 'Super Account', '01234567',
     '$2b$12$B/kxR5O85fN357.fZNUPoOiNblCj7j2lX3/VLajLvuE42OmqsyUTO')
  RETURNING id
    INTO super_id;
  INSERT INTO account (created_at, updated_at, username, email, name, phone, password) VALUES
    (current_timestamp, current_timestamp, 'foo', 'foo@example.org', 'Foo Bar', '76543210',
     '$2b$12$o764MV/jh0HnsAtsEz53L.GfbLwCqZ5jTf3aV2yUAFFCaTrzGCcQm')
  RETURNING id
    INTO foo_id;

  INSERT INTO circle (created_at, created_by, updated_at, updated_by, name, description) VALUES
    (current_timestamp, super_id, current_timestamp, super_id, 'admins', 'Admin')
  RETURNING id
    INTO admins_id;

  INSERT INTO circle (created_at, created_by, updated_at, updated_by, name, description) VALUES
    (current_timestamp, super_id, current_timestamp, super_id, 'door', 'Door access')
  RETURNING id
    INTO door_id;

  INSERT INTO circle (created_at, created_by, updated_at, updated_by, name, description) VALUES
    (current_timestamp, super_id, current_timestamp, super_id, 'shopbot', 'Shopbot access')
  RETURNING id
    INTO shopbot_id;

  INSERT INTO circle (created_at, created_by, updated_at, updated_by, name, description) VALUES
    (current_timestamp, super_id, current_timestamp, super_id, 'shopbot-admin', 'Shopbot Admin')
  RETURNING id
    INTO shopbot_admin_id;

  INSERT INTO circle (created_at, created_by, updated_at, updated_by, name, description) VALUES
    (current_timestamp, super_id, current_timestamp, super_id, 'laser-cutter', 'Laser cutter access')
  RETURNING id
    INTO laser_cutter_id;

  INSERT INTO circle (created_at, created_by, updated_at, updated_by, name, description) VALUES
    (current_timestamp, super_id, current_timestamp, super_id, 'laser-cutter-admin', 'Laser cutter Admin')
  RETURNING id
    INTO laser_cutter_admin_id;

  INSERT INTO circle_member (created_at, created_by, updated_at, updated_by, account, circle) VALUES
    (current_timestamp, super_id, current_timestamp, super_id, super_id, admins_id),
    (current_timestamp, super_id, current_timestamp, super_id, super_id, door_id),
    (current_timestamp, super_id, current_timestamp, super_id, super_id, shopbot_admin_id),
    (current_timestamp, super_id, current_timestamp, super_id, super_id, laser_cutter_admin_id),
    (current_timestamp, super_id, current_timestamp, super_id, foo_id, door_id);
END;
$$;
