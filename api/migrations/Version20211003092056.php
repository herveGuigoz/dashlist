<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20211003092056 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE category (name VARCHAR(255) NOT NULL, description VARCHAR(255) DEFAULT NULL, PRIMARY KEY(name))');
        $this->addSql('CREATE TABLE list_item (id UUID NOT NULL, shopping_list_id UUID DEFAULT NULL, category_id VARCHAR(255) NOT NULL, name TEXT NOT NULL, quantity VARCHAR(255) DEFAULT NULL, is_completed BOOLEAN NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_5AD5FAF723245BF9 ON list_item (shopping_list_id)');
        $this->addSql('CREATE INDEX IDX_5AD5FAF712469DE2 ON list_item (category_id)');
        $this->addSql('CREATE TABLE shopping_list (id UUID NOT NULL, name TEXT NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE TABLE "user" (id UUID NOT NULL, email VARCHAR(180) NOT NULL, password VARCHAR(255) NOT NULL, roles JSON NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_8D93D649E7927C74 ON "user" (email)');
        $this->addSql('ALTER TABLE list_item ADD CONSTRAINT FK_5AD5FAF723245BF9 FOREIGN KEY (shopping_list_id) REFERENCES shopping_list (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE list_item ADD CONSTRAINT FK_5AD5FAF712469DE2 FOREIGN KEY (category_id) REFERENCES category (name) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE list_item DROP CONSTRAINT FK_5AD5FAF712469DE2');
        $this->addSql('ALTER TABLE list_item DROP CONSTRAINT FK_5AD5FAF723245BF9');
        $this->addSql('DROP TABLE category');
        $this->addSql('DROP TABLE list_item');
        $this->addSql('DROP TABLE shopping_list');
        $this->addSql('DROP TABLE "user"');
    }
}
