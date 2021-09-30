<?php

declare(strict_types=1);

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiFilter;
use ApiPlatform\Core\Annotation\ApiProperty;
use ApiPlatform\Core\Annotation\ApiResource;
use ApiPlatform\Core\Bridge\Doctrine\Orm\Filter\SearchFilter;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Doctrine\UuidGenerator;
use Ramsey\Uuid\UuidInterface;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * @see https://schema.org/ListItem Documentation on Schema.org
 */
#[ORM\Entity]
#[ApiResource(
    iri: 'https://schema.org/ListItem',
    collectionOperations: ['post'],
    itemOperations: ['delete'],
    denormalizationContext: ['groups' => ['item:write']],
    normalizationContext: ['groups' => ['item:read']],
)]
class ListItem
{
    #[ORM\Id, ORM\GeneratedValue(strategy: 'CUSTOM'), ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\Column(type: 'uuid', unique: true)]
    private ?UuidInterface $id = null;

    /**
     * The name of the shop.
     */
    #[ORM\Column(type: 'text')]
    #[ApiProperty(iri: 'http://schema.org/name')]
    #[Assert\NotBlank]
    #[Groups(groups: ['item:write', 'list:read', 'item:read'])]
    public ?string $name = null;

    /**
     * The ShoppingList.
     */
    #[ORM\ManyToOne(targetEntity: ShoppingList::class, inversedBy: 'items')]
    #[ORM\JoinColumn(nullable: false)]
    #[ApiFilter(SearchFilter::class)]
    #[ApiProperty(iri: 'https://schema.org/ItemList')]
    #[Assert\NotNull]
    #[Groups(groups: ['item:write', 'item:read'])]
    private ?ShoppingList $list = null;

    public function getId(): ?UuidInterface
    {
        return $this->id;
    }

    public function setList(?ShoppingList $list, bool $updateRelation = true): void
    {
        $this->list = $list;
        if ($updateRelation && null !== $list) {
            $list->addItem($this, false);
        }
    }

    public function getItem(): ?ShoppingList
    {
        return $this->list;
    }
}
