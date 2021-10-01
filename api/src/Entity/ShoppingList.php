<?php

declare(strict_types=1);

namespace App\Entity;

use App\Controller\RemoveCompletedItemAction;
use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\Common\Collections\ArrayCollection;
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
    collectionOperations: [
        'get',
        'post'
    ],
    itemOperations: [
        'get',
        'put',
        'delete',
        'clear' => [
            'method' => 'GET',
            'path' => '/shopping_lists/{id}/clear',
            'controller' => RemoveCompletedItemAction::class,
        ],
    ],
    mercure: true,
    denormalizationContext: ['groups' => ['list:write']],
    normalizationContext: ['groups' => ['list:read']],
)]
class ShoppingList
{
    #[ORM\Id, ORM\GeneratedValue(strategy: 'CUSTOM'), ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\Column(type: 'uuid', unique: true)]
    #[Groups(groups: ['list:read'])]
    private ?UuidInterface $id = null;

    #[ORM\Column(type: 'text')]
    #[Assert\NotBlank]
    #[Groups(groups: ['list:write', 'list:read'])]
    public ?string $name = null;

    #[ORM\OneToMany(mappedBy: 'shoppingList', targetEntity: ListItem::class, cascade: ['persist', 'remove'], orphanRemoval: true)]
    #[Groups(groups: ['list:read'])]
    private Collection $items;

    public function __construct()
    {
        $this->items = new ArrayCollection();
    }

    public function getId(): ?UuidInterface
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    /**
     * @return Collection|ListItem[]
     */
    public function getItems(): Collection
    {
        return $this->items;
    }

    public function addItem(ListItem $item, bool $updateRelation = true): void
    {
        if ($this->items->contains($item)) {
            return;
        }

        $this->items->add($item);
        if ($updateRelation) {
            $item->setShoppingList($this, false);
        }
    }

    public function removeItem(ListItem $item): void
    {
        $this->items->removeElement($item);
    }

    public function removeCompletedItem(): void
    {
        foreach ($this->items as $item) {
            if($item->getIsCompleted()) {
                $this->removeItem($item);
            }
        }
    }
}
