<?php

declare(strict_types=1);

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiResource;
use ApiPlatform\Core\Annotation\ApiSubresource;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Doctrine\UuidGenerator;
use Ramsey\Uuid\UuidInterface;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * @see https://schema.org/ItemList Documentation on Schema.org
 */
#[ORM\Entity]
#[ApiResource(
    itemOperations: [
        'get',
        'put',
        'delete'
    ],
    mercure: true,
    denormalizationContext: ['groups' => ['list:write']],
    normalizationContext: ['groups' => ['list:read']],
)]
class ShoppingList
{
    #[ORM\Id, ORM\GeneratedValue(strategy: 'CUSTOM'), ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\Column(type: 'uuid', unique: true)]
    private ?UuidInterface $id = null;

    /**
     * The name of the shop.
     */
    #[ORM\Column(type: 'text')]
    #[Assert\NotBlank]
    #[Groups(groups: ['list:write', 'list:read'])]
    public ?string $name = null;

    /**
     * The items's on this list.
     */
    #[ORM\OneToMany(mappedBy: 'list', targetEntity: ListItem::class, cascade: ['persist', 'remove'], orphanRemoval: true)]
    #[ApiSubresource]
    #[Groups(groups: ['list:read'])]
    private Collection $items;

    public function getId(): ?UuidInterface
    {
        return $this->id;
    }

    public function addItem(ListItem $item, bool $updateRelation = true): void
    {
        if ($this->items->contains($item)) {
            return;
        }

        $this->items->add($item);
        if ($updateRelation) {
            $item->setList($this, false);
        }
    }

    public function removeItem(ListItem $item, bool $updateRelation = true): void
    {
        $this->items->removeElement($item);
        if ($updateRelation) {
            $item->setList(null, false);
        }
    }

    /**
     * @return Collection<int, ListItem>
     */
    public function getItems(): iterable
    {
        return $this->items;
    }
}
