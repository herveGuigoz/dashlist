<?php

declare(strict_types=1);

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiProperty;
use ApiPlatform\Core\Annotation\ApiResource;
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
    collectionOperations: [
        'get',
        'post'
    ],
    itemOperations: [
        'get',
        'put'
    ],
    mercure: true,
    denormalizationContext: ['groups' => ['item:write']],
    normalizationContext: ['groups' => ['item:read']],
)]
class ListItem
{
    #[ORM\Id, ORM\GeneratedValue(strategy: 'CUSTOM'), ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\Column(type: 'uuid', unique: true)]
    #[Groups(groups: ['item:read', 'list:read'])]
    private ?UuidInterface $id = null;

    #[ORM\Column(type: 'text')]
    #[ApiProperty(iri: 'http://schema.org/name')]
    #[Assert\NotBlank]
    #[Groups(groups: ['item:read', 'item:write', 'list:read'])]
    public ?string $name = null;

    #[ORM\Column(type: 'string', length: 255, nullable: true)]
    #[Groups(groups: ['item:read', 'item:write', 'list:read'])]
    private ?string $quantity = null;

    #[ORM\Column(type: 'boolean')]
    #[Groups(groups: ['item:read', 'item:write', 'list:read'])]
    private bool $isCompleted = false;

    #[ORM\ManyToOne(targetEntity: ShoppingList::class, inversedBy: 'items')]
    #[Assert\NotNull]
    #[Groups(groups: ['item:read', 'item:write'])]
    private ShoppingList $shoppingList;

    #[ORM\ManyToOne(targetEntity: Category::class)]
    #[ORM\JoinColumn(referencedColumnName: 'name', nullable: false)]
    #[Groups(groups: ['item:read', 'item:write', 'list:read'])]
    private Category $category;

    public function getId(): ?UuidInterface
    {
        return $this->id;
    }

    public function getQuantity(): ?string
    {
        return $this->quantity;
    }

    public function setQuantity(string $quantity): self
    {
        $this->quantity = $quantity;

        return $this;
    }

    public function getIsCompleted(): ?bool
    {
        return $this->isCompleted;
    }

    public function setIsCompleted(bool $isCompleted): self
    {
        $this->isCompleted = $isCompleted;

        return $this;
    }

    public function getShoppingList(): ?ShoppingList
    {
        return $this->shoppingList;
    }

    public function setShoppingList(?ShoppingList $shoppingList, bool $updateRelation = true): void
    {
        $this->shoppingList = $shoppingList;
        if ($updateRelation && null !== $shoppingList) {
            $shoppingList->addItem($this, false);
        }
    }

    public function getCategory(): ?Category
    {
        return $this->category;
    }

    public function setCategory(?Category $category): self
    {
        $this->category = $category;

        return $this;
    }
}
