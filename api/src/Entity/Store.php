<?php

namespace App\Entity;

use ApiPlatform\Core\Annotation\ApiProperty;
use ApiPlatform\Core\Annotation\ApiResource;
use Doctrine\ORM\Mapping as ORM;
use Ramsey\Uuid\Doctrine\UuidGenerator;
use Ramsey\Uuid\UuidInterface;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * @see http://schema.org/Store Documentation on Schema.org
 */
#[ORM\Entity]
#[ApiResource(
    itemOperations: [
        'get',
        'put',
        'delete',
    ],
    mercure: true,
    normalizationContext: ['groups' => ['store:read']],
)]
class Store
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
    #[Groups(groups: ['store:read'])]
    public ?string $name = null;

    public function getId(): ?UuidInterface
    {
        return $this->id;
    }
}
